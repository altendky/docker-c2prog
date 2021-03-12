#!/usr/bin/bash

set -evx

NAME_AND_TAG=$1

id

docker run --user 1000 --pull never --interactive --rm ${NAME_AND_TAG} -target | tee run.log
grep --quiet 'Missing option -bin or -ehx!' run.log
cd example
ls -l
docker run --user 1000 --pull never --volume "$(pwd)/custom_demo.xml":/targets/custom_demo.xml --volume "$(pwd)":/data --rm ${NAME_AND_TAG} -create="z:/data/result.ehx" -bin="z:/data/test_2838x_c28_cpu01.out" -target=28388,6,4-CPU1_XBL-Demo
ls -l
[[ "$(stat -c %s test_2838x_c28_cpu01.ehx)" -eq "$(stat -c %s result.ehx)" ]]
rm result.ehx
