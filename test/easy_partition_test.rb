require 'minitest/autorun'
require 'easy_partition'

class EasyPartitionTest < Minitest::Test
  def test_version
    assert_equal "0.0.1", EasyPartition::VERSION
  end
end