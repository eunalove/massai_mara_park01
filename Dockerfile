# ./gradlew bootJava -Dorg.gradle.java.home=/usr/lib/jvm/java-21-amazon-corretto

# 실행 단계
FROM amazoncorretto:21-alpine

WORKDIR /app

COPY   /build/libs/*.jar   app.jar

ENV JAVA_OPTS="-Xms512m -Xmx512m"
ENV SERVER_PORT=8080

EXPOSE 8080

ENTRYPOINT ["sh", "-c", "java ${JAVA_OPTS} -jar app.jar"]