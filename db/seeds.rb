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
<<<<<<< HEAD
=======
>>>>>>> origin/feature/booking-system-functions

#add equipments
[
    { name: 'Projector', total_count: 5, available_count: 5},
    { name: 'Speaker', total_count: 5, available_count: 5 },
    { name: 'Microphone', total_count: 5, available_count: 5}
=======
#add student account
User.create!(
    email:"student@link.cuhk.edu.hk",
    name: "Student",
    role: "student",
    tenant: engineering
)

#add venues
#fake nowwwww!!! i made them up first
engineering.venues.create!([
    {name:"SHB301", location: "ho sin hang engineering building 3F", capacity: 50, latitude: 11.1111,longitude: 11.1111, booking_count: 10 },
    {name:"SHB302", location: "ho sin hang engineering building 3F", capacity: 50, latitude: 11.1112,longitude: 11.1112, booking_count: 8 },
])

lifescience.venues.create!([
    {name:"SC101", location: "science centre 1F", capacity: 50, latitude: 21.1111,longitude: 21.1111, booking_count: 8 },
    {name:"SC102", location: "science centre 1F", capacity: 50,  latitude: 31.1112,longitude: 31.1112, booking_count: 3 },
])

#add equipments
engineering.equipments.create!([
    {name: "ProjectorAA", description:"4K Projector", total_count: 5, available_count: 5, usage_count: 10},
    { name: 'Projector', description:"4K Projector",total_count: 5, available_count: 5, usage_count: 15},
    { name: 'Speaker',description:"4K Projector", total_count: 5, available_count: 5, usage_count: 20 },
    { name: 'Microphone', description:"4K Projector",total_count: 5, available_count: 5, usage_count: 13}
>>>>>>> origin/feature/add-dashboard

].each do |item|
  Equipment.find_or_create_by!(name: item[:name]) do |e|
    e.tenant = engineering
    e.total_count = item[:total_count]
    e.available_count = item[:available_count]
  end
end

<<<<<<< HEAD

#Location （test)
Location.find_or_create_by!(name: "Sir Run Run Shaw Hall", latitude: 22.420089834513423, longitude: 114.2072099614738)
Location.find_or_create_by!(name: "NA Gym", latitude: 22.42090899131629, longitude: 114.20930435032216)
Location.find_or_create_by!(name: "UC Gym", latitude: 22.420960312540984, longitude: 114.20567848673426)
Location.find_or_create_by!(name: "Lingnan Stadium", latitude: 22.41493476795026, longitude: 114.20880499854452)
Location.find_or_create_by!(name: "University Sports Centre", latitude: 22.418781207707248, longitude: 114.21198997917793)
Location.find_or_create_by!(name: "Shaw College lecture Theatre", latitude: 22.422362888628257, longitude: 114.2016351058803)

#Venue of UC Gym
uc_gym = Location.find_by(name: "UC Gym")
basketball_court = Venue.find_or_create_by!(name: "Basketball Court", location: uc_gym) do |v|
  v.capacity = 100
end

badminton_court = Venue.find_or_create_by!(name: "Badminton Court", location: uc_gym) do |v|
  v.capacity = 50
end

[basketball_court, badminton_court].each do |venue|
  next if venue.time_slots.exists?

  ["09:00", "10:00", "11:00", "14:00", "15:00", "16:00"].each do |start|
    hour = start.split(":").first.to_i
    venue.time_slots.create!(start_time: start, end_time: "#{hour + 1}:00")
  end
end


#sample bookinｇ data
<<<<<<< HEAD
=======
lifescience.equipments.create!([
    {name: "Projector", description:"4K Projector", total_count: 5, available_count: 5, usage_count: 14}
])
>>>>>>> origin/feature/add-dashboard
=======
>>>>>>> origin/feature/booking-system-functions
