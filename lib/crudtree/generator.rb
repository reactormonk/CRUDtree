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
        node, identifiers = find_node(resource)
        url = generate_url_from_node(node, identifiers)
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
        valid_nodes = {}
        nodes.each do |node|
          identifiers = identifiers_to_node(resource, node)
          valid_nodes[node] = identifiers if identifiers
        end
        parents = valid_nodes.keys.map(&:parents).flatten
        valid_nodes.reject!{|node, identifiers| parents.include?(node)}
        case valid_nodes.size
        when 1
          valid_nodes.first
        when 0
          raise(NoNode, "No node found for #{resource}.")
        else
          raise(NoUniqueNode, "No unique node found for #{resource}.")
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

    def generate_url_from_node(node, identifiers)
      (node.parents.reverse + [node]).map {|parent|
        "/#{parent.path}/#{identifiers.shift}"
      }.join
    end

    # @return [Array] with [String] of identifiers or false if the model is invalid
    #         for this node
    def identifiers_to_node(model, node, identifiers = [])
      return false unless node.model == model.class
      identifiers << model.send(node.identifier).to_s
      unless node.parent_is_master?
        identifiers_to_node(model.send(node.parent_call), node.parent, identifiers) or return false
      end
      identifiers.reverse
    end

    def generate_from_sub(node, names)
      name = names.shift
      sub = node.subs.find{|sub| sub.name == name} or raise(ArgumentError, "No subnode found on #{node} with name of #{name}.")
      url = "/#{sub.path}"
      url << generate_from_sub(sub, names) unless names.empty?
      url
    end
  end

  class InvalidPath < StandardError; end
  class NoUniqueNode < StandardError; end
  class NoNode < StandardError; end
end
