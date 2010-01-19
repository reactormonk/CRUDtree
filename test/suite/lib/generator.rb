require 'ostruct'
BareTest.suite do

  suite "CRUDtree" do

    suite "Generator" do

      suite "#compile_route_from_stem" do

        setup :stem, "a simple stem" do
          @stem = OpenStruct.new(:paths => ["foo"], :identifier => :id)
          @path = "/foo/:id"
        end

         setup :stem, "a stem with multiple parents" do
          @stem = OpenStruct.new(:paths => ["foo"], :identifier => :id,
                    :parent => OpenStruct.new(:paths => ["bar"], :identifier => :id,
                      :parent => OpenStruct.new(:paths => ["baz"], :identifier => :id,
                        :parent => nil)
                      )
                    )
          @path = "/foo/:id/bar/:id/baz/:id"
        end

        assert ":stem goes to the right path" do
          CRUDtree::Generator.allocate.send(:compile_route_from_stem, @stem).equals @path
        end

      end

      suite "#model_to_stem" do

        setup do
          class TestObj0; end
          class TestObj1; end
        end

        setup :trunk, "a simple trunk" do
          trunk = CRUDtree::Trunk.new
          @generator = CRUDtree::Generator.new(trunk)
          @stem = trunk.stem(klass: Object, model: TestObj0) {:foo}
          @model = TestObj0
        end

        setup :trunk, "a complex trunk" do
          trunk = CRUDtree::Trunk.new
          @generator = CRUDtree::Generator.new(trunk)
          @stem = trunk.stem(klass: Object, model: TestObj1){ stem(klass: Object, model: TestObj0){:foo}}
          @model = TestObj0
        end

        assert "The right model is found on :trunk." do
          @generator.model_to_stem[@model].equals @stem
        end

      end

    end

  end

end
