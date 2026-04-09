# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

#add a Admin
User.create!(
    email: "admin@link.cuhk.edu.hk",
    name: "Admin",
    role: "admin"
)

#add student account
User.create!(
    email:"student@link.cuhk.edu.hk",
    name: "Student",
    role: "student"
)

#add venues
#fake nowwwww!!! i made them up first
# engineering.venues.create!([
#     {name:"SHB301", location: "ho sin hang engineering building 3F", capacity: 50, latitude: 11.1111,longitude: 11.1111 },
#     {name:"SHB302", location: "ho sin hang engineering building 3F", capacity: 50, latitude: 11.1112,longitude: 11.1112 },
# ])

# lifescience.venues.create!([
#     {name:"SC101", location: "science centre 1F", capacity: 50, latitude: 21.1111,longitude: 21.1111 },
#     {name:"SC102", location: "science centre 1F", capacity: 50,  latitude: 31.1112,longitude: 31.1112 },
# ])

#add equipments
Equipment.create!([
    {name: "ProjectorAA", total_count: 5, available_count: 5},
    { name: 'Projector', total_count: 5, available_count: 5},
    { name: 'Speaker', total_count: 5, available_count: 5 },
    { name: 'Microphone', total_count: 5, available_count: 5}

])

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