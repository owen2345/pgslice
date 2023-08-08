module PgSlice
  class CLI
    desc "Manage triggers", "Allows to keep synced actual table with intermediate or retired"
    option :swapped, type: :boolean, default: false, desc: "True if the table was already swapped (retired)"
    def trigger(table)
      table = create_table(table)
      triggers_manager = TriggersManager.new(table, swapped: options[:swapped])
      run_query triggers_manager.drop_triggers
      run_query triggers_manager.build_triggers
    end
  end
end
