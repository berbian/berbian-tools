#!/bin/bash

TOOL_VERSION='0.0.1'
TOOL_DEV_STATUS='devel'

KRN_SRC_ORIGIN='pmos'
COMPILADOR='aarch64-linux-gnu-gcc'
#COMPILADOR='clang'
KERNEL_OUTDIR='../out-pmos'

fn_install_reqs() {
	## Requeriments
	dpkg --add-architecture arm64
	apt-get update && apt-get dist-upgrade
	apt-get install g++-aarch64-linux-gnu build-essential crossbuild-essential-arm64 git-buildpackage \
         git debootstrap u-boot-tools device-tree-compiler libncurses-dev flex bison libssl-dev rsync kmod
 }

fn_config_compiler() {
	if [ "$COMPILADOR" == 'clang' ]; then
		CC="$(which $COMPILADOR 2> /dev/null)"
	elif [ "$COMPILADOR" == 'aarch64-linux-gnu-gcc' ]; then
		CC="$(which $COMPILADOR 2> /dev/null)"
	fi
	[[ -z "$CC" ]] && echo "Could not find clang or aarch64-linux-gnu-gcc in $PATH" && exit 1
}

fn_config_sources_download() {
	## Config sources download
	if [ "$KRN_SRC_ORIGIN" == "mobian" ]; then
		SRCS_LINK='https://salsa.debian.org/Mobian-team/devices/kernels/sdm845-linux'
		GIT_BRANCH='mobian-6.0'
		GIT_TAG=''
	elif [ "$KRN_SRC_ORIGIN" == "pmos" ]; then
		SRCS_LINK='https://gitlab.com/sdm845-mainline/linux'
		GIT_BRANCH='sdm845/6.0-release'
		GIT_TAG=''
	fi
}

fn_git_create_local_repo() {
	git init
	git checkout -b $GIT_BRANCK 
}

fn_git_pull_sources() {
	## Dwonload repo branch
	git pull $GIT_LINK $GIT_BRANCH
	## Dwonload repo branch tags
	git pull --tags $GIT_LINK $GIT_BRANCH
	## Create new test branch since specific tag from current branch
        # git switch tags/$GIT_TAG -b "$GIT_TAG"-berb-test
}

fn_apply_patches() {
	## Apply patches listed in "debian/patches/series"
	gbp pq import
}

fn_make_defconfig() {
	if [ "$KRN_SRC_ORIGIN" == 'pmos' ]; then
		## pmos defconfig
		ARCH=arm64 CC="$CC" CROSS_COMPILE=aarch64-linux-gnu- make defconfig sdm845.config
	elif [ "$KRN_SRC_ORIGIN" == 'mobian' ]; then
		## mobian defconfig
		ARCH=arm64 CC="$CC" CROSS_COMPILE=aarch64-linux-gnu- make sdm845_defconfig
	fi
	make ARCH=arm64 CC="$CC" CROSS_COMPILE=aarch64-linux-gnu- menuconfig
}
fn_make_build() {
	## Compilation
	 ARCH=arm64 CC="$CC" CROSS_COMPILE=aarch64-linux-gnu- O=$KERNEL_OUTDIR/ make \
		 -j"$(($(nproc --all)+2))" bindeb-pkg \
		KERNELRELEASE="6.1.0-sdm845-berb" KDEB_PKGVERSION="1"
}
fn_config_krnl_src() {
	echo 'TODO'
}
fn_build_krnl_src() {
	echo 'TODO'
}
fn_save_config() {
	echo 'TODO'
	## Backup .config file
	# ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- make savedefconfig
}

fn_build_pmos_android_image_sample() {
	echo 'TODO'
	# Build initrd and Android boot image
	  ## If no `-d` arg is passed, `mkbootimg.sh` will read the pmos deviceinfo file for the \
	   # currently selected device and select the dtb from there.
	mkb -d <path to dtb> -c "rootfs_part=sda14 rootfs_path=.stowaways/postmarketOS.img" -o ~/pmos-boot.img
	mkb
}

## TODO
## Copy "debian" packaging dir


#################
## Script exec ##
#################
# required:
#  $1(pmos|mobian) > KRN_SRC_ORIGIN='pmos'
#  $2(aarch64-linux-gnu-gcc | clang) > COMPILADOR='aarch64-linux-gnu-gcc'
#  $3(../out-pmos) > KERNEL_OUTDIR='../out-pmos'

## Install requirements
	# fn_install_reqs
## Config compiler
	fn_config_compiler
## Git create local repo and rename default branch
	# fn_git_create_local_repo
## Git configure pull
	# fn_config_sources_download 
## Apply [debian] patches
	# fn_apply_patches
## Defconfig
	fn_make_defconfig
## Build
	fn_make_build
## Save config
	# fn_save_config # TODO
## Build android image pmos sample
	# fn_build_pmos_android_image_sample # TODO
