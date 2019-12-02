class MonthlyController < ApplicationController
  before_action :days_param, only: [:monthshow, :dayshow]
  def index
    # 出勤月の一覧出力
    @datas = Worktime.select(:year, :month).where("user_id = ?", current_user.id).group(:year, :month).order(year: "DESC", month: "DESC")
  end

  def monthshow
    # 今月の情報
    @year = params[:year]
    @month = params[:month]

    # 出勤日の回数
    @go_count = @go_work.count

    # 総稼働時間の計算
    time_total = 0
    @go_work.each do |go|
      time_con = go.retirement.present? ? (time_con = go.retirement - go.attendance) : 0;
      if time_total == 0
        time_total = time_con
      else
        time_total = time_total + time_con
      end
    end
    time_s = time_total.to_f
    @time_h = sprintf("%.2f", time_s /3600)

    # 休日の回数
    @rest_count = @rest_work.count
  end

  def dayshow
    # 今月の情報
    @year = params[:year]
    @month = params[:month]
  end

  private
  def days_param
    # 出勤日のリスト作成
    @go_work = Worktime.all.where("user_id = ? and year = ? and month = ?", current_user.id, params[:year], params[:month]).order(year: "DESC", month: "DESC", day: "DESC")

    # 休日のリスト作成
    @rest_work = Reason.all.where("user_id = ? and year = ? and month = ?", current_user.id, params[:year], params[:month]).order(year: "DESC", month: "DESC", day: "DESC")
  end
end
