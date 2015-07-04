class VisitsController < ApplicationController

  def new
    @visits = Visit.new
  end

  def create
    @visits = Visit.new(visit_params)
    if @visits.save
      @time = @visits.visited_time
    else
      @error = @visits.errors.full_messages.first
    end
  end

  private
  def visit_params
    params.require(:visit).permit(:mobile_no, :friend_mobile_no)
  end

end
