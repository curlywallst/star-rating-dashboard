FactoryBot.define do
  factory :user do
    username "JohnDoe"
    email "johndoe@test.com"
    provider "Github"
    password SecureRandom.hex
    name "John Doe"
    uid "234325"
  end
end