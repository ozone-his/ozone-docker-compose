# Use the base Orthanc plugins image
FROM jodogne/orthanc-plugins:latest

RUN apt-get update && apt-get install -y openjdk-17-jdk cmake build-essential python3 unzip libjsoncpp-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

WORKDIR /home/root/
RUN wget -qO- https://orthanc.uclouvain.be/downloads/sources/orthanc-java/OrthancJava-1.0.tar.gz | tar xvz

WORKDIR /home/root/OrthancJava-1.0
RUN mkdir BuildPlugin && \
    cd BuildPlugin && \
    cmake ../Plugin -DCMAKE_BUILD_TYPE=Release && \
    make

WORKDIR /home/root/OrthancJava-1.0
RUN mkdir BuildJavaSDK && \
    cd BuildJavaSDK && \
    cmake ../JavaSDK && \
    make

WORKDIR /home/root/
RUN wget https://orthanc.uclouvain.be/downloads/cross-platform/orthanc-java/mainline/OrthancFHIR.jar

COPY java/HelloWorld.java /home/root/java/
WORKDIR /home/root/java/
RUN javac -cp /home/root/OrthancJava-1.0/BuildJavaSDK/OrthancJavaSDK.jar HelloWorld.java

# Expose Orthanc default port
EXPOSE 4242 8042

ENV LD_PRELOAD=/usr/lib/jvm/java-17-openjdk-amd64/lib/server/libjvm.so
ENTRYPOINT ["/usr/local/sbin/Orthanc"]