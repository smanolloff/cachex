defmodule Cachex.Actions.Load do
  @moduledoc false
  # This module controls the implementation for the `load` command, which loads
  # a file dump of a cache back into the provided cache from the provided file
  # location. Only dumps generated by the logic in the `dump` command are accepted.

  # we need our imports
  use Cachex.Actions

  # add some aliases
  alias Cachex.Disk
  alias Cachex.State

  @doc """
  Loads records into a cache from a given disk location.

  If there are any issues reading the file, an error will be returned. Only files
  which were created via `dump` can be loaded, and the load will detect any disk
  compression automatically.

  Loading a backup will merge the file into the provided cache, overwriting any
  clashes. If you wish to empty the cache and then import your backup, you can
  use a transaction and clear the cache before loading the backup.

  There are currently no recognised options, the argument only exists for future
  proofing.
  """
  defaction load(%State{ cache: cache } = state, path, options) do
    with { :ok, terms } <- Disk.read(path, options) do
      { :ok, :ets.insert(cache, terms) }
    end
  end
end
