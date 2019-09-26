defmodule HCL do
  def parse(string) do
    case :hcl_lexer.string(String.to_charlist(string)) do
      {:ok, ast, _} ->
        :hcl_parser.parse(ast)
    end
  end
end
