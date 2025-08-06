package com.fairplay.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fairplay.domain.Member;
import com.fairplay.domain.NeededItemDTO;
import com.fairplay.service.NeededItemService;

@Controller
@RequestMapping("/needed")  // 공통 URL: /needed/*
public class NeededItemController {

    @Autowired
    private NeededItemService neededItemService;

    // [GET] 물품 목록 조회
    @GetMapping("/list")
    public String list(@RequestParam("groupId") Long groupId, Model model) {
        List<NeededItemDTO> items = neededItemService.getItemsByGroupId(groupId);
        model.addAttribute("items", items);
        model.addAttribute("groupId", groupId); // 뷰에서 필요
        return "neededList"; // → neededList.jsp
    }

    // [GET] 등록 폼으로 이동
    @GetMapping("/add")
    public String showAddForm(@RequestParam("groupId") Long groupId, Model model) {
        NeededItemDTO item = new NeededItemDTO();
        item.setGroupId(groupId);  // 히든 처리할 groupId
        model.addAttribute("item", item);
        return "neededAddForm"; // → neededAddForm.jsp
    }

 // [POST] 등록 처리
    @PostMapping("/add")
    public String addItem(@ModelAttribute NeededItemDTO item, HttpSession session) {

        System.out.println("📌 item 객체: " + item); // ← null인지 확인
        System.out.println("📌 item.itemName: " + item.getItemName()); // ← 데이터 잘 들어오는지
        System.out.println("📌 세션 객체: " + session.getAttribute("loginMember"));

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
}
