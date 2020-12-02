#!/sbin/sh

# Import Fstab
. /tmp/anykernel/tools/fstab.sh;

# Import Remover
. /tmp/anykernel/tools/remover.sh;

patch_cmdline "skip_override" "";


install_init=0


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
