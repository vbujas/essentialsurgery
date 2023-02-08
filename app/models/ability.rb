class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.admin?
      can :manage, :all
    end
    if user.doctor?
      can :manage, Doctor, user_id: user.id
    end
  end
end
