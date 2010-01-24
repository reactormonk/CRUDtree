module CRUDtree
  class Generator
    def initialize(master)
      @master = master
      @model_to_node = {}
      @master.nodes.each {|node| add_node_models(node) }
    end

    def generate(resource, *names)
      if resource.is_a? Symbol
        names << resource
        node = @master
        url = ""
      else
        node = find_node(resource)
        url = generate_url_from_node(node)
      end
      url << generate_from_sub(node, names) unless names.empty?
      url
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

    def generate_url_from_node(node)
      (node.parents.reverse + [node]).map {|parent|
        "/#{parent.path}/:#{parent.identifier}"
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

    def generate_from_sub(node, names)
      name = names.shift
      sub = node.subs.find{|sub| sub.name == name} or raise(ArgumentError, "No subnode found on #{node} with name of #{name}.")
      url = "/#{sub.path}"
      url << generate_from_sub(sub, names) unless names.empty?
      url
    end
  end

  class NoUniqueNode < StandardError; end
  class NoNode < StandardError; end
end
