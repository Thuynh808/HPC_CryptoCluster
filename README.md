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
  ansible-playbook install.yaml -vv
  ```
- **Set root password for container**

  ```bash
  wwctl container shell rockylinux-9
  ```
