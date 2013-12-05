class User < ActiveRecord::Base
  validates :name, presence: true
  validates :name, uniqueness: true
  validates :phone_number, presence: true
  validates :phone_number, uniqueness: true
  validates_numericality_of :phone_number, only_integer: true,
    :message => "can only contain numbers, no dashes or parentheses are allowed"
  validates_length_of :phone_number, :maximum => 11
  validates_length_of :phone_number, :minimum => 11,
    :message => "must start with 1 followed by area code then number"
  validates :relationship, presence: true

  has_many :text_data, class_name: "TextData"

#all my validations are happy!

  def self.find_sender(phone_number)
    User.where(phone_number: phone_number).first
  end

#count successful texts
  def text_count
    text_data.where(text_success:true).
      where(["extract(month from created_at) = ?",Date.today.month]).
      where(["extract(year from created_at) = ?",Date.today.year]).count
  end

#NEW CODE To keep track of the number of codes a user has used
  def code_limit_reached
    self.relationship.where(text_count:code_limit)
  end

#set by relationships: desk, office, suite, partner, packard
  def self.code_limit(relationship)
#like this?    User.where(relationship: desk = 4)
    desk = 1
    office = 5
    suite = 10
    partner = 5
    packard = 100
  end


end

