require 'rails_helper'

RSpec.describe GramsController, type: :controller do
  describe "grams#index action" do
    it "should successfully show the page" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end
  
  describe "grams#new action" do
    it "shoud require users to be logged in" do
      get :new
      expect(response).to redirect_to new_user_session_path
    end
    
    it "should sucessfully show the new form if the user is signed in" do
      user = FactoryGirl.create(:user)
      sign_in user
      
      get :new
      expect(response).to have_http_status(:success)
    end
    
  end
  
  describe "grams#create action" do
    it "should require users to be logged in" do
      post :create, gram: {message: 'Sup'}
      expect(response).to redirect_to new_user_session_path
    end
    
    
    it "should successfully create a new post in the db if the user is signed in" do
      user = FactoryGirl.create(:user)
      sign_in user
      
      post :create, gram: {message: 'sup!'}
      expect(response).to redirect_to root_path
      
      gram = Gram.last
      expect(gram.message).to eq('sup!')
      expect(gram.user).to eq(user)
    end
    
    it "should properly handle the case when the post has an empty message" do
      user = FactoryGirl.create(:user)
      sign_in user
      
      post :create, gram: {message: ''}
      expect(response).to have_http_status(:unprocessable_entity)
      expect(Gram.count).to eq 0
    end
    
    
  end
end
