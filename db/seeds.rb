# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

#add data in tenants (migration)
engineering = Tenant.find_or_create_by!(name: "Engineering Department")
lifescience = Tenant.find_or_create_by!(name: "Life Science Department")

#add an admin
admin = User.find_or_initialize_by(email: "admin@link.cuhk.edu.hk")
admin.assign_attributes(
  name: "Admin",
  role: "admin",
  tenant: engineering
)
if admin.new_record? || admin.password_digest.blank?
  admin.password = "123456"
  admin.password_confirmation = "123456"
end
admin.save!

#add student account
student = User.find_or_initialize_by(email: "student@link.cuhk.edu.hk")
student.assign_attributes(
  name: "Student",
  role: "student",
  tenant: engineering
)
if student.new_record? || student.password_digest.blank?
  student.password = "123456"
  student.password_confirmation = "123456"
end
student.save!

#add venues
#fake nowwwww!!! i made them up first
engineering.venues.create!([
    {name:"SHB301", location: "ho sin hang engineering building 3F", capacity: 50, latitude: 11.1111,longitude: 11.1111 },
    {name:"SHB302", location: "ho sin hang engineering building 3F", capacity: 50, latitude: 11.1112,longitude: 11.1112 },
])

lifescience.venues.create!([
    {name:"SC101", location: "science centre 1F", capacity: 50, latitude: 21.1111,longitude: 21.1111 },
    {name:"SC102", location: "science centre 1F", capacity: 50,  latitude: 31.1112,longitude: 31.1112 },
])

#add equipments
engineering.equipments.create!([
    {name: "ProjectorAA", description:"4K Projector", total_count: 5, available_count: 5},
    { name: 'Projector', description:"4K Projector",total_count: 5, available_count: 5},
    { name: 'Speaker',description:"4K Projector", total_count: 5, available_count: 5 },
    { name: 'Microphone', description:"4K Projector",total_count: 5, available_count: 5}

])

lifescience.equipments.create!([
    {name: "Projector", description:"4K Projector", total_count: 5, available_count: 5}
])

#location = [{location_id: 1, name: "University Library", latitude: 22.28108, longitude: 114.13967},
#            {location_id: 2, name: "Chung Chi College Library", latitude: 22.41653566823139, longitude: 114.20866370201111}
#            {location_id: 3, name: "New Asia College Library", latitude: 22.42143017542914, longitude: 114.20852690935135}
#            {location_id: 4, name: "United College Wu Chung Library", latitude: 22.42090453246833, longitude: 114.20480400323868}
#            {location_id: 5, name: "Architecture Library", latitude: 22.41624556284591, longitude:  114.2116329073906}
#            {location_id: 6, name: "Medical Library", latitude: 22.379129394962067, longitude: 114.20096576213837}
#            {location_id: 7, name: "Law Library", latitude: 22.419483798848937, longitude: 114.2045545578003}
#            {location_id: 8, name: "Learning Common (Wu Ho Man Yuen Building)", latitude: 22.41658525883494, longitude: 114.21148538589478}]
#            
#location.each do |location|
#  Location.create!(location)
#end

