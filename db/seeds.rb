# This file should ensure the existence of records required to run the application in every environment.
# Keep it idempotent so running `bin/rails db:seed` repeatedly is safe.

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

student = User.find_or_initialize_by(email: "student@link.cuhk.edu.hk")
student.assign_attributes(name: "Student", role: "student")
if student.new_record? || student.password_digest.blank?
  student.password = "123456"
  student.password_confirmation = "123456"
end
student.save!

# Equipment
[
  { tenant: engineering, name: "ProjectorAA", description: "4K Projector", total_count: 5, available_count: 5, usage_count: 10 },
  { tenant: engineering, name: "Projector", description: "4K Projector", total_count: 5, available_count: 5, usage_count: 15 },
  { tenant: engineering, name: "Speaker", description: "PA Speaker", total_count: 5, available_count: 5, usage_count: 20 },
  { tenant: engineering, name: "Microphone", description: "Wireless Microphone", total_count: 5, available_count: 5, usage_count: 13 },
  { tenant: lifescience, name: "Projector", description: "4K Projector", total_count: 5, available_count: 5, usage_count: 14 }
].each do |item|
  equipment = Equipment.find_or_initialize_by(name: item[:name], tenant: item[:tenant])
  equipment.description = item[:description]
  equipment.total_count = item[:total_count]
  equipment.available_count = item[:available_count]
  equipment.usage_count = item[:usage_count]
  equipment.save!
end

# Locations
Location.find_or_create_by!(name: "Sir Run Run Shaw Hall", latitude: 22.420089834513423, longitude: 114.2072099614738)
Location.find_or_create_by!(name: "NA Gym", latitude: 22.42090899131629, longitude: 114.20930435032216)
Location.find_or_create_by!(name: "UC Gym", latitude: 22.420960312540984, longitude: 114.20567848673426)
Location.find_or_create_by!(name: "Lingnan Stadium", latitude: 22.41493476795026, longitude: 114.20880499854452)
Location.find_or_create_by!(name: "University Sports Centre", latitude: 22.418781207707248, longitude: 114.21198997917793)
Location.find_or_create_by!(name: "Shaw College lecture Theatre", latitude: 22.422362888628257, longitude: 114.2016351058803)

# Venues and time slots
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
