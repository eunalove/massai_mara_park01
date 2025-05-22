# 1단계: Gradle 빌드
FROM gradle:8.5-jdk17-alpine AS builder

WORKDIR /app

# Gradle 캐시를 활용하기 위해 의존성 먼저 복사
COPY build.gradle.kts settings.gradle.kts ./
COPY gradle ./gradle

RUN gradle dependencies --no-daemon || true

# 나머지 소스 복사 후 빌드
COPY . .

RUN gradle bootJar --no-daemon -x test

# 2단계: 실제 실행 이미지
FROM amazoncorretto:17-alpine

WORKDIR /app

# 빌드된 JAR 복사
COPY --from=builder /app/build/libs/*.jar app.jar

# JVM 옵션 및 포트 설정
ENV JAVA_OPTS="-Xms512m -Xmx512m"
ENV SERVER_PORT=8080

EXPOSE 8080

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
