io#!/system/bin/sh

# Gaming
LogMSG "- Enabling Parallax Gaming Profile"

# IO Scheduler
echo "cfq" > /sys/block/sda/queue/scheduler
echo "cfq" > /sys/block/sdb/queue/scheduler
echo "cfq" > /sys/block/sdc/queue/scheduler
echo "cfq" > /sys/block/sdd/queue/scheduler
echo "cfq" > /sys/block/sde/queue/scheduler
echo "cfq" > /sys/block/sdf/queue/scheduler

#Sched Boost
dstune() {
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
echo "1" > /sys/module/cgroup/parameters/enable_cpu_boost
echo "1" > /sys/module/cgroup/parameters/boost_gpu
echo "1" > /sys/module/fork/parameters/boost_gpu
echo "1" > /sys/module/page_alloc/parameters/boost_gpu
echo "1" > /sys/module/devfreq/parameters/boost_gpu
echo "1" > /sys/module/devfreq_boost/parameters/boost_gpu
echo "1" > /sys/module/devfreq_devbw/parameters/boost_gpu
echo "1" > /sys/module/drm/parameters/boost_gpu
echo "1" > /sys/module/msm_kgsl_core/parameters/boost_gpu

maxcpu=`cat /sys/devices/system/cpu/cpufreq/policy4/scaling_boost_frequencies`;
if [ $maxcpu =  2956800 ]; then
	echo "2956800" > /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq
else
	echo "2803200" > /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq
fi

echo "schedutil" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo "1766400" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
echo "performance" > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
echo "1420000" > /sys/module/cpu_input_boost/parameters/input_boost_freq_lp
echo "2029000" > /sys/module/cpu_input_boost/parameters/input_boost_freq_hp
echo "125" > /sys/module/cpu_input_boost/parameters/input_boost_duration
echo "830" > /sys/class/kgsl/kgsl-3d0/max_clock_mhz
echo "830000000" > /sys/class/kgsl/kgsl-3d0/max_gpuclk
echo "830000000" > /sys/class/kgsl/kgsl-3d0/devfreq/max_frseq
echo "170" > /sys/class/kgsl/kgsl-3d0/min_clock_mhz
echo "170000000" > /sys/class/kgsl/kgsl-3d0/min_gpuclk
echo "170000000" > /sys/class/kgsl/kgsl-3d0/devfreq/min_freq
echo "2" > /sys/class/kgsl/kgsl-3d0/devfreq/adrenoboost
echo "0" > /sys/class/kgsl/kgsl-3d0/throttling

# Thermal
chmod 777 /sys/class/power_supply/bms/temp_cool
echo "450" > /sys/class/power_supply/bms/temp_cool
chmod 644 /sys/class/power_supply/bms/temp_cool
chmod 777 /sys/class/power_supply/bms/temp_warm
echo "470" > /sys/class/power_supply/bms/temp_warm
chmod 644 /sys/class/power_supply/bms/temp_warm

#Fingerprint Boost
echo "1" > /sys/kernel/fp_boost/enabled

LogMSG "- Parallax Gaming Profile Enabled"