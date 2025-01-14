module Api
  module V1
    class ClockInController < ApplicationController
      before_action :validate_clock_in, only: [:create]

      TYPE_NEEDED = {
        good_night: 'wake_up',
        wake_up: 'good_night'
      }

      # POST
      def create
        data = clock_in      

        render json: clock_in_list(data.user_id), status: :created if data.persisted?
      rescue => error
        render json: { errors: error }, status: :unprocessable_entity
      end

      def following_record
        user_id = params[:user_id]

        result = ClockInUseCase::RecordBuilder.new(user_id).perform

        render json: result, status: :ok
      rescue => error
        render json: { errors: error }, status: :unprocessable_entity
      end

      private

      def payload
        params.permit(:user_id, :clock_in_type)
      end

      def validate_clock_in
        post_params = payload

        clock_in = ::ClockInRepository.where_user_id_last(post_params[:user_id])
        if clock_in&.clock_in_type != post_params[:clock_in_type] && clock_in.present?
          return
        elsif clock_in.blank? && post_params[:clock_in_type] == 'good_night'
          return
        elsif clock_in.blank? && post_params[:clock_in_type] == 'wake_up'
          message = 'Please clock in with type good_night first'
        else
          message = "Please clock in with type: #{TYPE_NEEDED[post_params[:clock_in_type].to_sym]} before proceed"
        end
        
        render json: { errors: message }, status: :unprocessable_entity
      end

      def clock_in
        post_params = payload

        ::ClockInRepository.create(post_params[:user_id], post_params[:clock_in_type])
      end

      def clock_in_list(user_id)
        ::ClockInRepository.where_user_id(user_id)
      end
    end
  end
end
