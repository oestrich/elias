defmodule HCL.Object do
  defstruct [:key, :block]
end

defmodule HCL.Block do
  defstruct [:data]
end

defmodule HCL.Value do
  defstruct [:key, :value]
end
