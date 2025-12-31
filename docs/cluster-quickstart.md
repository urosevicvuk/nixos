# Kubernetes Cluster Quick Start Plan

**Hardware:** Desktop (anorLondo) - 32GB RAM, Ryzen 5 5600X (6c/12t)
**Goal:** Learn Kubernetes, build production cluster
**Approach:** Test on desktop VMs, then migrate to real hardware

---

## Phase 0: Single Node Testing (Week 1) ← START HERE

**Setup:** K3s on anorLondo (your desktop)

**What you get:**
- Working Kubernetes cluster (1 node)
- Learn kubectl, pods, deployments, services
- No HA, but full functionality
- Zero cost, zero hardware needed

**Implementation:**
```bash
# Enable K3s on anorLondo
# Add cluster modules to configuration
# Deploy test applications
# Learn Kubernetes fundamentals
```

**Success criteria:**
- [ ] K3s running on anorLondo
- [ ] Can deploy a test pod
- [ ] Understand kubectl basics
- [ ] Deploy simple app (nginx, etc.)

**Time:** 1-2 days

---

## Phase 1: 3-Node VM Cluster (Week 2-4)

**Setup:** 3 VMs on anorLondo

**VM Specs (each):**
- RAM: 4GB
- CPU: 2 cores
- Disk: 50GB (thin provisioned)
- OS: NixOS with bonfire configuration

**Resource usage:**
```
Total: 32GB RAM available
├─ Desktop (Hyprland + apps): 8GB
├─ bonfire01-vm: 4GB
├─ bonfire02-vm: 4GB
├─ bonfire03-vm: 4GB
└─ Free: 12GB headroom
```

**What you get:**
- Full 3-node K3s cluster
- Longhorn distributed storage (3x replication)
- High availability testing
- Node failure simulation
- Production-like environment

**Implementation:**
```bash
# Enable libvirt on anorLondo
# Create 3 VMs using virt-manager or NixOS
# Deploy bonfire config to each VM
# Form K3s cluster with all 3 nodes
# Deploy Longhorn for storage
# Migrate test apps from Phase 0
```

**Success criteria:**
- [ ] 3 VMs running NixOS
- [ ] 3-node K3s cluster formed
- [ ] Longhorn storage operational
- [ ] Can survive 1 node failure
- [ ] Deployed real app (Nextcloud test instance)

**Time:** 1-2 weeks

---

## Phase 2: Production Migration (Week 5-8)

**Setup:** Migrate firelink services to VM cluster

**Services to migrate:**
- PostgreSQL (with CloudNativePG operator)
- Redis (with Sentinel)
- Nextcloud (test instance first)
- Other Docker services

**Process:**
1. Deploy service to VM cluster (test URL)
2. Sync data from firelink
3. Test thoroughly
4. Plan maintenance window
5. Final sync and cutover
6. Keep firelink as backup for 1 week

**Success criteria:**
- [ ] All services running on K3s cluster
- [ ] Zero data loss
- [ ] Downtime <1 hour
- [ ] Monitoring in place
- [ ] Backups configured

**Time:** 2-4 weeks (careful testing)

---

## Phase 3: Real Hardware (When Ready)

**Setup:** 3 physical servers (bonfire01-03)

**Hardware shopping list (per node):**
- Server/desktop motherboard
- CPU (any modern CPU, even old i5/i7)
- 8-16GB RAM
- 500GB SSD/NVMe
- Network card (1GbE minimum, 10GbE ideal)
- Case + PSU

**Cost estimate:** ~$300-500 per node (used/refurb)
**Total:** ~$1000-1500 for full 3-node cluster

**Migration path:**
```
Option A: Fresh cluster
  - Build bonfire01-03 cluster
  - Export apps from VM cluster
  - Import to real cluster
  - Retire VMs

Option B: Gradual migration
  - Add bonfire01 to VM cluster (4 nodes)
  - Drain VM1, remove it
  - Add bonfire02 (still 4 nodes)
  - Drain VM2, remove it
  - Add bonfire03 (still 4 nodes)
  - Drain VM3, remove it
  - Now pure hardware cluster (3 nodes)
```

**Success criteria:**
- [ ] 3 physical nodes assembled
- [ ] NixOS installed with bonfire config
- [ ] Cluster formed and stable
- [ ] All services migrated
- [ ] VM cluster retired

**Time:** 2-4 weeks (hardware acquisition + setup)

---

## Phase 4: Advanced Learning (Optional)

**When cluster is stable, learn:**

### Separated Architecture (5+ nodes)
- Deploy bonfire-keeper (control plane)
- Deploy bonfire-ash (workers)
- Deploy bonfire-ember (Ceph storage)
- Understand enterprise patterns

### GitOps
- ArgoCD deployment
- Git as source of truth
- Automated deployments

### Advanced Monitoring
- Prometheus + Grafana
- Alerting (AlertManager)
- Log aggregation (Loki)
- Distributed tracing (Tempo)

### Service Mesh
- Istio or Linkerd
- mTLS between services
- Advanced traffic management

---

## Current Status

**Phase:** 0 (Getting Started)
**Next step:** Enable K3s on anorLondo
**Hardware:** Ready (32GB RAM, 6c/12t CPU)
**Config:** Placeholder hosts created

---

## Learning Resources

**Kubernetes Basics:**
- Official K8s docs: kubernetes.io/docs
- K3s docs: docs.k3s.io
- Practice: Play with kubectl

**NixOS + K8s:**
- NixOS K3s module docs
- Search nixpkgs for k8s examples

**Storage:**
- Longhorn docs: longhorn.io/docs
- Ceph docs (later): docs.ceph.com

**Monitoring:**
- Prometheus operator
- Grafana dashboards

---

## Quick Command Reference

**VM Management (Phase 1):**
```bash
# Start VMs
virsh start bonfire01-vm
virsh start bonfire02-vm
virsh start bonfire03-vm

# Connect to VM console
virsh console bonfire01-vm

# Stop VMs
virsh shutdown bonfire01-vm
```

**K3s Cluster:**
```bash
# Check cluster status
kubectl get nodes

# Deploy app
kubectl apply -f app.yaml

# Watch pods
kubectl get pods -w

# Check logs
kubectl logs pod-name

# Describe resource
kubectl describe pod pod-name
```

**Longhorn:**
```bash
# Port-forward to UI
kubectl port-forward -n longhorn-system svc/longhorn-frontend 8080:80

# Check volumes
kubectl get pv
kubectl get pvc
```

---

## Timeline Summary

```
Week 1:  Single node K3s on anorLondo ← YOU ARE HERE
Week 2:  Create 3 VMs
Week 3:  Deploy Longhorn, test HA
Week 4:  Deploy test applications
Week 5-8: Migrate production services
Later:   Buy real hardware when comfortable
```

**Key principle:** Learn on VMs (free, safe), then apply to real hardware (confident, tested).
