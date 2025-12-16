Java/Spring 기반 웹 플랫폼으로, 가정 내 가사 노동 데이터를 정량화 및 시각화하여 갈등 해소를 목표로 합니다. 데이터 기반의 통계/권한 제어 로직 설계 및 외부 API 연동 경험에 중점을 두었습니다.

프로젝트 핵심 기술 스택 (Core Technology Stack)

구분기술, 스택목적 및 기여 영역

Back-end : Java 17, Spring Framework (MVC)핵심 비즈니스 로직 및 API 개발, JDBC 기반의 DB 연동 처리

Front-end : HTML5, CSS3, JavaScript (ES6), JSP, jQuery사용자 인터페이스 구현 및 비동기 통신 처리

Database : MySQL 가사 활동 기록 및 사용자 정보 관리, 데이터 무결성 확보

External API : Chart.js, Daum Postcode API데이터 시각화 및 사용자 편의를 위한 주소 검색 기능 구현

Tools : Git, Eclipse(IDE), Apache Tomcat 9.0버전 관리 및 협업, 개발 환경 구축

실행 환경: JDK 17, Apache Tomcat 9.0

DB 설정: 로컬 환경에서 실행 시, DB 연결 정보를 설정 파일(예: datasource-context.xml 또는 root-context.xml)에서 설정해야 합니다.

[Git Repository Link]

[주요 폴더 설명] src/main/java/com/fairplay/controller (컨트롤러), src/main/java/com/fairplay/service (비즈니스 로직), src/main/webapp/WEB-INF/views (JSP 뷰 파일)
