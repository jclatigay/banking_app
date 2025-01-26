class ActivityLog < ApplicationRecord
  belongs_to :user
  belongs_to :trackable, polymorphic: true, optional: true

  validates :action, presence: true
  validates :description, presence: true

  scope :recent, -> { order(created_at: :desc) }
end
