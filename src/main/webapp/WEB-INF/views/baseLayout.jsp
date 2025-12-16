<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} | FairPlay</title>

    <!-- Bootstrap 5 CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" 
          rel="stylesheet" 
          xintegrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" 
          crossorigin="anonymous">
    
    <!-- Font Awesome (아이콘) -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <!-- Soft UI 디자인 에뮬레이션을 위한 커스텀 스타일 (전역) -->
    <style>
        :root {
            --soft-primary: #5e72e4; /* Soft Blue */
            --soft-secondary: #adb5bd;
            --soft-bg: #f8f9fa; /* Light Gray */
            --soft-shadow: 0 4px 6px rgba(0, 0, 0, 0.1), 0 1px 3px rgba(0, 0, 0, 0.08);
        }
        body {
            background-color: var(--soft-bg);
            /* Soft UI는 부드러운 폰트를 사용합니다. */
            font-family: 'Poppins', 'Nanum Gothic', sans-serif;
            margin: 0;
            padding: 0;
        }
        /* Soft UI 스타일을 모방한 카드 */
        .soft-card {
            background-color: white;
            border: none;
            border-radius: 1rem; /* 둥근 모서리 */
            box-shadow: var(--soft-shadow); /* 부드러운 그림자 */
            transition: all 0.3s ease;
        }
        .soft-card:hover {
            box-shadow: 0 6px 10px rgba(0, 0, 0, 0.15); /* 호버 시 그림자 강화 */
            transform: translateY(-2px);
        }
        /* 사이드바 스타일 (Soft UI 느낌) */
        .sidebar {
            width: 280px;
            background: linear-gradient(195deg, #42424a, #191919); /* 어두운 그라데이션 */
            height: 100vh;
            position: fixed;
            top: 0;
            left: 0;
            z-index: 1000;
            padding-top: 20px;
            border-right: 1px solid rgba(255, 255, 255, 0.1);
            color: white;
        }
        .sidebar-item {
            padding: 10px 20px;
            margin: 5px 15px;
            border-radius: 0.75rem;
            color: #ccc;
            transition: all 0.2s;
        }
        .sidebar-item:hover, .sidebar-item.active {
            background-color: var(--soft-primary);
            color: white;
            box-shadow: 0 4px 20px 0 rgba(0, 0, 0, 0.2), 0 7px 10px -5px rgba(94, 114, 228, 0.4);
        }
        /* 메인 콘텐츠 영역 (사이드바 공간 확보) */
        .main-content {
            margin-left: 280px;
            padding: 20px;
            min-height: 100vh;
        }

        /* 반응형 처리: 모바일에서는 사이드바 숨기고, 헤더 사용 */
        @media (max-width: 992px) {
            .sidebar {
                display: none;
                width: 0;
            }
            .main-content {
                margin-left: 0;
            }
            .top-navbar {
                display: block !important;
            }
        }

    </style>

</head>
<body>

<!-- 1. Soft UI 스타일의 사이드바 (데스크탑 전용) -->
<nav class="sidebar d-none d-lg-block">
    <div class="text-center mb-4">
        <a href="${pageContext.request.contextPath}/" class="text-white text-decoration-none h4 fw-bold">FairPlay</a>
        <hr class="mx-3 opacity-25">
    </div>
    
    <div class="list-group">
        <a href="${pageContext.request.contextPath}/" class="sidebar-item active">
            <i class="fas fa-home me-2"></i> 홈
        </a>
        <a href="#" class="sidebar-item">
            <i class="fas fa-list-check me-2"></i> 집안일 등록
        </a>
        <a href="#" class="sidebar-item">
            <i class="fas fa-calendar-alt me-2"></i> 일정 관리
        </a>
        <a href="#" class="sidebar-item">
            <i class="fas fa-wallet me-2"></i> 가계부
        </a>
        <a href="#" class="sidebar-item">
            <i class="fas fa-chart-pie me-2"></i> 기여도 통계
        </a>
        <a href="#" class="sidebar-item">
            <i class="fas fa-book-open me-2"></i> 히스토리
        </a>
        <a href="#" class="sidebar-item">
            <i class="fas fa-users me-2"></i> 그룹 관리
        </a>
        <hr class="mx-3 opacity-25 mt-4">
        <a href="#" class="sidebar-item">
            <i class="fas fa-user-circle me-2"></i> 마이페이지
        </a>
        <a href="#" class="sidebar-item">
            <i class="fas fa-sign-out-alt me-2"></i> 로그아웃
        </a>
    </div>
</nav>

<!-- 2. 상단 네비게이션 (모바일/태블릿 및 보조 네비게이션) -->
<header class="top-navbar d-lg-none navbar navbar-expand-lg navbar-light bg-white shadow-sm sticky-top">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold text-dark" href="${pageContext.request.contextPath}/">FairPlay</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mobileNav" aria-controls="mobileNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="mobileNav">
             <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/">홈</a></li>
                <li class="nav-item"><a class="nav-link" href="#">집안일 등록</a></li>
                <li class="nav-item"><a class="nav-link" href="#">일정 관리</a></li>
                <li class="nav-item"><a class="nav-link" href="#">가계부</a></li>
                <li class="nav-item"><a class="nav-link" href="#">통계</a></li>
                <li class="nav-item"><a class="nav-link" href="#">그룹 관리</a></li>
                <li class="nav-item"><a class="nav-link" href="#">마이페이지</a></li>
                <li class="nav-item"><a class="nav-link" href="#">로그아웃</a></li>
            </ul>
        </div>
    </div>
</header>

<!-- 3. 메인 콘텐츠 영역 (다른 JSP 내용이 여기에 삽입됩니다.) -->
<div class="main-content">
    
    <!-- 모든 페이지에서 이 JSTL 변수에 콘텐츠가 담겨야 합니다. -->
    ${pageContent} 

</div>

<!-- Bootstrap JS CDN -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" 
        xintegrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" 
        crossorigin="anonymous"></script>

</body>
</html>