#!/bin/bash

srcdir=~/gitrepo/tutor-prez
depdir=${srcdir}/WEB-INF
outwar=chemtestpage.war

if [ -d ${depdir} ]; then
    read -p "${depdir} will be deleted. Proceed? (y/N)> " keepdir
    if [ "${keepdir}" != "Y" -a "${keepdir}" != "y" ]; then
        exit 1
    fi
fi

rm -f ${srcdir}/${outwar}
rm -rf ${depdir}
mkdir -p ${depdir}/lib
mkdir -p ${depdir}/classes

cp ${srcdir}/test/servlet/web.xml ${depdir}
rm -rf ${srcdir}/tmpjar
mkdir ${srcdir}/tmpjar

pushd ${srcdir}
find tputil -name "*.class" -exec ${srcdir}/test/servlet/cp_class.sh {} ${srcdir}/tmpjar \;
find test -name "*.class" -exec ${srcdir}/test/servlet/cp_class.sh {} ${srcdir}/tmpjar \;

cd tmpjar
jar cvf ${depdir}/lib/chemtest.jar *

# 3rd party jars
## because of servlet container connection pooling, the needed driver jars
## must already be in the directory given by the container's docs
## For tomcat, that's ${CATALINA_HOME}/lib, or /usr/share/tomcat7/lib
cp ~/java-jars/mysql-connector-java-5.1.17.jar ${depdir}/lib
cp ~/java-jars/jsoup-1.9.2.jar ${depdir}/lib
cp ~/selenium/java/selenium-2.53.1/libs/* ${depdir}/lib
cp ~/selenium/java/selenium-2.53.1/selenium-java-2.53.1.jar ${depdir}/lib

cd ${srcdir}
jar cvf ${outwar} WEB-INF

