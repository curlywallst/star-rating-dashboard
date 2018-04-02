require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user){FactoryBot.create(:user)}

  describe 'User' do
    it 'is defined' do
      expect(user).to be_valid
    end

    it 'can\'t be created without username' do
      user = User.create
      expect(user).to_not be_valid
    end

    it 'can\'t be created without a password' do
      user = User.create(username: "Bob")
      expect(user).to_not be_valid
    end
  end
end