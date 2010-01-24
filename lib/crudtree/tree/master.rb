module CRUDtree
  class Master

    # Use :rango => true if you're using rango
    def initialize(params = {})
      @nodes = []
      @params = {dispatcher: :dispatcher}.merge(params)
    end

    attr_reader :nodes
    attr_accessor :mapping, :params

    def node(params, &block)
      @nodes << new_node = Node.new(self, params, &block)
      new_node
    end
  end
end
