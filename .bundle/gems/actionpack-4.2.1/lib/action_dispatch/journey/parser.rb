#
# DO NOT MODIFY!!!!
# This file is automatically generated by Racc 1.4.11
# from Racc grammer file "".
#

require 'racc/parser.rb'


require 'action_dispatch/journey/parser_extras'
module ActionDispatch
  module Journey
    class Parser < Racc::Parser
##### State transition tables begin ###

racc_action_table = [
    13,    15,    14,     7,    21,    16,     8,    19,    13,    15,
    14,     7,    17,    16,     8,    13,    15,    14,     7,    24,
    16,     8,    13,    15,    14,     7,    19,    16,     8 ]

racc_action_check = [
     2,     2,     2,     2,    17,     2,     2,     2,     0,     0,
     0,     0,     1,     0,     0,    19,    19,    19,    19,    20,
    19,    19,     7,     7,     7,     7,    22,     7,     7 ]

racc_action_pointer = [
     6,    12,    -2,   nil,   nil,   nil,   nil,    20,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,     4,   nil,    13,
    13,   nil,    17,   nil,   nil ]

racc_action_default = [
   -19,   -19,    -2,    -3,    -4,    -5,    -6,   -19,   -10,   -11,
   -12,   -13,   -14,   -15,   -16,   -17,   -18,   -19,    -1,   -19,
   -19,    25,    -8,    -9,    -7 ]

racc_goto_table = [
     1,    22,    18,    23,   nil,   nil,   nil,    20 ]

racc_goto_check = [
     1,     2,     1,     3,   nil,   nil,   nil,     1 ]

racc_goto_pointer = [
   nil,     0,   -18,   -16,   nil,   nil,   nil,   nil,   nil,   nil,
   nil ]

racc_goto_default = [
   nil,   nil,     2,     3,     4,     5,     6,     9,    10,    11,
    12 ]

racc_reduce_table = [
  0, 0, :racc_error,
  2, 11, :_reduce_1,
  1, 11, :_reduce_2,
  1, 11, :_reduce_none,
  1, 12, :_reduce_none,
  1, 12, :_reduce_none,
  1, 12, :_reduce_none,
  3, 15, :_reduce_7,
  3, 13, :_reduce_8,
  3, 13, :_reduce_9,
  1, 16, :_reduce_10,
  1, 14, :_reduce_none,
  1, 14, :_reduce_none,
  1, 14, :_reduce_none,
  1, 14, :_reduce_none,
  1, 19, :_reduce_15,
  1, 17, :_reduce_16,
  1, 18, :_reduce_17,
  1, 20, :_reduce_18 ]

racc_reduce_n = 19

racc_shift_n = 25

racc_token_table = {
  false => 0,
  :error => 1,
  :SLASH => 2,
  :LITERAL => 3,
  :SYMBOL => 4,
  :LPAREN => 5,
  :RPAREN => 6,
  :DOT => 7,
  :STAR => 8,
  :OR => 9 }

racc_nt_base = 10

racc_use_result_var = false

Racc_arg = [
  racc_action_table,
  racc_action_check,
  racc_action_default,
  racc_action_pointer,
  racc_goto_table,
  racc_goto_check,
  racc_goto_default,
  racc_goto_pointer,
  racc_nt_base,
  racc_reduce_table,
  racc_token_table,
  racc_shift_n,
  racc_reduce_n,
  racc_use_result_var ]

Racc_token_to_s_table = [
  "$end",
  "error",
  "SLASH",
  "LITERAL",
  "SYMBOL",
  "LPAREN",
  "RPAREN",
  "DOT",
  "STAR",
  "OR",
  "$start",
  "expressions",
  "expression",
  "or",
  "terminal",
  "group",
  "star",
  "symbol",
  "literal",
  "slash",
  "dot" ]

Racc_debug_parser = false

##### State transition tables end #####

# reduce 0 omitted

def _reduce_1(val, _values)
 Cat.new(val.first, val.last)
end

def _reduce_2(val, _values)
 val.first
end

# reduce 3 omitted

# reduce 4 omitted

# reduce 5 omitted

# reduce 6 omitted

def _reduce_7(val, _values)
 Group.new(val[1])
end

def _reduce_8(val, _values)
 Or.new([val.first, val.last])
end

def _reduce_9(val, _values)
 Or.new([val.first, val.last])
end

def _reduce_10(val, _values)
 Star.new(Symbol.new(val.last))
end

# reduce 11 omitted

# reduce 12 omitted

# reduce 13 omitted

# reduce 14 omitted

def _reduce_15(val, _values)
 Slash.new('/')
end

def _reduce_16(val, _values)
 Symbol.new(val.first)
end

def _reduce_17(val, _values)
 Literal.new(val.first)
end

def _reduce_18(val, _values)
 Dot.new(val.first)
end

def _reduce_none(val, _values)
  val[0]
end

    end   # class Parser
    end   # module Journey
  end   # module ActionDispatch
