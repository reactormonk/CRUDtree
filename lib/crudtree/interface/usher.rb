require_relative "../interface"
module CRUDtree
  module Interface
    module Usher
      # Integration part
      
      def master_params
        master.params
      end

      def master
        @master ||= Master.new
      end

      # Logic part

      def node(params, &block)
        node = master.node(params, &block)
        compile_node("", node)
      end

      private
      def compile_node(pre_path, node)
        paths = node.paths.map {|p| "#{pre_path}/#{p}"}
        paths.each do |path|
          node.subnodes.each do |subnode|
            compile_subnode(path, subnode)
          end
        end
      end

      def compile_subnode(pre_path, subnode)
        case subnode
        when EndNode
          compile_endnode(pre_path, subnode)
        when Node
          compile_node("#{pre_path}/:#{subnode.identifier}", subnode)
        end
      end

    end
  end
end
