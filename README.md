FairPlay (가사 분담 관리 플랫폼)

가정 내 가사 노동 데이터를 정량화 및 시각화하여 갈등 해소를 목표로 합니다. 데이터 기반의 통계 로직 설계와 Docker/AWS 기반의 인프라 구축 및 CI/CD 자동화 경험에 중점을 두었습니다.

프로젝트 핵심 기술 스택

Back-end

Java 17, Spring Framework (MVC), JdbcTemplate, JavaMailSender

핵심 비즈니스 로직 및 API 개발, JDBC 기반의 DB 연동 처리

Database

MySQL (Dockerized)

가사 활동 기록 및 데이터 관리, Volume Mount를 통한 데이터 영속성 확보

Infra / DevOps

AWS EC2, Docker

클라우드 서버 환경 구축 및 애플리케이션/DB 컨테이너화 운영

CI/CD

GitHub Actions

코드 Push 시 빌드 및 배포 과정 자동화 파이프라인 구축

Web / Frontend

JSP/JSTL, JavaScript (ES6), HTML/CSS, Bootstrap, Chart.js, Daum Postcode API

가사 데이터 시각화 통계 및 주소 검색 기능 구현

Tools & Build

Git, Maven, Eclipse IDE, MySQL Workbench, Duck DNS

버전 관리, 프로젝트 빌드 자동화 및 외부 도메인 연동

실행 및 배포 환경

JDK 17, Apache Tomcat 9.0, Docker

CI/CD: GitHub Actions를 통한 AWS EC2 자동 배포

DB 설정: Docker 컨테이너 내 MySQL 서버 운용 (호스트 볼륨 연동)

Git Repository Link

https://github.com/Han-Gyo/fairplay

[주요 폴더 설명]

src/main/java/com/fairplay/controller (컨트롤러)

src/main/java/com/fairplay/service (비즈니스 로직 및 DB 연동)

src/main/java/com/fairplay/domain (데이터 객체 및 도메인 모델)

src/main/webapp/WEB-INF/views (JSP 뷰 파일)
