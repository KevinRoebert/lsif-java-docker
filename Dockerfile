FROM openjdk:17-jdk-buster as builder

WORKDIR /build
ENV GRADLE_VERSION=7.2

RUN apt-get update -y && apt-get install -y git maven unzip
RUN wget https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -P /tmp && \
    unzip -d /opt/gradle /tmp/gradle-*.zip
ENV GRADLE_HOME=/opt/gradle/gradle-${GRADLE_VERSION}
ENV PATH=$PATH:$GRADLE_HOME/bin

RUN git clone https://github.com/sourcegraph/lsif-java.git .
RUN gradle installDist

FROM openjdk:17-jdk-buster

COPY --from=builder /build/build/ /build/build/
RUN apt-get update -y && apt-get install -y maven
