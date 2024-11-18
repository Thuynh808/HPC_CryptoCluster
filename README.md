![HPC_CryptoCluster](https://i.imgur.com/31TiOpL.png)

<details close>
<summary> <h4>images</h4> </summary>

  ![HPC_CryptoCluster](https://i.imgur.com/v4cEmFA.png)
  ![HPC_CryptoCluster](https://i.imgur.com/ggrAsG8.png)
  ![HPC_CryptoCluster](https://i.imgur.com/FaFgG7i.png)
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


| Server         | Role              | CPU | RAM  |
|----------------|-------------------|-----|------|
| Control        | Controller        | 4   | 8 GB |
| Node1          | Compute Node      | 2   | 4 GB |     
| Node2          | Compute Node      | 2   | 4 GB |    
| Node3          | Compute Node      | 2   | 4 GB |  

- **install git, ansible, collections, and clone the repository**
```bash
dnf install -y git ansible-core
git clone -b dev https://github.com/Thuynh808/HPC_CryptoCluster
cd HPC_CryptoCluster
ansible-galaxy collection install -r requirements.yaml -vv
```
- **Run install playbooks**
```bash
ansible-playbook warewulf.yaml -vv
ansible-playbook john.yaml -vv
```
- **Configure container image**
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
- **install and configure slurm/munge setup for controller**
```bash
ansible-playbook slurm-control.yaml -vv
```
- **Start compute nodes**
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


