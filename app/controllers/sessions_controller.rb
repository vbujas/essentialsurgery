class SessionsController < Devise::SessionsController
  clear_respond_to
  respond_to :json
  # respond_to :js

  def create
    resource = warden.authenticate!(scope: resource_name, recall: "#{controller_path}#failure")
    sign_in(resource_name, resource)
    return render json: { success: true }
  end

  def failure
    return render json: { success: false, errors: ['Login or password incorrect, please try again'] }, status: :unprocessable_entity
  end
end
