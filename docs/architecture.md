# Architecture & Network Topology

## Overview
This project establishes an enterprise-grade network boundary simulation using Linux kernel network namespaces. It enforces strict perimeter isolation, routing control, and stateful firewall filtering between untrusted public domains and secured internal subnets.

## Topology Diagram

[ Public Internet ] (net-public)
│  (192.168.xxx.x/24)
│  veth-pub
▼  (192.168.xxx.x/24)
┌──────────────────────────────┐
│      Edge Router / FW        │ (net-router)
│  - IP Forwarding Enabled     │
│  - Stateful iptables Filter  │
│  - Automated Threat Defense  │
└──────────────────────────────┘
▲  (10.0.0.x/24)
│  veth-r-priv
│  veth-priv (10.0.0.x/24)
[ Internal Corporate Network ] (net-private)

## Component Breakdown
* **`net-public`**: Simulates an external untrusted network or public internet connection.
* **`net-router`**: Acts as the edge security gateway, handling inter-network routing, stateful inspection, and automated threat mitigation.
* **`net-private`**: Represents the isolated internal corporate environment protected behind the firewall boundary.


