#! /usr/bin/env bash

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

NAME=$1

if [ -z $NAME ] ; then
   echo "usage: $0 appname"
   exit 1
fi

/get_conf.sh $NAME accumulo-env env accumulo-env.sh
/get_conf.sh $NAME accumulo-site xml accumulo-site.xml
/get_conf.sh $NAME client properties client.conf
/get_conf.sh $NAME log4j template log4j.properties
