class UsersController < ApplicationController
  def index
    @users = User.paginate(page: params[:page])
                 .order(created_at: :desc)
  end

  def parse
    ParseUsersWorker.perform_async(params[:location_id], params[:number_of_pages])
  end
end
