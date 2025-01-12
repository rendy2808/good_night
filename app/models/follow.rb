class Follow < ApplicationRecord
  # Associations
  belongs_to :user, class_name: 'User'
  belongs_to :followed_user, class_name: 'User'

  # Validations
  validates :user_id, presence: true
  validates :followed_user_id, presence: true
end
