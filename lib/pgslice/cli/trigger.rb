module PgSlice
  class CLI
    # pgslice trigger <table>
    desc "Manage triggers", "Allows to keep synced actual table with intermediate or retired"
    option :swapped, type: :boolean, default: false, desc: "If true, the data will be synced to the retired table"
    option :drop, type: :boolean, default: false, desc: "If true, the current trigger will be dropped without adding new one"
    def trigger(table)
      table = create_table(table)
      triggers_manager = TriggersManager.new(table, swapped: options[:swapped])

      if options[:drop]
        run_query triggers_manager.drop_triggers
      else
        log_sql triggers_manager.build_triggers
        connection.exec triggers_manager.build_triggers
      end
    end
  end
end
