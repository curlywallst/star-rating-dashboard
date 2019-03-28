class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, authentication_keys: [:username]
  devise :registerable, :recoverable, :rememberable, :trackable
  devise :omniauthable, omniauth_providers: %i[github]

  has_many :roles
  validates :username, presence: true, uniqueness: true
  validates :uid, presence: true, uniqueness: true
  validates :provider, presence: true
  validates :name, presence: true, uniqueness: true

  def email_required?
    false
  end

  def email_changed?
    false
  end

  def is_admin?
    roles.any?{|role| role.admin}
    true
  end

  def is_technical_coach?
    roles.any?{|role| role.technical_coach}
  end

  def add_admin_role
    roles.create(admin: Admin.create)
  end

  def add_technical_coach_role(id)
    roles.create(technical_coach: TechnicalCoach.find_by_id(id))
  end

  def destroy_technical_coach_role
    roles.each{|role| role.destroy if role.technical_coach}
    update(roles: roles.select{|role| !role.technical_coach})
  end

  def destroy_admin_role
    roles.each{|role| role.admin.destroy if role.admin}
    roles.each{|role| role.destroy if role.admin}
    update(roles: roles.select{|role| !role.admin})
  end

  def list_roles
    roles.collect do |role|
      if role.admin
        "Admin"
      elsif role.technical_coach
        "Technical Coach"
      end
    end.join(", ")
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.username = auth.info.nickname
      user.name = auth.info.name
      user.email = auth.info.email if auth.info.email
      user.password = Devise.friendly_token[0,20]
    end
  end
end
