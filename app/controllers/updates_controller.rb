class UpdatesController < ApplicationController
  before_action :authenticate_user!
   
  layout 'admin_panel'

  def index
   
  end
 
end
