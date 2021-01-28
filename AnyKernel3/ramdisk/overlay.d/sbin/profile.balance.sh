#!/system/bin/sh

# Balance
LogMSG "- Enabling Parallax Balance Profile"

# IO Scheduler
echo "cfq" > /sys/block/sda/queue/scheduler
echo "cfq" > /sys/block/sdb/queue/scheduler
echo "cfq" > /sys/block/sdc/queue/scheduler
echo "cfq" > /sys/block/sdd/queue/scheduler
echo "cfq" > /sys/block/sde/queue/scheduler
echo "cfq" > /sys/block/sdf/queue/scheduler

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

echo "schedutil" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo "blu_schedutil" > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
echo "1766400" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
echo "2553800" > /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq
echo "0" > /sys/module/cpu_input_boost/parameters/input_boost_freq_lp
echo "0" > /sys/module/cpu_input_boost/parameters/input_boost_freq_hp
echo "60" > /sys/module/cpu_input_boost/parameters/input_boost_duration
echo "msm-adreno-tz" > /sys/class/kgsl/kgsl-3d0/devfreq/governor
echo "710" > /sys/class/kgsl/kgsl-3d0/max_clock_mhz
echo "710000000" > /sys/class/kgsl/kgsl-3d0/max_gpuclk
echo "710000000" > /sys/class/kgsl/kgsl-3d0/devfreq/max_freq
echo "170" > /sys/class/kgsl/kgsl-3d0/min_clock_mhz
echo "170000000" > /sys/class/kgsl/kgsl-3d0/min_gpuclk
echo "170000000" > /sys/class/kgsl/kgsl-3d0/devfreq/min_freq
echo "1" > /sys/class/kgsl/kgsl-3d0/devfreq/adrenoboost
echo "1" > /sys/class/kgsl/kgsl-3d0/throttling
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

LogMSG "- Parallax Balance Profile Enabled"
