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
comments
equality
keys
multi_comments
quotes
root
section
section_name
string
value
words
.

Terminals
array_close
array_open
back_slash
bracket_close
bracket_open
colon
comma
dash
digit
double_quote
equals
forward_slash
newline
pound
semi_colon
single_quote
space
star
word
comment_open
comment_close
.

Rootsymbol root.

root -> block_start assignments block_end : '$2'.
root -> assignments : '$1'.

array -> array_start array_end : {array, []}.
array -> array_start array_inner array_end : {array, '$2'}.

array_end -> space array_close : ']'.
array_end -> array_close : ']'.

array_inner -> block comma array_inner : ['$1' | '$3'].
array_inner -> space array_inner : '$2'.
array_inner -> newline array_inner : '$2'.
array_inner -> block : ['$1'].

array_start -> array_open : '['.

assignments -> comments assignments : ['$1' | '$2'].
assignments -> assignment assignments : ['$1' | '$2'].
assignments -> assignment semi_colon assignments : ['$1' | '$3'].
assignments -> section assignments : ['$1' | '$2'].
assignments -> space assignments : '$2'.
assignments -> newline assignments : '$2'.
assignments -> '$empty' : [].

assignment -> word equality array : {assignment, val('$1'), '$3'}.
assignment -> word equality block : {section, [{string, val('$1')}], '$3'}.
assignment -> word equality digit : {assignment, val('$1'), integer('$3')}.
assignment -> word equality string : {assignment, val('$1'), '$3'}.
assignment -> word equality value : {assignment, val('$1'), '$3'}.

block -> block_start block_end : {block, []}.
block -> block_start assignments block_end : {block, '$2'}.

block_end -> bracket_close newline : '}'.
block_end -> bracket_close : '}'.

block_start -> bracket_open newline : '{'.
block_start -> bracket_open : '{'.

comments -> comment_open multi_comments comment_close : {comments, '$2'}.
comments -> pound words newline : {comments, '$2'}.

multi_comments -> back_slash multi_comments : [val('$1') | '$2'].
multi_comments -> bracket_close multi_comments : [val('$1') | '$2'].
multi_comments -> bracket_open multi_comments : [val('$1') | '$2'].
multi_comments -> forward_slash multi_comments : [val('$1') | '$2'].
multi_comments -> newline multi_comments : [val('$1') | '$2'].
multi_comments -> pound multi_comments : [val('$1') | '$2'].
multi_comments -> double_quote multi_comments : [val('$1') | '$2'].
multi_comments -> single_quote multi_comments : [val('$1') | '$2'].
multi_comments -> space multi_comments : [val('$1') | '$2'].
multi_comments -> word multi_comments : [val('$1') | '$2'].
multi_comments -> star multi_comments : [val('$1') | '$2'].
multi_comments -> '$empty' : [].

equality -> space equals space : '='.
equality -> equals space : '='.
equality -> space equals : '='.
equality -> equals : '='.
equality -> space colon space : '='.
equality -> colon space : '='.
equality -> space colon : '='.
equality -> colon : '='.

keys -> string keys : ['$1' | '$2'].
keys -> digit keys : ['$1' | '$2'].
keys -> '$empty' : [].

quotes -> double_quote : val('$1').
quotes -> single_quote : val('$1').

section -> section_name keys block : {section, ['$1' | '$2'], '$3'}.
section -> section_name keys space block : {section, ['$1' | '$2'], '$4'}.

section_name -> word space : {string, [val('$1')]}.

string -> double_quote words double_quote : {string, '$2'}.

value -> word : {value, val('$1')}.

words -> word words : [val('$1') | '$2'].
words -> back_slash quotes words : [val('$1'), '$2' | '$3'].
words -> back_slash word words : [val('$1'), val('$2') | '$3'].
words -> single_quote words : [val('$1') | '$2'].
words -> bracket_close words : [val('$1') | '$2'].
words -> bracket_open words : [val('$1') | '$2'].
words -> space words : [val('$1') | '$2'].
words -> star words : [val('$1') | '$2'].
words -> pound words : [val('$1') | '$2'].
words -> dash words : [val('$1') | '$2'].
words -> digit words : [val('$1') | '$2'].
words -> forward_slash words : [val('$1') | '$2'].
words -> comment_open words : [val('$1') | '$2'].
words -> comment_close words : [val('$1') | '$2'].
words -> '$empty' : [].

Expect 3.

Erlang code.

integer(V) ->
  Digits = val(V),
  {integer, erlang:list_to_integer(Digits)}.

val({_, _, V}) ->
  V.
