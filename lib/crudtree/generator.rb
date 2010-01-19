module CRUDtree
  class Generator
    def initialize(trunk)
      @trunk = trunk
      @model_to_stem = {}
      @trunk.stems.each {|stem| add_stem_models(stem) }
    end

    def generate(resource, call = nil)
      route = compile_route_from_stem(find_stem(resource))
      # TODO now leaf
    end

    private
    def find_stem(resource)
      case stems = @model_to_stem[resource.class]
      when Stem
        stems
      when Array
        valid_stems = stems.select {|stem| valid_model_for_stem?(resource, stem)}
        parents = valid_stems.map{|stem| stem.parents}.flatten
        valid_stems.reject!{|stem| parents.include?(stem)}
        case valid_stems.size
        when (2..1/0.0)
          raise(NoUniqueStem, "No unique stem found for #{resource}.")
        when 0
          raise(NoStem, "No stem found for #{resource}.") if valid_stems.size == 1
        else
          valid_stems.first
        end
      end
    end

    def add_stem_models(stem)
      @model_to_stem[stem.model] = if target_stem = @model_to_stem[stem.model]
                                     ([target_stem] << stem).flatten
                                   else
                                     stem
                                   end
      stem.stems.each { |leaf|
        add_stem_models(leaf)
      }
    end

    def compile_route_from_stem(stem)
      (stem.parents.reverse + [stem]).map {|parent|
        "/#{parent.paths.first}/:#{parent.identifier}"
      }.join
    end

    def valid_model_for_stem?(model, stem)
      return false unless stem.model == model.class
      unless stem.parent_is_trunk?
        valid_model_for_stem?(model.send(stem.parent_call), stem.parent)
      else
        true
      end
    end
  end

  class NoUniqueStem < StandardError; end
  class NoStem < StandardError; end
end
