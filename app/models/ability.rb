class Ability
    include CanCan::Ability
  
    def initialize(user)
      user ||= User.new
  
      if user.hr_manager?
        can :manage, :all
      else
        can :read, Employee, user_id: user.id
        can :read, Task, employee: { user_id: user.id }
        can :update, Task, employee: { user_id: user.id }
      end
    end
end
