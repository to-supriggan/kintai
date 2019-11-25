class WorktimesController < ApplicationController
  def show
    @worktime = Worktime.all.where("user_id = ? and day = ?", current_user.id, Date.current)
  end

  def create
    if !Reason.all.where("user_id = ? and day = ?", current_user.id, Date.current).blank?
      flash[:notice] = "あなたは今日休みです。"
    elsif Worktime.all.where("user_id = ? and day = ?", current_user.id, Date.current).blank?
        Worktime.create(day: Date.current, attendance: Time.current, user_id: current_user.id)
    else
      flash[:notice] = "本日はすでに出勤しています。"
    end
    redirect_to worktime_path(current_user.id)
  end

  def update


    if !Reason.all.where("user_id = ? and day = ?", current_user.id, Date.current).blank?
      flash[:notice] = "あなたは今日休みです。"
    elsif !Worktime.all.where("user_id = ? and day = ?", current_user.id, Date.current).blank?
        Worktime.update(retirement: Time.current)
      else
      flash[:notice] = "本日はまだ出勤していません。"
    end
    redirect_to worktime_path(current_user.id)
  end
end
