#!/usr/bin/env rails runner

Equipment.order(:name).each do |e|
  puts "#{e.id} - #{e.name}"
end

puts "\nGrouping by name:"
Equipment.group(:name).count.each do |name, count|
  puts "#{name}: #{count} records"
end
