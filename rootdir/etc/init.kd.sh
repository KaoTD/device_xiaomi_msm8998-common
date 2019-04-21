#!/system/bin/sh

function write() {
    echo -n $2 > $1
}

{
    sleep 5
    
	# Schedutil config
    echo "schedutil" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
    echo "schedutil" > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor

	# SchedTune
    echo "1" > /dev/stune/foreground/schedtune.prefer_idle
    echo "1" > /dev/stune/top-app/schedtune.prefer_idle
    echo "0" > /dev/stune/top-app/schedtune.boost
    echo "1" > /dev/stune/top-app/schedtune.sched_boost

	# cpuset
    echo "0-3,6-7" > /dev/cpuset/foreground/cpus
    echo "0-3" > /dev/cpuset/restricted/cpus

    # end boot time fs tune
    write /sys/block/sda/queue/read_ahead_kb 256
    write /sys/block/sda/queue/nr_requests 256
    write /sys/block/sda/queue/iostats 1
    write /sys/block/sda/queue/scheduler anxiety
    write /sys/block/sde/queue/read_ahead_kb 256
    write /sys/block/sde/queue/nr_requests 256
    write /sys/block/sde/queue/iostats 1
    write /sys/block/sde/queue/scheduler anxiety

    write /proc/sys/vm/page-cluster 0
    write /proc/sys/vm/swappiness 100
    
    sleep 10

#	  write /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq 175000
#	  write /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq 175000
#    write /sys/module/cpu_boost/parameters/input_boost_freq "0:8xiaomi00 4:422400"
#    write /sys/module/cpu_boost/parameters/input_boost_ms 64

	# Adreno Idler
    write /sys/module/adreno_idler/parameters/adreno_idler_downdifferential 20

	# Alucard cpu hotplug
    write /sys/kernel/alucard_hotplug/maxcoreslimit_sleep 2
	
	# io scheduler
    write /sys/block/sda/queue/scheduler anxiety
    write /sys/block/sda/queue/rq_affinity 1

    # set interaction lock idle time
    write /sys/devices/virtual/graphics/fb0/idle_time 100

    sleep 20
}&
