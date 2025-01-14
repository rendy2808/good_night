require 'rails_helper'

RSpec.describe 'Clock In API', type: :request do
  let!(:users) { create_list(:user, 2) }
  let(:user1_id) { users.first.id }
  let(:user2_id) { users.last.id }

  let(:headers) do
    {
      'x-api-key' => 'key-12345'
    }
  end

  let(:attributes) { { user_id: user1_id, follow_id: user2_id } }

  describe 'POST /follow' do
    let(:subject) do
      post '/api/v1/follow', headers: headers, params: attributes
    end

    context 'when fail to follow another user' do
      context 'when user_id not found' do
        let(:user1_id) { 9999999999 }

        it 'response unprocessable' do
          subject

          expect(response).to have_http_status(422)
          expect(JSON.parse(response.body)['errors']).to eq 'Validation failed: User must exist'
        end
      end

      context 'when follow_id(user) not found' do
        let(:user2_id) { 9999999999 }

        it 'response unprocessable' do
          subject

          expect(response).to have_http_status(422)
          expect(JSON.parse(response.body)['errors']).to eq 'Validation failed: Followed user must exist'
        end
      end

      context 'when user followed the taget user' do
        before { create(:follow, user_id: user1_id, followed_user_id: user2_id) }
        it 'response unprocessable' do
          subject

          expect(response).to have_http_status(422)
          expect(JSON.parse(response.body)['errors']).to eq 'The target user is followed'
        end
      end
    end

    context 'when successfully follow another user' do
      it 'response success' do
        subject

        expect(response).to have_http_status(201)
      end
    end
  end

  describe 'POST follow/unfollow' do
    let(:subject) do
      post '/api/v1/follow/unfollow', headers: headers, params: attributes
    end

    context 'when fail to unfollow another user' do
      context 'when user unfollowing the taget user but not following' do
        it 'response unprocessable' do
          subject

          expect(response).to have_http_status(422)
          expect(JSON.parse(response.body)['errors']).to eq 'The target user is not followed'
        end
      end
    end

    context 'when successfully unfollow another user' do
      before { create(:follow, user_id: user1_id, followed_user_id: user2_id) }
      it 'response success' do
        subject

        expect(response).to have_http_status(200)
      end
    end
  end
end
