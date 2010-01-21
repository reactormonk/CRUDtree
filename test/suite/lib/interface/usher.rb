require 'crudtree/interface/usher'
require 'ostruct'

module CRUDtree::Interface::Usher
  public :compile_subnode, :compile_node
  extend self
end

BareTest.suite "CRUDtree" do

  suite "interface" do

    suite "usher" do

      suite "#compile_subnode" do

        setup :subnode, "Node" do
          @pre_path = "/foo"
          @subnode = Node.new(nil, klass: Object, paths: "foo", model: Object) {:foo}
          CRUDtree::Interface::Usher.expects(:compile_node).with("/foo/:id", @subnode).returns(true)
        end

        setup :subnode, "EndNode" do
          @pre_path = ""
          @subnode = EndNode.allocate
          CRUDtree::Interface::Usher.expects(:compile_subnode).with(@pre_path, @subnode).returns(true)
        end

        assert "Compilation with a :subnode as subnode" do
          CRUDtree::Interface::Usher.compile_subnode(@pre_path, @subnode)
        end

      end

      suite "#compile_node" do

        setup do
          @subnode = Object.new
          @pre_path = "/baz"
          @node = OpenStruct.new(paths: ["foo", "bar"], subnodes: [@subnode])
          CRUDtree::Interface::Usher.expects(:compile_subnode).with("/baz/foo", @subnode).returns(true)
          CRUDtree::Interface::Usher.expects(:compile_subnode).with("/baz/bar", @subnode).returns(true)
        end

        assert "compilation" do
          CRUDtree::Interface::Usher.compile_node(@pre_path, @node)
        end

      end

    end

  end

end
