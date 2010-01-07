module CRUDtree
  class Stem
    # The params Hash takes the following keys:
    #
    # :class_name
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
    # The collection that is called when nothing is given. Defaults to :index,.
    #
    # :default_member
    # The member which is chosen when no method is given. Defaults to :show.
    #
    # :paths
    # You may specify mutiple paths which generate the route. When generating,
    # the first one is being taken.
    #
    def intialize(params, &block)
      @class_name = params[:class_name] || nil
      @identifier = params[:identifier] || :id
      @default_collection = params[:default_collection] || :index
      @default_member = params[:default_member] || :show
      @paths = params[:paths] || ["/" + params[:class_name].to_s.downcase]
      raise ArgumentError, "No paths given" if @paths.empty?
      @leafs = []
      instance_eval(&block)
    end

    attr_reader :class_name, :identifier, :default_collection, :default_member, :paths

    # Creates a new Leaf and attaches it to this Stem.
    def leaf(params)
      @leafs << Leaf.new(params)
    end

    # Creates a new leaf with type member. See Leaf.
    def member(params)
      leaf(params.merge({type: :member}))
    end

    # Creates a new leaf with type collection. See Leaf.
    def collection(params)
      leaf(params.merge({type: :collection}))
    end

    def resource(params, &block)
      @leafs << Stem.new(params, &block)
    end
  end
end