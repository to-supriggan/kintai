class WorktimesController < ApplicationController
  before_action :today_param

  def show
    @worktime = Worktime.find_by(user_id: current_user.id, year: @today.strftime("%Y"), month: @today.strftime("%m"), day: @today.strftime("%d"))
    @rest = Reason.find_by(user_id: current_user.id, year: @today.strftime("%Y"), month: @today.strftime("%m"), day: @today.strftime("%d"))
  end

  def create
    if !Reason.all.where("user_id = ? and year = ? and month = ? and day = ?", current_user.id, @today.strftime("%Y"), @today.strftime("%m"), @today.strftime("%d")).blank?
      flash[:notice] = "あなたは今日休みです。"
    elsif Worktime.all.where("user_id = ? and year = ? and month = ? and day = ?", current_user.id, @today.strftime("%Y"), @today.strftime("%m"), @today.strftime("%d")).blank?
        Worktime.create(year: @today.strftime("%Y"), month: @today.strftime("%m"), day: @today.strftime("%d"), attendance: Time.current, user_id: current_user.id)
    else
      flash[:notice] = "本日はすでに出勤しています。"
    end
    redirect_to worktime_path(current_user.id)
  end

  def update
    if !Reason.all.where("user_id = ? and year = ? and month = ? and day = ?", current_user.id, @today.strftime("%Y"), @today.strftime("%m"), @today.strftime("%d")).blank?
      flash[:notice] = "あなたは今日休みです。"
    elsif !Worktime.all.where("user_id = ? and year = ? and month = ? and day = ?", current_user.id, @today.strftime("%Y"), @today.strftime("%m"), @today.strftime("%d")).blank?
      Worktime.where("user_id = ? and year = ? and month = ? and day = ?", current_user.id, @today.strftime("%Y"), @today.strftime("%m"), @today.strftime("%d")).update_all(retirement: Time.current)
    else
      flash[:notice] = "本日はまだ出勤していません。"
    end
    redirect_to worktime_path(current_user.id)
  end

  private 

  def today_param
    @today = Date.current
  end
end
