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
engineering = Tenant.find_or_create_by!(name:"Engineering Department")
lifescience =Tenant.find_or_create_by!(name: "Life Science Department")

#add a Admin
User.find_or_create_by!(
    email: "admin@link.cuhk.edu.hk",
    name: "Admin",
    role: "admin",
    tenant: engineering
)

#add student account
User.find_or_create_by!(
    email:"student@link.cuhk.edu.hk",
    name: "Student",
    role: "student",
    tenant: engineering
)

#add venues
#fake nowwwww!!! i made them up first
engineering.venues.find_or_create_by!([
    {name:"SHB301", location: "ho sin hang engineering building 3F", capacity: 50, latitude: 11.1111,longitude: 11.1111 },
    {name:"SHB302", location: "ho sin hang engineering building 3F", capacity: 50, latitude: 11.1112,longitude: 11.1112 },
])

lifescience.venues.find_or_create_by!([
    {name:"SC101", location: "science centre 1F", capacity: 50, latitude: 21.1111,longitude: 21.1111 },
    {name:"SC102", location: "science centre 1F", capacity: 50,  latitude: 31.1112,longitude: 31.1112 },
])

#add equipments
engineering.equipments.find_or_create_by!([
    {name: "ProjectorAA", description:"4K Projector", total_count: 5, available_count: 5},
    { name: 'Projector', description:"4K Projector",total_count: 5, available_count: 5},
    { name: 'Speaker',description:"4K Projector", total_count: 5, available_count: 5 },
    { name: 'Microphone', description:"4K Projector",total_count: 5, available_count: 5}

])

lifescience.equipments.find_or_create_by!([
    {name: "Projector", description:"4K Projector", total_count: 5, available_count: 5}
])