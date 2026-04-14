FairPlay (가사 분담 관리 플랫폼)

서비스 바로가기
http://~~

GitHub Repository
https://github.com/Han-Gyo/fairplay

한 줄 소개
가사 노동을 데이터로 기록하고 시각화하여 공정한 분담을 지원하는 플랫폼입니다.

프로젝트 개요
가정 내 가사 노동을 기록하고 점수화하여 구성원 간의 역할 분담을 명확하게 하고,
데이터 기반으로 갈등을 줄이기 위해 기획한 서비스입니다.
Spring 기반 백엔드 개발과 Docker, AWS EC2를 활용한 인프라 구축 및
GitHub Actions를 통한 CI/CD 자동화 경험에 중점을 두었습니다.


기술 스택

1. Back-end
Java 17, Spring Framework (MVC), JdbcTemplate, JavaMailSender
- 핵심 비즈니스 로직 및 API 개발
- JDBC 기반 데이터베이스 연동 처리

2. Database
MySQL (Dockerized)
- 가사 활동 기록 및 데이터 관리
- Volume Mount를 통한 데이터 영속성 확보

3. Infra / DevOps
AWS EC2, Docker
- 클라우드 서버 환경 구축
- 애플리케이션 및 DB 컨테이너 분리 운영

4. CI/CD
GitHub Actions
- 코드 Push 시 자동 빌드 및 배포 파이프라인 구성

5. Web / Frontend
JSP/JSTL, JavaScript (ES6), HTML/CSS, Bootstrap, Chart.js, Daum Postcode API
- 가사 데이터 시각화 및 사용자 인터페이스 구현
- 주소 검색 API 연동

6. Tools & Build
Git, Maven, Eclipse IDE, MySQL Workbench, Duck DNS
- 형상 관리 및 빌드 자동화
- 외부 도메인 연결


실행 및 배포 환경

- JDK 17
- Apache Tomcat 9.0
- Docker 기반 컨테이너 환경 구성
- GitHub Actions를 통한 AWS EC2 자동 배포
- MySQL 컨테이너 운영 및 호스트 Volume 연동으로 데이터 유지


주요 기능

- 회원 가입 및 로그인 (이메일 인증)
- 그룹 생성 및 참여 기능
- 집안일 등록 및 수행 관리
- 수행 내역 기록 및 점수 부여
- 월별 점수 자동 집계 (@Scheduled)
- Chart.js를 활용한 데이터 시각화


프로젝트 구조

src/main/java/com/fairplay/controller
- 요청 처리 및 화면 흐름 제어

src/main/java/com/fairplay/service
- 비즈니스 로직 및 데이터 처리

src/main/java/com/fairplay/domain
- 데이터 객체 및 도메인 모델

src/main/webapp/WEB-INF/views
- JSP 기반 View 구성
