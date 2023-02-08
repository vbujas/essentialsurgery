class UsersController < ApplicationController

  before_action :authenticate_user!
  before_action :set_user, only: [:edit, :update]
  respond_to :html, :json
  layout 'admin_panel'

  def index
    
      @users = User.paginate(:page => params[:page], :per_page => 10)
      
  end

    def edit
    @user = User.find(params[:id])
    authorize! :update, @user
  end


  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:id, :username, :email, :role )
  end

end
