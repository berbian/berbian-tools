#!/bin/bash

CHROOT_DIR='/media/rootfs-img'
if [ "$USER" != 'root' ]; then SUDO='sudo'; fi

fn_start_chroot() {
	$SUDO mount -o bind /dev $CHROOT_DIR/dev
	$SUDO mount -o bind /dev/pts $CHROOT_DIR/dev/pts
	$SUDO mount -o bind /proc $CHROOT_DIR/proc
	$SUDO mount -o bind /sys $CHROOT_DIR/sys
	$SUDO cp -av $CHROOT_DIR/etc/hosts $CHROOT_DIR/etc/hosts_backup
	$SUDO echo "127.0.0.1 loclhost" > $CHROOT_DIR/etc/hosts
	$SUDO echo "199.232.150.132 deb.debian.org" >> $CHROOT_DIR/etc/hosts
	$SUDO echo "91.121.79.211 repo.mobian.org" >> $CHROOT_DIR/etc/hosts
	$SUDO chroot $CHROOT_DIR groupadd -g 3003 android_inet
	$SUDO chroot $CHROOT_DIR usermod -g android_inet _apt
	$SUDO chroot $CHROOT_DIR /bin/bash
}

fn_stop_chroot() {
	$SUDO cp -av $CHROOT_DIR/etc/hosts_backup $CHROOT_DIR/etc/hosts
	$SUDO chroot $CHROOT_DIR usermod -g nogroup _apt
	$SUDO chroot $CHROOT_DIR groupdel android_inet
	$SUDO umount $CHROOT_DIR/sys
	$SUDO umount $CHROOT_DIR/proc
	$SUDO umount $CHROOT_DIR/dev/pts
	$SUDO umount $CHROOT_DIR/dev
	#umount /media/rootfs-img
}

if [ "$1" == "start" ]; then
	fn_start_chroot
elif [ "$1" == "stop" ]; then
	fn_stop_chroot
fi
