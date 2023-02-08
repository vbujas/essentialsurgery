# == Schema Information
#
# Table name: ngos
#
#   t.string :organization_name
#   t.string :contact_email
#   t.string	:website
#   t.string	:surgery_focused, :limit => 1	
#   t.string	:permanent_hospital, :limit => 1
#   t.string	:self_contained, :limit => 1
#   t.string    :short_term, :limit => 1
#   t.string	:long_term, :limit => 1
#   t.string	:humanitarian, :limit => 1
#

class Ngo < ActiveRecord::Base
 
end
