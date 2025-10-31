FROM whanos-java

RUN apt-get update && \
    apt-get install -y maven && \
    rm -rf /var/lib/apt/lists/*

COPY . .
WORKDIR /app/app

RUN mvn clean package -DskipTests

RUN JAR_FILE=$(find target -name "*.jar" | grep -v "original" | head -1) && \
    if [ -z "$JAR_FILE" ]; then \
        echo "ERROR: No JAR file found in target/"; \
        exit 1; \
    fi && \
    echo "Found JAR: $JAR_FILE" && \
    cp "$JAR_FILE" /app/app.jar

RUN rm -rf target/ src/ ~/.m2 && \
    apt-get purge -y maven && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

ENTRYPOINT ["java"]

CMD ["-jar", "app.jar"]
