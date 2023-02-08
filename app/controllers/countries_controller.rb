class CountriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_country, only: [:edit, :update]
  respond_to :html, :json
   
  layout 'admin_panel'
  def index
  	 if current_user.admin?
      @countries = Country.paginate(:page => params[:page], :per_page => 10)   
    end
  end

   def edit
    @country = Country.find(params[:id])
  end
   
    def update
    respond_to do |format|
      if @country.update(country_params)
        format.html { redirect_to :back, notice: 'Country was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end 

 def new   
    @country = Country.new
    respond_with(@country)     
  end

  def create    
    @country = Country.new(country_params)
    @country.save
    format.html { redirect_to action:"index", notice: 'Country was succesfully created.' }  
  end

  def delete
  end

  def set_country
    @country = Country.find(params[:id])
  end

  def country_params
    params.require(:country).permit(:id, :name, :longitude, :latitude)
  end
end
