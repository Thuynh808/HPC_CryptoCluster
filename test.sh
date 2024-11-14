#!/bin/bash
#SBATCH --job-name=hostname_check   # Job name
#SBATCH --output=test.log  # Output file
#SBATCH --error=test_error.log    # Error file
#SBATCH --nodelist=node1,node2,node3              # Specify node1

# Command to check hostname
hostname
uptime
lscpu
free -h
lsblk
df -h 

