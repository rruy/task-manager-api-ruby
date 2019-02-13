require 'rails_helper'

RSpec.describe 'User API', type: :request do
   let!(:user) { create(:user) }
   let(:user_id) { user.id }

   before { host! 'api.taskmanager.test' }

   describe 'GET /users/:id' do
     before do  
        headers = { 'Accept' => 'application/vnd.taskmanager.v1' } 
        get "/users/#{user_id}", {}, headers
     end

     context 'when the user exists' do
       it 'returns the users' do
         user_response = JSON.parse(response.body)   
         expect(user_response['id']).to eq(user_id)
       end

       it 'returns status 200' do
         expect(response).to have_http_status(200)
       end
     end

     context 'when the user does not exist' do
       let(:user_id) { 10000 }

       it 'returns status 404' do 
         expect(response).to have_http_status(404)
       end
     end

   end
    
   describe 'POST /users' do
      before do  
        headers = { 'Accept' => 'application/vnd.taskmanager.v1' } 
        post "/users/", params: {user: user_params }.to_json, headers: headers
      end
 
      context 'when the user params are valid' do
        let(:user_params) { attributes_for(:user) }

        it 'returns status code 201' do 
          expect(response).to have_http_status(201)
        end

        it 'returns json data for the created user' do 
          user_response = JSON.parse(response.body) 
          expect(user_response['email']).to eq(user_params[:email])
        end
      end
 
      context 'when the user does not exist' do
        
      end
 
    end
 

end