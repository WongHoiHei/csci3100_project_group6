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
