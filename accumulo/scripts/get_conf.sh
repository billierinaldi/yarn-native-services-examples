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
CONF=$2
FORMAT=$3
FILENAME=$4

if [ -z $NAME ] || [ -z $CONF ] || [ -z $FORMAT ] || [ -z $FILENAME ] ; then
   echo "usage: $0 appname confname format filename"
   exit 1
fi

runcmd() {
  CMD=$1
  echo $CMD
  until $CMD; do
    echo "Retrying $CMD"
    sleep 5;
  done
}

runcmd "yarn slider registry --name $NAME --getconf $CONF --format $FORMAT --dest /opt/accumulo/conf/$FILENAME"
