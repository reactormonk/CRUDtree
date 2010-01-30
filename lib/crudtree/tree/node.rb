module CRUDtree
  class Node
    # The params Hash takes the following keys:
    #
    # :klass
    # The object where to send the method that is returned by the router.
    # Mostly a class, therefore it's called 'class_name'. Defaults to nil,
    # but the interface may complain. You have been warned ;).
    # May be used by the interface as needed (Rango wants Class.send
    # :dispatcher, :send_method)
    #
    # :identifier
    # The identifier used to identify a resource, aka /user/:name instead of
    # /user/:id (default).
    #
    # :default_collection
    # The collection that is called when nothing is given. Defaults to :index.
    #
    # :default_member
    # The member which is chosen when no method is given. Defaults to :show.
    #
    # :paths
    # Specify the path(s) you want to call this resource with.
    # Defaults to klass.to_s.downcase
    # The first one is used for generation.
    #
    # Options used for generating
    #
    # :model
    # The name of the model. Needed. We don't do magic here.
    #
    # :parent_call
    # The method to call on the model object to get its parent (for nested
    # resources). Defaults to :model.downcase of the parent.
    #
    # :name
    # Symbol used to identify the node when generating a collection route.
    # Defaults to Klass.to_s.downcase.to_sym
    #
    def initialize(parent, params, &block)
      @klass = params[:klass]
      @identifier = params[:identifier] || :id
      @default_collection = params[:default_collection] || :index
      @default_member = params[:default_member] || :show
      @paths = if params[:paths]
                 [params[:paths]].flatten
               elsif params[:klass]
                 [params[:klass].to_s.downcase.split("::").last]
               else
                raise ArgumentError, "No paths given"
               end
      @subnodes = []
      @parent = parent
      # default routes
      @subnodes.unshift(EndNode.new(self, type: :member, call: :show, path: "", rest: :get))
      @subnodes.unshift(EndNode.new(self, type: :collection, call: :index, path: "", rest: :get))
      # generating
      unless @model = params[:model]
        raise(ArgumentError, "No model given.")
      end
      @parent_call =  if params[:parent_call]
                        params[:parent_call]
                      elsif ! parent_is_master?
                        parent.model.to_s.split('::').last.downcase
                      else
                        nil
                      end
      @name = params[:name] || klass.to_s.downcase.to_sym
      block ? instance_eval(&block) : raise(ArgumentError, "No block given.")
    end

    attr_reader :klass, :identifier, :default_collection, :default_member, :paths, :parent, :subnodes, :model, :parent_call, :name

    # Creates a new End and attaches it to this Node.
    def endnode(params)
      @subnodes << EndNode.new(self, params)
    end

    # Creates a new endnode with type member. See Endnode.
    def member(params)
      endnode(params.merge({type: :member}))
    end

    # Creates a new endnode with type collection. See EndNode.
    def collection(params)
      endnode(params.merge({type: :collection}))
    end

    def node(params, &block)
      @subnodes << Node.new(self, params, &block)
    end

    def parents
      [find_parent(self)].flatten[0..-2]
    end

    def nodes
      subnodes.select{|subnode| subnode.is_a? Node}
    end

    def endnodes
      subnodes.select{|subnode| subnode.is_a? EndNode}
    end

    def parent_is_master?
      ! parent.respond_to? :parent
    end

    # Duck typing used for generation
    def path
      @paths.first
    end

    def subs
      endnodes
    end

    def collection?
      false
    end

    private
    def find_parent(node)
      if node.parent.respond_to? :parent
        [node.parent, find_parent(node.parent)]
      end
    end
  end
end
