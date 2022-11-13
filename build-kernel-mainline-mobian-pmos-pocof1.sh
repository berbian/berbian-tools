#!/bin/bash

ANSWER=""
VERSION=""
CC='/usr/bin/aarch64-linux-gnu-gcc'

VERSION_PMOS_5="5.19.17-pmos-berb-sdm845"
VERSION_PMOS_60="6.0.6-pmos-berb-sdm845"
VERSION_PMOS_61="6.1.0-mobian-pmos-sdm845"
VERSION_MOBI_5="5.19.17-mobian-berb-sdm845"
VERSION_MOBI_6="6.0.5-mobian-berb-sdm845"
VERSION_DEFAULT="$VERSION_PMOS_61"


echo && read -p "Type a version string or Enter to default [ $VERSION_DEFAULT ]: " ANSWER
if [ "$ANSWER" == "" ]; then VERSION="$VERSION_DEFAULT"; fi

echo && read -p "Version string \"$VERSION\" will be used."

## Build command
ARCH=arm64 CC="$CC" CROSS_COMPILE=aarch64-linux-gnu- make -j"$(($(nproc --all)+2))" bindeb-pkg \
	KERNELRELEASE="$VERSION" KDEB_PKGVERSION="1"

