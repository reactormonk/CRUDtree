module CRUDtree
  class Trunk

    # klass may be needed for the compiler. We never know :-).
    def initialize(klass)
      @klass = klass
      @stems = []
    end

    attr_reader :stems, :klass
    attr_accessor :compiler

    def add_stem(params, &block)
      @stems << stem = Stem.new(params, &block)
      compiler.call(@klass, stem)
    end
  end
end
