module PgSlice
  class CLI
    desc "Apply missing indexes", "Allows to apply missing indexes"
    option :print, type: :boolean, default: false, desc: "If true, the indexes will only be printed (not performed)."
    option :primary_key, type: :boolean, default: false, desc: "If true, includes primary key as part of the indexes."
    def index(table)
      table = create_table(table)
      queries = []

      if options[:primary_key]
        queries << "ALTER TABLE #{table.intermediate_table} ADD PRIMARY KEY (ID);"
      end

      table.index_defs.each do |index_def|
        queries << make_index_def(index_def, table.intermediate_table)
      end

      table.foreign_keys.each do |fk_def|
        queries << make_fk_def(fk_def, table.intermediate_table)
      end

      if options[:print] == 'true'
        say queries
      else
        run_queries(queries)
      end
    end
  end
end
