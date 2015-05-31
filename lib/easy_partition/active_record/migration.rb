module EasyPartition
  module ActiveRecord
    module Migration
      def create_partitions_tables!(column_name, *partitions)
        create_child_tables(column_name, partitions)
        define_trigger(column_name, partitions)
        enable_trigger
      end

      def drop_partitions_tables!(column_name, *partitions)
        drop_trigger
        drop_trigger_definition
        drop_child_tables(column_name, partitions)
      end

      def create_child_tables(column_name, partitions)
        partitions.each do |partition|
          create_child_table(column_name, partition)
          create_child_table_partition_index(column_name, partition)
        end
      end

      def drop_child_tables(column_name, partitions)
        partitions.each do |partition|
          drop_child_table_partition_index(column_name, partition)
          drop_child_table(partition)
        end
      end

      def create_child_table(column_name, partition)
        connection.execute <<-SQL
          CREATE TABLE #{child_table_name(partition)} (
            CHECK ( #{column_name} = '#{partition}' )
          ) INHERITS (#{master_table});
        SQL
      end

      def drop_child_table(partition)
        connection.execute <<-SQL
          DROP TABLE #{child_table_name(partition)};
        SQL
      end

      def create_child_table_partition_index(column_name, partition)
        connection.execute <<-SQL
          CREATE INDEX #{child_table_index_name(column_name, partition)} ON #{child_table_name(partition)} (#{column_name});
        SQL
      end

      def drop_child_table_partition_index(column_name, partition)
        connection.execute <<-SQL
          DROP INDEX #{child_table_index_name(column_name, partition)};
        SQL
      end

      def define_trigger(column_name, partitions)
        query = trigger_header
        partitions.each do |partition|
          query += %[IF (NEW.#{column_name} = '#{partition}') THEN
            INSERT INTO #{child_table_name(partition)} VALUES (NEW.*);
          ELS]
        end
        query += trigger_footer
        connection.execute query
      end

      def drop_trigger_definition
        connection.execute <<-SQL
          DROP FUNCTION IF EXISTS #{master_table}_insert_trigger();
        SQL
      end

      def enable_trigger
        connection.execute <<-SQL
          CREATE TRIGGER insert_#{master_table}_trigger
          BEFORE INSERT ON #{master_table}
          FOR EACH ROW EXECUTE PROCEDURE #{master_table}_insert_trigger();
        SQL
      end

      def drop_trigger
        connection.execute <<-SQL
          DROP TRIGGER IF EXISTS insert_#{master_table}_trigger ON #{master_table};
        SQL
      end

      def trigger_header
        <<-SQL
          CREATE OR REPLACE FUNCTION #{master_table}_insert_trigger()
          RETURNS TRIGGER AS $$
            BEGIN
        SQL
      end

      def trigger_footer
        %(E
                RAISE EXCEPTION 'partition out of range';
              END IF;
              RETURN NULL;
            END;
          $$
          LANGUAGE plpgsql;
        )
      end

      def master_table
        table_name
      end

      def child_table_name(partition)
        [master_table, partition].join('_')
      end

      def child_table_index_name(column_name, partition)
        [child_table_name(partition), column_name].join('_')
      end
    end
  end
end
