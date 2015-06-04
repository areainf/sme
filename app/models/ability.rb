class Ability
  include CanCan::Ability

  def initialize(user)
    if user.is_admin?
      can :manage, :all
      can :enter, Document
      cannot :update, TemporaryNote
      cannot :create, TemporaryNote
    elsif user.is_reception?
      can :read, :all
      can :create, :all
      can :update, :all
      can :manage, Folder
      can :enter, Document
      can :enter, Document
      can :in_folder, Document
      cannot :update, TemporaryNote
      cannot :create, TemporaryNote
      # can :destroy, Item do |item|
      #   item.try(:user) == user
      # end
    elsif user.is_dependency?
      can :read, Entity
      can :update, User
      can :create, TemporaryNote
      can :show, Document do |tmpnote|
         tmpnote.try(:create_user) == user
      end
      can :index, TemporaryNote do |tmpnote|
         tmpnote.try(:create_user) == user
      end
      can :update, TemporaryNote do |tmpnote|
        tmpnote.try(:create_user) == user
      end
      can :destroy, TemporaryNote do |tmpnote|
        tmpnote.try(:create_user) == user &&
        tmpnote.document.blank?
      end
      # can :read, Item
    end
    false
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
