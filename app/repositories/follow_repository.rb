class FollowRepository
  class << self
    def find_by_user_id_and_followed_user_id(user_id, following_id)
      Follow.find_by(user_id: user_id, followed_user_id: following_id)
    end

    def create(user_id, following_id)
      Follow.create!(user_id: user_id, followed_user_id: following_id)
    end

    def delete_by_user_id_and_followed_user_id(user_id, followed_id)
      Follow.find_by(
        user_id: user_id,
        followed_user_id: followed_id
      ).delete
    end
  end
end
