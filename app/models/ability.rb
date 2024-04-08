class Ability
  include CanCan::Ability

  def initialize(user)
    if user.customer?
      can [:read, :update], User, id: user.id
      can [:read, :create, :update, :destroy], Booking, user_id: user.id, status: 'booked'
      can :read, Venue
    elsif user.admin?
      can :manage, :all
    end
  end
end
