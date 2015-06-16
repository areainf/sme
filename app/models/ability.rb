class Ability
  include CanCan::Ability

  def initialize(user)
    if user.is_admin? || user.is_reception?
      can :manage, :all
      can :enter, Document
      cannot :update, TemporaryNote
      cannot :create, TemporaryNote
    # elsif user.is_reception?
    #   can :read, :all
    #   can :create, :all
    #   can :update, :all
    #   can :manage, Folder
    #   can :enter, Document
    #   can :enter, Document
    #   can :in_folder, Document
    #   cannot :update, TemporaryNote
    #   cannot :create, TemporaryNote
      # can :destroy, Item do |item|
      #   item.try(:user) == user
      # end
    elsif user.is_dependency?
      can :read, Entity
      can :update, User
      can :create, TemporaryNote
      can :show, Document do |document|
         has_persmission?(user, document)
      end
      can :index, TemporaryNote do |tmpnote|
        has_persmission?(user, tmpnote)
      end
      can :update, TemporaryNote do |tmpnote|
        has_persmission?(user, tmpnote)
      end
      can :destroy, TemporaryNote do |tmpnote|
        has_persmission?(user, tmpnote) &&
        tmpnote.document.blank?
      end
      # can :read, Item
    end
    false
  end

  def has_persmission?(user, document)
    # dependency.ancestors.collect(&:id)
    dep_ids = user.permission.dependencies_ids
    emp_ids = user.permission.employments_ids
    dep_is_all = dep_ids.include? 0
    emp_is_all = emp_ids.include? 0
    if dep_is_all && emp_is_all || document.try(:create_user) == user
      return true
    else
      entities = Entity.all
      entities = entities.where("dependency_id in (?)", dep_ids) unless dep_is_all
      entities = entities.where("employment_id in (?)", emp_ids) unless emp_is_all
      ids_entities_doc = document.senders.map{|s| s.entity.id} +
                    document.recipients.map{|s| s.entity.id}
      return  (ids_entities_doc & entities.map(&:id)).count > 0
    end
  end
end
