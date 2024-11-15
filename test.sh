#!/bin/bash
#SBATCH --job-name=test_john
#SBATCH --output=/scratch/john_result.log
#SBATCH --error=/scratch/john_error.log
#SBATCH --nodelist=node1

/opt/john/run/john --format=raw-sha256 --rules=Jumbo --fork=2 --wordlist=/opt/john/run/password.lst /home/slurm/john_hash.txt

