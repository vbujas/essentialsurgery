# == Schema Information
#
# Table name: fellow_types
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class FellowType < ActiveRecord::Base
  has_many :doctors
end
