class FalseClass
  def to_bool
    return self
    raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
  end
end