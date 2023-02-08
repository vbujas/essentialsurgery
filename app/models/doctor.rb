# == Schema Information
#
# Table name: doctors
#
#  id              :integer          not null, primary key
#  title           :string(255)
#  first_name      :string(255)
#  middle_name     :string(255)
#  last_name       :string(255)
#  email           :string(255)
#  fellow_type_id  :integer
#  gender          :string(255)
#  specialty_id    :integer
#  city_id         :integer
#  country_id      :integer
#  created_at      :datetime
#  updated_at      :datetime
#  organisation_id :integer
#  qualification   :text
#  user_id         :integer
#

class Doctor < ActiveRecord::Base
  belongs_to :fellow_type
  belongs_to :specialty
  belongs_to :country
  belongs_to :city
  belongs_to :organisation

  acts_as_taggable

  TITLE = { 0 => "Dr", 1 => "Ms", 2 => "Mr", 3 => "Prof" }
  GENDER = { 0 => "Male", 1 => "Female" }
end
