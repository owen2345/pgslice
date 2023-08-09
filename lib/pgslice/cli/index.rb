module PgSlice
  class CLI
    desc "Apply missing indexes", "Allows to apply missing table indexes and foreign keys"
    option :print, type: :boolean, default: false, desc: "If true, the indexes will only be printed (not performed)."
    def index(table)
      table = create_table(table)
      queries = []

      table.index_defs.each do |index_def|
        queries << make_index_def(index_def, table.intermediate_table)
      end

      table.foreign_keys.each do |fk_def|
        queries << make_fk_def(fk_def, table.intermediate_table)
      end

      if options[:print]
        say queries
      else
        run_queries(queries)
      end
    end
  end
end
