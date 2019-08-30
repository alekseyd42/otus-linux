#!/usr/bin/env bash
cp /vagrant/unit.sh /opt/unit.sh
cp /vagrant/{mytimer.timer,mytimer.service} /etc/systemd/system/
systemctl daemon-reload
systemctl enable --now mytimer.timer
systemctl status mytimer.timer
systemctl status mytimer.service