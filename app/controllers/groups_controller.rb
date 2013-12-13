class GroupsController < ApplicationController
  before_filter :authenticity_token_to_md5 ,except: :create 
  def create
    @group = Group.create(params.require(:group).permit(:name))
    params[:user][:user_id].split(",").each do |f|
      @user = User.find(f.to_i) 
      (@group.users << @user) if @user
    end
    if @group.save
      if params[:creator_id]
        @admin_user = GroupUser.where(:user_id => params[:creator_id]).where(:group_id => @group.id).first
        @admin_user.update_attribute(:admin,true) 
      end
      render json: {:message=>"group created successfully", success: :true}
    else
      render json: @group.errors, status: :unprocessable_entity
    end  
  end
  def destroy
    @group_user = GroupUser.where(:group_id => params[:id]).where(:user_id => params[:user_id]).first
    if is_admin? 
      if @group_user.destroy
        render json: {:message => "member deleted Succesfully"}
      else
        render json: @group_user.errors, status: :unprocessable_entity
      end
    else
      render json: {:message => "You don't have permission to delete the user from group"}
    end
  end
  def is_admin? 
    group_user_admin = GroupUser.where(:group_id => params[:id]).where(:user_id => @user.id).first
    return (group_user_admin and group_user_admin.admin == true ?  true :  false)
  end
end
