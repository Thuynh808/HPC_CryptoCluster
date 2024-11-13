# HPC_CryptoCluster


- **Install `git` and `ansible-core`**
  
  ```bash
  dnf install -y git ansible-core
  ```
- **Clone the repository**
  
  ```bash
  git clone -b dev https://github.com/Thuynh808/HPC_CryptoCluster
  cd HPC_CryptoCluster
  ansible-galaxy collection install -r requirements.yaml -vv
  ```
- **Run install playbook**

  ```bash
  ansible-playbook warewulf.yaml -vv
  ```
- **Set root password for container**

  ```bash
  wwctl container shell rockylinux-9
  ```
  ```bash
  passwd #set password
  ```
- **Clone repo and run playbooks to configure container image**

  ```bash
  dnf install -y git ansible-core
  git clone -b dev https://github.com/Thuynh808/HPC_CryptoCluster
  cd HPC_CryptoCluster
  ansible-galaxy collection install -r requirements.yaml -vv
  ansible-playbook john.yaml -vv
  ansible-playbook slurm-node.yaml -vv
  exit #rebuild container image
  ```
- **run slurm/munge setup playbook**
  ```bash
  ansible-playbook slurm-control.yaml -vv
  ```
