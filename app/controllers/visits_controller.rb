class VisitsController < ApplicationController
  http_basic_authenticate_with name: "hardikg23", password: "whardik91v", only: :index

  def index
    page = params[:page] || 1
    @visits = Visit.order('id desc').paginate(:page => page, :per_page => 30)
  end

  def new
    @visit = Visit.new
  end

  def create
    @visit = Visit.new(visit_params)
    if @visit.save
      @time = @visit.visited_time
    else
      @error = @visit.errors.full_messages.first
    end
  end

  private
  def visit_params
    params.require(:visit).permit(:mobile_no, :friend_mobile_no)
  end

end
