# Validation & Testing Guide

## 1. Outbound Connectivity Test
Verify that private network endpoints can successfully reach public endpoints through the router gateway:
```bash
sudo ip netns exec net-private ping -c 3 192.xxx.xxx.2

Success Criteria: 0% packet loss.

2. Inbound Block Test

Verify that external public endpoints cannot initiate connections into the private network:

sudo ip netns exec net-public ping -c 3 10.0.0.2

Success Criteria: 100% packet loss (timed out), confirming default-deny enforcement.

3. Automated Threat Response Verification

Execute the edge defense script and check the router iptables chain:

sudo bash scripts/threat-response.sh
sudo ip netns exec net-router iptables -L INPUT -v -n

Success Criteria: The offending IP address (192.168.xxx.xxx) appears at the top of the INPUT and FORWARD chains with a DROP target.

