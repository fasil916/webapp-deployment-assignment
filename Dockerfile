FROM eclipse-temurin:17-jdk-jammy

WORKDIR /app

COPY target/hello-microservice-1.0.0.jar app.jar

RUN groupadd -r appuser && useradd -r -g appuser appuser

RUN chown -R appuser:appuser /app

USER appuser

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]

