class Api::UsersController < ApplicationController
  respond_to :json
  before_filter :authenticity_token_to_md5,  :except => [:index, :create]

  def create
    @user = User.new(params.require(:user).permit(:email,:password,:password_confirmation,:phone,:digital_pin, :profile_attributes => [:id,:first_name,:last_name,:nickname,:address,:contact_information,:DOB,:eye_color,:hair_color,:gender,:height,:weight,:blood_type,:ethnicity],:emergency_contacts_attributes => [:id,:first_name,:last_name,:relationship,:phone]))
    @user.authenticity_token = Digest::MD5.hexdigest(@user.email)

    if @user.save
      render json: {:message => "signed up successfully", :success => true}
    else
      render json: @user.errors, status: :unprocessable_entity 
    end
  end
    
  def update
    if @user.update_attributes(params[:user].permit(:first_name,:last_name,:password,:password_confirmation,:phone,:digital_pin))
      render json: { status: :ok, :message => "updated successfully" }
    else
      render json: @user.errors, status: :unprocessable_entity 
    end
  end

  def destroy
    if @user.destroy
      render json: { status: :ok, :message => "Deleted Successfully" }
        
    else
      render json: @user.errors, status: :unprocessable_entity 
    end
  end
end
