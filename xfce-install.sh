#!/bin/sh

source ./lib

show_message "Installing xwindow..."
yum install --assumeyes @base-x >> /tmp/install.log 2>&1
show_result $?

show_message "Installing xfce..."
yum install --assumeyes @xfce >> /tmp/install.log 2>&1
show_result $?

show_message "Linking targets part 1..."
ln -s /lib/systemd/system/graphical.target /etc/systemd/system/default2.target >> /tmp/install.log 2>&1
show_result $?

show_message "Linking targets part 2..."
mv -f /etc/systemd/system/default2.target /etc/systemd/system/default.target >> /tmp/install.log 2>&1
show_result $?
