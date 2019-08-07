#!/usr/bin/ruby
#

require './massbin2.rb'

bin_range = ( ARGV.shift ).to_f
max_mz    = ( ARGV.shift ).to_i
min_mz    = ( ARGV.shift ).to_i

mb3 = MassBin.new( bin_range, max_mz, min_mz )
mass_file_list = open( ARGV.shift )
mass_file_list.each do |x|
  STDERR.print "Start hash-preparing for #{x}\n"
  next if x !~ /\S/
  path_to_a_mass_file = x.chomp
  mb3.add_bins_from_a_peak_table( path_to_a_mass_file )
  STDERR.print "End hash-preparing for #{x}\n"
end
STDERR.puts mb3.bins.keys.size
mb3.show_bins_profiles


