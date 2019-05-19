class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :trackable, :omniauthable

  PLANS = ['FREE', 'PLUS', 'PRO'].freeze
  BANDWIDTH = [5, 50, 500].freeze

  validates :plan, presence: true, inclusion: { in: 0..(PLANS.length-1),
    message: "Plan is not valid" }

  # instead of deleting, indicate the user requested a delete & timestamp it  
  def soft_delete  
    update_attribute(:deleted_at, Time.current)  
  end  
  
  # ensure user account is active  
  def active_for_authentication?  
    super && !deleted_at  
  end  
  
  # provide a custom message for a deleted account   
  def inactive_message   
  	!deleted_at ? super : :deleted_account  
  end  

  def notices
    if self.is_support?
      messages = Message.where(support_call: true, message_id: nil).includes(:replies)
    else
      messages = Message.where(user_id: self.id, user_call: true, message_id: nil).includes(:replies)
    end
    messages
  end
end
