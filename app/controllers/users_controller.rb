# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    @users = User.paginate(page: params[:page])
                 .order(created_at: :desc)
  end

  def parse
    Users::ParseService.call(params[:location_id], params[:number_of_pages])
    redirect_to root_path
    flash[:success] = 'Users have been uploaded!'
  end

  def destroy
    User.destroy_all
    redirect_to root_path
    flash[:success] = 'Users have been deleted!'
  end
end
