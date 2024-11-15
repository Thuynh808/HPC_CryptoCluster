#!/bin/bash
#SBATCH --job-name=main_john
#SBATCH --output=/home/slurm/main_result.log
#SBATCH --error=/home/slurm/main_error.log
#SBATCH --nodelist=node1

/opt/john/run/john --format=raw-sha256 --rules=Jumbo --fork=2 --wordlist=/opt/john/run/password.lst /home/slurm/main_hash.txt

