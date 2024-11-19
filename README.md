![HPC_CryptoCluster](https://i.imgur.com/31TiOpL.png)

<details close>
<summary> <h4>images</h4> </summary>
  

  ![HPC_CryptoCluster](https://i.imgur.com/Julx1xb.png)
  ![HPC_CryptoCluster](https://i.imgur.com/82vV2aF.png)
  ![HPC_CryptoCluster](https://i.imgur.com/UCc5IMD.png)
  ![HPC_CryptoCluster](https://i.imgur.com/AvlmOHC.png)
  ![HPC_CryptoCluster](https://i.imgur.com/zQkYUcj.png)
  ![HPC_CryptoCluster](https://i.imgur.com/xY4asql.png)
  ![HPC_CryptoCluster](https://i.imgur.com/RHsmczr.png)
  ![HPC_CryptoCluster](https://i.imgur.com/MnZO0Tu.png)
  ![HPC_CryptoCluster](https://i.imgur.com/lk5kop8.png)
  ![HPC_CryptoCluster](https://i.imgur.com/kv4N547.png)
  ![HPC_CryptoCluster](https://i.imgur.com/4Sp87TD.png)
  ![HPC_CryptoCluster](https://i.imgur.com/qB3Oj56.png)
</details>

## Project Overview
This project simulates a high-performance computing (HPC) cluster designed for distributed password cracking. Using VirtualBox, Warewulf, and Slurm, I created a scalable environment to run John the Ripper across multiple nodes, demonstrating both HPC management skills and basic pentesting capabilities. The project showcases how compute resources can be efficiently scaled for demanding tasks in cybersecurity.

### Components

- **Rocky Linux:** provides a stable base for the cluster
- **VirtualBox:** VirtualBox hosts the virtual machines for each cluster node
- **Network Boot:** iPXE enables compute nodes to boot over the network
- **Ansible:** automates configuration and deployment tasks across the cluster, streamlining setup and updates
- **Warewulf:** manages and deploys the operating system and software configurations across compute nodes
- **Slurm:** workload manager that allocates resources and schedules jobs across the cluster
- **John the Ripper:** used to test the cluster's distributed password cracking jobs
- **Munge:** provides secure authentication for message passing between nodes

### Versions

| Component      | Version  |
|----------------|----------|
| Rocky Linux    | 9.4      |
| VirtualBox     | 7.0      |   
| Ansible        | 2.14     |   
| Warewulf       | 4.5.7    |   
| Slurm          | 22.05.9  |
| Munge          | 0.5.13   |
| JohnTheRipper  | 1.9.0    |

<br><br>
## Environment Setup

In this section, we’ll set up the virtual infrastructure for the HPC_CryptoCluster project by creating a NAT network, configuring virtual machines, and enabling network boot so compute nodes can receive configurations. The table below shows each VM's specifications:

| Server         | Role              | CPU | RAM  |
|----------------|-------------------|-----|------|
| Control        | Controller        | 4   | 8 GB |
| Node1          | Compute Node      | 2   | 4 GB |     
| Node2          | Compute Node      | 2   | 4 GB |    
| Node3          | Compute Node      | 2   | 4 GB |  

- **Create NAT Network:**
  - In VirtualBox, create a NAT Network
  - Disable DHCP
- **Create VMs:**
  - 1 Controller Node(Rocky 9 ISO)
  - 3 Compute Nodes(No image ISO)
- **Setup Network Boot:**
  - Assign all nodes to NAT Network
  - Download and attach the iPXE ISO to each compute node’s virtual DVD drive to enable network booting
  - Set boot order on compute nodes
  <details close>
  <summary> <h4>See Configuration Images</h4> </summary>
  
  ![HPC_CryptoCluster](https://i.imgur.com/v4cEmFA.png)
  ![HPC_CryptoCluster](https://i.imgur.com/ggrAsG8.png)
  ![HPC_CryptoCluster](https://i.imgur.com/FaFgG7i.png)
  <br><br>
  </details>
<br>   

## Installation

Power on Controller node and follow these steps to install necessary tools and configure the cluster

- **Install Git, Ansible, and Clone the Project Repository:**
```bash
dnf install -y git ansible-core
git clone -b dev https://github.com/Thuynh808/HPC_CryptoCluster
cd HPC_CryptoCluster
ansible-galaxy collection install -r requirements.yaml -vv
```
- **Run the Ansible playbooks to install and configure Warewulf and John the Ripper:**
```bash
ansible-playbook warewulf.yaml -vv
ansible-playbook john.yaml -vv
```
- **In Warewulf container image shell, install dependencies, and configure Slurm for the compute nodes:**
```bash
wwctl container shell rockylinux-9
```
```bash
dnf install -y git ansible-core
git clone -b dev https://github.com/Thuynh808/HPC_CryptoCluster
cd HPC_CryptoCluster
ansible-galaxy collection install -r requirements.yaml -vv
ansible-playbook slurm-node.yaml -vv
exit #rebuild container image
```
- **Set Up Slurm and Munge on the Controller Node to manage the Slurm job scheduler and secure communication:**
```bash
ansible-playbook slurm-control.yaml -vv
```
- **Power on compute nodes to initialize the network boot and connect to the controller node**
<br><br>

<br><br>
<br><br>
<br><br>
---
- **Confirm warewulf service is up and node overlays configured**
```bash
wwctl node list -l && wwctl node list -n
wwctl node list -a | tail -9
systemctl status warewulfd.service --no-pager
firewall-cmd --list-all
```

- **Confirm password file and Run a simple test with John**
```bash
cd /home/slurm
ls -l
cat john_hash.txt
john --test --format=raw-sha256
```

- **Confirm slurm and munge are operational**
```bash
systemctl status slurmctld munge --no-pager
munge -n | ssh node1 unmunge
ssh node1 systemctl status slurmd
```

- **Confirm nodes are properly up**
```bash
ssh node3
```
```bash
dmesg | head
cat /etc/hosts
sinfo -l
scontrol show node
```
---

- **first test: john single node crack. from controller node execute sbatch command**
```bash
cd /home/slurm
sbatch john_test.sh
```
```bash
sinfo -l
scontrol show job <JobId>
```
```bash
scontrol show job <JobId>
cat /home/slurm/john_result.log
```

- **second test: john distributed test.  execute distributed sbatch command**
```bash
cd /home/slurm
sbatch john_distributed.sh
```
```bash
sinfo -l
scontrol show job <JobId>
cat /home/slurm/john_distributed_result.log
```
---


