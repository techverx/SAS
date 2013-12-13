class ApplicationController < ActionController::Base
  def authenticity_token_to_md5
    @user = User.find_by_authenticity_token(params[:authenticity_token])
    unless @user
      render json: {:message => "invalid user token"}  
    end
  end
end
