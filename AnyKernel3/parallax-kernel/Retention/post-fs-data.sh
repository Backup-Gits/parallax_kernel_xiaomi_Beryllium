#!/system/bin/sh
# Please don't hardcode /magisk/modname/... ; instead, please use $MODDIR/...
# This will make your scripts compatible even if Magisk change its mount point in the future
MODDIR=${0%/*}

# This script will be executed in post-fs-data mode
# More info in the main Magisk thread

# Changes kcal setting at Boot
echo "226" > /sys/module/msm_drm/parameters/kcal_red
echo "226" > /sys/module/msm_drm/parameters/kcal_green
echo "226" > /sys/module/msm_drm/parameters/kcal_blue
