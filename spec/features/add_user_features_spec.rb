require 'rails_helper'
include Warden::Test::Helpers
RSpec.describe "Add User Features", type: :feature do
  let(:user){FactoryBot.create(:user)}
  let(:admin){FactoryBot.create(:admin).tap{|user| user.add_admin_role}}
  let(:john){FactoryBot.create(:john)}

  describe 'Add User' do
    it 'admins can view search user page' do
      login_as(admin, scope: :user)
      visit "/"
      click_link "Add User"
      expect(page).to have_current_path(users_search_user_path)
    end

    it 'admins can search for other users' do
      login_as(admin, scope: :user)
      visit users_search_user_path
      fill_in "username", with: user.username
      click_button 'Search'
      expect(page).to have_current_path(add_user_path(user.username))
      expect(page).to have_content(user.name)
    end

    it 'admins can add other users to admin' do
      login_as(admin, scope: :user)
      visit add_user_path(user.username)
      check "user_is_admin"
      click_button "Update User"
      expect(page).to have_current_path(add_user_path(user.username))
      expect(page).to have_content(user.name)
      expect(user.is_admin?).to eq(true)
    end

    xit 'admins can add other users as Technical Coach' do
      login_as(admin, scope: :user)
      visit add_user_path(user.username)
      check "user_is_technical_coach"
      click_button "Update User"
      expect(page).to have_content(user.name)
      print page.body
      # TODO: Figure out how to fix the select for capybara
      select("1", from: "role_technical_coach_id")
      click_button "Update User"
      expect(user.roles.include?(john)).to eq(true)
    end
  end
end