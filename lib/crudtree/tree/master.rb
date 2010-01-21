module CRUDtree
  class Master

    # Use :rango => true if you're using rango
    def initialize(params = {})
      @nodes = []
      @params = params
    end

    attr_reader :nodes, :params
    attr_accessor :mapping

    def node(params, &block)
      @nodes << new_node = Node.new(self, params, &block)
      new_node
    end
  end
end
