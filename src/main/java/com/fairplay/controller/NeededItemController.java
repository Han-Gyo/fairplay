package com.fairplay.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.fairplay.domain.Group;
import com.fairplay.domain.Member;
import com.fairplay.domain.NeededItemDTO;
import com.fairplay.service.GroupMemberService;
import com.fairplay.service.NeededItemService;

@Controller
@RequestMapping("/needed")  // 공통 URL: /needed/*
public class NeededItemController {

    @Autowired
    private NeededItemService neededItemService;
    @Autowired
    private GroupMemberService groupMemberService;
    
    // [GET] 물품 목록 조회
    @GetMapping("/list")
    public String list(@RequestParam(value = "groupId", required = false) Long groupId,
                       Model model,
                       HttpSession session,
                       RedirectAttributes redirectAttributes) {

        Member loginMember = (Member) session.getAttribute("loginMember");
        if (loginMember == null) {
            redirectAttributes.addFlashAttribute("error", "로그인 후 이용해주세요.");
            return "redirect:/member/login";
        }

        // 1. 내가 속한 그룹 리스트 조회
        List<Group> joinedGroups = groupMemberService.findGroupsByMemberId((long) loginMember.getId());
        model.addAttribute("joinedGroups", joinedGroups);

        // 2. groupId가 없는 경우 → 첫 번째 그룹 선택
        if (groupId == null && !joinedGroups.isEmpty()) {
            groupId = (long) joinedGroups.get(0).getId();  // 첫 번째 그룹 ID로 자동 설정
        }

        // 3. 해당 그룹 멤버인지 확인
        boolean isMember = groupMemberService.isGroupMember(groupId, (long) loginMember.getId());
        if (!isMember) {
            redirectAttributes.addFlashAttribute("error", "소속된 그룹이 없습니다. 그룹에 먼저 가입해주세요.");
            return "redirect:/group/groups";
        }

        // 4. 물품 목록 조회
        List<NeededItemDTO> items = neededItemService.getItemsByGroupId(groupId);
        model.addAttribute("items", items);
        model.addAttribute("groupId", groupId); // 선택된 그룹 ID도 같이 넘기기
        return "neededList";
    }




    // [GET] 등록 폼으로 이동
    @GetMapping("/add")
    public String showAddForm(@RequestParam(value = "groupId", required = false) Long groupId,
                              HttpSession session,
                              Model model,
                              RedirectAttributes ra) {

        Member loginMember = (Member) session.getAttribute("loginMember");
        if (loginMember == null) {
            ra.addFlashAttribute("error", "로그인 후 이용해주세요.");
            return "redirect:/member/login";
        }

        // 그룹 리스트 가져오기
        List<Group> joinedGroups = groupMemberService.findGroupsByMemberId((long) loginMember.getId());
        if (joinedGroups.isEmpty()) {
            ra.addFlashAttribute("error", "소속된 그룹이 없습니다. 그룹에 먼저 가입해주세요.");
            return "redirect:/group/groups";
        }
        model.addAttribute("joinedGroups", joinedGroups);

        // item 객체 생성 및 groupId 설정
        NeededItemDTO item = new NeededItemDTO();
        if (groupId != null) {
            item.setGroupId(groupId);
        } else {
            // groupId가 없으면 첫 번째 그룹으로 자동 설정
            item.setGroupId((long) joinedGroups.get(0).getId());
        }
        model.addAttribute("item", item);

        return "neededAddForm";
    }



 // [POST] 등록 처리
    @PostMapping("/add")
    public String addItem(@ModelAttribute NeededItemDTO item, HttpSession session) {

        System.out.println("item 객체: " + item); // ← null인지 확인
        System.out.println("item.itemName: " + item.getItemName()); // ← 데이터 잘 들어오는지
        System.out.println("세션 객체: " + session.getAttribute("loginMember"));

        Member loginMember = (Member) session.getAttribute("loginMember");

        if (loginMember != null) {
            item.setAddedBy((long)loginMember.getId());  // ← 여기서 nullPointerException 나면 item 자체가 null일 가능성 있음
        } else {
            throw new IllegalStateException("로그인 정보가 없습니다.");
        }

        neededItemService.addItem(item);
        return "redirect:/needed/list?groupId=" + item.getGroupId();
    }


    // [GET] 수정 폼으로 이동
    @GetMapping("/edit")
    public String showEditForm(@RequestParam("id") Long id, Model model) {
        NeededItemDTO item = neededItemService.getItemById(id);
        model.addAttribute("item", item);
        return "neededEditForm"; // → neededEditForm.jsp
    }

    // [POST] 수정 처리
    @PostMapping("/edit")
    public String editItem(@ModelAttribute NeededItemDTO item) {
        neededItemService.updateItem(item);
        return "redirect:/needed/list?groupId=" + item.getGroupId();
    }

    // [POST] 삭제 처리
    @PostMapping("/delete")
    public String deleteItem(@RequestParam("id") Long id, @RequestParam("groupId") Long groupId) {
        neededItemService.deleteItem(id);
        return "redirect:/needed/list?groupId=" + groupId;
    }

    // [POST] 구매 여부 토글 (AJAX 추천)
    @PostMapping("/toggle")
    @ResponseBody
    public String togglePurchased(@RequestParam("id") Long id,
                                  @RequestParam("isPurchased") boolean isPurchased) {
        neededItemService.togglePurchased(id, isPurchased);
        return "success";
    }
    
    // 구매 완료 상태 토글 처리 (AJAX)
    @PostMapping("/togglePurchased")
    @ResponseBody
    public Map<String, Object> togglePurchased(@RequestBody Map<String, Object> requestData) {
        Map<String, Object> response = new HashMap<>();

        try {
            Long itemId = Long.valueOf(requestData.get("id").toString());
            boolean purchased = Boolean.parseBoolean(requestData.get("purchased").toString());

            boolean success = neededItemService.updatePurchasedStatus(itemId, purchased);

            response.put("success", success);
        } catch (Exception e) {
            e.printStackTrace(); // 서버 콘솔에서 에러 확인용
            response.put("success", false);
            response.put("error", e.getMessage());
        }

        return response;
    }


}
