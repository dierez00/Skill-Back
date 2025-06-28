# Etapa 1: Compilar con Maven y Java 17
FROM maven:3.8.6-eclipse-temurin-17 AS builder

WORKDIR /app

# Copiar pom.xml y descargar dependencias primero (mejora el cache)
COPY pom.xml .
RUN mvn dependency:go-offline

# Copiar el resto del código y compilar
COPY src ./src
RUN mvn clean package -DskipTests

# Etapa 2: Crear imagen liviana con JRE 17
FROM eclipse-temurin:17-jdk-alpine

WORKDIR /app

# Copiar el .jar compilado
COPY --from=builder /app/target/*.jar app.jar

# Puerto dinámico para Render (usa variable $PORT)
ENV PORT=8080
EXPOSE $PORT

ENTRYPOINT ["java", "-jar", "app.jar"]
