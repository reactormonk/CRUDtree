BareTest.suite "CRUDtree" do

  suite "tree" do

    suite "trunk" do

      assert "initialize" do
        trunk = CRUDtree::Trunk.new(object = Object)
        trunk.klass == object && trunk.stems == []
      end

    end

  end

end
