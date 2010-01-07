#require_relative 'interfaces/usher'

module CRUDtree
  module Interface
    InterfaceRegistry = {}

    def self.register(name, block)
      InterfaceRegistry[name.to_sym] = block
    end

    def self.for(router)
      InterfaceRegistry[name.to_sym]
    end
  end
end
