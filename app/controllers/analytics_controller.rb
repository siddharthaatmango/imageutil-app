class AnalyticsController < ApplicationController
  before_action :authenticate_user!
  def index
    t1 = (Time.now - 30.days).beginning_of_day
    t2 = Time.now+1.day
    days_in_month = Date.new(t1.year, t1.month, t1.day).upto(Date.new(t2.year, t2.month, t2.day))
    analytics = current_user.is_support? ? Analytic.where(created_at: t1..t2).group_by{|a| a.created_at.strftime("%Y-%m-%d")} : Analytic.where(created_at: t1..t2, user_id: current_user.id).group_by{|a| a.created_at.strftime("%Y-%m-%d")}
    
    @totalUsageData = {}
    @uniqUsageData = {}
    days_in_month.each do |a|
      @uniqUsageData["#{a.strftime("%b %d")}"] = analytics[a.to_s] ? analytics[a.to_s].sum(&:uniq_request) : 0 #rand(100)
      @totalUsageData["#{a.strftime("%b %d")}"] = analytics[a.to_s] ? analytics[a.to_s].sum(&:total_request) : 0 #rand(100)
    end
    @max_limit = @totalUsageData.values.max
    @min_limit = @totalUsageData.values.min
    @max_limit = @max_limit > 10 ? @max_limit : 10
    @min_limit = @min_limit > 0 ? @min_limit : 1

    @images = current_user.is_support? ? Image.last(4) : Image.where(user_id: current_user.id).last(4)
  end
end
