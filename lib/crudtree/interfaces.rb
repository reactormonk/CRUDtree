#require_relative 'interfaces/usher'

module CRUDtree
  module Interface
    InterfaceRegistry = {}

    def self.register(name, mod)
      InterfaceRegistry[name.to_sym] = mod
    end

    def self.for(name)
      InterfaceRegistry[name.to_sym].attach
    end
  end
end
