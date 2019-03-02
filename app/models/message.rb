class Message < ApplicationRecord
  belongs_to :user
  has_many :replies, :foreign_key => "message_id", :class_name => "Message"

  validates :subject, presence: true
  validates :body, presence: true
  validates :status, presence: true, inclusion: { in: %w(new w_support w_user closed),
    message: "%{value} is not a valid status" }

  before_validation :set_status
  after_create :set_parent_status, unless: Proc.new{ self.message_id.blank? }

  def last_user
    return self.user unless self.replies.exists?
    return self.replies.last.user

  end

  def last_message
    return self unless self.replies.exists?
    return self.replies.last
  end

  def status_name(for_support=false)
    if for_support
    n = {
      new: "New",
      w_support: "Waiting for your reply",
      w_user: "Waiting for user",
      closed: "Closed"
    }
    else
    n = {
      new: "New",
      w_support: "Waiting for support",
      w_user: "Waiting for your reply",
      closed: "Closed"
    }
    end
    n[self.status.to_sym]
  end
  def status_class(for_support=false)
    if for_support
      n = {
        new: "bg-light border-primary",
        w_support: "bg-light border-primary",
        w_user: "bg-light",
        closed: 'bg-light'
      }
    else
      n = {
        new: "bg-light border-primary",
        w_support: "bg-light",
        w_user: "bg-light border-primary",
        closed: 'bg-light'
      }
    end
    n[self.status.to_sym]
  end

  private
  def set_parent_status
    Message.where(id: self.message_id).first.update_columns(status: self.status, support_call: self.support_call, user_call: self.user_call, updated_at: Time.now)
  end
  def set_status
    if self.status == 'closed'
      self.support_call = false
      self.user_call = false
    elsif self.new_record? && self.message_id.blank?
      self.status = 'new'
      self.support_call = true
      self.user_call = false
    elsif self.user.is_support?
      self.status = 'w_user'
      self.support_call = false
      self.user_call = true
    else
      self.status = 'w_support'
      self.support_call = true
      self.user_call = false
    end
  end
end
