# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!
Rails.logger = Le.new('c6ebec35-5da3-361e-98a0-b28e8d4c1946', :debug => true, :local => true)
