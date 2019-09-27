Nonterminals
array
array_end
array_inner
array_start
assignment
assignments
block
block_end
block_start
empty_line
keys
object
objects
quotes
resource
string
words
.

Terminals
array_close
array_open
back_slash
bracket_close
bracket_open
comma
digit
double_quote
equals
newline
single_quote
space
word
.

Rootsymbol objects.

array -> array_start array_end : {array, []}.
array -> array_start array_inner array_end : {array, '$2'}.

array_end -> space array_close : ']'.
array_end -> array_close : ']'.

array_inner -> block comma array_inner : ['$1' | '$3'].
array_inner -> newline array_inner : '$2'.
array_inner -> block : ['$1'].

array_start -> array_open : '['.

assignments -> assignment assignments : ['$1' | '$2'].
assignments -> space assignments : '$2'.
assignments -> newline assignments : '$2'.
assignments -> '$empty' : [].

assignment -> word space equals space string : {assignment, val('$1'), '$5'}.
assignment -> word space equals space digit : {assignment, val('$1'), integer('$5')}.
assignment -> word space equals space array : {assignment, val('$1'), '$5'}.
assignment -> word space equals space block : {assignment, val('$1'), '$5'}.

block -> block_start block_end : {block, []}.
block -> space block_start assignments block_end : {block, '$3'}.
block -> block_start assignments block_end : {block, '$2'}.

block_end -> bracket_close newline : '}'.
block_end -> bracket_close : '}'.

block_start -> bracket_open newline : '{'.
block_start -> bracket_open : '{'.

empty_line -> space newline : nil.
empty_line -> newline : nil.

keys -> string keys : ['$1' | '$2'].
keys -> '$empty' : [].

objects -> object objects : ['$1' | '$2'].
objects -> empty_line objects : '$2'.
objects -> '$empty' : [].

object -> resource keys block : {object, ['$1' | '$2'], '$3'}.

quotes -> double_quote : val('$1').
quotes -> single_quote : val('$1').

resource -> word space : {string, [val('$1')]}.

string -> double_quote words double_quote : {string, '$2'}.

words -> word words : [val('$1') | '$2'].
words -> back_slash quotes words : [val('$1'), '$2' | '$3'].
words -> single_quote words : [val('$1') | '$2'].
words -> bracket_close words : [val('$1') | '$2'].
words -> bracket_open words : [val('$1') | '$2'].
words -> space words : [val('$1') | '$2'].
words -> '$empty' : [].

Expect 3.

Erlang code.

integer(V) ->
  Digits = val(V),
  {integer, erlang:list_to_integer(Digits)}.

val({_, _, V}) ->
  V.
