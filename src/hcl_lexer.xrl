Definitions.

ArrayClose = \]
ArrayOpen = \[
BackSlash = \\
BracketClose = }
BracketOpen = {
Colon = :
Comma = ,
Dash = -
Digit = [0-9]+
DoubleQuote = "
Equals = =
NewLine = (\n|\n\r|\r)
SingleQuote = '
Space = \s+
Word = [^0-9{}\n\[\]=\s'":\\-]+

Rules.

{ArrayClose} : {token, {array_close, TokenLine, TokenChars}}.
{ArrayOpen} : {token, {array_open, TokenLine, TokenChars}}.
{BackSlash} : {token, {back_slash, TokenLine, TokenChars}}.
{BracketClose} : {token, {bracket_close, TokenLine, TokenChars}}.
{BracketOpen} : {token, {bracket_open, TokenLine, TokenChars}}.
{Comma} : {token, {comma, TokenLine, TokenChars}}.
{Digit} : {token, {digit, TokenLine, TokenChars}}.
{DoubleQuote} : {token, {double_quote, TokenLine, TokenChars}}.
{Equals} : {token, {equals, TokenLine, TokenChars}}.
{NewLine} : {token, {newline, TokenLine, TokenChars}}.
{SingleQuote} : {token, {single_quote, TokenLine, TokenChars}}.
{Space} : {token, {space, TokenLine, TokenChars}}.
{Word} : {token, {word, TokenLine, TokenChars}}.

Erlang code.
