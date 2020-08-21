defmodule Elias.Section do
  @moduledoc false
  defstruct [:key, :block]
end

defmodule Elias.Block do
  @moduledoc false
  defstruct [:data]
end

defmodule Elias.Variable do
  @moduledoc false
  defstruct [:key, :value]
end

defmodule Elias.Value do
  @moduledoc false
  defstruct [:data]
end

defmodule Elias.Comments do
  @moduledoc false
  defstruct [:text]
end
