module CRUDtree
  class Leaf
    # The params Hash takes the following keys:
    #
    # :type
    # may either be member or collection
    #
    # :path
    # path to this leaf - you can use 
    # /join
    # or
    # /join/:date/:foo/:whatever
    # the interface will handle those parameters.
    #
    # :rest
    # which REST method should match this route. Defaults to nil, aka all.
    #
    # :call
    # The method to be called if this route is matched. Required.
    def initialize(params)
      @type = params[:type] if [:member, :collection].include? params[:type]
      raise ArgumentError, "Invalid type: #{params[:type]}" unless @type
      @path = params[:path] or raise ArgumentError, "No path given."
      @rest = params[:rest]
      @call = params[:call] or raise ArgumentError, "No call given."
    end

    attr_reader :type, :path, :rest, :call
  end
end
