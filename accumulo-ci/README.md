# Running Apache Accumulo Continuous Ingest with Apache Hadoop YARN Native Services

This is an example Docker image that can be used to run [Apache Accumulo](http://accumulo.apache.org) with its continuous ingest test suite using [Apache Hadoop](http://hadoop.apache.org) YARN Native Services.
This is a toy nonsecure example for testing out the new YARN features.

## Setting up

Follow the instructions for the yarn-native-services-examples/accumulo example, including building and setting up Hadoop, building the accumulo Docker image, and building the accumulo app to HDFS for use as an external app.
Do not launch or start the accumulo app.

After building the accumulo Docker image, build the accumulo-ci Docker image.
```
cd yarn-native-services-examples/accumulo-ci
scripts/build.sh
```

Note the image must be present on all nodes.

## Running Accumulo Continuous Ingest

Launch a YARN app:
```
docker run -it accumulo-ci /launch.sh ci1
```

Create a client image:
```
docker run -t --name accumulo-ci1 accumulo-ci /setup_ci_client.sh ci1
docker commit -m "accumulo ci1 client" accumulo-ci1 accumulo-ci1
```

Run a generic client container:
```
docker run -it accumulo-ci1 bash
```

Stop ingest:
```
docker run -t accumulo-ci1 yarn slider flex ci1 --component INGESTER 0
```

Verify data ingested (note I was unable to launch this MR job without removing the conflicting version of libthrift from the YARN client classpath):
```
docker run -it accumulo-ci1 bash
rm -f /opt/hadoop-3.0.0-alpha2-SNAPSHOT/share/hadoop/yarn/lib/libthrift-0.9.0.jar && . /opt/accumulo/conf/ci-env.sh && tool.sh /opt/accumulo/lib/accumulo-test.jar org.apache.accumulo.test.continuous.ContinuousVerify -Dmapreduce.map.memory.mb=512 -Dmapreduce.map.java.opts=-Xmx500m -Dmapreduce.reduce.memory.mb=512 -Dmapreduce.reduce.java.opts=-Xmx500m -Dmapreduce.job.reduce.slowstart.completedmaps=0.95 -libjars /opt/accumulo/lib/accumulo-test.jar $AUTH_OPT -i $INSTANCE_NAME -z $ZOO_KEEPERS -u $ACCUMULO_USER -p $PASS --table $TABLE --output output --maxMappers 4 --reducers 4 $SCAN_OPT
```

Stop and destroy the app:
```
docker run -t accumulo-ci /destroy.sh ci1
```

## Note on passwords

For the accumulo app, user passwords can be kept out of the appConfig due to the
 use of the CustomAuthenticator along with Accumulo's CredentialProviderShim.This method reads passwords from a JavaKeyStore in HDFS instead of from the command line or from a configuration file.
Continuous ingest clients are designed to read the user password from the comman
d line, so for the continuous ingest app we must have the password in the appCon
fig.
This is not a problem for a toy example like this one, but in designing other apps for YARN native services, developers should consider using a CredentialProvider approach or enabling Kerberos.
