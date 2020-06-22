#!/bin/bash

if [ "$#" -ne 4 ]; then
    echo "Usage: build-packer-image.sh <config file> <packer script folder> <output image name>"
	exit 1
fi

BUILD_AGENT_CONFIG_FILE=$1
BUILD_AGENT_PACKER_FOLDER=$2
IMAGE_NAME=$3

PROJECT=`cat ${BUILD_AGENT_CONFIG_FILE} | jq -r ".project_id"`

if [[ `gcloud --project=${PROJECT} compute images list --filter=name=${IMAGE_NAME} --format=json` != '[]' ]]; then

	echo "Image already exists; skipping build"

else
	cd ${BUILD_AGENT_PACKER_FOLDER}
	packer build -var-file=${BUILD_AGENT_CONFIG_FILE} -var image_name=${IMAGE_NAME} UE4-GCE-Win64-Git-GitHubActions-MSVC.json 
fi
