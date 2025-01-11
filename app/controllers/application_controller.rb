class ApplicationController < ActionController::API
  before_action :validate_api_key

  private

  def validate_api_key
    api_key = request.headers['X-API-KEY']
    valid_key = 'key-12345' # Or ENV['API_KEY'], for technical test purpose

    render json: { error: 'Unauthorized' }, status: :unauthorized unless api_key == valid_key
  end
end
