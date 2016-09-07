#!/bin/bash

jdk7dir=/Library/Java/JavaVirtualMachines/jdk1.7.0_45.jdk/Contents/Home
HOMEDIR=`ls -d ~`

pushd ~/gitrepo/tutor-prez
${jdk7dir}/bin/javac -cp "${HOMEDIR}/java-jars/selenium-server-standalone-2.53.1.jar:${HOMEDIR}/java-jars/jsoup-1.9.2.jar:${HOMEDIR}/java-jars/mysql-connector-java-5.1.17.jar:." test/*.java test/pageobjects/*.java test/servlet/*.java
popd
