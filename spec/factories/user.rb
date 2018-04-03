FactoryBot.define do
  factory :user do
    username "JohnDoe"
    email "johndoe@test.com"
    provider "github"
    password SecureRandom.hex
    name "John Doe"
    uid "234325"
  end

  factory :admin, class: User do
    username "Admin"
    email "admin@admin.net"
    provider "github"
    password SecureRandom.hex
    name "Admin Bob"
    uid "234342"
  end

  factory :john, class: TechnicalCoach do
    name "John D"
    slug "john-d"
  end
end