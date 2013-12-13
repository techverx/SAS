class Api::SessionsController < DeviseController
  prepend_before_filter :allow_params_authentication!, :only => :create
  before_filter :ensure_params_exist, only: :create 
  before_filter :authenticity_token_to_md5,  :except => [:create]
  respond_to :json
  
  
  # POST /resource/sign_in
  def create
    
    self.resource = User.find_for_database_authentication(:email=>params[:user][:email])
    return invalid_login_attempt unless resource
    if resource.valid_password?(params[:user][:password])
      sign_in("user", resource)
      render :json=> {:success=>true, :id=>resource.id, :authenticity_token=>resource.authenticity_token,:email=>resource.email,:first_name=>resource.first_name,:last_name=>resource.last_name,:phone=>resource.phone,:digital_pin=>resource.digital_pin, :message => "signed in successfully"}, :status => 200
      return
    end
    invalid_login_attempt
  end
  # DELETE /resource/sign_out
  def destroy
    
    #user = User.find(params[:id])
    sign_out(@user)
    render :json => {:success => true, :message => "signed out successfully "}
  end
  
  protected
  def ensure_params_exist
    if params[:user][:email].blank? or params[:user][:password].blank?
      render :json=>{:success=>false, :message=>"missing user_login parameter"}, :status=>422
    end
  end
 
  def invalid_login_attempt
    warden.custom_failure!
    render :json=> {:success=>false, :message=>"Your email or password are invalid"}, :status=>401
  end
  def authenticity_token_to_md5
     @user = User.find_by_authenticity_token(params[:authenticity_token])
  end
end