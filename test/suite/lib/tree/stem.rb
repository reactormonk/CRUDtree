BareTest.suite "CRUDtree" do

  suite "tree" do

    suite "stem" do

      suite "initialize" do
        
        suite "paths" do

          assert "defaults to the name of the class" do
            Stem.new(nil, klass: Stem){:foo}.paths == ["stem"]
          end

          assert "raises if no path is given" do
            raises(ArgumentError) {Stem.new(nil, foo: :bar){:foo}}
          end

        end

        assert "raises if no block is given" do
          raises(ArgumentError) {Stem.new(nil, foo: :bar)}
        end
        
      end

      suite "extended leafs" do

        setup :method, "#member" do
          @method = :member
        end

        setup :method, "#collection" do
          @method = :collection
        end

        setup :stem, "stem" do
          @stem = Stem.allocate
          @params = {foo: :bar}
          @result = @params.merge({type: @method})
          @stem.expects(:branch).with(@result)
        end

        assert ":method" do
          case @method
          when :member
            @stem.member @params
          when :collection
            @stem.collection @params
          end
          true
        end

      end

    end

  end

end
