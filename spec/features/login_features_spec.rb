require 'rails_helper'
include Warden::Test::Helpers
RSpec.describe "User Features", type: :feature do

  let(:user){FactoryBot.create(:user)}

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
  end
end