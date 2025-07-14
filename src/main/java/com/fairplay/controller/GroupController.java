package com.fairplay.controller;

import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

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
import com.fairplay.service.GroupService;

@Controller
@RequestMapping("/group")
public class GroupController {
	
	@Autowired
	private GroupService groupService;
	
	// 그룹 등록 폼 페이지로 이동 (Create)
	@GetMapping("/create")
	public String createForm() {
		
		return "groupCreateForm";
	}
	
	// 그룹등록 폼 제출 시 그룹 등록 처리 (Create)
	@PostMapping("/create")
	public String createGroup(@ModelAttribute Group group) {
	    
	    // 1. 업로드된 파일 꺼내오기 (폼에서 전달된 파일은 DTO의 file 필드에 바인딩됨)
	    MultipartFile file = group.getFile();

	    // 2. 파일이 존재하고 비어있지 않은 경우 처리
	    if (file != null && !file.isEmpty()) {
	        // 2-1. 원래 파일 이름 추출
	        String fileName = file.getOriginalFilename();

	        // 2-2. 저장할 경로 지정 (서버의 C:/upload 디렉토리에 저장)
	        Path savePath = Paths.get("C:/upload/" + fileName);

	        try {
	            // 2-3. 실제 파일 저장
	            file.transferTo(savePath.toFile());

	            // 2-4. 저장된 파일명을 DB에 넣기 위해 DTO의 profile_img 필드에 설정
	            group.setProfile_img(fileName);
	        } catch (IOException e) {
	            e.printStackTrace(); // 에러 발생 시 로그 출력
	        }
	    }

	    // 3. 서비스 호출 → DB에 그룹 정보 저장 (파일명 포함)
	    groupService.save(group);

	    // 4. 저장 후 그룹 목록 페이지로 리다이렉트
	    return "redirect:/group/groups";
	}
	
	// 전체 그룹 목록을 조회하여 뷰에 전달 (Read_all)
	@GetMapping("/groups")
	public String groupList(Model model) {
		
		// 전체 그룹 데이터 조회
		List<Group> groups = groupService.readAll();
		
		// 모델에 그룹 리스트 데이터 추가
		model.addAttribute("groups", groups);
		
		// 그룹 목록 JSP 뷰 반환
		return "groups";
	}
	
	// 특정 그룹을 조회하여 수정 폼 이동(Update용 Read_one)
	@GetMapping("/edit")
	public String findById(@RequestParam("id")int id, Model model) {
		
		// id 기반으로 그룹 데이터 조회
		Group group = groupService.findById(id);
		
		// 해당 id에 그룹이 없을 경우 -> 목록 페이지로 리다이렉트 (예외처리)
		if (group == null) {
		    return "redirect:/group/groups";
		}
		
		// JSP로 해당 객체 데이터 전달
		model.addAttribute("group", group);
		
		// 수정 폼 페이지 반환
		return "groupEditForm";
		
	}
	
	// 특정 그룹을 조회하여 상세 보기 페이지로 이동(View용 Read_one)
		@GetMapping("/detail")
		public String viewDetail(@RequestParam("id")int id, Model model) {
			
			// id 기반으로 그룹 데이터 조회
			Group group = groupService.findById(id);
			
			// 해당 id가 없을 경우 목록으로 리다이렉트
			if (group == null) {
				return "redirect:/group/groups";
			}
			
			// 조회된 객체를 모델에 담아 뷰로 전달
			model.addAttribute("group", group);
			
			// 상세 보기 페이지 반환
			return "groupDetail";
		}
	
		
	// 수정된 그룹 데이터를 DB에 반영하고 전체 그룹 목록 페이지로 리다이렉트
	@PostMapping("/update")
	public String update(@ModelAttribute Group group, @RequestParam("profile_img") MultipartFile file) {
		
		// 파일 업로드가 있을 경우 처리
		if (!file.isEmpty()) {
			String fileName = file.getOriginalFilename();
			Path savePath = Paths.get("C:/upload/" + fileName);
			
			try {
				file.transferTo(savePath.toFile());			// 실제 파일 저장
				group.setProfile_img(fileName);				// DB에 저장할 파일명 설정
			} catch(IOException e) {
				e.printStackTrace();
			}
		}
		
		// 서비스 호출
		groupService.update(group);
		
		// 그룹 목록으로 이동
		return "redirect:/group/groups";
	}
	
	

}
