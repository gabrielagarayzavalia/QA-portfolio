FROM maven:3.9-eclipse-temurin-21-alpine AS build
WORKDIR /build
COPY sut/spring-api/pom.xml .
COPY sut/spring-api/src ./src
RUN mvn -q package -DskipTests

FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY --from=build /build/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
