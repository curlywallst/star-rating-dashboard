require 'rails_helper'

RSpec.describe Role, type: :model do
  let(:user){FactoryBot.create(:user)}
  describe 'Role' do
    it 'is defined' do
      expect(Role.new).to be_valid
    end

    it 'can be created on a user' do
      expect(user.roles.build).to be_valid
    end
  end
end
