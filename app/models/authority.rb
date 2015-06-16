class Authority
  # attr_accessor :entity
  def self.all
    Entity.where("dependency_id is not NULL and employment_id is not NULL").group(:dependency_id, :employment_id)
  end
end
