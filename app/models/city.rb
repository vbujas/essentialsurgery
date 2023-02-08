# == Schema Information
#
# Table name: cities
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  country_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class City < ActiveRecord::Base
  has_many :doctors
  belongs_to :country
  belongs_to :district

   CAPITAL = { 0 => "No", 1 => "Yes" }
end
