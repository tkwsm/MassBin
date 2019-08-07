#!/usr/bin/ruby
#

a = []
ARGF.each_with_index do |x, i|
  a    = x.chomp.split("\t")
  akey = a[1]
  if  i == 0
    print akey, "\t", a[3..-1].join("\t"), "\n"
  else
#    next if x =~ /neg/
    next if x =~ /pos/
    print akey
    a[3..-1].each do |v|
      print "\t0" if v.to_i == 0
      print "\t1" if v.to_i >  0
    end
    print "\n"
  end
end
