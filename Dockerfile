FROM openjdk:17-jdk-buster as builder

WORKDIR /build
RUN apt-get update -y && apt-get install -y git maven unzip
RUN wget https://services.gradle.org/distributions/gradle-7.2-bin.zip -P /tmp && \
    unzip -d /opt/gradle /tmp/gradle-*.zip
ENV GRADLE_HOME=/opt/gradle
ENV PATH=$PATH:$GRADLE_HOME/bin

RUN git clone https://github.com/sourcegraph/lsif-java.git .
RUN /opt/gradle installDist

FROM openjdk:17-jdk-buster

COPY --from=builder /build/build/ /build/build/
RUN apt-get update -y && apt-get install -y maven
