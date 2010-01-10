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
    # Defaults to call.to_s
    #
    # :rest
    # which REST method should match this route. Defaults to nil, aka all.
    #
    # :call
    # The method to be called if this route is matched. Required.
    #
    # :name
    # The name of this route, used for generating. Symbol.
    def initialize(params)
      @type = params[:type] if [:member, :collection].include? params[:type]
      raise ArgumentError, "Invalid type: #{params[:type]}" unless @type

      @call = params[:call] or raise ArgumentError, "No call given."

      @path = params[:path] || @call.to_s
      raise ArgumentError, "No path given." unless @path

      @rest = params[:rest]

      @name = params[:name] || @call
    end

    attr_reader :type, :path, :rest, :call, :name
  end
end
