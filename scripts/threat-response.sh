#!/bin/bash
# Automated Edge Threat Response Script

BLOCKED_IPS_FILE="/tmp/blocked_ips.txt"
touch "$BLOCKED_IPS_FILE"

# Simulate detecting an offending IP from the public perimeter
ATTACKER_IP="192.168.100.100"

if ! grep -q "$ATTACKER_IP" "$BLOCKED_IPS_FILE"; then
    echo "[!] Anomaly detected from $ATTACKER_IP. Applying dynamic edge drop rule."
    ip netns exec net-router iptables -I INPUT -s "$ATTACKER_IP" -j DROP
    ip netns exec net-router iptables -I FORWARD -s "$ATTACKER_IP" -j DROP
    echo "$ATTACKER_IP" >> "$BLOCKED_IPS_FILE"
fi
