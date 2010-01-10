require_relative "../interface"
module CRUDtree
  module Interface
    module Usher
      # Integration part
      
      def initialize(app = nil, params = {}, &block)
        @trunk = Trunk.new
        params.merge!(:allow_identical_variable_names => false)
        super(app, params, &block)
      end

      def trunk_params
        @trunk.params
      end

      # Logic part

      def stem(params, &block)
        stem = @trunk.add_stem(params, &block)
        compile_stem(stem, [""])
      end

      private
      def compile_stem(pre_paths, stem)
        # >> ["a", "b"].product(["c", "d"]).map(&:join)
        # => ["ac", "ad", "bc", "bd"]
        paths = pre_paths.product(stem.paths).map {|ary| ary.join("/")}
        stem.leafs.each do |leaf|
          compile_leaf(paths, stem, leaf)
        end
      end

      def compile_leaf(pre_paths, stem, leaf)
        case leaf
        when Leaf
          pre_paths.each do |p|
            p << "/:#{stem.identifier}" if leaf.type == :member
            compile_path(p, stem, leaf)
          end
        when Stem
          compile_stem(pre_paths, leaf)
        end
      end

    end
  end
end
