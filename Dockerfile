FROM openjdk:17-jdk-buster as builder

WORKDIR /build
RUN apt-get update -y && apt-get install -y git maven
RUN git clone https://github.com/sourcegraph/lsif-java.git . && \
    ./gradlew installDist

FROM openjdk:17-jdk-buster

COPY --from=builder /build/build/ /build/build/
RUN apt-get update -y && apt-get install -y maven
