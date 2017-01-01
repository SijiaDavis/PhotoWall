require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe "comments#create action" do
    it "should require the user to be logged in" do
      gram = FactoryGirl.create(:gram)
      
      post :create, gram_id: gram.id, comment: {message: 'awesome post!'}
      expect(response).to redirect_to new_user_session_path
    end
    
    it "should allow user to create comments on posts" do
      gram = FactoryGirl.create(:gram)
      user = FactoryGirl.create(:user)
      sign_in user
      
      post :create, gram_id: gram.id, comment: {message: 'awesome post!'}
      expect(response).to redirect_to root_path
      expect(gram.comments.length).to eq 1
      expect(gram.comments.first.message).to eq "awesome post!"
    end
    
    it "should return a 404 status code if the post is not found" do
      user = FactoryGirl.create(:user)
      sign_in user
      
      post :create, gram_id: 'celia', comment: {message: 'awesome post!'}
      expect(response).to have_http_status(:not_found)
    end
  end
end
