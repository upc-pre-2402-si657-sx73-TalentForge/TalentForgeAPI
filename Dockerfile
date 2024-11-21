# Fase de construcción
FROM ubuntu:latest as build
RUN apt-get update
RUN apt-get install openjdk-21-jdk -y

# Copiar archivos necesarios para Maven Wrapper
COPY .mvn/ .mvn/
COPY mvnw .
COPY pom.xml .

# Dar permisos de ejecución al archivo mvnw
RUN chmod +x ./mvnw

# Instalar Maven y compilar el proyecto
RUN ./mvnw clean package

# Fase de ejecución
FROM openjdk:21-jdk-slim
EXPOSE 8080

# Copiar el archivo JAR generado en la fase de construcción
COPY --from=build target/TalentForgeApi-0.0.1-SNAPSHOT.jar app.jar

# Comando de entrada para ejecutar el archivo JAR
ENTRYPOINT ["java", "-jar", "app.jar"]
