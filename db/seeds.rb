# This file should ensure the existence of records required to run the application in every environment.
# Keep it idempotent so running `bin/rails db:seed` repeatedly is safe.

# Users
admin = User.find_or_initialize_by(email: "admin@link.cuhk.edu.hk")
admin.assign_attributes(name: "Admin", role: "admin")
if admin.new_record? || admin.password_digest.blank?
  admin.password = "123456"
  admin.password_confirmation = "123456"
end
admin.save!


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
end


#Location （test)
Location.find_or_create_by!(name: "Sir Run Run Shaw Hall", latitude: 22.420089834513423, longitude: 114.2072099614738)
Location.find_or_create_by!(name: "NA Gym", latitude: 22.42090899131629, longitude: 114.20930435032216)
Location.find_or_create_by!(name: "UC Gym", latitude: 22.420960312540984, longitude: 114.20567848673426)
Location.find_or_create_by!(name: "Lingnan Stadium", latitude: 22.41493476795026, longitude: 114.20880499854452)
Location.find_or_create_by!(name: "University Sports Centre", latitude: 22.418781207707248, longitude: 114.21198997917793)
Location.find_or_create_by!(name: "Shaw College lecture Theatre", latitude: 22.422362888628257, longitude: 114.2016351058803)
Location.find_or_create_by!(name: "University Library", latitude: 22.419483798848937, longitude: 114.20480400323868)
Location.find_or_create_by!(name: "Chung Chi College Library", latitude: 22.41653566823139, longitude: 114.20866370201111)
Location.find_or_create_by!(name: "New Asia College Library", latitude: 22.42143017542914, longitude: 114.20852690935135)
Location.find_or_create_by!(name: "United College Wu Chung Library", latitude: 22.42090453246833, longitude: 114.20480400323868)
Location.find_or_create_by!(name: "Architecture Library", latitude: 22.41624556284591, longitude:  114.2116329073906)
Location.find_or_create_by!(name: "Medical Library", latitude: 22.3831, longitude: 114.2054)
Location.find_or_create_by!(name: "Law Library", latitude: 22.419483798848937, longitude: 114.2045545578003)
Location.find_or_create_by!(name: "Learning Common (Wu Ho Man Yuen Building)", latitude: 22.41658525883494, longitude: 114.21148538589478)


#Venue of UC Gym
uc_gym = Location.find_by(name: "UC Gym")
basketball_court = Venue.find_or_create_by!(name: "Basketball Court", location: uc_gym) do |v|
  v.capacity = 100
end

badminton_court = Venue.find_or_create_by!(name: "Badminton Court", location: uc_gym) do |v|
  v.capacity = 50
end

#Venue of NA Gym
na_gym = Location.find_by(name: "NA Gym")
basketball_court = Venue.find_or_create_by!(name: "Basketball Court", location: na_gym) do |v|
  v.capacity = 100
end

badminton_court = Venue.find_or_create_by!(name: "Badminton Court", location: na_gym) do |v|
  v.capacity = 50
end

#Venue of Lingnan Stadium
lingnan_stadium = Location.find_by(name: "Lingnan Stadium")
basketball_court = Venue.find_or_create_by!(name: "Basketball Court", location: lingnan_stadium) do |v|
  v.capacity = 100
end

badminton_court = Venue.find_or_create_by!(name: "Badminton Court", location: lingnan_stadium) do |v|
  v.capacity = 50
end

#Venue of University Sports Centre
university_sports_entre = Location.find_by(name: "University Sports Centre")
basketball_court = Venue.find_or_create_by!(name: "Basketball Court", location: university_sports_entre) do |v|
  v.capacity = 100
end

badminton_court = Venue.find_or_create_by!(name: "Badminton Court", location: university_sports_entre) do |v|
  v.capacity = 50
end


# Venue of University Library
u_lib = Location.find_by(name: "University Library")

u_lib_rooms = [
  { name: "Group Study Room 10 - 1/F", capacity: 4 },
  { name: "Group Study Room 11 - 1/F", capacity: 6 },
  { name: "Group Study Room 12 - 1/F", capacity: 4 },
  { name: "Group Study Room 13 - 1/F", capacity: 4 },
  { name: "Group Study Room 14 - 1/F", capacity: 4 },
  { name: "Group Study Room 15 - 1/F", capacity: 4 },
  { name: "Group Study Room 16 - 1/F", capacity: 4 },
  { name: "Group Study Room 17 - 1/F", capacity: 4 },
  { name: "Group Study Room 18 - 1/F", capacity: 8 },
  { name: "Group Study Room 19 - 3/F", capacity: 5 },
  { name: "Group Study Room 20 - 3/F", capacity: 5 },
  { name: "Group Study Room 21 - 4/F", capacity: 5 },
  { name: "Bubble Group Study Room 1 - LG/F", capacity: 4 },
  { name: "Bubble Group Study Room 2 - LG/F", capacity: 4 },
  { name: "Bubble Group Study Room 3 - LG/F", capacity: 4 },
  { name: "Bubble Group Study Room 4 - LG/F", capacity: 4 },
  { name: "Bubble Group Study Room 5 - LG/F", capacity: 4 },
  { name: "Creative Media Studio - LG/F", capacity: 8 },
  { name: "Study Pod 1 - LG/F", capacity: 2 },
  { name: "Study Pod 2 - LG/F", capacity: 2 }
]

library_venues = u_lib_rooms.map do |room|
  Venue.find_or_create_by!(name: room[:name], location: u_lib) do |v|
    v.capacity = room[:capacity]
  end
end

# Venue of Chung Chi College Library
cc_lib = Location.find_by(name: "Chung Chi College Library")

cc_lib_rooms = [
  { name: "Group Study Room 1 - G/F", capacity: 6 },
  { name: "Group Study Room 2 - G/F", capacity: 6 },
  { name: "Group Study Room 3 - 1/F", capacity: 6 },
  { name: "Group Study Room 4 - 1/F", capacity: 6 },
  { name: "Group Study Room 5 - 1/F", capacity: 6 },
  { name: "Group Study Room 6 - 1/F", capacity: 6 },
  { name: "Listening Room 1 - 2/F", capacity: 2 },
  { name: "Listening Room 2 - 2/F", capacity: 2 },
  { name: "Music Room 1 - 2/F", capacity: 4 },
  { name: "Music Room 2 - 2/F", capacity: 8 }
]

cc_library_venues = cc_lib_rooms.map do |room|
  Venue.find_or_create_by!(name: room[:name], location: cc_lib) do |v|
    v.capacity = room[:capacity]
  end
end

# Venue of NA Library
na_lib = Location.find_by(name: "New Asia College Library")

na_lib_rooms = [
  { name: "Group Study Room 1", capacity: 4 },
  { name: "Group Study Room 2", capacity: 4 },
  { name: "Group Study Room 3", capacity: 6 }
]

na_library_venues = na_lib_rooms.map do |room|
  Venue.find_or_create_by!(name: room[:name], location: na_lib) do |v|
    v.capacity = room[:capacity]
  end
end

# Venue of UC Library
uc_lib = Location.find_by(name: "United College Wu Chung Library")

uc_lib_rooms = [
  { name: "Group Study Room 1", capacity: 4 },
  { name: "Group Study Room 2", capacity: 4 },
  { name: "Group Study Room 3", capacity: 4 },
  { name: "Group Study Room 4", capacity: 6 },
  { name: "Group Study Room 5", capacity: 4 }
]

uc_library_venues = uc_lib_rooms.map do |room|
  Venue.find_or_create_by!(name: room[:name], location: uc_lib) do |v|
    v.capacity = room[:capacity]
  end
end

# Venues of Architecture Library
arch_lib = Location.find_by(name: "Architecture Library")
arch_lib_venue = Venue.find_or_create_by!(name: "Group Study Room", location: arch_lib) do |v|
  v.capacity = 4
end

# Venues of Medical Library
med_lib = Location.find_by(name: "Medical Library")

med_lib_rooms = [
  { name: "MEL Group Study Pod", capacity: 4 },
  { name: "Group Study Room 1", capacity: 6 },
  { name: "Group Study Room 2", capacity: 6 },
  { name: "Group Study Room 3", capacity: 6 },
  { name: "Group Study Room 4", capacity: 6 },
  { name: "Group Study Room 5", capacity: 6 },
  { name: "MEL Group Pod", capacity: 2 }
]

med_library_venues = med_lib_rooms.map do |room|
  Venue.find_or_create_by!(name: room[:name], location: med_lib) do |v|
    v.capacity = room[:capacity]
  end
end

# Venue of Law Library
law_lib = Location.find_by(name: "Law Library")

law_lib_rooms = [
  { name: "Online Interview Room 1 - 4/F", capacity: 1 },
  { name: "Group Study Room 1 - 4/F", capacity: 6 },
  { name: "Group Study Room 2 - 4/F", capacity: 6 },
  { name: "Group Study Room 3 - 4/F", capacity: 4 },
  { name: "Group Study Room 4 - 4/F", capacity: 4 },
  { name: "Group Study Room 5 - 4/F", capacity: 4 },
  { name: "Group Study Room 6 - 3/F", capacity: 6 },
  { name: "Online Interview Room 2 - 3/F", capacity: 3 }
]

law_library_venues = law_lib_rooms.map do |room|
  Venue.find_or_create_by!(name: room[:name], location: law_lib) do |v|
    v.capacity = room[:capacity]
  end
end

# Venue of Learning Common (Wu Ho Man Yuen Building)
lc = Location.find_by(name: "Learning Common (Wu Ho Man Yuen Building)")
lc_venues = [
  { name: "Group Study Room 1", capacity: 12 },
  { name: "Group Study Room 2", capacity: 6 },
  { name: "Group Study Room 3", capacity: 6 }
]
learning_common_venues = lc_venues.map do |room|
  Venue.find_or_create_by!(name: room[:name], location: lc) do |v|
    v.capacity = room[:capacity]
  end
end


["09:00", "10:00", "11:00", "14:00", "15:00", "16:00"].each do |start|
  hour = start.split(":").first.to_i
  TimeSlot.find_or_create_by!(start_time: start, end_time: "#{hour + 1}:00")
end


#sample booking data
