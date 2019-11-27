class ReasonsController < ApplicationController
  before_action :set_reason_param, only: [:create]

  def index
    now_day = Date.today
    @days = []
    for num in 0..6 do
      @days << now_day + num
    end
  end

  def create
    if Worktime.all.where("user_id = ? and year = ? and month = ? and day = ?", current_user.id, @day.strftime("%Y"), @day.strftime("%m"), @day.strftime("%d")).blank?
      if !Reason.all.where("user_id = ? and year = ? and month = ? and day = ?", current_user.id, @day.strftime("%Y"), @day.strftime("%m"), @day.strftime("%d")).blank?
        flash[:notice] = "すでに休みの連絡を出してます。"
        redirect_to reasons_path
      else
        Reason.create(year: @day.strftime("%Y"), month: @day.strftime("%m"), day: @day.strftime("%d"), reason: @reason, user_id: current_user.id)
        redirect_to root_path
      end
    else
      flash[:notice] = "本日は出勤しています。"
      redirect_to reasons_path
    end
  end

  private

  def set_reason_param
    @day = params.permit(:day).values[0].to_date
    @reason = params.permit(:reason).values[0]
  end

end
