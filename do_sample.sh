#!/bin/sh
#$ -S /bin/sh
#$ -cwd 
#$ -l short
#$ -l s_vmem=32G,mem_req=32G
## #$ -l s_vmem=8G,mem_req=8G
### #$ -l short
### #$ -l debug
#$ -pe def_slot 1
#$ -o ./log
#$ -e ./log

source ~/.bashrc
cd /home/takeshik/scripts/Tkwsm/MassBin

# ruby sample.rb sample2.peak_tables.list >sample2_peak_tables.profile.out
# ruby sample.rb sample.peak_tables.list >sample_peak_tables.profile.out
# ruby sample.rb peak_tables.list >peak_tables.profile.out
# ruby sample.rb 1 2000 80 peak_tables.list >peak_tables.1.2k.80.profile.out
# ruby sample.rb 10 2000 80 peak_tables.metazoa.list >peak_tables.10.2k.80.profile.out
 ruby sample.rb 1 2000 80 peak_tables.metazoa.list >peak_tables.1.2k.80.profile.out
