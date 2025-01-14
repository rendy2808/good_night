require 'rails_helper'

RSpec.describe 'Clock In API', type: :request do
  let!(:users) { create_list(:user, 3) }
  let(:user_id) { users.first.id }

  let(:headers) do
    {
      'x-api-key' => 'key-12345'
    }
  end

  let(:attributes) { { user_id: user_id, clock_in_type: clock_in_type } }

  describe 'POST /clock_in' do
    let(:subject) do
      post '/api/v1/clock_in', headers: headers, params: attributes
    end

    context 'when failed clock in' do
      context 'when without headers' do
        let(:headers) {}
        let(:attributes) { { user_id: user_id, clock_in_type: clock_in_type } }
        let(:clock_in_type) { 'good_night' }

        it 'response unauthorized' do
          subject

          expect(response).to have_http_status(401)
        end
      end

      context 'when using wrong attribute' do
        context 'when user_id' do
          let(:clock_in_type) { 'good_night' }
          let(:user_id) { 99999999999 }

          it 'response unprocessable' do
            subject
  
            expect(response).to have_http_status(422)
          end
        end

        context 'when clock_in_type' do
          let(:clock_in_type) { 'sleep' }

          it 'response unprocessable' do
            subject
  
            expect(response).to have_http_status(422)
          end
        end
      end

      context 'when clock in type is good_night without wake_up' do
        let!(:good_night_clock_in) { create(:clock_in, user_id: user_id, clock_in_type: 'good_night') }
        let(:clock_in_type) { 'good_night' }

        it 'response unprocessable' do
          subject

          expected_response = { "errors"=>"Please clock in with type: wake_up before proceed" }

          expect(response).to have_http_status(422)
          expect(JSON.parse(response.body)).to eq(expected_response)
        end 
      end

      context 'when clock in type is wake_up without good_night' do
        let!(:wake_up_clock_in) { create(:clock_in, user_id: user_id, clock_in_type: 'wake_up') }
        let(:clock_in_type) { 'wake_up' }

        it 'response unprocessable' do
          subject

          expected_response = { "errors"=>"Please clock in with type: good_night before proceed" }

          expect(response).to have_http_status(422)
          expect(JSON.parse(response.body)).to eq(expected_response)
        end
      end
    end

    context 'when success clock in' do
      context 'when clock in type is good_night' do
        let(:clock_in_type) { 'good_night' }

        it 'successfully clock in' do
          subject

          clock_in = ClockIn.last
          expected_response = [
            {
              'created_at' => clock_in.created_at.strftime("%Y-%m-%dT%H:%M:%S.%LZ"),
              'clock_in_type' => clock_in_type,
              'id' => clock_in.id,
              'updated_at' => clock_in.updated_at.strftime("%Y-%m-%dT%H:%M:%S.%LZ"),
              'user_id' => user_id
            }
          ]

          expect(response).to have_http_status(201)
          expect(JSON.parse(response.body)).to eq expected_response
        end
      end

      context 'when clock in type is wake_up ' do
        let(:clock_in_type) { 'wake_up' }
        let!(:good_night_clock_in) { create(:clock_in, user_id: user_id, clock_in_type: 'good_night') }

        it 'successfully clock in' do
          subject

          clock_in_first = ClockIn.first
          clock_in_last = ClockIn.last
          expected_response = [
            {
              'created_at' => clock_in_last.created_at.strftime("%Y-%m-%dT%H:%M:%S.%LZ"),
              'clock_in_type' => clock_in_type,
              'id' => clock_in_last.id,
              'updated_at' => clock_in_last.updated_at.strftime("%Y-%m-%dT%H:%M:%S.%LZ"),
              'user_id' => user_id
            },
            {
              'created_at' => clock_in_first.created_at.strftime("%Y-%m-%dT%H:%M:%S.%LZ"),
              'clock_in_type' => 'good_night',
              'id' => clock_in_first.id,
              'updated_at' => clock_in_first.updated_at.strftime("%Y-%m-%dT%H:%M:%S.%LZ"),
              'user_id' => user_id
            }
          ]

          expect(response).to have_http_status(201)
          expect(JSON.parse(response.body)).to eq expected_response
        end
      end
    end
  end

  describe 'GET /clock_in/following_record' do
    let(:subject) do
      get "/api/v1/clock_in/following_record?user_id=#{user_id}", headers: headers
    end

    let!(:clock_in1) { create(:clock_in, user_id: users[1].id, clock_in_type: 'good_night') }
    let!(:clock_in2) { create(:clock_in, user_id: users[1].id, clock_in_type: 'wake_up') }
    let!(:clock_in3) { create(:clock_in, user_id: users[1].id, clock_in_type: 'good_night') }
    let!(:clock_in4) { create(:clock_in, user_id: users[1].id, clock_in_type: 'wake_up') }
    let!(:clock_in5) { create(:clock_in, user_id: users[2].id, clock_in_type: 'good_night') }
    let!(:clock_in6) { create(:clock_in, user_id: users[2].id, clock_in_type: 'wake_up') }
    let!(:clock_in7) { create(:clock_in, user_id: users[2].id, clock_in_type: 'good_night') }
    let!(:clock_in8) { create(:clock_in, user_id: users[2].id, clock_in_type: 'wake_up') }

    before do
      create(:follow, user_id: user_id, followed_user_id: users[1].id)
      create(:follow, user_id: user_id, followed_user_id: users[2].id)
    end

    context 'when successfuly retrieve data' do
      it 'success' do
        subject

        expected_response = [
          { "#{users[1].name}" => clock_in2.created_at - clock_in1.created_at },
          { "#{users[1].name}" => clock_in4.created_at - clock_in3.created_at },
          { "#{users[2].name}" => clock_in6.created_at - clock_in5.created_at },
          { "#{users[2].name}" => clock_in8.created_at - clock_in7.created_at },
        ].sort_by { |hash| hash.values.first }

        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)).to eq expected_response
      end
    end

    context 'when user_id not found' do
      let(:subject) do
        get "/api/v1/clock_in/following_record?user_id=999", headers: headers
      end

      it 'response empty array' do
        subject

        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)).to eq []
      end
    end
  end
end
