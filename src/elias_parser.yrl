Nonterminals
array
array_end
array_inner
array_start
array_value
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
single_comments
string
symbol
value
value_sub
whitespace
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
comment_close
comment_open
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
.

Rootsymbol root.

symbol -> array_close : val('$1').
symbol -> array_open : val('$1').
symbol -> back_slash : val('$1').
symbol -> bracket_close : val('$1').
symbol -> bracket_open : val('$1').
symbol -> colon : val('$1').
symbol -> comma : val('$1').
symbol -> dash : val('$1').
symbol -> digit : val('$1').
symbol -> double_quote : val('$1').
symbol -> equals : val('$1').
symbol -> forward_slash : val('$1').
symbol -> pound : val('$1').
symbol -> semi_colon : val('$1').
symbol -> single_quote : val('$1').
symbol -> space : val('$1').
symbol -> star : val('$1').
symbol -> word : val('$1').

root -> block_start assignments block_end : '$2'.
root -> assignments : '$1'.

whitespace -> newline whitespace : [val('$1') | '$2'].
whitespace -> space whitespace : [val('$1') | '$2'].
whitespace -> comments whitespace : ['$1' | '$2'].
whitespace -> newline : [val('$1')].
whitespace -> space : [val('$1')].
whitespace -> comments : ['$1'].

array -> array_start array_end : {array, []}.
array -> array_start whitespace array_end : {array, []}.
array -> array_start array_inner array_end : {array, '$2'}.
array -> array_start array_inner whitespace array_end : {array, '$2'}.

array_end -> array_close : ']'.

array_inner -> array_value comma array_inner : ['$1' | '$3'].
array_inner -> space array_inner : '$2'.
array_inner -> newline array_inner : '$2'.
array_inner -> comments array_inner : ['$1' | '$2'].
array_inner -> array_value : ['$1'].

array_start -> array_open : '['.

array_value -> block : '$1'.
array_value -> string : '$1'.
array_value -> value : '$1'.
array_value -> digit : integer('$1').

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
comments -> pound single_comments newline : {comments, '$2'}.

single_comments -> symbol single_comments : ['$1' | '$2'].
single_comments -> comment_close single_comments : [val('$1') | '$2'].
single_comments -> comment_open single_comments : [val('$1') | '$2'].
single_comments -> symbol : ['$1'].
single_comments -> comment_close : [val('$1')].
single_comments -> comment_open : [val('$1')].

multi_comments -> symbol multi_comments : ['$1' | '$2'].
multi_comments -> newline multi_comments : [val('$1') | '$2'].
multi_comments -> symbol : ['$1'].
multi_comments -> newline : [val('$1')].

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

value -> value_sub : {value, join('$1')}.

value_sub -> word value_sub : [val('$1') | '$2'].
value_sub -> dash value_sub : [val('$1') | '$2'].
value_sub -> digit value_sub : [val('$1') | '$2'].
value_sub -> word : [val('$1')].

words -> word words : [val('$1') | '$2'].
words -> back_slash quotes words : [val('$1'), '$2' | '$3'].
words -> back_slash word words : [val('$1'), val('$2') | '$3'].
words -> equals words : [val('$1') | '$2'].
words -> single_quote words : [val('$1') | '$2'].
words -> bracket_close words : [val('$1') | '$2'].
words -> bracket_open words : [val('$1') | '$2'].
words -> space words : [val('$1') | '$2'].
words -> star words : [val('$1') | '$2'].
words -> pound words : [val('$1') | '$2'].
words -> dash words : [val('$1') | '$2'].
words -> digit words : [val('$1') | '$2'].
words -> colon words : [val('$1') | '$2'].
words -> forward_slash words : [val('$1') | '$2'].
words -> comment_open words : [val('$1') | '$2'].
words -> comment_close words : [val('$1') | '$2'].
words -> '$empty' : [].

Expect 5.

Erlang code.

integer(V) ->
  Digits = val(V),
  {integer, erlang:list_to_integer(Digits)}.

val({_, _, V}) ->
  V.

join([]) ->
  [];

join([Str | Strs]) ->
  Str ++ join(Strs).
