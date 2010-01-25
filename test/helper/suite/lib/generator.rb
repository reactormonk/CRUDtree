class Model0
  def id
    0
  end
end
class Model1
end
class Model2
  def id
    2
  end
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
  def id
    0
  end
end
class Mod1
  def id
    1
  end
  def mod0
    Mod0.new
  end
end
class Mod2
  def id
    2
  end
  def initialize(parent = Mod0)
    instance_variable_set("@#{parent.to_s.downcase}", parent.new)
  end
  attr_accessor :mod0, :mod1, :mod2
end
