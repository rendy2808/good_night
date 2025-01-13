class ClockIn < ApplicationRecord
  # Associations
  belongs_to :user, class_name: 'User'

  # Validations
  validates :user_id, presence: true
  validates :clock_in_type, presence: true

  enum clock_in_type: { good_night: 0, wake_up: 1 }
end
