require_relative "../interface"
module CRUDtree
  module Interface
    module Usher
      # Integration part
      
      def trunk_params
        trunk.params
      end

      def trunk
        @trunk ||= Trunk.new
      end

      # Logic part

      def stem(params, &block)
        stem = trunk.stem(params, &block)
        compile_stem("", stem)
      end

      private
      def compile_stem(pre_path, stem)
        paths = stem.paths.map {|p| "#{pre_path}/#{p}"}
        paths.each do |path|
          stem.leafs.each do |leaf|
            compile_branch(path, leaf)
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
