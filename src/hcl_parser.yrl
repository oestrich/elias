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
keys
object
objects
resource
string
whitespace
words
.

Terminals
array_close
array_open
back_slash
bracket_close
bracket_open
comma
equals
newline
quote
space
word
.

Rootsymbol objects.

array -> array_start array_end : {array, []}.
array -> array_start array_inner array_end : {array, '$2'}.

array_end -> space array_close : ']'.
array_end -> array_close : ']'.

array_inner -> block comma array_inner : ['$1' | '$3'].
array_inner -> whitespace array_inner : '$2'.
array_inner -> block : ['$1'].

array_start -> space array_open : '['.
array_start -> array_open : '['.

assignments -> assignment assignments : ['$1' | '$2'].
assignments -> assignment whitespace assignments : ['$1' | '$3'].
assignments -> assignment : ['$1'].

assignment -> space assignment : '$2'.
assignment -> word space equals space string : {assignment, val('$1'), '$5'}.
assignment -> word space equals space string whitespace : {assignment, val('$1'), '$5'}.
assignment -> word space equals space array : {assignment, val('$1'), '$5'}.
assignment -> word space equals space array whitespace : {assignment, val('$1'), '$5'}.
assignment -> word space equals space block : {assignment, val('$1'), '$5'}.
assignment -> word space equals space block whitespace : {assignment, val('$1'), '$5'}.

block -> block_start block_end : {block, []}.
block -> block_start assignments block_end : {block, '$2'}.

block_end -> bracket_close newline : '}'.
block_end -> bracket_close : '}'.

block_start -> bracket_open newline : '{'.
block_start -> bracket_open : '{'.

keys -> string keys : ['$1' | '$2'].
keys -> string : ['$1'].

objects -> object objects : ['$1' | '$2'].
objects -> object : ['$1'].

object -> resource keys block : {object, ['$1' | '$2'], '$3'}.
object -> resource keys block newline : {object, ['$1' | '$2'], '$3'}.

resource -> word space : {string, [val('$1')]}.

string -> quote words quote space : {string, '$2'}.
string -> quote words quote : {string, '$2'}.

whitespace -> newline whitespace: ['$1' | '$2'].
whitespace -> space whitespace : ['$1' | '$2'].
whitespace -> newline : ['$1'].
whitespace -> space : ['$1'].

words -> word words : [val('$1') | '$2'].
words -> back_slash quote words : [val('$1'), val('$2') | '$2'].
words -> bracket_close words : [val('$1') | '$2'].
words -> bracket_open words : [val('$1') | '$2'].
words -> newline words : [val('$1') | '$2'].
words -> space words : [val('$1') | '$2'].
words -> back_slash quote : [val('$1'), val('$2')].
words -> bracket_close : [val('$1')].
words -> word : [val('$1')].

Expect 16.

Erlang code.

val({_, _, V}) -> V.
