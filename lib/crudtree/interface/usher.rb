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
        compile_stem(stem, "")
      end

      private
      def compile_stem(pre_path, stem)
        paths = stem.paths.map {|p| "#{pre_path}/#{stem.path}"}
        paths.each do |path|
          stem.leafs.each do |leaf|
              compile_branch(path, stem)
          end
        end
      end

      def compile_branch(pre_path, branch)
        case branch
        when Leaf
          compile_leaf(pre_path, branch)
        when Stem
          compile_stem(pre_path, branch)
        end
      end

    end
  end
end
