#!/bin/bash
#SBATCH --job-name=john_password
#SBATCH --output=/home/john_result.log
#SBATCH --error=/home/john_error.log
#SBATCH --nodelist=node1

john --format=raw-SHA256 --wordlist=/opt/john/password.lst /home/john_hash.txt

