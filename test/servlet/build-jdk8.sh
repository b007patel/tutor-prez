#!/bin/bash

jdk8dir=/java/8/not/found
if [ "`uname -s`" == "Darwin" ]; then
    jdk8dir=/Library/Java/JavaVirtualMachines/jdk1.8.0_102.jdk/Contents/Home
fi
if [ "`uname -s`" == "Linux" ]; then
    jdk8dir=/usr/lib/jvm/java-8-openjdk-amd64
fi
HOMEDIR=`ls -d ~`

dbg_flag=""
if [ -n "${1}" ]; then
    dbg_flag="-g -sourcepath /home/ubuntu/gitrepo/tutor-prez"
fi

pushd ~/gitrepo/tutor-prez
${jdk8dir}/bin/javac ${dbg_flag} -cp "${HOMEDIR}/java-jars/selenium-server-standalone-2.53.1.jar:${HOMEDIR}/java-jars/jsoup-1.9.2.jar:${HOMEDIR}/java-jars/mysql-connector-java-5.1.17.jar:." tputil/*.java test/*.java test/pageobjects/*.java test/servlet/*.java
popd
