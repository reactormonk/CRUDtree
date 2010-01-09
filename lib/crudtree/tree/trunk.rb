module CRUDtree
  class Trunk

    # Use :rango => true if you're using rango
    def initialize(params = {})
      @stems = []
      @params = params
    end

    attr_reader :stems, :params

    def add_stem(params, &block)
      @stems << Stem.new(params, &block)
    end
  end
end
