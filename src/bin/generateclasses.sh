#!/bin/bash --

outputpath=com/support/bonitasoft

mkdir -p "${outputpath}"  2> /dev/null

methods=$(j=0;while [ $j -lt $2 ] ; do j=$((j + 1));printf '\npublic String get%04d() {\nString internalString = "%s";\ninternalString += ",%04d" + data;\nreturn internalString;\n}' $j $RANDOM $j;done)

maxNbOfClasses=$1
nbOfClasses=0
nbOfClassesPerPackage=500
if [[ $maxNbOfClasses -lt $nbOfClassesPerPackage ]] ; then
  nbOfClassesPerPackage=$maxNbOfClasses
fi
nbOfPackages=0
maxNbOfClassesAlt=$((maxNbOfClasses - 3))
while [[ $nbOfClasses -lt $maxNbOfClasses ]] ; do
  packagepath="${outputpath}"/autogen$(printf "%04d" $nbOfPackages)
  mkdir -p "${packagepath}"  2> /dev/null
  maxNbOfChainedClasses=$((nbOfClassesPerPackage - 2))
  i=0
  while [[ $i -lt $maxNbOfChainedClasses && $nbOfClasses -lt $maxNbOfClassesAlt ]] ; do
    num=$((i + 1))
    printf 'package com.support.bonitasoft.autogen%04d;\nimport java.io.Serializable;\nimport java.util.List;\npublic class Auto%04d implements Serializable {\npublic Serializable auto%04d = null;\npublic transient String data = null;\npublic Auto%04d(String data, List<Serializable> objects) {\nthis.data = "%s,%04d" + data;\nobjects.add(this);\nauto%04d = new Auto%04d(data,objects);\n}%s\n}' $nbOfPackages $i $num $i $RANDOM $i $num $num "${methods}" > "${packagepath}"/Auto$(printf '%04d' $i).java
    i=$num
    nbOfClasses=$((nbOfClasses + 1))
  done
  printf 'package com.support.bonitasoft.autogen%04d;\nimport java.io.Serializable;\nimport java.util.List;\npublic class Auto%04d implements Serializable {\npublic String data = null;\npublic Auto%04d(String data, List<Serializable> objects) {\nthis.data = data;\nobjects.add(this);\n}\n}' $nbOfPackages $i $i > "${packagepath}"/Auto$(printf '%04d' $i).java
  printf 'package com.support.bonitasoft.autogen%04d;\nimport java.io.Serializable;\nimport java.util.List;\nimport java.util.ArrayList;\npublic class TestC implements Serializable {\npublic List<Serializable> objects = null;\npublic transient String oneKB = "Lorem ipsum %s,0000";\npublic String data = null;\npublic TestC() {\ndata = oneKB + System.currentTimeMillis();\nobjects = new ArrayList<>();\nnew Auto%04d(data, objects);\n}\n }' $nbOfPackages $RANDOM 0 > "${packagepath}"/TestC.java
  i=$((i + 1))
  nbOfClasses=$((nbOfClasses + 2))
  nbOfPackages=$((nbOfPackages + 1))
done
packagepath="${outputpath}"/autogen
mkdir -p "${packagepath}" 2> /dev/null
printf 'package com.support.bonitasoft.autogen;\nimport java.io.Serializable;\nimport java.util.List;\nimport java.util.ArrayList;\npublic class TestC implements Serializable {\npublic List<Serializable> objects = null;\npublic TestC() {\nobjects = new ArrayList<>();\n' $RANDOM 0 >> "${packagepath}"/TestC.java
k=0
while [[ $k -lt $nbOfPackages ]] ; do
  printf 'objects.add(new com.support.bonitasoft.autogen%04d.TestC());\n' $k >> "${packagepath}"/TestC.java
  k=$((k + 1))
done
printf '\n}\n }' >> "${packagepath}"/TestC.java
