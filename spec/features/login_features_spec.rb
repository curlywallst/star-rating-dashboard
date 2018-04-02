require 'rails_helper'
include Warden::Test::Helpers
RSpec.describe "User Features", type: :feature do

  let(:user){FactoryBot.create(:user)}
  let(:admin){FactoryBot.create(:admin).tap{|user| user.add_admin_role}}

  describe 'Login' do
    it 'can log in' do
      login_as(user, scope: :user)
      visit "/"
      expect(page).to have_content("Log Out")
      expect(page).to have_content("John Doe")
    end

    it 'can log out' do
      login_as(user, scope: :user)
      visit "/"
      click_link "Log Out"
      expect(page).to have_content("Log In")
    end

    it 'admins have access to admin dashboard' do
      login_as(admin, scope: :user)
      visit "/"
      expect(page).to have_content("Star Ratings")
    end

    it 'non-admins do not have access to admin dashboard' do
      login_as(user, scope: :user)
      visit "/"
      expect(page).to_not have_content("Star Ratings")
    end

  end
end