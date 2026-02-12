package com.fairplay.controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.fairplay.domain.Group;
import com.fairplay.domain.Member;
import com.fairplay.service.GroupMemberService;
import com.fairplay.service.GroupService;

@Controller
@RequestMapping("/group")
public class GroupController {
	
	@Autowired
	private GroupService groupService;
	@Autowired
	private GroupMemberService groupMemberService;
	
	// 그룹 등록 폼 페이지로 이동 (Create)
	@GetMapping("/create")
	public String createForm(HttpSession session) {
		
		// 로그인 세션 정보 확인
		Member loginMember = (Member) session.getAttribute("loginMember");
		
		// 로그인 정보가 null일 경우 로그인 페이지로 리다이렉트
		if (loginMember == null) {
			return "redirect:/member/login";
		}
		
		return "groupCreateForm";
	}
	
	// 그룹등록 폼 제출 시 그룹 등록 처리 (Create)
	@PostMapping("/create")
	public String createGroup(@ModelAttribute Group group, HttpSession session) {
	    
		// 로그인한 사용자 정보 가져오기
		Member loginMember = (Member) session.getAttribute("loginMember");
		
		// 로그인 정보가 null인 경우 NullPointerException 방지 및 리다이렉트
		if (loginMember == null) {
			return "redirect:/member/login";
		}
		
		// 그룹장 ID 설정
		group.setLeaderId(loginMember.getId());
		
		// 파일 업로드 처리
	    MultipartFile file = group.getFile(); // DTO에서 전달받은 파일 추출

	    if (file != null && !file.isEmpty()) {
	        // 1. 원본 파일명 추출
	        String originalName = file.getOriginalFilename();

	        // 2. UUID + 안전한 파일명으로 변환 (한글/공백 문제 방지)
	        String safeFileName = UUID.randomUUID().toString() + "_" + originalName.replaceAll("[^a-zA-Z0-9.]", "_");

	        // 3. 실제 저장 경로 지정
	        Path savePath = Paths.get("C:/upload/" + safeFileName);

	        try {
	            file.transferTo(savePath.toFile()); // 4. 파일 저장
	            group.setProfile_img(safeFileName); // 5. DB에 저장할 파일명 설정
	        } catch (IOException e) {
	            e.printStackTrace(); // 에러 발생 시 로그 출력
	        }
	    }

	    // 그룹 정보 저장 (DB insert) + 자동 그룹장 등록은 서비스 내부에서 처리됨
	    groupService.save(group);
	    
	    return "redirect:/group/groups"; // 저장 후 그룹 목록으로 이동
	}

	
	// 전체 그룹 목록을 조회하여 뷰에 전달 (Read_all)
	@GetMapping("/groups")
	public String groupList(Model model, HttpSession session) {

	    // 전체 그룹 데이터 조회
	    List<Group> groups = groupService.readAll();

	    // 각 그룹별 현재 가입 인원 수 조회 (group_id → count)
	    Map<Integer, Integer> currentMemberCountMap = new HashMap<>();
	    for (Group group : groups) {
	        int count = groupMemberService.countByGroupId(group.getId());
	        currentMemberCountMap.put(group.getId(), count);
	    }

	    // 로그인한 사용자 정보 가져오기
	    Member loginMember = (Member) session.getAttribute("loginMember");

	    // 내가 가입한 그룹 리스트 조회 (서비스 메서드 그대로 활용)
	    List<Group> myGroups = null;
	    List<Integer> myGroupIds = null;
	    if (loginMember != null) {
	        myGroups = groupMemberService.findGroupsByMemberId((long) loginMember.getId());
	        // ID 리스트로 변환해서 JSP에서 contains(g.id)로 체크 가능하게 함
	        myGroupIds = myGroups.stream().map(Group::getId).collect(Collectors.toList());
	    }

	    // 모델에 그룹 리스트 + 현재 인원 수 map 추가
	    model.addAttribute("groups", groups);
	    model.addAttribute("memberCounts", currentMemberCountMap); // JSP에서 memberCounts[group.id]로 접근
	    model.addAttribute("myGroupIds", myGroupIds); // JSP에서 내 그룹 여부 체크에 사용

	    // 그룹 목록 JSP 뷰 반환
	    return "groups";
	}

	
	// 특정 그룹을 조회하여 수정 폼 이동(Update용 Read_one 그룹장만 접근 가능하게)
	@GetMapping("/edit")
	public String findById(@RequestParam("id")int id,
						   HttpSession session,
						   Model model) {
		
		// id 기반으로 그룹 데이터 조회
		Group group = groupService.findById(id);
		
		// 해당 id에 그룹이 없을 경우 -> 목록 페이지로 리다이렉트 (예외처리)
		if (group == null) {
		    return "redirect:/group/groups";
		}
		
		// 로그인한 사용자 정보
		Member loginMember = (Member) session.getAttribute("loginMember");
		
		// 그룹장이 아닌 경우 접근 차단
		if (loginMember == null || loginMember.getId() != group.getLeaderId()) {
			return "redirect:/group/detail?id=" + id;	// 상세 페이지로 되돌림
		}
		
		// JSP로 해당 객체 데이터 전달 (모델에 그룹 데이터 전달)
		model.addAttribute("group", group);
		
		// 수정 폼 페이지 반환
		return "groupEditForm";
		
	}
	
	// 특정 그룹을 조회하여 상세 보기 페이지로 이동(View용 Read_one)
	@GetMapping("/detail")
	public String viewDetail(@RequestParam("id")int id,
							 HttpSession session,		// 세션에서 로그인 회원 추출용
							 Model model) {
		
		// id 기반으로 그룹 데이터 조회
		Group group = groupService.findById(id);
		
		// 해당 id가 없을 경우 목록으로 리다이렉트
		if (group == null) {
			return "redirect:/group/groups";
		}
		
		// 조회된 객체를 모델에 담아 뷰로 전달
		model.addAttribute("group", group);
		
		// 로그인한 사용자 정보 가져오기
		Member loginMember = (Member) session.getAttribute("loginMember");
		model.addAttribute("loginMember", loginMember);	// JSP에서도 loginMember 사용할 수 있게 모델에 담음
		
		// 해당 그룹에 로그인 사용자가 가입했는지 여부 판단
		boolean isMember = false;
		if (loginMember != null) {
			isMember = groupMemberService.isGroupMember( (long) group.getId(), (long) loginMember.getId());
		}
		
		model.addAttribute("isMember", isMember);	// 멤버 보기 버튼 조건 분기에 사용
		
		// 현재 인원 수 모델에 담기
		int currentMemberCount = groupMemberService.countByGroupId(group.getId());
		model.addAttribute("currentMemberCount", currentMemberCount);
		
		// 상세 보기 페이지 반환
		return "groupDetail";
	}
	
		
	// 수정된 그룹 데이터를 DB에 반영하고 전체 그룹 목록 페이지로 리다이렉트 (Update)
	@PostMapping("/update")
	public String update(@ModelAttribute Group group, 
	                     @RequestParam(value="imageDeleted", defaultValue="false") boolean imageDeleted) {

		MultipartFile file = group.getFile(); // DTO에서 전달받은 파일 추출

		// 기존 그룹 정보 가져오기 (기존 파일명 확인 및 데이터 유지를 위해)
	    Group existingGroup = groupService.findById(group.getId());
	    
		if (file != null && !file.isEmpty()) {
			// [새 파일 업로드 처리]
			String originalName = file.getOriginalFilename();
			String safeFileName = UUID.randomUUID().toString() + "_" + originalName.replaceAll("[^a-zA-Z0-9.]", "_");
			Path savePath = Paths.get("C:/upload/" + safeFileName);

			try {
				file.transferTo(savePath.toFile());             // 1. 파일 저장
				group.setProfile_img(safeFileName);             // 2. DB에 저장할 파일명 설정
				
				// 기존 파일이 있었다면 서버에서 삭제 (파일 교체 시 용량 확보)
				if (existingGroup.getProfile_img() != null && !existingGroup.getProfile_img().isEmpty()) {
					deleteActualFile(existingGroup.getProfile_img());
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
		} else if (imageDeleted) {
			// [사용자가 이미지 삭제 버튼을 클릭한 경우 처리]
			// 1. 서버 폴더에서 물리적 파일 삭제
			if (existingGroup.getProfile_img() != null && !existingGroup.getProfile_img().isEmpty()) {
				deleteActualFile(existingGroup.getProfile_img());
			}
			// 2. DB에 반영될 파일명을 빈 값(혹은 null)으로 설정
			group.setProfile_img(null); 
		} else {
			// [새 파일도 없고 삭제 요청도 없는 경우]
			// 파일이 비어 있으면 기존 이미지 유지
			group.setProfile_img(existingGroup.getProfile_img());
		}

		groupService.update(group); // DB 업데이트 실행
		return "redirect:/group/groups"; // 수정 후 목록 페이지로 이동
	}

	
	// 그룹 삭제 요청 처리 (Delete)
	@GetMapping("delete")
	String delete(@RequestParam("id")int id, HttpSession session) {
		
		// 그룹 정보 조회
		Group group = groupService.findById(id);
		
		// 로그인한 사용자 정보 가져오기
		Member loginMember = (Member) session.getAttribute("loginMember");
		
		// 그룹장이 아닌 경우 삭제 차단
		if (loginMember == null || group.getLeaderId() != loginMember.getId()) {
			// 권한 없는 사용자 -> 그룹 상세 페이지로 리다이렉트
			return "redirect:/group/detail?id=" +id;
		}
		
		// [추가 로직] 그룹 삭제 시 서버 폴더에 저장된 이미지 파일도 함께 삭제
		if (group.getProfile_img() != null && !group.getProfile_img().isEmpty()) {
			deleteActualFile(group.getProfile_img());
		}
		
		// 그룹장 본인일 경우 삭제 진행
		groupService.delete(id);
		return "redirect:/group/groups";
	}

	
	// [추가 함수] C:/upload 폴더에서 파일을 물리적으로 삭제하는 함수
	// @param fileName 삭제할 파일명
	private void deleteActualFile(String fileName) {
		File file = new File("C:/upload/" + fileName);
		if (file.exists()) {
			file.delete();
		}
	}
}