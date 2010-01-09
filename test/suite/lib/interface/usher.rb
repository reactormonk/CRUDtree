require 'crudtree/interface/usher'
require 'ostruct'

module CRUDtree::Interface::Usher
  public :compile_leaf, :compile_stem
  extend self
end

BareTest.suite "CRUDtree" do

  suite "interface" do

    suite "usher" do

      suite "#compile_leaf" do

        suite "Leaf" do

          setup do
            @stem = OpenStruct.new(identifier: :id)
            @pre_paths = ["", "/foo"]
          end

          setup :leaf, "member Leaf" do
            @leaf = Leaf.new(type: :member, rest: :get, call: :show, path: "show")
            CRUDtree::Interface::Usher.expects(:compile_path).with("/:id", @stem, @leaf)
            CRUDtree::Interface::Usher.expects(:compile_path).with("/foo/:id", @stem, @leaf)
          end

          setup :leaf, "collection Leaf" do
            @leaf = Leaf.new(type: :collection, rest: :get, call: :index, path: "index")
            CRUDtree::Interface::Usher.expects(:compile_path).with("", @stem, @leaf)
            CRUDtree::Interface::Usher.expects(:compile_path).with("/foo", @stem, @leaf)
          end

          assert "compilation with a :leaf" do
            CRUDtree::Interface::Usher.compile_leaf(@pre_paths, @stem, @leaf)
          end

        end

        suite "Stem" do

          setup :stem, "Stem" do
            @stem = Object.new
            @leaf = Stem.allocate
            @pre_paths = [""]
            CRUDtree::Interface::Usher.expects(:compile_stem).with([""], @leaf).returns(true)
          end

          assert "compilation with a :stem" do
            CRUDtree::Interface::Usher.compile_leaf(@pre_paths, @stem, @leaf)
          end

        end

      end

      suite "#compile_stem" do

        setup do
          @leaf = Object.new
          @pre_paths = ["", "/baz"]
          @stem = OpenStruct.new(paths: ["foo", "bar"], leafs: [@leaf])
          CRUDtree::Interface::Usher.expects(:compile_leaf).with(["/foo", "/bar", "/baz/foo", "/baz/bar"], @stem, @leaf).returns(true)
        end

        assert "compilation" do
          CRUDtree::Interface::Usher.compile_stem(@pre_paths, @stem)
        end

      end

    end

  end

end
