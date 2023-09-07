# dependencies
require "pg"
require "thor"

# stdlib
require "cgi"
require "time"
require "uri"

# modules
require_relative "pgslice/helpers"
require_relative "pgslice/table"
require_relative "pgslice/version"

# commands
require_relative "pgslice/cli"
require_relative "pgslice/cli/add_partitions"
require_relative "pgslice/cli/analyze"
require_relative "pgslice/cli/fill"
require_relative "pgslice/cli/prep"
require_relative "pgslice/cli/swap"
require_relative "pgslice/cli/unprep"
require_relative "pgslice/cli/unswap"
require_relative "pgslice/cli/index"
require_relative "pgslice/cli/trigger"
require_relative "pgslice/triggers_manager"
require_relative "pgslice/cli/rename_index"
