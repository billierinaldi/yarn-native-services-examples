# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM centos:7

RUN yum install -y wget \
    && yum install -y which \
    && yum install -y java-1.8.0-openjdk-devel \
    && yum install -y gcc-c++ \
    && yum install -y make

ENV JAVA_HOME /usr/lib/jvm/java

RUN mkdir -p /opt/accumulo && \
    wget -nv --output-document=/opt/accumulo.tgz https://dist.apache.org/repos/dist/release/accumulo/1.8.0/accumulo-1.8.0-bin.tar.gz && \
    tar -C /opt/accumulo --extract --file /opt/accumulo.tgz --strip-components=1 && \
    rm /opt/accumulo.tgz* && \
    chown -R nobody /opt/accumulo && \
    /opt/accumulo/bin/build_native_library.sh

RUN mkdir -p /opt/zookeeper && \
    wget -nv --output-document=/opt/zookeeper.tgz https://dist.apache.org/repos/dist/release/zookeeper/zookeeper-3.4.6/zookeeper-3.4.6.tar.gz && \
    tar -C /opt/zookeeper --extract --file /opt/zookeeper.tgz --strip-components=1 && \
    rm /opt/zookeeper.tgz* && \
    chown -R nobody /opt/zookeeper

ENV ZOOKEEPER_HOME /opt/zookeeper
ENV HADOOP_VERSION 3.0.0-alpha2-SNAPSHOT

ADD etc-hadoop-conf /etc/hadoop/conf
ADD hadoop-$HADOOP_VERSION.tar.gz /opt/
RUN chown -R nobody /opt/hadoop-$HADOOP_VERSION

ENV HADOOP_PREFIX /opt/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR /etc/hadoop/conf
ENV HADOOP_HOME /opt/hadoop-$HADOOP_VERSION
ENV HADOOP_COMMON_HOME /opt/hadoop-$HADOOP_VERSION
ENV HADOOP_YARN_HOME /opt/hadoop-$HADOOP_VERSION
ENV HADOOP_HDFS_HOME /opt/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR /etc/hadoop/conf

ADD CustomAuthenticator.java /tmp
RUN pushd /tmp && \
    javac -cp /opt/accumulo/lib/accumulo-core.jar:/opt/accumulo/lib/accumulo-server-base.jar:/opt/hadoop-$HADOOP_VERSION/share/hadoop/common/hadoop-common-$HADOOP_VERSION.jar CustomAuthenticator.java && \
    jar cvf /opt/accumulo/lib/CustomAuthenticator.jar CustomAuthenticator.class && \
    rm -f /tmp/CustomAuthenticator.class && \
    popd

ADD resources /resources
ADD scripts/maybe_init.sh /
ADD scripts/wait_for_init.sh /
ADD scripts/launch.sh /
ADD scripts/setup_client.sh /
ADD scripts/get_conf.sh /
ADD scripts/destroy.sh /
ADD appConfig.json /
ADD resources.json /

ENV PATH /opt/accumulo/bin:/opt/hadoop-$HADOOP_VERSION/bin:$PATH
