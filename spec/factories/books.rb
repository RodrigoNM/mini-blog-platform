require 'faker'

FactoryBot.define do
  factory :post do
    title { 'Sample Post Title' }
    body { 'This is the body of the post.' }
    association :user
  end
end
