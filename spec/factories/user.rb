require 'faker'

FactoryBot.define do
  factory :user do
    email { 'user@example.com' }
    password { 'password' }
    role { :author }

    trait :guest do
      role { :guest }
    end
  end
end
