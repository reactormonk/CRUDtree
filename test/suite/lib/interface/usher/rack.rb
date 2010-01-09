require 'crudtree/interface/usher/rack'
require 'ostruct'

module CRUDtree::Interface::Usher::Rack
  public :compile_path
  extend self
end

class TestObj < Object; end
class TestObj2 < Object; end


BareTest.suite "CRUDtree" do

  suite "interface" do

    suite "usher" do

      suite "rack" do

        suite "#compile_path" do

          setup :leaf, "a simple leaf" do
            @pre_path = ""
            @leaf = Leaf.new(type: :member, call: :foo, name: :foo)
            @stem = OpenStruct.new(klass: TestObj)
            @path = "/foo"
            @params = {name: :foo, conditions: {}}
            @send = [:foo]
            @trunk_params = {}
          end

          setup :leaf, "a more complex leaf" do
            @pre_path = "/bar"
            @leaf = Leaf.new(type: :member, call: :foo, name: :foo)
            @stem = OpenStruct.new(klass: TestObj)
            @path = "/bar/foo"
            @params = {name: :foo, conditions: {}}
            @send = [:dispatcher, :foo]
            @trunk_params = {rango: true}
          end

          setup :foo, "Foo" do
            TestObj.expects(:send).with(*@send).returns(:yeah)
            TestObj2.any_instance.expects(:to).with(:yeah)
            CRUDtree::Interface::Usher::Rack.expects(:trunk_params).returns(@trunk_params)
            CRUDtree::Interface::Usher::Rack.expects(:path).with(@path, @params).returns(TestObj2.new)
          end

          assert "compilaton with :leaf" do
            CRUDtree::Interface::Usher::Rack.compile_path(@pre_path, @stem, @leaf)
            true
          end

        end

      end

    end

  end

end
