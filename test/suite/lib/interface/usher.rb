require 'crudtree/interface/usher'
require 'ostruct'

module CRUDtree::Interface::Usher
  public :compile_branch, :compile_stem
  extend self
end

BareTest.suite "CRUDtree" do

  suite "interface" do

    suite "usher" do

      suite "#compile_branch" do

        setup :branch, "Stem" do
          @pre_path = "/foo"
          @branch = Stem.new(nil, klass: Object, paths: "foo") {:foo}
          CRUDtree::Interface::Usher.expects(:compile_stem).with("/foo/:id", @branch).returns(true)
        end

        setup :branch, "Leaf" do
          @pre_path = ""
          @branch = Leaf.allocate
          CRUDtree::Interface::Usher.expects(:compile_leaf).with(@pre_path, @branch).returns(true)
        end

        assert "Compilation with a :branch as branch" do
          CRUDtree::Interface::Usher.compile_branch(@pre_path, @branch)
        end

      end

      suite "#compile_stem" do

        setup do
          @leaf = Object.new
          @pre_paths = ["", "/baz"]
          @stem = OpenStruct.new(paths: ["foo", "bar"], leafs: [@leaf])
          CRUDtree::Interface::Usher.expects(:compile_leaf).with(["/foo", "/bar", "/baz/foo", "/baz/bar"], @stem).returns(true)
        end

        assert "compilation" do
          CRUDtree::Interface::Usher.compile_stem(@pre_paths, @stem)
        end

      end

    end

  end

end
