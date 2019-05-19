class AnalyticsController < ApplicationController
  before_action :authenticate_user!
  def index
    t1 = Time.now.beginning_of_month
    t2 = Time.now+1.day
    days_in_month = Date.new(t1.year, t1.month, t1.day).upto(Date.new(t2.year, t2.month, t2.day))
    analytics = current_user.is_support? ? Analytic.where(created_at: t1..t2).group_by{|a| a.created_at.strftime("%Y-%m-%d")} : Analytic.where(created_at: t1..t2, user_id: current_user.id).group_by{|a| a.created_at.strftime("%Y-%m-%d")}
    
    @totalUsageData = {}
    @uniqUsageData = {}
    @totalBytesUsageData = {}
    days_in_month.each do |a|
      if analytics[a.to_s]
      @uniqUsageData["#{a.strftime("%b %d")}"] = analytics[a.to_s].sum(&:uniq_request)
      @totalUsageData["#{a.strftime("%b %d")}"] = analytics[a.to_s].sum(&:total_request)
      @totalBytesUsageData["#{a.strftime("%b %d")}"] =   analytics[a.to_s].collect{|a| a.total_bytes * a.total_request}.sum 
      else
        @uniqUsageData["#{a.strftime("%b %d")}"] = 0
        @totalUsageData["#{a.strftime("%b %d")}"] = 0
        @totalBytesUsageData["#{a.strftime("%b %d")}"] = 0
      end
    end
    @total_limit = @totalUsageData.values.sum
    @max_limit = @totalUsageData.values.max
    @min_limit = @totalUsageData.values.min
    @max_limit = @max_limit > 10 ? @max_limit : 10
    @min_limit = @min_limit > 0 ? @min_limit : 1

    @total_bytes = @totalBytesUsageData.values.sum
    @max_bytes_limit = User::BANDWIDTH[current_user.plan] * 1024 * 1024 * 1024

    @images = current_user.is_support? ? Image.last(4) : Image.where(user_id: current_user.id).last(4)

    @total_space_size_image = current_user.is_support? ? Image.sum(&:file_size) : Image.where(user_id: current_user.id).sum(&:file_size)

    @total_space_size_folder = current_user.is_support? ? Folder.sum(&:file_size) : Folder.where(user_id: current_user.id).sum(&:file_size)
    
    @total_space_size = @total_space_size_image + @total_space_size_folder

    @total_count_folder = current_user.is_support? ? Folder.where(is_file: true).count : Folder.where(user_id: current_user.id, is_file: true).count
  end
end
