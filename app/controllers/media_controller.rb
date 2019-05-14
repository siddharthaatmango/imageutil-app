class MediaController < ApplicationController
  before_action :authenticate_user!
  def index
    @show_file_tree = true
    # respond_to do |format|
    #   format.html
    # end
  end
end
