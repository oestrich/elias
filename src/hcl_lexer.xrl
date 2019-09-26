Definitions.

ArrayOpen = \[
ArrayClose = \]
BackSlash = \\
BracketOpen = {
BracketClose = }
Colon = :
Comma = ,
Dash = -
Equals = =
NewLine = (\n|\n\r|\r)
Quote = ['"]
Space = \s+
Word = [^{}\n\[\]=\s'":\\-]+

Rules.

{ArrayClose} : {token, {array_close, TokenLine, TokenChars}}.
{ArrayOpen} : {token, {array_open, TokenLine, TokenChars}}.
{BackSlash} : {token, {back_slash, TokenLine, TokenChars}}.
{BracketClose} : {token, {bracket_close, TokenLine, TokenChars}}.
{BracketOpen} : {token, {bracket_open, TokenLine, TokenChars}}.
{Comma} : {token, {comma, TokenLine, TokenChars}}.
{Equals} : {token, {equals, TokenLine, TokenChars}}.
{NewLine} : {token, {newline, TokenLine, TokenChars}}.
{Quote} : {token, {quote, TokenLine, TokenChars}}.
{Quote} : {token, {quote, TokenLine, TokenChars}}.
{Space} : {token, {space, TokenLine, TokenChars}}.
{Word} : {token, {word, TokenLine, TokenChars}}.

Erlang code.
