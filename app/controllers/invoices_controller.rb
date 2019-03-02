class InvoicesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_invoice, only: [:show]

  # GET /invoices
  # GET /invoices.json
  def index
    @invoices = Invoice.where(user_id: current_user.id).all
  end

  # GET /invoices/1
  # GET /invoices/1.json
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invoice
      @invoice = Invoice.where(user_id: current_user.id, id: params[:id]).first
    end

end
