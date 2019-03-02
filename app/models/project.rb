class Project < ApplicationRecord
  belongs_to :user
  has_many :images

  validates :name, presence: true
  validates :uuid, presence: true
  validates :fqdn, presence: true

  validates :name, uniqueness: { case_sensitive: false, scope: :user_id,
    message: "is already created" }
  validates :fqdn, uniqueness: { case_sensitive: false }

end
