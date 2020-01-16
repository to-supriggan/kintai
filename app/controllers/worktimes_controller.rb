class WorktimesController < ApplicationController
  before_action :today_params
  before_action :create_params, only: [:new, :edit]

  def show
    @worktime = Worktime.find_by(user_id: current_user.id, year: @now_day.strftime("%Y"), month: @now_day.strftime("%m"), day: @now_day.strftime("%d"))
    @rest = Reason.find_by(user_id: current_user.id, year: @now_day.strftime("%Y"), month: @now_day.strftime("%m"), day: @now_day.strftime("%d"))
  end

  def new
  end

  def create
    if params[:commit].present?
      # 打刻忘れ登録の場合

      # パラメータ設定
      param_times_set

      if @start_time_to_time <= @end_time_to_time
        # 退勤時間が出勤時間よりも遅く設定されている場合（正常）
        if !Reason.all.where("user_id = ? and year = ? and month = ? and day = ?", current_user.id, params[:year], params[:month], params[:day]).blank?
          flash[:notice] = "あなたは指定日休んでいます。"
        elsif Worktime.all.where("user_id = ? and year = ? and month = ? and day = ?", current_user.id, params[:year], params[:month], params[:day]).blank?
          Worktime.create(year: params[:year], month: params[:month], day: params[:day], attendance: @start_time_to_time, retirement: @end_time_to_time, user_id: current_user.id)
          flash[:notice] = "指定日の打刻が完了しました。"
        else
          flash[:notice] = "指定日は出勤しています。編集画面で指定日を選択して下さい。"
        end
      else
        # 出勤時間が退勤時間よりも遅く設定されている場合（異常）
        flash[:notice] = "退勤時間が出勤時間よりも早く設定されています。"
      end
    else
      # 出勤登録の場合
      if !Reason.all.where("user_id = ? and year = ? and month = ? and day = ?", current_user.id, @now_day.strftime("%Y"), @now_day.strftime("%m"), @now_day.strftime("%d")).blank?
        flash[:notice] = "あなたは今日休みです。"
      elsif Worktime.all.where("user_id = ? and year = ? and month = ? and day = ?", current_user.id, @now_day.strftime("%Y"), @now_day.strftime("%m"), @now_day.strftime("%d")).blank?
          Worktime.create(year: @now_day.strftime("%Y"), month: @now_day.strftime("%m"), day: @now_day.strftime("%d"), attendance: Time.current, user_id: current_user.id)
      else
        flash[:notice] = "本日はすでに出勤しています。"
      end
    end
    redirect_to worktime_path(current_user.id)
  end

  def update
    if params[:commit].present?
      # 打刻誤り修正の場合

      # パラメータ設定
      param_times_set

      if @start_time_to_time <= @end_time_to_time
        # 退勤時間が出勤時間よりも遅く設定されている場合（正常）
        @update_day = Worktime.find(params[:id])
        if !Reason.all.where("user_id = ? and year = ? and month = ? and day = ?", current_user.id, @update_day.year, @update_day.month, @update_day.day).blank?
          flash[:notice] = "あなたは指定日休んでいます。"
        elsif Worktime.all.where("user_id = ? and year = ? and month = ? and day = ?", current_user.id, @update_day.year, @update_day.month, @update_day.day).blank?
          flash[:notice] = "指定日に出勤していません。打刻忘れを登録して下さい。"
        else
          Worktime.where("user_id = ? and id = ?", current_user.id, params[:id]).update_all(attendance: @start_time_to_time,retirement: @end_time_to_time)
          flash[:notice] = "更新が完了しました。"
        end
      else
        # 出勤時間が退勤時間よりも遅く設定されている場合（異常）
        flash[:notice] = "退勤時間が出勤時間よりも早く設定されています。"
      end
      redirect_to edit_worktime_path(params[:id]);
    else
      # 退勤打刻の場合
      if !Reason.all.where("user_id = ? and year = ? and month = ? and day = ?", current_user.id, @now_day.strftime("%Y"), @now_day.strftime("%m"), @now_day.strftime("%d")).blank?
        flash[:notice] = "あなたは今日休みです。"
      elsif Worktime.all.where("user_id = ? and year = ? and month = ? and day = ?", current_user.id, @now_day.strftime("%Y"), @now_day.strftime("%m"), @now_day.strftime("%d")).blank?
        flash[:notice] = "本日はまだ出勤していません。"
      else
        Worktime.where("user_id = ? and year = ? and month = ? and day = ?", current_user.id, @now_day.strftime("%Y"), @now_day.strftime("%m"), @now_day.strftime("%d")).update_all(retirement: Time.current)
      end
      redirect_to worktime_path(current_user.id)
    end
  end

  def pre_edit
    # 出勤月の一覧出力
    @datas = Worktime.select(:year, :month).where("user_id = ?", current_user.id).group(:year, :month).order(year: "DESC", month: "DESC")
  end

  def go_workshow
    # 今月の情報
    @year = params[:year]
    @month = params[:month]

    # 出勤日のリスト作成
    @go_work = Worktime.all.where("user_id = ? and year = ? and month = ?", current_user.id, params[:year], params[:month]).order(year: "DESC", month: "DESC", day: "DESC")
  end

  def edit
    # 編集対象を取得
    @date = Worktime.find(params[:id])
  end

  private 

  def today_params
    # 現在の日付
    @now_day = Date.today
  end

  def create_params
    @years = []
    # 去年までを設定できるように設定
    old_year = @now_day.strftime("%Y").to_i - 1
    for num in 0..5 do
      @years << old_year + num
    end

    @months = []
    for num in 1..12 do
      @months << "%#02d" %  num
    end

    @days = []
    # 設定年月によって自動で月の日数が変更するように設定
    day_end_month = Time.current.end_of_month.strftime("%d")
    num = 1
    while num <= day_end_month.to_i
      @days << "%#02d" %  num
      num += 1
    end

    # 時間設定用
    @hours = []
    for num in 0..23 do
      @hours << "%#02d" %  num
    end
    @minutes = []
    for num in 0 ..59 do
      @minutes << "%#02d" %  num
    end
  end


  def param_times_set
    @start_time_to_time = Time.parse("#{params[:go_hour]}:#{params[:go_minute]}")
    @end_time_to_time   = Time.parse("#{params[:ret_hour]}:#{params[:ret_minute]}")
  end
end
