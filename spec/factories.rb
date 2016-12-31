FactoryGirl.define do
  factory :user do
    # Validations prevent two users from having the same email. 
    # The sequence will ensure that if we build multiple users they 
    # won't have the same email address
    sequence :email do |n|
      "dummy#{n}@gmail.com"
    end
    password "welcome"
    password_confirmation "welcome"
  end
  
  factory :gram do
    message "sup!"
    association :user
  end
end