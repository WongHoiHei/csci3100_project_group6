# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Departments / owners for equipment
engineering = Tenant.find_or_create_by!(name: "Engineering Department")
lifescience = Tenant.find_or_create_by!(name: "Life Science Department")

# Users
admin = User.find_or_initialize_by(email: "admin@link.cuhk.edu.hk")
admin.assign_attributes(name: "Admin", role: "admin")
if admin.new_record? || admin.password_digest.blank?
  admin.password = "123456"
  admin.password_confirmation = "123456"
end
admin.save!

<<<<<<< HEAD
student = User.find_or_initialize_by(email: "student@link.cuhk.edu.hk")
student.assign_attributes(name: "Student", role: "student")
if student.new_record? || student.password_digest.blank?
  student.password = "123456"
  student.password_confirmation = "123456"
end
student.save!

# Locations
locations = [
  ["Sir Run Run Shaw Hall", 22.420089834513423, 114.2072099614738],
  ["NA Gym", 22.42090899131629, 114.20930435032216],
  ["UC Gym", 22.420960312540984, 114.20567848673426],
  ["Lingnan Stadium", 22.41493476795026, 114.20880499854452],
  ["University Sports Centre", 22.418781207707248, 114.21198997917793],
  ["Shaw College lecture Theatre", 22.422362888628257, 114.2016351058803]
]

locations.each do |name, latitude, longitude|
  Location.find_or_create_by!(name: name) do |location|
    location.latitude = latitude
    location.longitude = longitude
  end
end

# Venues
uc_gym = Location.find_by(name: "UC Gym")
Venue.find_or_create_by!(name: "Basketball Court", location: uc_gym) do |venue|
  venue.capacity = 100
end
Venue.find_or_create_by!(name: "Badminton Court", location: uc_gym) do |venue|
  venue.capacity = 50
end

# Equipment
equipment_items = [
  ["ProjectorAA", "4K Projector", 5],
  ["Projector", "4K Projector", 5],
  ["Speaker", "Audio Speaker", 5],
  ["Microphone", "Wireless Microphone", 5]
]

equipment_items.each do |name, description, count|
  Equipment.find_or_create_by!(name: name, tenant_id: engineering.id) do |equipment|
    equipment.description = description
    equipment.total_count = count
    equipment.available_count = count
  end
end

Equipment.find_or_create_by!(name: "Projector", tenant_id: lifescience.id) do |equipment|
  equipment.description = "4K Projector"
  equipment.total_count = 5
  equipment.available_count = 5
end
=======

#add equipments
[
    { name: 'Projector', total_count: 5, available_count: 5},
    { name: 'Speaker', total_count: 5, available_count: 5 },
    { name: 'Microphone', total_count: 5, available_count: 5}

].each do |item|
  equip = Equipment.find_or_create_by!(name: item[:name]) do |e|
    e.total_count = item[:total_count]
    e.available_count = item[:available_count]
  end
 
  if equip.time_slots.count == 0
    ["09:00", "10:00", "11:00", "14:00", "15:00", "16:00"].each do |start|
      hour = start.split(":").first.to_i
      equip.time_slots.create!(start_time: start, end_time: "#{hour + 1}:00")
    end
  end
end


#Location （test)
Location.find_or_create_by!(name: "Sir Run Run Shaw Hall", latitude: 22.420089834513423, longitude: 114.2072099614738)
Location.find_or_create_by!(name: "NA Gym", latitude: 22.42090899131629, longitude: 114.20930435032216)
Location.find_or_create_by!(name: "UC Gym", latitude: 22.420960312540984, longitude: 114.20567848673426)
Location.find_or_create_by!(name: "Lingnan Stadium", latitude: 22.41493476795026, longitude: 114.20880499854452)
Location.find_or_create_by!(name: "University Sports Centre", latitude: 22.418781207707248, longitude: 114.21198997917793)
Location.find_or_create_by!(name: "Shaw College lecture Theatre", latitude: 22.422362888628257, longitude: 114.2016351058803)

#Venue of UC Gym
uc_gym = Location.find_by(name: "UC Gym")
uc_gym.venues.create!(name: "Basketball Court", capacity: 100)
uc_gym.venues.create!(name: "Badminton Court", capacity: 50)


#sample bookinｇ data
>>>>>>> origin/booking
