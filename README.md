# HPC_CryptoCluster


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
- **first test: john single node crack. from controller node execute sbatch command**
  ```bash
  cd /home/slurm
  sbatch john_test.sh
  ```
- **second test: john distributed test.  execute distributed sbatch command**
  ```bash
  cd /home/slurm
  sbatch john_distributed.sh
  ```






















  - **Confirm warewulf service is up and node overlays configured**
  ```bash
  wwctl node list -l && wwctl node list -n
  wwctl node list -a | tail -9
  systemctl status warewulfd.service
  firewall-cmd --list-all
  ```
