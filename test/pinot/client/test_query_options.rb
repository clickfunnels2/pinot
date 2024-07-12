require "test_helper"

class Pinot::Client::QueryQueryOptionsTest < Minitest::Test
  def test_it_sets_up_the_default_values
    options = Pinot::Client::QueryOptions.new
    assert_nil options.enable_null_handling
  end

  def test_it_configures_the_option_correctly
    options = Pinot::Client::QueryOptions.new(enable_null_handling: true)
    assert options.enable_null_handling
  end

  def test_it_generates_nil_query_options_by_default
    options = Pinot::Client::QueryOptions.new
    assert_nil options.to_query_options
  end

  def test_it_generates_the_query_options_correctly
    options = Pinot::Client::QueryOptions.new(enable_null_handling: true, use_multistage_engine: true)
    assert_equal "enableNullHandling=true;useMultistageEngine=true", options.to_query_options
  end

  def test_it_raises_on_unknown_option
    e = assert_raises Pinot::Client::QueryOptions::InvalidOption do
      Pinot::Client::QueryOptions.new(unknown_option: true)
    end
    assert_equal "`unknown_option' is not a valid option for Pinot Client", e.message
  end
end
