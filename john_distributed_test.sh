#!/bin/bash
#SBATCH --job-name=john_distributed_test
#SBATCH --output=/home/slurm/john_distributed_result.log
#SBATCH --error=/home/slurm/john_distributed_error.log
#SBATCH --nodes=3
#SBATCH --ntasks=3

/scratch/john/run/john --format=raw-sha256 --rules=Jumbo --fork=2 --wordlist=/scratch/john/run/passwordlist_00 /home/slurm/john_hash.txt

/scratch/john/run/john --format=raw-sha256 --rules=Jumbo --fork=2 --wordlist=/scratch/john/run/passwordlist_01 /home/slurm/john_hash.txt

/scratch/john/run/john --format=raw-sha256 --rules=Jumbo --fork=2 --wordlist=/scratch/john/run/passwordlist_02 /home/slurm/john_hash.txt
