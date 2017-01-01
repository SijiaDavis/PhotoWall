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
  
  describe "grams#show action" do
    it "should successfully show the post if it can be found" do
      gram = FactoryGirl.create(:gram)
      get :show, id: gram.id
      expect(response).to have_http_status(:success)
    end
    
    it "should return a 404 status code if the post is not found" do
      get :show, id: 'celia'
      expect(response).to have_http_status(:not_found)
    end
  end
  
  describe "grams#edit action" do
    it "should not let unauthenticated user edit posts" do
      gram = FactoryGirl.create(:gram)
      get :edit, id: gram.id 
      expect(response).to redirect_to new_user_session_path
    end
    
    it "should not let a user who didn't create this post edit it" do
      gram = FactoryGirl.create(:gram)
      user = FactoryGirl.create(:user)
      sign_in user
      get :edit, id: gram.id 
      expect(response).to have_http_status(:forbidden)
    end
    
    it "should sucessfully show the edit form if the post can be found" do
      gram = FactoryGirl.create(:gram)
      sign_in gram.user
      get :edit, id: gram.id
      expect(response).to have_http_status(:success)      
    end
    
    it "should return a 404 status code if the post is not found" do
      user = FactoryGirl.create(:user)
      sign_in user
      
      get :edit, id: 'celia'
      expect(response).to have_http_status(:not_found)
    end
  end
  
  describe "grams#update action" do
    it "should not let unauthenticated user update a post" do
      gram = FactoryGirl.create(:gram, message: "Initial Value")
      patch :update, id: gram.id, gram: {message: "Changed"}
      expect(response).to redirect_to new_user_session_path
    end
    
    it "should not let user who didn't create the post update it" do
      gram = FactoryGirl.create(:gram, message: "Initial Value")
      user = FactoryGirl.create(:user)
      sign_in user
      patch :update, id: gram.id, gram: {message: "Changed"}
      expect(response).to have_http_status(:forbidden)
    end
    
    it "should sucessfully update the post if the post can be found" do
      gram = FactoryGirl.create(:gram, message: "Initial Value")
      sign_in gram.user
      
      patch :update, id: gram.id, gram: {message: "Changed"}
      expect(response).to redirect_to root_path
      
      gram.reload
      expect(gram.message).to eq("Changed")
    end
    
    it "should return a 404 status code if the post is not found" do
      user = FactoryGirl.create(:user)
      sign_in user
      patch :update, id: "celia", gram: {message: "Changed"}
      expect(response).to have_http_status(:not_found)
    end
    
    it "should render the edit form with a http status of unprocessable_entity" do
      gram = FactoryGirl.create(:gram, message: "Initial Value")
      sign_in gram.user
      patch :update, id: gram.id, gram: {message: ""}
      expect(response).to have_http_status(:unprocessable_entity)
      gram.reload
      expect(gram.message).to eq("Initial Value")
    end
  end
  
  describe "grams#destroy action" do
    it "should not let unauthenticated user destroy a post" do
      gram = FactoryGirl.create(:gram)
      delete :destroy, id: gram.id 
      expect(response).to redirect_to new_user_session_path
    end
    
    it "should not let user who didn't create this post destroy it" do
      gram = FactoryGirl.create(:gram)
      user = FactoryGirl.create(:user)
      sign_in user
      
      delete :destroy, id: gram.id 
      expect(response).to have_http_status(:forbidden)
    end
    
    it "should successfully destroy the post if it can be found" do
      gram = FactoryGirl.create(:gram)
      sign_in gram.user
      delete :destroy, id: gram.id 
      expect(response).to redirect_to root_path
      gram = Gram.find_by_id(gram.id)
      expect(gram).to eq nil
    end
    
    it "should return a 404 status code if the post can not be found" do
      user = FactoryGirl.create(:user)
      sign_in user
      delete :destroy, id: "celia"
      expect(response).to have_http_status(:not_found) 
    end
  end
end
