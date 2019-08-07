#!/bin/sh
#$ -S /bin/sh
#$ -cwd 
#$ -l short
## #$ -l s_vmem=32G,mem_req=32G
#$ -l s_vmem=8G,mem_req=8G
### #$ -l short
### #$ -l debug
#$ -pe def_slot 1
#$ -o ./log
#$ -e ./log

source ~/.bashrc
cd /home/takeshik/scripts/Tkwsm/MassBin

# ruby sample2.rb 1 200 180 sample2.peak_tables.list >sample2.peak_tables.bs.1.200.180.profile.out
# ruby sample2.rb 1 2000 80 peak_tables.metazoa.list >peak_tables.bs.1.2k.80.profile.out
 ruby sample2.rb 0.1 2000 80 peak_tables.metazoa.list >peak_tables.bs.0_1.2k.80.profile.out
