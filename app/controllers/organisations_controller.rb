class OrganisationsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_organisation, only: [:edit, :update]
    respond_to :html, :json
  layout 'admin_panel'
  def index
  	 if current_user.admin?
      @organisations = Organisation.paginate(:page => params[:page], :per_page => 10)   
    end
  end

   def edit
    @organisation = Organisation.find(params[:id])
    @countries = Country.all
  end
   
    def update
    respond_to do |format|
      if @organisation.update(organisation_params)
        format.html { redirect_to :back, notice: 'Organisation was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end 

   def new
     
    @organisation = Organisation.new
    @countries = Country.all
   # @cities = City.where("country_id = ?", @organisation.country_id)
    respond_with(@organisation)
      
  end

  

  def create
     
    @organisation = Organisation.new(organisation_params)
    @organisation.save
   
    format.html { redirect_to action:"index", notice: 'Organisation was succesfully created.' }
    
  end

   def delete
  end
   private
  def set_organisation
    @organisation = Organisation.find(params[:id])
  end

  def organisation_params
    params.require(:organisation).permit(:id, :name, :longitude, :latitude, :training, :city_id)
  end
 
end
