#!/bin/bash

currdepdir=`dirname ${2}/${1}`;
if [ ! -d ${currdepdir} ]; then
    mkdir -p ${currdepdir}
fi

cp ${1} ${2}/${1}
