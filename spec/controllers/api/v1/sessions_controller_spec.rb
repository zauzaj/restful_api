require 'rails_helper'

describe Api::V1::SessionsController do
  
	describe	"POST #create" do
		before(:each) do
		  @user = FactoryGirl.create :user
		end
		
		context 'when the credentials are correct' do
		  before(:each) do
		    credentials = { email: @user.email, password: "password" }
				post :create, { session: credentials }
		  end
			
			it 'returns the user record corresponding to the given credentials' do
				json_response = JSON.parse(response.body, symbolize_names: true)
			  @user.reload
				expect(json_response[:auth_token]).to eql @user.auth_token
			end
			it { should respond_with 200 }
		end
		
		context 'when the credentials are incorrect' do
		  before(:each) do
		    credentials = { email: @user.email, password: "invalidpassword" }
				post :create, { session: credentials }
		  end
			it 'returns a json with an error' do
				json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:errors]).to eql "Invalid email or password"
			end
			it { should respond_with 422 }
		end
	end
	describe 'DELETE #desrtoy' do
	  before(:each) do
	    @user = FactoryGirl.create :user
			sign_in @user, store: false
			delete :destroy
	  end
		it { should respond_with 204 }
	end
end