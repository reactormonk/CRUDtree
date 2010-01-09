BareTest.suite "CRUDtree" do

  suite "tree" do

    suite "stem" do

      suite "initialize" do
        
        suite "paths" do

          assert "defaults to the name of the class" do
            Stem.new(klass: Stem){:foo}.paths.first == "/stem"
          end

          assert "raises if no path is given" do
            raises(ArgumentError) {Stem.new(foo: :bar){:foo}}
          end

          suite "path sanitizing" do

            setup :input, "no Array" do
              @paths = "/foo"
              @result = ["/foo"]
            end

            setup :input, "an Array" do
              @paths = ["/foo", "/bar"]
              @result = ["/foo", "/bar"]
            end

            assert ":input is always a flattened Array" do
              Stem.new(paths: @paths){:foo}.paths == @result
            end

          end

        end

        assert "raises if no block is given" do
          raises(ArgumentError) {Stem.new(foo: :bar)}
        end
        
      end

#       suite "extended leafs" do

#         setup :method, "#member" do
#           @method = :member
#         end

#         setup :method, "#collection" do
#           @method = :collection
#         end

#         setup :stem, "stem" do
#           @stem = Stem.allocate
#           @params = {foo: :bar}
#           @result = @params.merge({type: @method})
#           mock(@stem).leaf(@result)
#         end

#         assert ":method" do
#           case @method
#           when :member
#             @stem.member @params
#           when :collection
#             @stem.collection @params
#           end
#         end

#       end

#       assert "stem"

    end

  end

end
