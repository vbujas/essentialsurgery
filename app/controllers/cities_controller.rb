class CitiesController < ApplicationController
	 before_action :authenticate_user!
   before_action :set_city, only: [:edit, :update]
   respond_to :html, :json
   
  layout 'admin_panel'
  def index
  		 if current_user.admin?
      @cities = City.paginate(:page => params[:page], :per_page => 10)   
    end
  end
 
  def edit
    @city = City.find(params[:id])
    @countries = Country.all
  end
   
    def update
    respond_to do |format|
      if @city.update(city_params)
        format.html { redirect_to :back, notice: 'City was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end 

   def new
     
    @city = City.new
    @countries = Country.all
    respond_with(@city)
      
  end

  

  def create
     
    @city = Organisation.new(city_params)
    @city.save
    format.html { redirect_to action:"index", notice: 'City was succesfully created.' }
    
  end

  def delete
  end

   private
  def set_city
    @city = City.find(params[:id])
  end

  def city_params
    params.require(:city).permit(:id, :name, :longitude, :latitude, :capital, :mapbox_obj_id)
  end

end
