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
- **run slurm/munge setup and hashes for testing**
  ```bash
  ansible-playbook slurm-control.yaml -vv
  ansible-playbook john_hashes.yaml -vv
  ```
- **Start compute nodes**
  <br><br>
- **from controller node execute sbatch command**
  ```bash
  cd /home/slurm
  sbatch john_test.sh
  ```
- **view log files and job status**
  ```bash
  squeue -l
  scontrol show job "jobID"
  cat john_result.log
  cat john_error.log
  ```
- **execute distributed sbatch command**
  ```bash
  cd /home/slurm
  sbatch john_distributed.sh
  ```
- **view log files and job status**
  ```bash
  squeue -l
  scontrol show job "jobID"
  cat john_distributed_result.log
  cat john_distributed_error.log
  ```
