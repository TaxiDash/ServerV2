class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  #Handle https redirects
  force_ssl if: :ssl_required?

  #Handle authentication
  before_action :authenticate_user!, if: :login_required?

  def ssl_required?
    #ssl is forced for specific modules
    if Rails.env.development? then
      return false
    end

    return module_name == "manage" || module_name == "api" ||
      module_name == "devise"
  end

  def login_required?
    #puts "login required? #{module_name == "manage" && current_path != '/users/sign_in'}"
    return module_name == "manage" && current_path != '/users/sign_in'
  end

  private 

  def current_path
    #puts "path is #{request.env['PATH_INFO']}"
    return request.env['PATH_INFO']
  end 

  def module_name
    class_name = self.class.to_s

    if not class_name.index("::").nil? then #it is a namespace
      return self.class.to_s.split("::").first.downcase
    else
      return nil
    end
  end

  #CanCan stuff
private

def current_ability
  #I am sure there is a slicker way to capture the controller namespace
  controller_name_segments = params[:controller].split('/')
  controller_name_segments.pop
  controller_namespace = controller_name_segments.join('/').camelize
  Ability.new(current_user, controller_namespace)
end


end
