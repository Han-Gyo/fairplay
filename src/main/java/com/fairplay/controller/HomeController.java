package com.fairplay.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import com.fairplay.domain.Group;
import com.fairplay.domain.Member;
import com.fairplay.service.GroupMemberService;

import java.util.List;

@Controller
public class HomeController {

    @Autowired
    private GroupMemberService groupMemberService;

    @GetMapping("/")
    public String home(HttpSession session) {

        Member loginMember = (Member) session.getAttribute("loginMember");
        if (loginMember != null) {
        	session.setAttribute("userNickname", loginMember.getNickname());
          Integer groupId = (Integer) session.getAttribute("currentGroupId");
          if (groupId == null) {
            List<Group> myGroups = groupMemberService.findGroupsByMemberId((long) loginMember.getId());
            if (!myGroups.isEmpty()) {
              groupId = myGroups.get(0).getId();
              session.setAttribute("currentGroupId", groupId);
            }
          }

          if (groupId != null) {
            String role = groupMemberService.findRoleByMemberIdAndGroupId(
              loginMember.getId(), groupId
            );
            session.setAttribute("role", role);
          }
        }

        return "home";
    }
}
