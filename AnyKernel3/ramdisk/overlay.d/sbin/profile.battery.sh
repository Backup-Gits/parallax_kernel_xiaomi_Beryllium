#!/system/bin/sh

# Battery profile
LogMSG "- Enabling Parallax Battery Profile"

# IO Scheduler
echo "zen" > /sys/block/sda/queue/scheduler
echo "zen" > /sys/block/sdb/queue/scheduler
echo "zen" > /sys/block/sdc/queue/scheduler
echo "zen" > /sys/block/sdd/queue/scheduler
echo "zen" > /sys/block/sde/queue/scheduler
echo "zen" > /sys/block/sdf/queue/scheduler

stune="/dev/stune"

echo "0" > $stune/schedtune.boost
echo "0" > $stune/schedtune.sched_boost_enabled
echo "0" > $stune/schedtune.sched_boost_no_override
echo "0" > $stune/schedtune.prefer_idle
echo "0" > $stune/schedtune.colocate
echo "0" > $stune/cgroup.clone_children
echo "0" > $stune/cgroup.sane_behavior

#top app
echo "0" > $stune/top-app/schedtune.boost
echo "1" > $stune/top-app/schedtune.sched_boost_enabled
echo "1" > $stune/top-app/schedtune.sched_boost_no_override
echo "0" > $stune/top-app/schedtune.prefer_idle
echo "0" > $stune/top-app/cgroup.clone_children

#rt
echo "0" > $stune/rt/schedtune.boost
echo "0" > $stune/rt/schedtune.sched_boost_enabled
echo "0" > $stune/rt/schedtune.sched_boost_no_override
echo "0" > $stune/rt/schedtune.prefer_idle
echo "0" > $stune/rt/cgroup.clone_children

#fg app
echo "0" > $stune/foreground/schedtune.boost
echo "1" > $stune/foreground/schedtune.sched_boost_enabled
echo "0" > $stune/foreground/schedtune.sched_boost_no_override
echo "0" > $stune/foreground/schedtune.prefer_idle
echo "0" > $stune/foreground/cgroup.clone_children

#bg app
echo "-10" > $stune/background/schedtune.boost
echo "0" > $stune/background/schedtune.sched_boost_enabled
echo "0" > $stune/background/schedtune.sched_boost_no_override
echo "0" > $stune/background/schedtune.prefer_idle
echo "0" > $stune/background/cgroup.clone_children

# Performance Config
echo "0" > /sys/module/cgroup/parameters/enable_cpu_boost
echo "0" > /sys/module/cgroup/parameters/boost_gpu
echo "0" > /sys/module/fork/parameters/boost_gpu
echo "0" > /sys/module/page_alloc/parameters/boost_gpu
echo "0" > /sys/module/devfreq/parameters/boost_gpu
echo "0" > /sys/module/devfreq_boost/parameters/boost_gpu
echo "0" > /sys/module/devfreq_devbw/parameters/boost_gpu
echo "0" > /sys/module/drm/parameters/boost_gpu
echo "0" > /sys/module/msm_kgsl_core/parameters/boost_gpu

# Profile Performance Config
echo "1" > /sys/class/kgsl/kgsl-3d0/throttling
echo "blu_schedutil" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo "blu_schedutil" > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
echo "1766800" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
echo "1612800" > /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq
echo "0" > /sys/module/cpu_input_boost/parameters/input_boost_freq_lp
echo "0" > /sys/module/cpu_input_boost/parameters/input_boost_freq_hp
echo "30" > /sys/module/cpu_input_boost/parameters/input_boost_duration
echo "powersave" > /sys/class/kgsl/kgsl-3d0/devfreq/governor
echo "520" > /sys/class/kgsl/kgsl-3d0/max_clock_mhz
echo "520000000" > /sys/class/kgsl/kgsl-3d0/max_gpuclk
echo "520000000" > /sys/class/kgsl/kgsl-3d0/devfreq/max_freq
echo "170" > /sys/class/kgsl/kgsl-3d0/min_clock_mhz
echo "170000000" > /sys/class/kgsl/kgsl-3d0/min_gpuclk
echo "170000000" > /sys/class/kgsl/kgsl-3d0/devfreq/min_freq
echo "0" > /sys/class/kgsl/kgsl-3d0/devfreq/adrenoboost
echo "1" > /sys/class/kgsl/kgsl-3d0/throttling
echo "powersave" > /sys/class/kgsl/kgsl-3d0/devfreq/governor
echo "65" > /proc/sys/vm/swappiness

# Thermal
chmod 777 /sys/class/power_supply/bms/temp_cool
echo "450" > /sys/class/power_supply/bms/temp_cool
chmod 644 /sys/class/power_supply/bms/temp_cool
chmod 777 /sys/class/power_supply/bms/temp_warm
echo "470" > /sys/class/power_supply/bms/temp_warm
chmod 644 /sys/class/power_supply/bms/temp_warm

#Fingerprint Boost
echo "1" > /sys/kernel/fp_boost/enabled

LogMSG "- Parallax Battery Profile Enabled"