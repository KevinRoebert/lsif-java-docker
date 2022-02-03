FROM openjdk:18-jdk-buster as builder

WORKDIR /build
ENV GRADLE_VERSION=7.3.3

RUN apt-get update -y && apt-get install -y git maven unzip
RUN wget https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -P /tmp && \
    unzip -d /opt/gradle /tmp/gradle-*.zip
ENV GRADLE_HOME=/opt/gradle/gradle-${GRADLE_VERSION}
ENV PATH=$PATH:$GRADLE_HOME/bin

RUN curl -fLo coursier https://git.io/coursier-cli \
  && chmod +x coursier \
  && ./coursier bootstrap --standalone -o lsif-java com.sourcegraph:lsif-java_2.13:0.7.2

FROM openjdk:18-jdk-buster

COPY --from=builder /build/ /build/
RUN apt-get update -y && apt-get install -y maven
