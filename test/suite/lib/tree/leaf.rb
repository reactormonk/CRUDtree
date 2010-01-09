BareTest.suite "CRUDtree" do

  suite "tree" do

    suite "leaf" do

      suite "initialize" do

        assert ":type should only accept :member or :collection" do
          raises(ArgumentError) {CRUDtree::Leaf.new({type: :foo, call: :foo})}
        end

        assert ":call should not accept an empty argument" do
          raises(ArgumentError) {CRUDtree::Leaf.new({type: :member, path: "/foo"})}
        end

        assert ":path should default to :call" do
          CRUDtree::Leaf.new({type: :member, call: :foo}).path == "foo"
        end

      end

    end

  end

end
