#!/system/bin/sh

# Performance
LogMSG "- Enabling Parallax Performance Profile"

# IO Scheduler
echo "fiops" > /sys/block/sda/queue/scheduler
echo "fiops" > /sys/block/sdb/queue/scheduler
echo "fiops" > /sys/block/sdc/queue/scheduler
echo "fiops" > /sys/block/sdd/queue/scheduler
echo "fiops" > /sys/block/sde/queue/scheduler
echo "fiops" > /sys/block/sdf/queue/scheduler

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

#read max cpu
maxcpu=`cat /sys/devices/system/cpu/cpufreq/policy4/scaling_boost_frequencies`;
if [ $maxcpu =  2956800 ]; then
	echo "2956800" > /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq
else
	echo "2803200" > /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq
fi

echo "schedutil" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo "schedutil" > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
echo "1766400" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
echo "1056000" > /sys/module/cpu_input_boost/parameters/input_boost_freq_lp
echo "1228000" > /sys/module/cpu_input_boost/parameters/input_boost_freq_hp
echo "120" > /sys/module/cpu_input_boost/parameters/input_boost_duration
echo "msm-adreno-tz" > /sys/class/kgsl/kgsl-3d0/devfreq/governor
echo "835" > /sys/class/kgsl/kgsl-3d0/max_clock_mhz
echo "835000000" > /sys/class/kgsl/kgsl-3d0/max_gpuclk
echo "835000000" > /sys/class/kgsl/kgsl-3d0/devfreq/max_freq
echo "170" > /sys/class/kgsl/kgsl-3d0/min_clock_mhz
echo "170000000" > /sys/class/kgsl/kgsl-3d0/min_gpuclk
echo "170000000" > /sys/class/kgsl/kgsl-3d0/devfreq/min_freq
echo "3" > /sys/class/kgsl/kgsl-3d0/devfreq/adrenoboost
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

LogMSG "- Parallax Performance Profile Enabled"