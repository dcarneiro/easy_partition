require 'active_record'
require 'easy_partition/version'

module EasyPartition
  autoload :ActiveRecord, 'partitions/active_record'
end

# ActiveRecord::Base.extend(EasyPartition::ActiveRecord::Migration)