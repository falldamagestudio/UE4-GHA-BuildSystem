#!/bin/bash

if [ "$#" -ne 3 ]; then
    echo "Usage: build-packer-image.sh <template file, with absolute path> <variable file, with absolute path> <output image name>"
	exit 1
fi

TEMPLATE_FILE=$1
VARIABLE_FILE=$2
IMAGE_NAME=$3

TEMPLATE_FOLDER=`dirname "${TEMPLATE_FILE}"`
TEMPLATE_FILENAME=`base "${TEMPLATE_FILE}"`

PROJECT=`cat ${VARIABLE_FILE} | jq -r ".project_id"`

if [[ `gcloud --project=${PROJECT} compute images list --filter=name=${IMAGE_NAME} --format=json` != '[]' ]]; then

	echo "Image already exists; skipping build"

else
	cd ${TEMPLATE_FOLDER}
	packer build -var-file=${VARIABLE_FILE} -var image_name=${IMAGE_NAME} ${TEMPLATE_FILENAME}
fi
