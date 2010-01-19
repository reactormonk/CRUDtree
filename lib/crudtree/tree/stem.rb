module CRUDtree
  class Stem
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
      @leafs = []
      @parent = parent
      block ? instance_eval(&block) : raise(ArgumentError, "No block given.")
      # default routes
      @leafs.unshift(Leaf.new(self, type: :member, call: :show, path: "", rest: :get))
      @leafs.unshift(Leaf.new(self, type: :collection, call: :index, path: "", rest: :get))
      # generating
      unless @model = params[:model]
        raise(ArgumentError, "No model given.")
      end
      @parent_call =  if params[:parent_call]
                        params[:parent_call]
                      elsif parent.respond_to? :parent # see if it's not the trunk
                        parent.model.to_s.split('::').last
                      else
                        nil
                      end
    end

    attr_reader :klass, :identifier, :default_collection, :default_member, :paths, :parent, :leafs, :model, :parent_call

    # Creates a new Leaf and attaches it to this Stem.
    def branch(params)
      @leafs << Leaf.new(self, params)
    end

    # Creates a new leaf with type member. See Leaf.
    def member(params)
      branch(params.merge({type: :member}))
    end

    # Creates a new leaf with type collection. See Leaf.
    def collection(params)
      branch(params.merge({type: :collection}))
    end

    def stem(params, &block)
      @leafs << Stem.new(self, params, &block)
    end
  end
end
