module PgSlice
  class CLI
    desc "Apply missing indexes", "Allows to apply missing table indexes and foreign keys"
    option :print, type: :boolean, default: false, desc: "If true, the indexes will only be printed (not performed)."
    option :concurrent, type: :boolean, default: false, desc: "If true, forces indexes to be added concurrently."
    def index(table)
      table = create_table(table)
      queries = []

      table.foreign_keys.each do |fk_def|
        queries << make_fk_def(fk_def, table.intermediate_table)
      end

      table.index_defs.each do |index_def|
        index = make_index_def(index_def, table.intermediate_table)
        index = index.sub('CREATE INDEX ', 'CREATE INDEX CONCURRENTLY ') if options[:concurrent]
        queries << index
      end

      if options[:print]
        queries.map { |q| log_sql(q) }
      else
        # run_queries(queries) # Does not work with concurrent indexes
        queries.each do |query| # allows to run concurrent indexes
          log_sql query
          connection.exec query
        end
      end
    end
  end
end
