#!/bin/bash

DEVICE='pocof1'

# Defconfig files for pmos kernel
DEFCONFIG_FILES="defconfig sdm845.config"

# Defconfig files for mobian kernel 5
DEFCONFIG_FILES_MOB5="sdm845_defconfig"
# Defconfig files for mobian kernel 6
DEFCONFIG_FILES_MOB6="sdm845_defconfig sdm845.config"

ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- make $DEFCONFIG_FILES

ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- make menuconfig
