*&---------------------------------------------------------------------*
*& Report ZLC_ADVENT22_DAY11
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zlc_advent22_day11.

class yc_monkey definition.
  public section.
    types:
      yworry  type p length 14 decimals 0,
      yt_item type standard table of yworry with default key.
    class-methods run_inspection importing i_round type i default 20 preferred parameter i_round.
    class-methods throw_to_monkey
      importing i_monkey type i
                i_item   type yworry.
    class-methods get_monkey_business returning value(r_business) type i.
    methods constructor
      importing it_item        type yt_item
                i_operator     type string
                i_oper_value   type i
                i_div          type i
                i_monkey_true  type i
                i_monkey_false type i.
    methods inspect.
    methods get_number_of_inspections returning value(r_inspection) type i.
    methods add_item importing i_item type yworry optional preferred parameter i_item.

  private section.
    class-data pt_monkey type standard table of ref to yc_monkey with default key.
    data p_inspections type i.
    data pt_item type yt_item.
    data p_operator type string.
    data p_oper_value type i.
    data p_div type i.
    data p_monkey_true type i.
    data p_monkey_false type i.

endclass.


class yc_day11 definition inheriting from zcl_lc_adv2022.
  public section.
    methods parse_input importing it_input type yt_string_table optional preferred parameter it_input.
    methods get_monkey_business
      importing i_round           type i default 20 preferred parameter i_round
      returning value(r_business) type i.

endclass.


*&---------------------------------------------------------------------*
data l_input_filename type string.
data lr_day11 type ref to yc_day11.
data lt_input type yc_day11=>yt_string_table.
data l_monkey_business type i.

create object lr_day11.
l_input_filename = lr_day11->get_input_filename( ).
check l_input_filename <> space.

check lr_day11->import_data( exporting i_filename = l_input_filename importing et_data = lt_input ) = 0.
check lines( lt_input ) > 0.

lr_day11->parse_input( lt_input ).
l_monkey_business = lr_day11->get_monkey_business( 20 ).
write: / 'Monkey business after 20 rounds', l_monkey_business.


*&---------------------------------------------------------------------*


class yc_day11 implementation.
  method parse_input.
    data l_line type string.
    data l_part type string.
    data l_dummy type string.
    data lt_parts type standard table of string with default key.
    data l_item type yc_monkey=>yworry.
    data lt_item type yc_monkey=>yt_item.
    data l_operator type string.
    data l_oper_value type i.
    data l_oper_value_s type string.
    data l_div type i.
    data l_monkey_true type i.
    data l_monkey_false type i.
    data lr_monkey type ref to yc_monkey.
    loop at it_input into l_line.
      if l_line cp 'Monkey*'.
        clear lt_item.
        clear l_operator .
        clear l_oper_value_s.
        clear l_div.
        clear l_monkey_true.
        clear l_monkey_false.

      elseif l_line cp '*Starting items*'.
        condense l_line no-gaps.
        split l_line at ':' into l_dummy l_part.
        split l_part at ',' into table lt_parts.
        loop at lt_parts into l_part.
          l_item = l_part.
          append l_part to lt_item.
        endloop.

      elseif l_line cp '*Operation*'.
        split l_line at space into table lt_parts.
        l_operator = lt_parts[ lines( lt_parts ) - 1 ].
        l_oper_value_s = lt_parts[ lines( lt_parts ) ].
        l_oper_value = cond #( when l_oper_value_s = 'old' then -1 else l_oper_value_s ).

      elseif l_line cp '*Test*'.
        split l_line at space into table lt_parts.
        l_div = lt_parts[ lines( lt_parts ) ].

      elseif l_line cp '*If true*'.
        split l_line at space into table lt_parts.
        l_monkey_true = lt_parts[ lines( lt_parts ) ].

      elseif l_line cp '*If false*'.
        split l_line at space into table lt_parts.
        l_monkey_false = lt_parts[ lines( lt_parts ) ].
        create object lr_monkey
          exporting
            it_item        = lt_item
            i_operator     = l_operator
            i_oper_value   = l_oper_value
            i_div          = l_div
            i_monkey_true  = l_monkey_true
            i_monkey_false = l_monkey_false.

      endif.
    endloop.
  endmethod.


  method get_monkey_business.
    yc_monkey=>run_inspection( i_round ).
    r_business = yc_monkey=>get_monkey_business(  ).
  endmethod.

endclass.


class yc_monkey implementation.
  method throw_to_monkey.
    data lr_monkey type ref to yc_monkey.
    read table pt_monkey index i_monkey + 1 into lr_monkey.
    lr_monkey->add_item( i_item ).
  endmethod.


  method run_inspection.
    data lr_monkey type ref to yc_monkey.
    do i_round times.
      loop at pt_monkey into lr_monkey.
        lr_monkey->inspect( ).
      endloop.
    enddo.
  endmethod.


  method get_monkey_business.
    data lr_monkey type ref to yc_monkey.
    data lt_business type standard table of i with default key.
    clear r_business.
    loop at pt_monkey into lr_monkey.
      append lr_monkey->get_number_of_inspections(  ) to lt_business.
    endloop.
    sort lt_business descending.
    r_business = lt_business[ 1 ] * lt_business[ 2 ].
  endmethod.

  method constructor.
    clear p_inspections.
    pt_item = it_item.
    p_operator = i_operator.
    p_oper_value = i_oper_value.
    p_div = i_div.
    p_monkey_true = i_monkey_true.
    p_monkey_false = i_monkey_false.
    append me to pt_monkey.
  endmethod.


  method inspect.
    data l_worry_level type yworry.
    data l_oper_value type yworry.
    while lines( pt_item ) > 0.
      read table pt_item index 1 into l_worry_level.
      l_oper_value = cond #( when p_oper_value = -1 then l_worry_level else p_oper_value ).
      try.
          case p_operator.
            when '+'. l_worry_level = l_worry_level + l_oper_value.
            when '-'. l_worry_level = l_worry_level - l_oper_value.
            when '*'. l_worry_level = l_worry_level * l_oper_value.
            when '/'. l_worry_level = l_worry_level / l_oper_value.
          endcase.
        catch cx_sy_arithmetic_overflow.
          if 1 = 1. endif.
      endtry.

      l_worry_level = trunc( l_worry_level / 3 ).

      if frac( l_worry_level / p_div ) = 0.
        throw_to_monkey( i_monkey = p_monkey_true i_item = l_worry_level ).
      else.
        throw_to_monkey( i_monkey = p_monkey_false i_item = l_worry_level ).
      endif.

      add 1 to p_inspections.
      delete pt_item index 1.

    endwhile.
  endmethod.


  method get_number_of_inspections.
    r_inspection = p_inspections.
  endmethod.


  method add_item.
    append i_item to pt_item.
  endmethod.

endclass.
