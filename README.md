![HPC_CryptoCluster](https://i.imgur.com/31TiOpL.png)

## Project Overview
This project simulates a high-performance computing (HPC) cluster for distributed password cracking. Using VirtualBox, **Warewulf**, and **Slurm**, the cluster scales password-cracking tasks with **John the Ripper** across multiple nodes, demonstrating HPC management and pentesting capabilities.

The cluster utilizes stateless compute nodes, which are booted over the network using iPXE and provisioned with containerized environments managed by Warewulf. This approach ensures consistency, flexibility, and efficient resource utilization, as the nodes do not require persistent storage and can be quickly reconfigured or rebuilt from the central container image.

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

<br>

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

  </details>
> Note: This project is configured and executed as `root` for simplicity and to streamline the setup process.
<br>   

## Installation

Power on Controller node and follow these steps to install necessary tools and configure the cluster.

- **Install Git, Ansible, and Clone the Project Repository:**
```bash
dnf install -y git ansible-core
git clone -b dev https://github.com/Thuynh808/HPC_CryptoCluster
cd HPC_CryptoCluster
ansible-galaxy collection install -r requirements.yaml -vv
```
- **Run the Ansible playbooks to install and configure `Warewulf` and `John the Ripper`:**
```bash
ansible-playbook warewulf.yaml -vv
ansible-playbook john.yaml -vv
```
- **In `Warewulf` container image shell, install dependencies, and configure `Slurm` for the compute nodes:**
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
- **Set Up `Slurm` and `Munge` on the Controller Node to manage the Slurm job scheduler and secure communication:**
```bash
ansible-playbook slurm-control.yaml -vv
```
- **`Power on` compute nodes to initialize the network boot and connect to the controller node**

<br>

## Deployment Verification

Let's verify everything is up and running!

- **Confirm `Warewulf` service is up and node overlays configured**
```bash
wwctl node list -l && wwctl node list -n
wwctl node list -a | tail -9
systemctl status warewulfd.service --no-pager
firewall-cmd --list-all
```
  <details close>
  <summary> <h4>See Images</h4> </summary>
  
  ![HPC_CryptoCluster](https://i.imgur.com/Julx1xb.png)
  ![HPC_CryptoCluster](https://i.imgur.com/82vV2aF.png)
  <br><br>
  </details>
  
- **Confirm sample password file is created and Run a benchmark test with `John`**
```bash
cd /home/slurm
ls -l
cat john_hash.txt
john --test --format=raw-sha256
```
  <details close>
  <summary> <h4>See Images</h4> </summary>
  
  ![HPC_CryptoCluster](https://i.imgur.com/UCc5IMD.png)
  <br><br>
  </details>
  
- **Confirm `Slurm` and `Munge` are operational and Munge key is valid**
```bash
systemctl status slurmctld munge --no-pager
munge -n | ssh node1 unmunge
ssh node1 systemctl status slurmd
```
  <details close>
  <summary> <h4>See Images</h4> </summary>
  
  ![HPC_CryptoCluster](https://i.imgur.com/AvlmOHC.png)
  ![HPC_CryptoCluster](https://i.imgur.com/zQkYUcj.png)
  <br><br>
  </details>
  
- **Confirm compute nodes are properly up with network boot and hosts configured**
```bash
ssh node3
```
```bash
dmesg | head
cat /etc/hosts
sinfo -l
scontrol show node
```
  <details close>
  <summary> <h4>See Images</h4> </summary>
    
  ![HPC_CryptoCluster](https://i.imgur.com/xY4asql.png)
  ![HPC_CryptoCluster](https://i.imgur.com/RHsmczr.png)
  <br><br>
  </details>
<br>   


## Testing Cluster with John the Ripper

This section demonstrates the cluster's functionality through two tests: a single-node password-cracking job and a multi-node distributed job.

<details close>
<summary> <h3>Single Node Test</h3> </summary>

- **Submit the sbatch password-cracking job on a single compute node**
```bash
cd /home/slurm
sbatch john_test.sh
```
- **Verify the job is submitted and running on single node**
```bash
sinfo -l
scontrol show job <JobId>
```
![HPC_CryptoCluster](https://i.imgur.com/MnZO0Tu.png)

- With 2 cpus, Slurm can be configured to allocate 2 processes to split the load of the job
     
![HPC_CryptoCluster](https://i.imgur.com/lk5kop8.png)  

- **Confirm finished job and view results**
```bash
scontrol show job <JobId>
cat /home/slurm/john_result.log
```

- The job ran efficiently and recovered all 10 target passwords within 16 minutes and 22 seconds, confirming the effectiveness of the single-node configuration for password cracking.
    
![HPC_CryptoCluster](https://i.imgur.com/kv4N547.png)

</details>

<details close>
<summary> <h3>Multi-Node Distributed Test</h3> </summary>
  
- **Now we'll submit the distributed job**
```bash
cd /home/slurm
sbatch john_distributed.sh
sleep 5
sinfo -l
scontrol show job <JobId>
```

- The job is allocated across three nodes (node[1-3]), with each node contributing 2 CPUs for a total of 6 CPUs.
    
![HPC_CryptoCluster](https://i.imgur.com/4Sp87TD.png)
  
- **Confirm job finished and view results**
```bash
scontrol show job <JobId>
cat /home/slurm/john_distributed_result.log
```

**Analysis:**
- The distributed job completed in 6 minutes and 52 seconds, demonstrating a significant reduction in runtime compared to the single-node test (16 minutes and 22 seconds).
- All 10 passwords were successfully recovered, showcasing the cluster's ability to handle distributed workloads efficiently.
- The multi-node distributed test highlights the efficiency and scalability of the cluster. By utilizing three nodes, the runtime was reduced by nearly 58% compared to the single-node test.
- All 10 passwords were successfully cracked, demonstrating the cluster's capability to handle resource-intensive tasks efficiently while maintaining accuracy.
    
![HPC_CryptoCluster](https://i.imgur.com/qB3Oj56.png) 

</details>
<br>

## Conclusion

This project gave me valuable hands-on experience building an HPC cluster for distributed password cracking using VirtualBox, Warewulf, Slurm, John the Ripper, and Ansible. I tackled challenges like troubleshooting iPXE network boot, fixing Munge authentication, and refining Warewulf overlays, which reinforced the importance of solid infrastructure management.

With Slurm, the cluster reduced the distributed password cracking job runtime by nearly 58%, showing the power of scaling across multiple nodes. Automating setup with Ansible streamlined the process and ensured consistency across the cluster. Overall, this project strengthened my understanding of HPC concepts, automation, and how distributed systems handle real-world tasks like pentesting and other compute-heavy jobs.
