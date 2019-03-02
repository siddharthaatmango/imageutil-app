class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_message, only: [:show]

  # GET /messages
  # GET /messages.json
  def index
    @messages = current_user.is_support? ? Message.where(message_id: nil).order("support_call desc, updated_at desc").includes(:replies).all : Message.where(user_id: current_user.id, message_id: nil).order("user_call desc, updated_at desc").includes(:replies).all
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
    @reply = Message.new
    @reply.message_id = @message.id
    @reply.subject = "Reply to > #{@message.subject}"
  end

  # GET /messages/new
  def new
    @message = Message.new
  end

  # POST /messages
  # POST /messages.json
  def create
    msg = Message.new(message_params)
    msg.user_id = current_user.id
    msg.status = 'closed' if params[:close_tkt]
    respond_to do |format|
      if msg.save
        parent_msg = Message.where(id: msg.message_id).first if msg.message_id
        @message = parent_msg ? parent_msg : msg
        format.html { redirect_to @message, notice: 'Message was successfully created.' }
        format.json { render :show, status: :created, location: @message }
      else
        parent_msg = Message.where(id: msg.message_id).first if msg.message_id
        @message = parent_msg ? parent_msg : msg
        format.html { render :new }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = current_user.is_support? ? Message.where(id: params[:id]).first : Message.where(user_id: current_user.id, id: params[:id]).first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(:message_id, :subject, :body)
    end
end
