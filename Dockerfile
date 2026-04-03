# 1. 베이스 이미지 설정 (톰캣 9 버전, 자바 11 또는 17 중 프로젝트에 맞는 것 선택)
# Java 17 jdk17
FROM tomcat:9.0-jdk17-openjdk

# 2. 한국 시간 설정 (로그 확인 및 DB 등록 시 시간 오류 방지)
ENV TZ=Asia/Seoul
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 3. 메이븐 빌드로 생성된 .war 파일을 톰캣의 webapps 폴더로 복사
# 프로젝트 이름이 fairplay이므로 빌드 시 target/fairplay.war가 생성됩니다.
COPY target/fairplay.war /usr/local/tomcat/webapps/ROOT.war

# 4. 파일 업로드 경로 생성 (config-prod.properties의 upload.path와 일치)
# 톰캣 내부 경로인 /usr/local/tomcat/upload 폴더를 미리 만들어둡니다.
RUN mkdir -p /usr/local/tomcat/upload

# 5. 톰캣이 실행될 때 환경 변수 주입 (-Denvironment=prod)
# 기본 톰캣 실행 옵션(CATALINA_OPTS)에 우리가 만든 환경 변수를 추가합니다.
ENV CATALINA_OPTS="-Denvironment=prod -Djava.security.egd=file:/dev/./urandom"

# 6. 8080 포트 개방
EXPOSE 8080

# 7. 톰캣 실행
CMD ["catalina.sh", "run"]