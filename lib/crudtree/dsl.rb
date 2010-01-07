module CRUDtree
  module DSL
    def self.included(mod)
      @_trunk = Trunk.new(self)
    end

    def resource(params, &block)
      @_trunk.add_stem(params, &block)
    end
  end
end
