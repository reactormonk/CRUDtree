class Model0
end
class Model1
end
class Model2
  def model0
    Model0.new
  end
end
class Klass0
end
class Klass1
end
class Klass2
end

class Mod0
end
class Mod1
  def mod0
    Mod0.new
  end
end
class Mod2
  def initialize(parent = Mod0)
    instance_variable_set("@#{parent.to_s.downcase}", parent.new)
  end
  attr_accessor :mod0, :mod1, :mod2
end
