require 'rails_helper'

RSpec.describe TechnicalCoach, type: :model do
  let(:user){FactoryBot.create(:user)}
  let(:tc){TechnicalCoach.create(name: "John Doe", slug: "john-doe")}
  describe 'can be created' do
    it 'is defined' do
      expect(tc).to be_valid
    end

    it 'belongs to role' do
        role = user.roles.create(technical_coach: tc)
        expect(role.technical_coach).to eq(tc)
        expect(tc.role).to eq(role)
    end

    it 'must have a name' do
        tc = TechnicalCoach.create
        expect(tc).to_not be_valid
    end
  end
end