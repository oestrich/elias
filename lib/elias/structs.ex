defmodule Elias.Section do
  defstruct [:key, :block]
end

defmodule Elias.Block do
  defstruct [:data]
end

defmodule Elias.Value do
  defstruct [:key, :value]
end

defmodule Elias.Comments do
  defstruct [:text]
end
