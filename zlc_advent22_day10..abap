*&---------------------------------------------------------------------*
*& Report ZLC_ADVENT22_DAY10
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zlc_advent22_day10.

class yc_day10 definition inheriting from zcl_lc_adv2022.
  public section.
    types: begin of ys_instruction,
             oper  type string,
             value type i,
           end of ys_instruction,
           yt_instruction type standard table of ys_instruction with default key,
           yt_screen      type standard table of string with default key.

    methods parse_input importing it_input type yt_string_table optional preferred parameter it_input.
    methods get_signal_strength
      importing i_cycles                 type i optional preferred parameter i_cycles
      returning value(r_signal_strength) type i.
    methods render_screen returning value(rt_screen) type yt_screen.

  private section.
    data x type i.
    data pt_instruction type yt_instruction.
    methods get_sprite returning value(r_sprite) type string.

endclass.


*&---------------------------------------------------------------------*
data l_input_filename type string.
data lr_day10 type ref to yc_day10.
data lt_input type yc_day10=>yt_string_table.
data l_signal_strength type i.
data lt_screen type yc_day10=>yt_screen.
data l_line type string.

create object lr_day10.
l_input_filename = lr_day10->get_input_filename( ).
check l_input_filename <> space.

check lr_day10->import_data( exporting i_filename = l_input_filename importing et_data = lt_input ) = 0.
check lines( lt_input ) > 0.

lr_day10->parse_input( lt_input ).
l_signal_strength = lr_day10->get_signal_strength( 6 ).
write: / 'Total signal strength', l_signal_strength.

skip 2.
lt_screen = lr_day10->render_screen( ).
loop at lt_screen into l_line.
  write: / l_line.
endloop.

*&---------------------------------------------------------------------*


class yc_day10 implementation.
  method parse_input.
    data l_line type string.
    data l_oper type string.
    data l_value type string.
    data ls_instruction type ys_instruction.
    loop at it_input into l_line.
      split l_line at space into l_oper l_value.
      case l_oper.
        when 'noop'.
          ls_instruction-oper = l_oper.
          ls_instruction-value = 0.
          append ls_instruction to pt_instruction.

        when 'addx'.
          ls_instruction-oper = 'skip'.
          ls_instruction-value = 0.
          append ls_instruction to pt_instruction.
          ls_instruction-oper = l_oper.
          ls_instruction-value = l_value.
          append ls_instruction to pt_instruction.

        when others.
          "do nothing

      endcase.

    endloop.
  endmethod.


  method get_signal_strength.
    data ls_instruction type ys_instruction.
    data l_cycle type i.
    x = 1.
    r_signal_strength = 0.
    loop at pt_instruction into ls_instruction.
      if ( sy-tabix - 20 ) mod 40 = 0.
        r_signal_strength = r_signal_strength + x * sy-tabix.
        add 1 to l_cycle.
      endif.

      case ls_instruction-oper.
        when 'addx'.
          add ls_instruction-value to x.

        when others.
          "do nothing

      endcase.

      if l_cycle = i_cycles.
        return.
      endif.

    endloop.

  endmethod.


  method render_screen.
    data l_line type string.
    data l_pos type i.
    data l_sprite type string.
    data ls_instruction type ys_instruction.
    clear rt_screen.
    x = 1.
    loop at pt_instruction into ls_instruction.
      l_pos = ( sy-tabix - 1 ) mod 40.
      l_sprite = get_sprite( ).
      l_line = |{ l_line }{ l_sprite+l_pos(1) }|.

      case ls_instruction-oper.
        when 'addx'.
          add ls_instruction-value to x.

        when others.
          "do nothing

      endcase.

      if sy-tabix mod 40 = 0.
        append l_line to rt_screen.
        clear l_line.
      endif.

    endloop.
  endmethod.


  method get_sprite.
    data l_index type sy-index.
    clear r_sprite.
    do 40 times.
      l_index = sy-index - 1.
      r_sprite = |{ r_sprite }{ cond #( when l_index >= ( x - 1 ) and l_index <= x + 1 then '#' else '.' ) }|.
    enddo.
  endmethod.

endclass.
