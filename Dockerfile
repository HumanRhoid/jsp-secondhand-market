# ── 1단계: WAR 빌드 (로컬에 Maven 없어도 컨테이너 안에서 빌드) ──
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
# 컨테이너용 접속 설정(db/redis 호스트명, /data/upload)으로 교체 후 패키징
COPY docker/db.properties ./src/main/resources/db.properties
RUN mvn -q clean package -DskipTests

# ── 2단계: 실행 (Tomcat 10.1 + JDK 21) ──
FROM tomcat:10.1-jdk21-temurin
# 기본 예제 앱 제거
RUN rm -rf /usr/local/tomcat/webapps/*
# 컨텍스트 경로 /secondhand 로 배포
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/secondhand.war
EXPOSE 8080
