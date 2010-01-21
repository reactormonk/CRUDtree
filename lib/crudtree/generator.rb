module CRUDtree
  class Generator
    def initialize(master)
      @master = master
      @model_to_node = {}
      @master.nodes.each {|node| add_node_models(node) }
    end

    def generate(resource, call = nil)
      route = compile_route_from_node(find_node(resource))
      # TODO now subnode
    end

    private
    def find_node(resource)
      case nodes = @model_to_node[resource.class]
      when Node
        nodes
      when Array
        valid_nodes = nodes.select {|node| valid_model_for_node?(resource, node)}
        parents = valid_nodes.map(&:parents).flatten
        valid_nodes.reject!{|node| parents.include?(node)}
        case valid_nodes.size
        when (2..1/0.0)
          raise(NoUniqueNode, "No unique node found for #{resource}.")
        when 0
          raise(NoNode, "No node found for #{resource}.") if valid_nodes.size == 1
        else
          valid_nodes.first
        end
      end
    end

    def add_node_models(node)
      @model_to_node[node.model] = if target_node = @model_to_node[node.model]
                                     ([target_node] << node).flatten
                                   else
                                     node
                                   end
      node.nodes.each { |subnode|
        add_node_models(subnode)
      }
    end

    def compile_route_from_node(node)
      (node.parents.reverse + [node]).map {|parent|
        "/#{parent.paths.first}/:#{parent.identifier}"
      }.join
    end

    def valid_model_for_node?(model, node)
      return false unless node.model == model.class
      unless node.parent_is_master?
        valid_model_for_node?(model.send(node.parent_call), node.parent)
      else
        true
      end
    end
  end

  class NoUniqueNode < StandardError; end
  class NoNode < StandardError; end
end
