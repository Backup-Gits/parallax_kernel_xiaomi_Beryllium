#!/sbin/sh

# Import Fstab
. /tmp/anykernel/tools/fstab.sh;

# Import Remover
. /tmp/anykernel/tools/remover.sh;

patch_cmdline "skip_override" "";


install_init=0
#Check Parallax DIR
if [ ! -d /data/media/0/Parallax ]; then
	mkdir -p /data/media/0/Parallax;
fi
if [ ! -d /data/media/0/Parallax/pubg ]; then
	mkdir -p /data/media/0/Parallax/pubg;
fi

# Clear
ui_print "";
ui_print "";

keytest() {
  ui_print "   Press a Vol Key..."
  (/system/bin/getevent -lc 1 2>&1 | /system/bin/grep VOLUME | /system/bin/grep " DOWN" > /tmp/anykernel/events) || return 1
  return 0
}

chooseport() {
  #note from chainfire @xda-developers: getevent behaves weird when piped, and busybox grep likes that even less than toolbox/toybox grep
  while (true); do
    /system/bin/getevent -lc 1 2>&1 | /system/bin/grep VOLUME | /system/bin/grep " DOWN" > /tmp/anykernel/events
    if (`cat /tmp/anykernel/events 2>/dev/null | /system/bin/grep VOLUME >/dev/null`); then
      break
    fi
  done
  if (`cat /tmp/anykernel/events 2>/dev/null | /system/bin/grep VOLUMEUP >/dev/null`); then
    return 0
  else
    return 1
  fi
}

chooseportold() {
  # Calling it first time detects previous input. Calling it second time will do what we want
  $bin/keycheck
  $bin/keycheck
  SEL=$?
  if [ "$1" == "UP" ]; then
    UP=$SEL
  elif [ "$1" == "DOWN" ]; then
    DOWN=$SEL
  elif [ $SEL -eq $UP ]; then
    return 0
  elif [ $SEL -eq $DOWN ]; then
    return 1
  else
    abort "   Vol key not detected!"
  fi
}

if keytest; then
  FUNCTION=chooseport
else
  FUNCTION=chooseportold
  ui_print "   Press Vol Up Again..."
  $FUNCTION "UP"
  ui_print "   Press Vol Down..."
  $FUNCTION "DOWN"
fi

# Install Kernel

# Clear
ui_print " ";
ui_print " ";


# Choose Permissive or Enforcing
ui_print " "
ui_print "Permissive is necessary if you are facing Bootloop or Any bugs "
ui_print " "
ui_print "Permissive Or Enforcing Kernel?"
ui_print " "
ui_print "   Vol+ = Yes, Vol- = No"
ui_print ""
ui_print "   Yes.. Permissive"
ui_print "   No!!... Enforcing"
ui_print " "

if $FUNCTION; then
	ui_print "-> Permissive Kernel Selected.."
	install_pk="  -> Permissive Kernel..."
	patch_cmdline androidboot.selinux androidboot.selinux=permissive
else
	ui_print "-> Enforcing Kernel Selected.."
	install_pk="  -> Enforcing Kernel..."
	patch_cmdline androidboot.selinux androidboot.selinux=enforcing
fi

ui_print " "
ui_print "Install Kernel ?"
ui_print "   Vol+ = Yes, Vol- = No"
ui_print "   Yes!!... With init (with all feature Parallax)"
ui_print "   No!!... Without init (Pure Kernel)"
ui_print " "
if $FUNCTION; then
install_init=0
	ui_print " "
	ui_print "PUBG User..??"
	ui_print " "
	ui_print "Select your option"
	ui_print " "
	ui_print "   Vol+ = Yes, Vol- = No"
	ui_print ""
	ui_print "   Yes.. PUBG Users"
	ui_print "   No!!... Not Playing PUBG"
	ui_print " "

	if $FUNCTION; then
		# Max FPS
		ui_print " "
		ui_print "Install Default Patch Max FPS.."
		ui_print " "
		ui_print "   PUBG Can be Patch to Max FPS"
		ui_print "   with select install on this option"
		ui_print "   or you can edit manually your Active.sav"
		ui_print " "
		ui_print "   Edit Active.sav on sdcard/Parallax/pubg/ori/Active.sav"
		ui_print "   if you don't know how to edit it you can search "
		ui_print "   on google unlock 90 fps and copy your edited to "
		ui_print "   sdcard/Parallax/pubg/Active.sav"
		ui_print " "
		ui_print "   This patch will be reset to default settings"
		ui_print "   if you change settings graphics on pubg."
		ui_print "   you can get it back with Start PUBG HDR Extreme"
		ui_print "   (Qstile - featured from Parallax Manager)"
		ui_print " "
		ui_print "   You can lock this patch, but it's not recomended"
		ui_print "   maybe you can get banned, but i don't know"
		ui_print "   to enable change value sdcard/Parallax/pubg/ro to 1"
		ui_print "   to disbale change value to 0"
		ui_print " "
		ui_print "   Vol+ = Yes, Vol- = No"
		ui_print " "
		ui_print "   Yes.. Use Default Patch Max FPS"
		ui_print "   No!!... don't patch Max FPS by default"
		ui_print " "

		if $FUNCTION; then
			ui_print "-> Try patch max FPS by default config.."
			install_ppubg="  -> Try patch max FPS by default..."
			echo "1" >> /data/media/0/Parallax/pubg/dp
		else
			ui_print "-> Not use patch max FPS by default.."
			install_ppubg="  -> Not use patch max FPS - edit manually..."
			echo "0" >> /data/media/0/Parallax/pubg/dp
		fi
	else
		ui_print "-> Not Playing PUBG.."
		install_ppubg="  -> Skip Max FPS Patch..."
		echo "0" >> /data/media/0/Parallax/pubg/dp
	fi
	install_ppubg=""
	echo "0" >> /data/media/0/Parallax/pubg/dp
else
	install_init=1
fi

umount /system || true
mount -o rw /dev/block/bootdevice/by-name/system /system
if [ -f /system/build.prop ]; then
	patch_build=/system/build.prop
else
	if [ -f /system_root/system/build.prop ]; then
		patch_build=/system_root/system/build.prop
	else
		if [ -f /system/system_root/system/build.prop ]; then
			patch_build=/system_root/system/build.prop
		else
			patch_build=0
		fi
	fi
fi;


# Start Install Init
. /tmp/anykernel/tools/init.sh;
ui_print " "
ui_print " "
ui_print "Installing Parallax Kernel with :"
if [ $install_init = 0 ]; then
ui_print "  -> Init mode"
ui_print " "
else
ui_print "  -> Pure"
ui_print " "
ui_print "Init not installed.!"
ui_print "------------------------------------"
ui_print "You won't get many features from this option, such as Parallax Manager not installed, Performance mode, Patch PUBG, and several other features."
fi

umount /system || true
