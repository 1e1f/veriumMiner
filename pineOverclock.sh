#!/bin/bash
sudo cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq
sudo cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies
# 480000 600000 720000 816000 912000 960000 1008000 1056000 1104000 1152000 1200000 1344000
sudo cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors
# interactive conservative ondemand userspace powersave performance
# echo 1200000 | sudo tee /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq

cat << _EOF_ > /etc/systemd/system/cpuondemand.service
[Unit]
Description=cpuondemand

[Service]
Type=oneshot
ExecStart=/bin/bash -c 'echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor'
StandardOutput=tty
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
_EOF_
systemctl enable cpuondemand.service
systemctl daemon-reload

cat << _EOF_ > /etc/systemd/system/overclock.service
[Unit]
Description=overclock

[Service]
Type=oneshot
ExecStart=/bin/bash -c 'echo 1344000 | sudo tee /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq'
StandardOutput=tty
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
_EOF_
systemctl enable overclock.service
systemctl daemon-reload

cat << _EOF_ > /etc/systemd/system/cpuminer.service
[Unit]
Description=cpuminer

[Service]
Type=oneshot
ExecStart=/bin/bash -c '/home/pine64/veriumMiner/cpuminer -o http://192.168.1.3:33987 -O veriumrpc:7dEZ9Vk2LhNGTj1magg1VCh8dVte7jb1hHhSr8jPXZjp | tee /home/pine64/miner.log'
StandardOutput=tty
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
_EOF_
systemctl enable cpuminer.service
systemctl daemon-reload