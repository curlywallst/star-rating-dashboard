require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user){FactoryBot.create(:user)}
  let(:john){FactoryBot.create(:john)}
  describe 'Validations' do
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

		it 'can\'t be created without an uid' do
			user = User.create(username: "Bob", password: SecureRandom.hex)
			expect(user).to_not be_valid
		end
		
		
		it 'can\'t be created without a provider' do
			user = User.create(username: "Bob", password: SecureRandom.hex, uid: "testtest")
			expect(user).to_not be_valid
		end
		
		it 'can\'t be created without a name' do
			user = User.create(username: "Bob", password: SecureRandom.hex, uid: "testtest", provider: "Github")
			expect(user).to_not be_valid
		end

		it 'must have an unique uid' do
			user = User.create(username: "Bob", password: SecureRandom.hex, uid: "testtest", provider: "Github", name: "Bob B")
			user2 = User.create(username: "Bob", password: SecureRandom.hex, uid: "testtest", provider: "Github", name: "Bob R")

			expect(user2).to_not be_valid
		end

		it 'must have an unique name' do
			user = User.create(username: "Bob", password: SecureRandom.hex, uid: "testtest", provider: "Github", name: "Bob B")
			user2 = User.create(username: "Bob", password: SecureRandom.hex, uid: "testtest2", provider: "Github", name: "Bob B")

			expect(user2).to_not be_valid
		end

		it 'must have an unique username' do
			user = User.create(username: "Bob", password: SecureRandom.hex, uid: "testtest", provider: "Github", name: "Bob B")
			user2 = User.create(username: "Bob", password: SecureRandom.hex, uid: "testtest2", provider: "Github", name: "Bob R")
			expect(user2).to_not be_valid
		end

		it 'can create a valid account' do
			expect(user).to be_valid
		end
	end

	describe 'roles' do
		it '#is_admin? without admin, returns false' do
			expect(user.is_admin?).to eq(false)
		end

		it '#is_admin? with admin, returns true' do
			admin = Admin.create
			user.roles.create(admin: admin)
			expect(user.is_admin?).to eq(true)
		end
		
		it '#add_admin_role, adds admin role to user' do
			user.add_admin_role
			expect(user.is_admin?).to eq(true)
		end

		it '#add_technical_coach_role, adds admin role to user' do
			user.add_technical_coach_role(john.id)
			expect(user.is_technical_coach?).to eq(true)
		end

		it '#destroy_admin_role, deletes admin role from database and removes role from user' do
			admin = Admin.create
			role = user.roles.create(admin: admin)
			user.destroy_admin_role
			expect(user.is_admin?).to eq(false)
			expect(Role.find_by_id(role.id)).to eq(nil)
			expect(Admin.find_by_id(admin.id)).to eq(nil)
		end

		it "#destroy_technical_coach_role, removes technical coach role" do
			user.add_technical_coach_role(john.id)
			expect(user.is_technical_coach?).to be(true)
			user.destroy_technical_coach_role
			expect(user.is_technical_coach?).to be(false)
		end

		it '#list_roles, returns a string of roles' do
			user.add_admin_role
			expect(user.list_roles).to eq("Admin")
		end
	end
end