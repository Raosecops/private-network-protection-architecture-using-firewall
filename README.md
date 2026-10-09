# Private Network Protection Architecture Using Firewall

An enterprise-grade perimeter security and traffic isolation lab engineered from scratch using Linux kernel network namespaces, advanced routing,
 stateful `iptables` packet inspection, and automated edge threat response mechanisms.

---

## Architecture Overview

This project simulates a segmented enterprise topology featuring a public perimeter, an edge routing/firewall tier, and a private internal subnet.

 All network environments are logically isolated using Linux network namespaces (`ip netns`) and interconnected via virtual Ethernet pairs (`veth`).

[ Public Internet ] (net-public)
│  (192.xxx.xxx.2/24)
│  veth-pub
▼  (192.xxx.xxx.1/24)
┌──────────────────────────────┐
│      Edge Router / FW        │ (net-router)
│  - IP Forwarding Enabled     │
│  - Stateful iptables Filter  │
│  - Automated Threat Defense  │
└──────────────────────────────┘
▲  (10.0.0.1/24)
│  veth-r-priv
│  veth-priv (10.0.0.x/24)
[ Internal Corporate Network ] (net-private)

---

## Repository Structure

```text
private-network-protection-architecture-using-firewall/
├── README.md
├── scripts/
│   ├── setup-topology.sh
│   └── threat-response.sh
├── configs/
│   └── iptables-rules.v4
└── docs/
    ├── architecture.md
    └── validation-guide.md

Quick Start & Deployment
1. Provision Network Topology & Routing

sudo bash scripts/setup-topology.sh

Verification: Run ip netns list to confirm all three namespaces (net-public, net-router, net-private) are active.

2. Apply Stateful Firewall Policies

sudo ip netns exec net-router iptables-restore < configs/iptables-rules.v4

Verification: Run sudo ip netns exec net-router iptables -L -v to confirm default-deny and stateful rules are loaded.

3. Run Automated Threat Mitigation

sudo bash scripts/threat-response.sh

Verification: Run sudo ip netns exec net-router iptables -L INPUT -v -n to verify the automated drop rule is injected at the edge.


