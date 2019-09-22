#!/bin/bash
set -ex
docker images | grep ^alpine- | while read name ignore; do
  docker tag $name wkite/$name
  docker push wkite/$name
  docker rmi wkite/$name
done
