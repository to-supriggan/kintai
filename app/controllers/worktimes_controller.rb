class WorktimesController < ApplicationController
  def show
    @worktime = Worktime.all.where("user_id = ? and day = ?", current_user.id, Date.current)
  end

  def create
    Worktime.create(day: Date.current, attendance: Time.current, user_id: current_user.id)
    redirect_to worktime_path(current_user.id)
  end

  def update
    worktime = Worktime.all.where("user_id = ? and day = ?", current_user.id, Date.current)
    worktime.update(retirement: Time.current)
    redirect_to worktime_path(current_user.id)
  end
end
