# Host Configurations

This directory contains NixOS configurations for all machines in the ynix infrastructure.

## Current Hosts (Production)

### anorLondo
**Type:** Desktop workstation
**Hardware:** AMD desktop with Hyprland
**Purpose:** Primary development and daily driver
**Features:** Full desktop environment, gaming, development tools

### ariandel
**Type:** Framework AMD AI 300 laptop
**Hardware:** Framework 13 with AMD AI 300-series
**Purpose:** Mobile workstation
**Features:** Desktop environment, fingerprint auth, suspend/resume fixes

### firelink
**Type:** Single server
**Hardware:** Intel-based server
**Purpose:** Current monolith running Nextcloud, databases, services
**Features:** Nextcloud, PostgreSQL, Redis, Docker services

---

## Cluster Hosts (Planned - Phase 1: All-in-One)

### bonfire
**Type:** All-in-one cluster node template
**Instances:** bonfire01, bonfire02, bonfire03
**Purpose:** K3s cluster with Longhorn distributed storage
**Architecture:**
- K3s control plane (all nodes)
- K3s workers (all nodes)
- Longhorn storage (all nodes)
- 3x replication across nodes

**Use Case:** Phase 1-4 of cluster deployment (learning Kubernetes, HA setup)

---

## Cluster Hosts (Future - Phase 5+: Separated Architecture)

### bonfire-keeper
**Type:** Dedicated control plane node
**Purpose:** K8s control plane only (no workloads)
**Components:**
- kube-apiserver
- etcd
- kube-scheduler
- kube-controller-manager

**Use Case:** When scaling beyond 3 nodes and wanting separated concerns

### bonfire-ash
**Type:** Dedicated worker node
**Purpose:** Run application workloads only
**Components:**
- kubelet
- Container runtime
- Application pods

**Use Case:** Compute-heavy workloads without storage overhead

### bonfire-ember
**Type:** Dedicated storage node
**Purpose:** Ceph storage cluster
**Components:**
- Ceph OSD (object storage daemon)
- Ceph MON (monitor - optional)
- Ceph MGR (manager - optional)

**Use Case:** When learning Ceph or requiring separated storage layer (5+ nodes recommended)

---

## Deployment Strategy

### Phase 1-3: Start with All-in-One (bonfire × 3)
```
3 nodes running everything:
  - K3s control plane + worker + Longhorn storage
  - Simple, cost-effective
  - Good for learning Kubernetes fundamentals
```

### Phase 4+: Optional Separation
```
If expanding to 5-10+ nodes:
  - bonfire-keeper × 3 (control plane HA)
  - bonfire-ash × N (workers, scales as needed)
  - bonfire-ember × 5+ (Ceph storage cluster)

Total minimum: 11 nodes (3 + 3 + 5)
```

---

## Building Configurations

```bash
# Build specific host
nix build .#nixosConfigurations.bonfire.config.system.build.toplevel

# Deploy to remote host
nixos-rebuild switch --flake .#bonfire --target-host vyke@bonfire01.tailscale --use-remote-sudo

# Test configuration without activating
nixos-rebuild build --flake .#bonfire
```

---

## Notes

- All cluster nodes use Tailscale for mesh networking
- Configurations are declarative and version-controlled
- Hardware-configuration.nix files are generated during installation
- Cluster modules (k3s, longhorn, ceph) will be created in modules-nixos/cluster/
