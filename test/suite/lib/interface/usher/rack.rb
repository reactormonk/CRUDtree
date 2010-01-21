require 'crudtree/interface/usher/rack'
require 'ostruct'



BareTest.suite "CRUDtree" do

  suite "interface" do

    suite "usher" do

      suite "rack" do

        setup do
          module CRUDtree::Interface::Usher::Rack
            public :compile_path
            extend self
          end

          class TestObj < Object; end
          class TestObj2 < Object; end
          class Cont1 < Object; end
          class Cont2 < Object; end
        end

        suite "#compile_path" do

          setup :subnode, "a simple member subnode" do
            @pre_path = ""
            @node = OpenStruct.new(klass: TestObj, identifier: :id, paths: "testobj")
            @subnode = EndNode.new(@node, type: :member, call: :foo, name: "foo")
            @path = "/testobj/:id/foo"
            @params = {conditions: {}}
            @send = [:foo]
            @master_params = {}
          end

          setup :subnode, "a more complex collection subnode" do
            @pre_path = "/bar"
            @node = OpenStruct.new(klass: TestObj, identifier: :id, paths: "testobj")
            @subnode = EndNode.new(@node, type: :collection, call: :foo, name: "foo")
            @path = "/bar/testobj/foo"
            @params = {conditions: {}}
            @send = [:dispatcher, :foo]
            @master_params = {rango: true}
          end

          setup :subnode, "a nested collection subnode" do
            @pre_path = ""
            @node1 = Node.new(nil, klass: Cont1, identifier: :id, paths: "cont1", model: Object){:foo}
            @node2 = Node.new(@node1, klass: TestObj, model: Object){:foo}
            @subnode = EndNode.new(@node2, type: :collection, call: :foo, name: "foo", model: Object)
            @path = "/cont1/:id/testobj/foo"
            @params = {conditions: {}}
            @send = [:dispatcher, :foo]
            @master_params = {rango: true}
          end

          setup :subnode, "a nested member subnode" do
            @pre_path = ""
            @node1 = Node.new(nil, klass: Cont1, identifier: :id, paths: "cont1", model: Object){:foo}
            @node2 = Node.new(@node1, klass: TestObj, model: Object){:foo}
            @subnode = EndNode.new(@node2, type: :member, call: :foo, name: "foo")
            @path = "/cont1/:id/testobj/:id/foo"
            @params = {conditions: {}}
            @send = [:foo]
            @master_params = {}
          end

          setup :foo, "Foo" do
            TestObj.expects(:send).with(*@send).returns(:yeah)
            TestObj2.any_instance.expects(:to).with(:yeah)
            CRUDtree::Interface::Usher::Rack.expects(:master_params).returns(@master_params)
            CRUDtree::Interface::Usher::Rack.expects(:path).with(@path, @params).returns(TestObj2.new)
          end

          assert "compilaton with :subnode" do
            CRUDtree::Interface::Usher::Rack.compile_path(@pre_path, @subnode)
            true
          end

        end

      end

    end

  end

end
