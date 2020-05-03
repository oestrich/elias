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
ForwardSlash = /
NewLine = (\n|\n\r|\r)
Pound = \#
SemiColon = \;
SingleQuote = '
Space = \s+
Star = \*
CommentOpen = \/\*
CommentClose = \*\/
Word = [^0-9{}\*\/#\n\[\]=\s'":\;\\-]+

Rules.

{ArrayClose} : {token, {array_close, TokenLine, TokenChars}}.
{ArrayOpen} : {token, {array_open, TokenLine, TokenChars}}.
{BackSlash} : {token, {back_slash, TokenLine, TokenChars}}.
{BracketClose} : {token, {bracket_close, TokenLine, TokenChars}}.
{BracketOpen} : {token, {bracket_open, TokenLine, TokenChars}}.
{Comma} : {token, {comma, TokenLine, TokenChars}}.
{Colon} : {token, {colon, TokenLine, TokenChars}}.
{Dash} : {token, {dash, TokenChars, TokenChars}}.
{Digit} : {token, {digit, TokenLine, TokenChars}}.
{DoubleQuote} : {token, {double_quote, TokenLine, TokenChars}}.
{Equals} : {token, {equals, TokenLine, TokenChars}}.
{ForwardSlash} : {token, {forward_slash, TokenLine, TokenChars}}.
{NewLine} : {token, {newline, TokenLine, TokenChars}}.
{Pound} : {token, {pound, TokenLine, TokenChars}}.
{SemiColon} : {token, {semi_colon, TokenLine, TokenChars}}.
{SingleQuote} : {token, {single_quote, TokenLine, TokenChars}}.
{Space} : {token, {space, TokenLine, TokenChars}}.
{Star} : {token, {star, TokenLine, TokenChars}}.
{Word} : {token, {word, TokenLine, TokenChars}}.
{CommentOpen} : {token, {comment_open, TokenLine, TokenChars}}.
{CommentClose} : {token, {comment_close, TokenLine, TokenChars}}.

Erlang code.
