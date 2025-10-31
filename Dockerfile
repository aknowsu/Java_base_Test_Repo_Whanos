FROM whanos-java

RUN apt-get update && \
    apt-get install -y maven && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY . .

RUN mvn clean package -DskipTests

ENTRYPOINT ["bash", "-c", "java -jar $(find target -name '*.jar' | head -n 1)"]
