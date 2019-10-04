defmodule UCL.Section do
  defstruct [:key, :block]
end

defmodule UCL.Block do
  defstruct [:data]
end

defmodule UCL.Value do
  defstruct [:key, :value]
end

defmodule UCL.Comments do
  defstruct [:text]
end
