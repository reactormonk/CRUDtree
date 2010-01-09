module CRUDtree
  class Trunk

    def initialize
      @stems = []
    end

    attr_reader :stems, :klass
    attr_accessor :compiler

    def add_stem(params, &block)
      @stems << Stem.new(params, &block)
    end
  end
end
