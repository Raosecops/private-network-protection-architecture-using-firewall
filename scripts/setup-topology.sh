#!/bin/bash
# Enterprise-Edge Network Topology Provisioning Script

set -e

echo "[*] Cleaning up any existing namespaces..."
ip netns del net-public 2>/dev/null || true
ip netns del net-router 2>/dev/null || true
ip netns del net-private 2>/dev/null || true

echo "[*] Creating network namespaces..."
ip netns add net-public
ip netns add net-router
ip netns add net-private

echo "[*] Creating virtual Ethernet pairs..."
ip link add veth-pub type veth peer name veth-r-pub
ip link add veth-priv type veth peer name veth-r-priv

echo "[*] Moving interfaces into namespaces..."
ip link set veth-pub netns net-public
ip link set veth-r-pub netns net-router
ip link set veth-priv netns net-private
ip link set veth-r-priv netns net-router

echo "[*] Assigning IP addresses..."
ip netns exec net-public ip addr add 192.168.100.2/24 dev veth-pub
ip netns exec net-public ip link set veth-pub up
ip netns exec net-public ip link set lo up

ip netns exec net-router ip addr add 192.168.100.1/24 dev veth-r-pub
ip netns exec net-router ip addr add 10.0.0.1/24 dev veth-r-priv
ip netns exec net-router ip link set veth-r-pub up
ip netns exec net-router ip link set veth-r-priv up
ip netns exec net-router ip link set lo up

ip netns exec net-private ip addr add 10.0.0.2/24 dev veth-priv
ip netns exec net-private ip link set veth-priv up
ip netns exec net-private ip link set lo up

echo "[*] Enabling IP forwarding on router..."
ip netns exec net-router sysctl -w net.ipv4.ip_forward=1 > /dev/null

echo "[*] Adding default routes..."
ip netns exec net-private ip route add default via 10.0.0.1 dev veth-priv
ip netns exec net-public ip route add default via 192.168.100.1 dev veth-pub

echo "[+] Network topology setup complete."
