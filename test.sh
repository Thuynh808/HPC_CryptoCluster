#!/bin/bash
#SBATCH --job-name=test_john
#SBATCH --output=/home/slurm/john_result.log
#SBATCH --error=/home/slurm/john_error.log
#SBATCH --nodelist=node1

/scratch/john/run/john --format=raw-sha256 --rules=Jumbo --fork=2 --wordlist=/scratch/john/run/password.lst /home/slurm/john_hash.txt

