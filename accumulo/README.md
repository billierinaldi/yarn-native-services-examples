# Running Apache Accumulo with Apache Hadoop YARN Native Services

This is an example Docker image that can be used to run [Apache Accumulo](http://accumulo.apache.org) using [Apache Hadoop](http://hadoop.apache.org) YARN Native Services.
This is a toy nonsecure example for testing out the new YARN features.

## Setting up Hadoop

First, build the [yarn-native-services branch](https://github.com/apache/hadoop/tree/yarn-native-services) of Hadoop with patches [YARN-5690](https://issues.apache.org/jira/browse/YARN-5690) and [YARN-5701](https://issues.apache.org/jira/browse/YARN-5701) applied.
Include the -Pnative flag when building.
I used the following mvn command:
```
mvn clean package -Pdist -Pnative -DskipTests -Dtar -Dcontainer-executor.additional_cflags="-DDEBUG" -Dmaven.javadoc.skip=true
```

Install, configure, and start HDFS and YARN, as well as ZooKeeper.
Beyond the standard YARN configurations, set the following values in yarn-site.xml.
Also make sure to change the group of the Hadoop installation to match that of yarn.nodemanager.linux-container-executor.group, and to chmod permissions on the bin/container-executor file (750 and ug+s worked for me).
```
<property>
  <name>yarn.nodemanager.linux-container-executor.group</name>
  <value>hadoop</value>
</property>
<property>
  <name>yarn.nodemanager.linux-container-executor.nonsecure-mode.local-user</name>
  <value>nobody</value>
</property>
<property>
  <name>yarn.nodemanager.container-executor.class</name>
  <value>org.apache.hadoop.yarn.server.nodemanager.LinuxContainerExecutor</value>
</property>
```

Now you are able to issue "yarn slider" commands that previously would have been issued as [Apache Slider (incubating)](https://slider.incubator.apache.org) commands (see [Slider's command reference guide](http://slider.incubator.apache.org/docs/manpage.html)).

## Building the Docker image

Copy the hadoop tarball into the yarn-native-services-examples/accumulo directory and cd into that directory.

Build the Docker image:
```
scripts/build.sh
```

Note the image must be present on all nodes.

## Running an Accumulo app

Launch a YARN app:
```
docker run -it accumulo /launch.sh ac1
```

You will be prompted for a number of sensitive properties, including the Accumulo root user password.

Create a client image:
```
docker run -t --name accumulo-ac1 accumulo /setup_client.sh ac1
docker commit -m "accumulo ac1 client" accumulo-ac1 accumulo-ac1
```

Run the accumulo shell:
```
docker run -it accumulo-ac1 accumulo shell
```

Run a generic client container:
```
docker run -it accumulo-ac1 bash
```

Stop and destroy the app:
```
docker run -t accumulo /destroy.sh ac1
```

Build to HDFS for use as an external app:
```
docker run -t accumulo yarn slider build accumulo --template /appConfig.json --resources /resources.json --provider docker
```
