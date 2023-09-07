# frozen_string_literal: true

module PgSlice
  class TriggersManager
    attr_reader :table, :sync_to, :trigger_name

    def initialize(table, swapped: false)
      @table = table
      @sync_to = swapped ? table.retired_table : table.intermediate_table
      @trigger_name = "#{table.name}_pgslice_sync"
    end

    def drop_triggers
      "DROP TRIGGER IF EXISTS #{trigger_name} ON #{table.quote_table};"
    end

    def build_triggers
      "CREATE OR REPLACE FUNCTION #{trigger_name}() RETURNS TRIGGER AS $$
      BEGIN
          IF (TG_OP = 'DELETE') THEN
              DELETE FROM #{sync_to} WHERE id = OLD.id;
          ELSIF (TG_OP = 'UPDATE') THEN
              UPDATE #{sync_to} SET #{update_columns} WHERE id = NEW.id;
          ELSIF (TG_OP = 'INSERT') THEN
              INSERT INTO #{sync_to} VALUES(NEW.*)
              ON CONFLICT (id) DO UPDATE SET #{update_columns};
          END IF;
          RETURN NULL; -- result is ignored since this is an AFTER trigger
      END;
      $$ LANGUAGE plpgsql;

      CREATE TRIGGER #{trigger_name}
          AFTER INSERT OR UPDATE OR DELETE ON #{table.quote_table}
          FOR EACH ROW EXECUTE FUNCTION #{trigger_name}();"
    end

    private

    def update_columns
      columns = (table.columns - ['id'])
      columns.map { |col| "#{col}=NEW.#{col}" }.join(', ')
    end
  end
end
