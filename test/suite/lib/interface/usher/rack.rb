require 'crudtree/interface/usher/rack'
require 'ostruct'

module CRUDtree::Interface::Usher::Rack
  public :compile_path
  extend self
end

class TestObj < Object; end
class TestObj2 < Object; end
class Cont1 < Object; end
class Cont2 < Object; end


BareTest.suite "CRUDtree" do

  suite "interface" do

    suite "usher" do

      suite "rack" do

        suite "#compile_path" do

          setup :leaf, "a simple member leaf" do
            @pre_path = ""
            @stem = OpenStruct.new(klass: TestObj, identifier: :id, path: "testobj")
            @leaf = Leaf.new(@stem, type: :member, call: :foo, name: "foo")
            @path = "/testobj/:id/foo"
            @params = {conditions: {}}
            @send = [:foo]
            @trunk_params = {}
          end

          setup :leaf, "a more complex collection leaf" do
            @pre_path = "/bar"
            @stem = OpenStruct.new(klass: TestObj, identifier: :id, path: "testobj")
            @leaf = Leaf.new(@stem, type: :collection, call: :foo, name: "foo")
            @path = "/bar/testobj/foo"
            @params = {conditions: {}}
            @send = [:dispatcher, :foo]
            @trunk_params = {rango: true}
          end

          setup :leaf, "a nested collection leaf" do
            @pre_path = ""
            @stem1 = Stem.new(nil, klass: Cont1, identifier: :id, path: "cont1"){:foo}
            @stem2 = Stem.new(@stem1, klass: TestObj){:foo}
            @leaf = Leaf.new(@stem2, type: :collection, call: :foo, name: "foo")
            @path = "/cont1/:id/testobj/foo"
            @params = {conditions: {}}
            @send = [:dispatcher, :foo]
            @trunk_params = {rango: true}
          end

          setup :leaf, "a nested member leaf" do
            @pre_path = ""
            @stem1 = Stem.new(nil, klass: Cont1, identifier: :id, path: "cont1"){:foo}
            @stem2 = Stem.new(@stem1, klass: TestObj){:foo}
            @leaf = Leaf.new(@stem2, type: :member, call: :foo, name: "foo")
            @path = "/cont1/:id/testobj/:id/foo"
            @params = {conditions: {}}
            @send = [:foo]
            @trunk_params = {}
          end

          setup :foo, "Foo" do
            TestObj.expects(:send).with(*@send).returns(:yeah)
            TestObj2.any_instance.expects(:to).with(:yeah)
            CRUDtree::Interface::Usher::Rack.expects(:trunk_params).returns(@trunk_params)
            CRUDtree::Interface::Usher::Rack.expects(:path).with(@path, @params).returns(TestObj2.new)
          end

          assert "compilaton with :leaf" do
            CRUDtree::Interface::Usher::Rack.compile_path(@pre_path, @leaf)
            true
          end

        end

      end

    end

  end

end
