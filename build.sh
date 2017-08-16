#! /bin/bash

# export BRANCH and/or COMMIT to modify the build process

branch="${BRANCH:=master}"
commit="${COMMIT:=$(curl -s https://api.github.com/repos/red-eclipse/base/commits/$branch | jq -r '.sha')}"

image_name="quay.io/theassassin/redeclipse"

docker build --build-arg COMMIT="$commit" --build-arg BRANCH="$branch" -t "$image_name:$commit" -t "$image_name:$branch" .
docker push "$image_name:$commit"
docker push "$image_name:$branch"
