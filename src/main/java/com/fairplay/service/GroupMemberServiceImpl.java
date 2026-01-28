package com.fairplay.service;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import com.fairplay.domain.Group;
import com.fairplay.domain.GroupMember;
import com.fairplay.domain.GroupMemberInfoDTO;
import com.fairplay.domain.MemberMonthlyScore;
import com.fairplay.repository.GroupMemberRepository;
import com.fairplay.repository.GroupRepository;

@Service
public class GroupMemberServiceImpl implements GroupMemberService {

    private final GroupMemberRepository gmRepo;
    private final GroupRepository groupRepository;
    private final HistoryService historyService;

    @Autowired
    public GroupMemberServiceImpl(GroupMemberRepository gmRepo,
                                  GroupRepository groupRepository,
                                  HistoryService historyService) {
        this.gmRepo = gmRepo;
        this.groupRepository = groupRepository;
        this.historyService = historyService;
    }

    // 그룹 멤버 저장 (가입 처리)
    @Override
    public void save(GroupMember groupMember) {
        gmRepo.save(groupMember);
    }

    // 특정 그룹에 속한 멤버 전체 조회
    @Override
    public List<GroupMember> findByGroupId(int groupId) {
        return gmRepo.findByGroupId(groupId);
    }

    // PK(id)로 그룹 멤버 단일 조회
    @Override
    public GroupMember findById(int id) {
        return gmRepo.findById(id);
    }

    // 그룹 멤버 정보 수정 (역할, 점수, 경고 등)
    @Override
    public void update(GroupMember groupMember) {
        gmRepo.update(groupMember);
    }

    // 그룹 멤버 삭제
    @Override
    public void delete(int groupId, int memberId) {
        gmRepo.delete(groupId, memberId);
    }

    // 특정 멤버가 그룹에 속해 있는지 여부 확인
    @Override
    public boolean isGroupMember(Long groupId, Long memberId) {
        return gmRepo.isGroupMember(groupId, memberId);
    }

    // 그룹 ID로 멤버 정보 조회 (닉네임/실명 포함)
    // + 현재 달의 history 데이터를 기반으로 월간 점수를 실시간 반영
    @Override
    public List<GroupMemberInfoDTO> findMemberInfoByGroupId(int groupId) {
        List<GroupMemberInfoDTO> members = gmRepo.findMemberInfoByGroupId(groupId);

        // 현재 달(yyyy-MM) 기준으로 history 테이블에서 점수 집계
        String yearMonth = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM"));
        List<MemberMonthlyScore> monthlyScores = historyService.getMemberMonthlyScore(groupId, yearMonth);

        // DTO에 월간 점수 반영
        for (GroupMemberInfoDTO dto : members) {
            monthlyScores.stream()
                .filter(ms -> ms.getMemberId().equals(dto.getMemberId()))
                .findFirst()
                .ifPresent(ms -> dto.setMonthlyScore(ms.getScore()));
        }
        return members;
    }

    // 그룹 내 현재 인원 수 조회
    @Override
    public int countByGroupId(int groupId) {
        return gmRepo.countByGroupId(groupId);
    }

    // 그룹 탈퇴 처리
    @Override
    public void leaveGroup(int memberId, int groupId) {
        gmRepo.deleteByMemberIdAndGroupId(memberId, groupId);
        int remaining = gmRepo.countByGroupId(groupId);

        // 남은 인원이 없으면 그룹 자체 삭제
        if (remaining == 0) {
            groupRepository.deleteById(groupId);
        }
    }

    // 그룹 내 특정 멤버의 역할 조회
    @Override
    public String findRoleByMemberIdAndGroupId(int memberId, int groupId) {
        return gmRepo.findRoleByMemberIdAndGroupId(memberId, groupId);
    }

    // 리더 제외 멤버 목록 조회 (리더 위임 대상)
    @Override
    public List<GroupMemberInfoDTO> findMembersExcludingLeader(int groupId) {
        return gmRepo.findMembersExcludingLeader(groupId);
    }

    // 리더 위임 처리
    @Override
    public void updateRoleToLeader(int groupId, int memberId) {
        gmRepo.updateRoleToLeader(groupId, memberId);
        groupRepository.updateLeader(groupId, memberId); // 그룹 테이블의 leader_id도 갱신
    }

    // 내가 가입한 그룹 리스트 반환
    @Override
    public List<Group> findGroupsByMemberId(Long memberId) {
        return gmRepo.findGroupsByMemberId(memberId);
    }

    // 최근 가입 그룹 ID 반환
    @Override
    public Integer findDefaultGroupId(int memberId) {
        return gmRepo.findLatestGroupIdByMember(memberId);
    }

    // 가장 오래된 비리더 멤버 ID 조회
    @Override
    public Integer findOldestNonLeaderMemberId(int groupId) {
        return gmRepo.findOldestNonLeaderMemberId(groupId);
    }

    /**
     * 매월 1일 0시에 실행되는 스케줄러
     * - 지난 달 점수 집계 (historyService.getMemberMonthlyScore)
     * - 그룹 내 최고 점수(maxScore) 계산
     * - 각 멤버별 총점 누적 (totalScore += 지난달 score)
     * - 월간 점수 초기화 (monthlyScore = 0)
     * - 최고 점수의 20% 미만인 멤버는 경고 횟수 +1
     */
    @Scheduled(cron = "0 0 0 1 * ?")
    public void applyMonthlyWarnings() {
        // 모든 그룹 조회
        List<Group> groups = groupRepository.readAll();

        // 지난 달 기준 (yyyy-MM)
        String yearMonth = LocalDate.now().minusMonths(1).format(DateTimeFormatter.ofPattern("yyyy-MM"));

        for (Group g : groups) {
            // 지난 달 멤버별 점수 집계
            List<MemberMonthlyScore> scores = historyService.getMemberMonthlyScore(g.getId(), yearMonth);

            // 그룹 내 최고 점수 계산
            int maxScore = scores.stream()
                                 .mapToInt(MemberMonthlyScore::getScore)
                                 .max()
                                 .orElse(0);

            for (MemberMonthlyScore s : scores) {
                // groupId + memberId로 GroupMember 조회
                GroupMember gm = gmRepo.findByGroupIdAndMemberId(g.getId(), s.getMemberId());

                // 총점 누적
                gm.setTotalScore(gm.getTotalScore() + s.getScore());

                // 새 달 시작 → 월간 점수 초기화
                gm.setMonthlyScore(0);

                // 경고 부여 (최고 점수의 20% 미만이면 경고 횟수 증가)
                if (s.getScore() < maxScore * 0.2) {
                    gm.setWarningCount(gm.getWarningCount() + 1);
                }

                // DB 업데이트
                gmRepo.update(gm);
            }
        }
    }
}