class BugsController < ApplicationController
  before_action :set_bug, only: [:show, :edit, :update, :destroy]

  respond_to :html
  layout 'admin_panel'
  def index
    if current_user.admin?
      @bugs = Bug.paginate(:page => params[:page], :per_page => 10)   
      end 
  end

  def show
    respond_with(@bug)
  end

  def new
    @bug = Bug.new
    respond_with(@bug)
  end

  def edit
  end

  def create

   bug = Bug.new(bug_params)
    if bug.save
    
  # respond to normal request
    render :json => bug.to_json 
  #, :status=>201
  end
  end

  def update
    flash[:notice] = 'Bug was successfully updated.' if @bug.update(bug_params)
    respond_with(@bug)
  end

  def destroy
    @bug.destroy
    respond_with(@bug)
  end

  private
    def set_bug
      @bug = Bug.find(params[:id])
    end

    def bug_params
      params.require(:bug).permit(:title, :name, :email, :text)
    end
end
