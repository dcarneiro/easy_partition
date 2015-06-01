require File.expand_path('../../test_helper', __FILE__)

describe 'Migration' do
  before(:each) do
    assert Migrated.table_name = 'measurements'
  end

  describe '#test_child_table_name' do
    it 'should append the partition to the master table name to form the child table' do
      assert_equal 'measurements_pt', Migrated.child_table_name('pt')
    end
  end
end
