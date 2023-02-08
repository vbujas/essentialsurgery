class DoctorsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_doctor, only: [:edit, :update]
  respond_to :html, :json
  layout 'admin_panel'

  def index
    if current_user.admin?
      @doctors = Doctor.paginate(:page => params[:page], :per_page => 10)
      @stories = Story.all

    else
      doctor = Doctor.find(params[:id])
      @stories = Story.all
      redirect_to edit_doctor_path(doctor)
    end
  end

  def edit
    @doctor = Doctor.find(params[:id])
    @countries = Country.all
    @cities = City.where("country_id = ?", @doctor.country_id)
    authorize! :update, @doctor
  end

  def new
     
    @doctor = Doctor.new
    @countries = Country.all
    @cities = City.where("country_id = ?", @doctor.country_id)
    respond_with(@doctor)
      
  end

  

  def create
     
    @doctor = Doctor.new(doctor_params)
    @doctor.save
   
    format.html { redirect_to action:"index", notice: 'Doctor was succesfully created.' }
    
  end

  def update
    respond_to do |format|
      if @doctor.update(doctor_params)
        format.html { redirect_to :back, notice: 'Your profile was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def update_cities
    @cities = City.where("country_id = ?", params[:country_id])
    respond_to do |format|
      format.js
    end
  end

  private
  def set_doctor
    @doctor = Doctor.find(params[:id])
  end

  def doctor_params
    params.require(:doctor).permit(:title, :first_name, :middle_name, :last_name, :email, :fellow_type_id, :gender, :specialty_id, :city_id, :country_id)
  end
end
