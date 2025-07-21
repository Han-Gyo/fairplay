package com.fairplay.enums;

public enum MemberStatus {
    ACTIVE,     // 로그인 가능, 서비스 이용 가능
    INACTIVE,   // 탈퇴 처리된 회원 (소프트 삭제 상태)
    BANNED      // 운영자에 의해 정지된 상태
}

