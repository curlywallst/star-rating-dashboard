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

    it 'can have an admin role' do
      admin = Admin.create
      user.roles.create(admin: admin)

      expect(user.roles.first.admin).to eq(admin)
    end
  end
end
