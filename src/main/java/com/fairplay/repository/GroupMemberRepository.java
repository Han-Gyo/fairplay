package com.fairplay.repository;

import java.util.List;

import com.fairplay.domain.Group;
import com.fairplay.domain.GroupMember;
import com.fairplay.domain.GroupMemberInfoDTO;

public interface GroupMemberRepository {

    void save(GroupMember groupMember);

    List<GroupMember> findByGroupId(int groupId);

    GroupMember findById(int id);

    void update(GroupMember groupmember);

    void delete(int groupId, int memberId);

    boolean isGroupMember(Long groupId, Long memberId);

    // 그룹 ID로 그룹 멤버 정보(닉네임, 이름 포함) 조회
    List<GroupMemberInfoDTO> findMemberInfoByGroupId(int groupId);

    // 현재 인원 수 조회용 메서드
    int countByGroupId(int groupId);

    // 그룹장 탈퇴 전용 처리
    void deleteByMemberIdAndGroupId(int memberId, int groupId);

    // 그룹 내에서 해당 멤버의 역할 조회
    String findRoleByMemberIdAndGroupId(int memberId, int groupId);

    // 그룹 내에서 LEADER가 아닌 멤버 리스트 조회 (리더 위임 대상)
    List<GroupMemberInfoDTO> findMembersExcludingLeader(int groupId);

    // 새로운 리더로 역할 변경
    void updateRoleToLeader(int groupId, int memberId);

    // 내가 가입한 그룹 리스트 반환 (그룹명, ID 포함)
    List<Group> findGroupsByMemberId(Long memberId);

    // 로그인 사용자의 기본 그룹ID를 반환
    Integer findLatestGroupIdByMember(int memberId);

    // 가장 오래된(가입일자 대신 PK 오름차순) 비리더 멤버 ID 조회
    Integer findOldestNonLeaderMemberId(int groupId);
    
    // 특정 그룹(groupId) 안에서 특정 멤버(memberId)에 해당하는 그룹멤버 1명을 조회하는 메서드
    GroupMember findByGroupIdAndMemberId(int groupId, int memberId);
}