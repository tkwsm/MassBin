#!/usr/bin/ruby

require "/home/takeshik/scripts/Tkwsm/MolCalc/molcalc.rb"

class MassBin

  def initialize( bin_range, max_mol_weight, min_mol_weight=100 )
    @bin_range = bin_range
    @max_mw    = max_mol_weight.to_f
    @min_mw    = min_mol_weight.to_f
    @charge    = ""
    @bins      = {}
    @sorted_bins = []
    @samples = []
    @adduct_list = adduct_list
    create_bins_hash_for_initialize
  end

  attr_reader :bins

  def create_bins_hash_for_initialize
    current_bin_max = 0.0
    current_bin_min = @min_mw
    until current_bin_max > @max_mw
      current_bin_max = current_bin_min + @bin_range
      for charge in [:pos, :neg]
        akey = [ current_bin_min, current_bin_max, charge ]
        @bins[ akey ] = {}
      end
      current_bin_min = current_bin_max
    end
    @sorted_bins = @bins.keys.sort{|akey, bkey| akey[0] <=> bkey[0] }
  end

  def total_bins
    @bins.keys.size
  end

  def find_key( mol_weight, charge )
    @sorted_bins.each do | akey |
      min_border_akey = akey[0]
      max_border_akey = akey[1]
      charge_type     = akey[2] 
      charge          = charge.to_sym if charge.class == String
      next if min_border_akey > mol_weight
      next if max_border_akey < mol_weight
      next if charge_type != charge
      return akey
    end
    return nil
  end

  def adduct_list
    return { "[M+H]+" =>  1.0078250319 }
  end

  def   calc_exact_mass_without_adduct( mz, adduct )
#    if @adduct_list[ adduct ] == nil
#      STDERR.puts "No such adduct type listed #{adduct}\n"
#    else
#    end
#
#    adduct_mw =  @adduct_list[ adduct ]
    @mc = MolCalc.new
    digit_accuracy = 5
    sign, adduct_mw, charge, mult = @mc.adduct_mw(adduct, digit_accuracy)
#    adduct_mw =  @adduct_list[ adduct ]

    mult = ( -1.0 * mult ).to_f  if sign =~ /-/
    exact_mass_without_adduct = (mz * mult / charge ) - adduct_mw
    return exact_mass_without_adduct.round( digit_accuracy )
  end

  def  add_bins_from_a_peak_table( path_to_a_peak_table_file )
    sample_id = @samples.size
    a_peak_table_file = path_to_a_peak_table_file.split("/")[-1]
    @samples[ sample_id ] = a_peak_table_file 
    a = []
    open( path_to_a_peak_table_file ).each_with_index do |x, i|
      a = x.chomp.split("\t")
      charge = a[1]
      mz     = a[2].to_f
      adduct = a[3]
      mass   = calc_exact_mass_without_adduct( mz, adduct )
      akey = find_key( mass, charge )
###      p [ i, Time.new ]  if i % 1000 == 0
      if akey != nil
        @bins[ akey ][ sample_id ] =  0 if @bins[ akey ][ sample_id ] == nil
        @bins[ akey ][ sample_id ] += 1
      end
    end
  end

  def  show_bins_profiles
    print "charge\tmin\tmax"
    @samples.each{|samplename| print "\t#{samplename}" }
    print "\n"
    [:pos, :neg].each do |charge_type|
      @sorted_bins.each do |akey|
        next if akey[2].to_s != charge_type.to_s
        next if @bins[ akey ] == {}
        min_mass = akey[0]
        max_mass = akey[1]
        charge   = akey[2]
        print "#{charge}\t#{min_mass}\t#{max_mass}"
        @samples.each_with_index do |samplename, sample_id|
          if @bins[ akey ][ sample_id ] == nil
            bin_count = 0 
          else
            bin_count = @bins[ akey ][ sample_id ]
          end
          print "\t#{bin_count}"
        end
        print "\n"
      end
    end
  end

end


if $0 == __FILE__

# USAGE
# ruby molbin.rb 0.1

#  mb = MassBin.new
#  p mb.total_bins

  mb = MassBin.new( 0.1, 2000 )
  mb.add_bins_from_a_peak_table( ARGV.shift )
  mb.show_bins_profiles
#  print mb.total_bins, "\n"
end

