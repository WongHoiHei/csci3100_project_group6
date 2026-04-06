class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :bookable, polymorphic: true

  # #define status
  #enum status: {pending: 0, approved: 1, rejected: 2 }

  #ensure new booking not conflict with exist booking (Class)
  def self.new_conflict?(bookable_id, bookable_type, start_time, end_time)
    where(bookable_id: bookable_id,  bookable_type: bookable_type,  status: "approved") #key: value
    .where("start_time <? AND end_time >?" , end_time, start_time)
    .exists?


  end

  #checking i sthere conflict when revise existing booking (Instance)
  def revise_conflict?
    self.class.where(bookable_id: bookable_id,  bookable_type: bookable_type,  status: "approved") #key: value
    .where("start_time <? AND end_time >?" , end_time, start_time)
    .where.not(id: id) #except self application
    .exists?
  end
  

  #change status
  def approved!
    update(status: "approved")
  end

  def pending!
    update(status: "pending")
  end

  def rejected!
    update(status:  "rejected")
  end

  #check status
  def approved?
    status =="approved"
  end

  def pending?
    status =="pending"
  end

  def rejected?
    status =="rejected"
  end


end

