class Project < ApplicationRecord
  belongs_to :user
  has_many :images

  validates :name, presence: true
  validates :uuid, presence: true
  validates :fqdn, presence: true

  validates :name, uniqueness: { case_sensitive: false, scope: :user_id,
    message: "is already created" }
  validates :fqdn, uniqueness: { case_sensitive: false }

  has_one :current_image, -> { order created_at: :desc }, class_name: 'Image', foreign_key: :project_id


  HUMANIZED_ATTRIBUTES = {
    :fqdn => "Base URL"
  }

  def self.human_attribute_name(attr, options = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
end
