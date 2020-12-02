#!/sbin/sh

LD_PATH=/system/lib
if [ -d /system/lib64 ]; then
  LD_PATH=/system/lib64
fi

exec_util() {
  LD_LIBRARY_PATH=/system/lib64 $UTILS $1
}

RC_INIT=init.d8g.rc
RC_DC=init.dc.rc
RC_PUBG=init.pubg.rc
RC_PROFIL=init.spectrum.rc
RC_VDIR=/vendor/etc/init
SH_DIR=/vendor/etc/d8g
TMP_INIT=$ramdisk/overlay.d
TMP_SH=$TMP_INIT/sbin
#AV=getprop ro.system.build.version.sdk

copy_initA11() {
	exec_util "cp -af $TMP_INIT/$RC_INIT $RC_VDIR"
	rm -f $TMP_INIT/init.d8g.rc
	
	ImplementInit
}

RM_A10() {
	#rm -f $TMP_INIT/init.d8g.rc
	rm -f $TMP_INIT/init.dc.rc
	rm -f $TMP_INIT/init.pubg.rc
	rm -f $TMP_INIT/init.spectrum.rc
	rm -rf $TMP_SH;
}

RM_A11() {
if [ -d $SH_DIR ]; then
  rm -fr $SH_DIR
fi

if [ -f $RC_VDIR/$RC_INIT ]; then
  rm -f $RC_VDIR/$RC_INIT
fi
if [ -f $RC_VDIR/$RC_DC ]; then
  rm -f $RC_VDIR/$RC_DC
fi
if [ -f $RC_VDIR/$RC_PUBG ]; then
  rm -f $RC_VDIR/$RC_PUBG
fi
if [ -f $RC_VDIR/$RC_PROFIL ]; then
  rm -f $RC_VDIR/$RC_PROFIL
fi

if [ -f $RC_VDIR/hw/$RC_INIT ]; then
  rm -f $RC_VDIR/hw/$RC_INIT
fi
if [ -f $RC_VDIR/hw/$RC_DC ]; then
  rm -f $RC_VDIR/hw/$RC_DC
fi
if [ -f $RC_VDIR/hw/$RC_PUBG ]; then
  rm -f $RC_VDIR/hw/$RC_PUBG
fi
if [ -f $RC_VDIR/hw/$RC_PROFIL ]; then
  rm -f $RC_VDIR/hw/$RC_PROFIL
fi
}

ImplementInit() {
	#ui_print " ";
	#ui_print "Implementing Init...";
	if ! grep -q 'init.d8g.rc' /vendor/etc/init/hw/init.qcom.rc; then
		sed -i "/POSSIBILITY/c\import /vendor/etc/init/init.d8g.rc" /vendor/etc/init/hw/init.qcom.rc
	#	ui_print "-> Implementing Init Success";
	#	ui_print " ";
	#else
	#	ui_print "-> Init Implemented";
	#	ui_print " ";
	fi;

	if [ -f /vendor/etc/init/init.miui.rc ]; then
		rm -f /vendor/etc/init/init.miui.rc
	fi;
	if [ -f /system/etc/init/init.miui.rc ]; then
		rm -f /system/etc/init/init.miui.rc
	fi;
	if [ -f /system/bin/rw-vendor.sh ]; then
		rm -f /system/bin/rw-vendor.sh
	fi;
	if [ -f /system/bin/rw-system.sh ]; then
		sed -i "/over/c\    fixSPL" /system/bin/rw-system.sh
	fi;
	if [ -f /system_root/runtests.sh ]; then
		rm -f /system_root/runtests.sh
	fi;
}

InitA10() {
	#ui_print "Android : 9 - 10"; ui_print " ";
	#Remove Init A11
	RM_A11

	echo "10" >> /data/media/0/d8g/av
}

InitA11() {
	#ui_print "Android : 11"; ui_print " ";
	#Remove Init Android 11
	RM_A11
	#Make dir D8G Config
	if [ ! -d $SH_DIR ]; then
		mkdir -p $SH_DIR
	fi
	if [ -d /data/.d8g ]; then
		rm -rf /data/.d8g
	fi
	mkdir -p /data/.d8g
	#Install Init Android 11
	exec_util "cp -af $TMP_INIT/$RC_INIT $RC_VDIR"
	exec_util "cp -af $TMP_INIT/$RC_DC $RC_VDIR"
	exec_util "cp -af $TMP_INIT/$RC_PUBG $RC_VDIR"
	exec_util "cp -af $TMP_INIT/$RC_PROFIL $RC_VDIR"

	exec_util "cp -af $TMP_SH/bp $SH_DIR"
	exec_util "cp -af $TMP_SH/d8ginit $SH_DIR"
	exec_util "cp -af $TMP_SH/d8gp $SH_DIR"
	exec_util "cp -af $TMP_SH/d8grm $SH_DIR"
	exec_util "cp -af $TMP_SH/dc $SH_DIR"
	exec_util "cp -af $TMP_SH/dkm $SH_DIR"
	exec_util "cp -af $TMP_SH/dkm /data/.d8g"
	exec_util "cp -af $TMP_SH/pubg $SH_DIR"
	exec_util "cp -af $TMP_SH/pubgsav $SH_DIR"
	exec_util "cp -af $TMP_SH/pubguc $SH_DIR"
	exec_util "cp -af $TMP_SH/te $SH_DIR"
	exec_util "cp -af $TMP_SH/teb $SH_DIR"
	exec_util "cp -af $TMP_SH/tebp $SH_DIR"
	exec_util "cp -af $TMP_SH/tec $SH_DIR"
	exec_util "cp -af $TMP_SH/tecb $SH_DIR"
	exec_util "cp -af $TMP_SH/wcnss $SH_DIR"

	#Remove Init Android 9 - 10
	#A10
	rm -f $TMP_INIT/init.d8g.rc
	rm -rf $TMP_SH;

	ImplementInit

	echo "11" >> /data/media/0/d8g/av
}

perm() {
	chmod -R 644 $TMP_INIT/$RC_INIT;
	chmod -R 644 $TMP_INIT/$RC_DC;
	chmod -R 644 $TMP_INIT/$RC_PUBG;
	chmod -R 644 $TMP_INIT/$RC_PROFIL;
	chmod -R 755 $TMP_SH/bp;
	chmod -R 755 $TMP_SH/d8ginit;
	chmod -R 755 $TMP_SH/d8gp;
	chmod -R 755 $TMP_SH/d8grm;
	chmod -R 755 $TMP_SH/dc;
	chmod -R 644 $TMP_SH/dkm;
	chmod -R 755 $TMP_SH/pubg;
	chmod -R 755 $TMP_SH/pubgsav;
	chmod -R 755 $TMP_SH/pubguc;
	chmod -R 755 $TMP_SH/te;
	chmod -R 755 $TMP_SH/teb;
	chmod -R 755 $TMP_SH/tebp;
	chmod -R 755 $TMP_SH/tec;
	chmod -R 755 $TMP_SH/tecb;
	chmod -R 755 $TMP_SH/wcnss;
}
# Installing Init
#ui_print " "; ui_print "Installing init...";
umount /vendor || true
mount -o rw /dev/block/bootdevice/by-name/vendor /vendor
perm

#ui_print "SDK Version : $AV";

if [ $install_init = 0 ]; then
	if [ $patch_build = 0 ]; then
		if [ $AV = 1 ]; then
			ui_print "-> Android 11 Selected....";
			InitA11
		else
			if [ $AV2 = 1 ]; then
				ui_print "-> Android 10 Selected....";
			else
				ui_print "-> Android 9 Selected....";
			fi
			InitA10
		fi;
	else
		#ui_print " "
		#ui_print "Checking Android Version"
		if ! grep -q 'ro.system.build.version.sdk=30' $patch_build; then
			if ! grep -q 'ro.system.build.version.sdk=29' $patch_build; then
				#ui_print "-> Android 9 Detected....";
				install_av="  -> Android : 9"
				AV2=0
			else
				#ui_print "-> Android 10 Detected....";
				install_av="  -> Android : 10"
				AV2=1
			fi
			InitA10
			AV=0
		else
			#ui_print "-> Android 11 detected....";
			InitA11
			AV=1
			install_av="  -> Android : 11"
		fi;
	fi
else

	RM_A10
	RM_A11
	RM_MODULE

	#ui_print " "
	#ui_print "Checking Android Version"
	if [ $patch_build = 0 ]; then
		if [ $AV = 1 ]; then
			ui_print "-> Android 11 Selected....";
			install_av="  -> Android : 11"
		else
			if [ $AV2 = 1 ]; then
				ui_print "-> Android 10 Selected....";
				install_av="  -> Android : 10"
			else
				ui_print "-> Android 9 Selected....";
				install_av="  -> Android : 9"
			fi
		fi;
	else
		if ! grep -q 'ro.system.build.version.sdk=30' $patch_build; then
			if ! grep -q 'ro.system.build.version.sdk=29' $patch_build; then
				#ui_print "-> Android 9 Detected....";
				install_av="  -> Android : 9"
				AV2=0
			else
				#ui_print "-> Android 10 Detected....";
				install_av="  -> Android : 10"
				AV2=1
			fi
			AV=0
		else
			#ui_print "-> Android 11 detected....";
			AV=1
			install_av="  -> Android : 11"
			copy_initA11
		fi
	fi

fi

umount /vendor || true
