class DistrictsController < ApplicationController
  before_action :authenticate_user!
   before_action :set_district, only: [:edit, :update]
  layout 'admin_panel'

  def index
  	 if current_user.admin?
      @districts = District.paginate(:page => params[:page], :per_page => 10)   
    end
  end

  def edit
    @district = District.find(params[:id])
    @countries = Country.all
  end
   
    def update
    respond_to do |format|
      if @district.update(district_params)
        format.html { redirect_to :back, notice: 'City was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end 

  def create
  end

  private
  def set_district
    @district = District.find(params[:id])
  end

  def district_params
    params.require(:district).permit(:id, :name, :mapbox_obj_id, :country_id, :est_population)
  end

  def delete
  end
end
