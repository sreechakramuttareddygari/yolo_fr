#!/bin/bash

set -e

# check argument
if [[ -z $1 || ! $1 =~ [[:digit:]]x[[:digit:]] ]]; then
  echo "ERROR: This script requires 1 argument, \"input dimension\" of the YOLO model."
  echo "The input dimension should be {width}x{height} such as 608x608 or 416x256.".
  exit 1
fi

if which python3 > /dev/null; then
  PYTHON=python3
else
  PYTHON=python
fi

echo "** Install requirements"
# "gdown" is for downloading files from GoogleDrive
pip3 install --user gdown > /dev/null

# make sure to download dataset files to "yolov4_crowdhuman/data/raw/"
mkdir -p $(dirname $0)/raw
pushd $(dirname $0)/raw > /dev/null

get_file()
{
  # do download only if the file does not exist
  if [[ -f $2 ]];  then
    echo Skipping $2
  else
    echo Downloading $2...
    python3 -m gdown.cli $1
  fi
}

echo "** Download dataset files"
get_file https://drive.google.com/uc?id=1kX-n2PQrcpY7r9d1L397QRyIcKGOON8o Annotations_all.zip
#https://drive.google.com/file/d/1rrBNaBdX_jJkFZD0qMa4DL1HU2FFlPx9/view?usp=sharing
#https://drive.google.com/file/d/1kX-n2PQrcpY7r9d1L397QRyIcKGOON8o/view?usp=sharing
#get_file https://drive.google.com/uc?id=1sQ9HWEk8o7cb0BHYfUzIeui3Mo8G4fwZ CrowdHuman_train02.zip
#get_file https://drive.google.com/uc?id=1iFsJjMyYqgowEc8I5Y-z_ugX0NAvlLUy CrowdHuman_train03.zip
#get_file https://drive.google.com/uc?id=1G8ASJYDkK32uie5lj1tyHFE9MriKHdhM CrowdHuman_val.zip
# test data is not needed...
# get_file https://drive.google.com/uc?id=1tQG3E_RrRI4wIGskorLTmDiWHH2okVvk CrowdHuman_test.zip
#get_file https://drive.google.com/u/0/uc?id=1MX5jVfUNm-VC8OCg6YKzwwe7nd4PomUf annotation_train.odgt
#get_file https://drive.google.com/u/0/uc?id=103SIb64U-llIHoTUnwAuwi9e41Ny_tnD annotation_val.odgt

# unzip image files (ignore CrowdHuman_test.zip for now)
echo "** Unzip dataset files"
#for f in CrowdHuman_train01.zip CrowdHuman_train02.zip CrowdHuman_train03.zip CrowdHuman_val.zip ; do
#  unzip -n ${f}
#done

unzip -n annotation_check_yolo_format_head.zip
echo "** Create the crowdhuman-$1/ subdirectory"
rm -rf ../crowdhuman-$1/
mkdir ../crowdhuman-$1/
ln annotation_check_yolo_format_head/*.jpg ../crowdhuman-$1/
ln annotation_check_yolo_format_head/*.txt ../crowdhuman-$1/

# the crowdhuman/ subdirectory now contains all train/val jpg images

echo "** Generate yolo txt files"
cd ..
#${PYTHON} gen_txts.py $1

popd > /dev/null

echo "** Done."
