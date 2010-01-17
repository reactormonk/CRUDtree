module CRUDtree
  class Trunk

    # Use :rango => true if you're using rango
    def initialize(params = {})
      @stems = []
      @params = params
    end

    attr_reader :stems, :params

    def stem(params, &block)
      @stems << new_stem = Stem.new(self, params, &block)
      new_stem
    end
  end
end
