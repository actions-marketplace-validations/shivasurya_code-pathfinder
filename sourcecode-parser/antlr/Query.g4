grammar Query;
query: predicate_declarations? FROM select_list (WHERE expression)?;
predicate_declarations: predicate_declaration+;
predicate_declaration: PREDICATE predicate_name '(' parameter_list? ')' '{' expression '}';
predicate_name: IDENTIFIER;
parameter_list: parameter (',' parameter)*;
parameter: type IDENTIFIER;
type: IDENTIFIER;
select_list: select_item (',' select_item)*;
select_item: entity AS alias;
entity: IDENTIFIER;
alias: IDENTIFIER;
expression: orExpression;
orExpression: andExpression ( '||' andExpression )*;
andExpression: equalityExpression ( '&&' equalityExpression )*;
equalityExpression: relationalExpression ( ( '==' | '!=' ) relationalExpression )*;
relationalExpression: additiveExpression ( ( '<' | '>' | '<=' | '>=' ) additiveExpression )*;
additiveExpression: multiplicativeExpression ( ( '+' | '-' ) multiplicativeExpression )*;
multiplicativeExpression: unaryExpression ( ( '*' | '/' ) unaryExpression )*;
unaryExpression: ( '!' | '-' ) unaryExpression | primary;
primary: operand | predicate_invocation | '(' expression ')';
operand: value | variable | alias '.' method_chain | '[' value_list ']';
method_chain: method_or_variable ('.' method_or_variable)*;
method_or_variable: method | variable | predicate_invocation;
method: IDENTIFIER '(' argument_list? ')';
variable: IDENTIFIER;
predicate_invocation: predicate_name '(' argument_list? ')';
argument_list: expression (',' expression)*;
comparator: '==' | '!=' | '<' | '>' | '<=' | '>=' | 'LIKE' | 'in';
value: STRING | NUMBER | STRING_WITH_WILDCARD;
value_list: value (',' value)*;
STRING: '"' ( ~('"' | '\\') | '\\' . )* '"';
STRING_WITH_WILDCARD: '"' ( ~('"' | '\\') | '\\' . | '%' )* '"';
NUMBER: [0-9]+ ('.' [0-9]+)?;
PREDICATE: 'predicate';
FROM: 'FROM';
WHERE: 'WHERE';
AS: 'AS';
IDENTIFIER: [a-zA-Z_][a-zA-Z0-9_]*;
WS: [ \t\r\n]+ -> skip;