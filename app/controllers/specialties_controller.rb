class SpecialtiesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_specialty, only: [:edit, :update]
  respond_to :html, :json

  layout 'admin_panel'
  def index
  	 if current_user.admin?
      @specialties = Specialty.paginate(:page => params[:page], :per_page => 10)   
    end
  end

  def new   
    @specialty = Specialty.new
    respond_with(@specialty)     
  end

  def create    
    @specialty = Specialty.new(specialty_params)
   
    format.html { redirect_to action:"index", notice: 'Specialty was succesfully created.' }  
  end

  def update
  end

  def edit
  end
 
  def set_specialty
    @specialty = Specialty.find(params[:id])
  end

  def specialty_params
    params.require(:Specialty).permit(:id, :name)
  end

end
