#!/bin/bash
#SBATCH --job-name=test2_john
#SBATCH --output=/home/slurm/john_result2.log
#SBATCH --error=/home/slurm/john_error2.log
#SBATCH --nodelist=node2

/opt/john/run/john --format=raw-sha256 --rules=Jumbo --fork=2 --wordlist=/opt/john/run/password.lst /home/slurm/john_hash2.txt

