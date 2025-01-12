module Api
  module V1
    class FollowController < ApplicationController
      before_action :validate_following, only: [:create]
      before_action :validate_unfollowing, only: [:unfollow]

      # POST
      def create
        data = create_following_data      

        render json: data, status: :created if data.persisted?
      rescue => error
        render json: { errors: error }, status: :unprocessable_entity
      end

      # POST
      def unfollow
        data = remove_following_data

        render json: { message: 'Unfollow successfully' }, status: :ok if data
      rescue => error
        render json: { errors: error }, status: :unprocessable_entity
      end

      private

      def payload
        params.permit(:user_id, :follow_id)
      end

      def validate_following
        if followed?
          message = 'The target user is followed'

          render json: { errors: message }, status: :unprocessable_entity
        end
      end

      def validate_unfollowing
        unless followed?
          message = 'The target user is not followed'

          render json: { errors: message }, status: :unprocessable_entity
        end
      end

      def followed?
        post_params = payload

        ::FollowRepository.find_by_user_id_and_followed_user_id(post_params[:user_id], post_params[:follow_id])
      end

      def create_following_data
        post_params = payload

        ::FollowRepository.create(post_params[:user_id], post_params[:follow_id])
      end

      def remove_following_data
        post_params = payload

        ::FollowRepository.delete_by_user_id_and_followed_user_id(post_params[:user_id], post_params[:follow_id])
      end
    end
  end
end
