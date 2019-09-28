defmodule HCL.Parser do
  @moduledoc """
  Parse a string into an AST for processing
  """

  @doc """
  Parses a string into an AST
  """
  def parse(string) do
    case lex_string(string) do
      {:ok, tokens, _} ->
        parse_tokens(tokens)
    end
  end

  @doc """
  Turn a string into known tokens

  Step one of parsing a string
  """
  def lex_string(string) do
    :hcl_lexer.string(String.to_charlist(string))
  end

  @doc """
  Parse lexed tokens into an AST

  Step two of parsing a string
  """
  def parse_tokens(tokens) do
    case :hcl_parser.parse(tokens) do
      {:ok, ast} ->
        {:ok, ast}
    end
  end
end
