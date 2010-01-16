module CRUDtree
  class Trunk

    # Use :rango => true if you're using rango
    def initialize(params = {})
      @stems = []
      @params = params
    end

    attr_reader :stems, :params

    def stem(params, &block)
      @stems << Stem.new(self, params, &block)
    end
  end
end
