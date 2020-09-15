#!/bin/bash

ENV_VARS=""
in="FOO=BAR"
#in="FOO=BAR;NAME=travis;LAST=longoria"
in="FOO=BAR;NAME=travis;COLOR=red and green;URL=https://www.google.com"
IFS=';' list=($in)
pattern=" |'"
for item in "${list[@]}"; do
  case "$item" in
     *\ * )
          IFS='='
          read -ra strarr <<<"$item"
          ENV_VARS="-e ${strarr[0]}=\"${strarr[1]}\" ${ENV_VARS}"
          unset IFS
          ;;
       *)
          ENV_VARS="-e ${item} ${ENV_VARS}"
          ;;
  esac
done
echo "$ENV_VARS"

BUILD_PACK=$(if [ -n "" ]; then echo -n "--buildpack heroku/nodejs"; else echo -n ""; fi)

args=("$ENV_VARS")

#cmd="pack build nodefun ${ENV_VARS} --builder heroku/buildpacks ${BUILD_PACK}"
#echo $cmd
#$cmd

#pack build nodefun "${ENV_VARS}" --builder heroku/buildpacks --buildpack heroku/nodejs --verbose
pack build sample-hello-world-app --builder cnbs/sample-builder:alpine --buildpack . "${ENV_VARS}"

