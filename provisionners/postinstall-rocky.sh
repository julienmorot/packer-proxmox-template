#!/bin/bash

# Stop services for cleanup
sudo service rsyslog stop

# Update template
sudo dnf --assumeyes update

#clear audit logs
if [ -f /var/log/wtmp ]; then
    sudo truncate -s0 /var/log/wtmp
fi
if [ -f /var/log/lastlog ]; then
    sudo truncate -s0 /var/log/lastlog
fi

# cleanup /tmp directories
sudo rm -rf /tmp/*
sudo rm -rf /var/tmp/*

#cleanup current ssh keys
sudo rm -f /etc/ssh/ssh_host_*

# make machine-id unique
sudo bash -c "echo 'uninitialized' > /etc/machine-id"
if [ -f /var/lib/dbus/machine-id ]; then
    sudo rm /var/lib/dbus/machine-id
fi

#cleanup shell history
sudo cat /dev/null > ~/.bash_history && history -c
history -w

#cleanup journald
sudo journalctl --rotate
sudo journalctl --vacuum-time=1s

sudo sed -i 's|nocloud-net;seedfrom=http://.*/||' /etc/default/grub
sudo sed -i 's/autoinstall//g' /etc/default/grub

