module PgSlice
  class CLI
    desc "Rename indexes", "Renames intermediate indexes as the official indexes and the retired indexes as the <index>_retired"
    option :print, type: :boolean, default: false, desc: "If true, the renaming will only be printed (not performed)."

    def rename_index(table)
      table = create_table(table)
      queries = []

      create_table(table.retired_table.name).index_defs.each do |index_def|
        queries << renamed_index(index_def, suffix: '_retired')
      end

      table.index_defs.each do |index_def|
        queries << renamed_index(index_def, remove_suffix: '_intermediate')
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
