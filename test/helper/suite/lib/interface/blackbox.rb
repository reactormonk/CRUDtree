def results_in(path, klass, call, params)
  klass.expects(call).returns(:yeah!)
  to_mock = mock('to')
  to_mock.expects(:to).with(:yeah!).returns(true)
  Usher::Interface::Rack.any_instance.expects(:path).with(path, params).returns(to_mock)
end

module Usher; module Interface; class Rack;
  include CRUDtree::Interface::Usher::Rack
  def initialize(app = nil, options = nil, &block) 
    instance_eval(&block) if block
  end
end; end; end
class TestObj0; end
class TestObj1; end
class TestObj2; end

