*&---------------------------------------------------------------------*
*& Report ZLC_ADVENT22_DAY5
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zlc_advent22_day5.

class yc_cratemover_9000 definition.
  public section.
    types yt_crate type standard table of char1 with non-unique key table_line.
    methods get_crate returning value(r_crate) type char1.
    methods put_crate importing i_crate type char1 optional preferred parameter i_crate.
    methods get_top_create_value returning value(r_value) type char1.

  protected section.
    data pt_stack type yt_crate.
    data p_top_crate type i.

endclass.


class yc_cratemover_9001 definition inheriting from yc_cratemover_9000.
  public section.
    methods get_crates importing i_crates type i optional preferred parameter i_crates returning value(rt_crate) type yt_crate.
    methods put_crates importing it_crate type yt_crate optional preferred parameter it_crate.

endclass.


class yc_day5 definition inheriting from zcl_lc_adv2022.
  public section.
    types:
      begin of ys_move,
        qty  type i,
        from type i,
        to   type i,
      end of ys_move,
      yt_move type standard table of ys_move.

    methods parse_input importing it_input type yt_string_table optional preferred parameter it_input.
    methods move_crates.
    methods move_crates_9001.
    methods get_top_crates returning value(r_top_crates) type string.
    methods get_top_crates_9001 returning value(r_top_crates) type string.

  private section.
    data pt_stack type standard table of ref to yc_cratemover_9000.
    data pt_stack_9001 type standard table of ref to yc_cratemover_9001.
    data pt_move type yt_move.

endclass.



*&---------------------------------------------------------------------*
data l_input_filename type string.
data lr_day5 type ref to yc_day5.
data lt_input type yc_day5=>yt_string_table.
data l_response type string.


create object lr_day5.
l_input_filename = lr_day5->get_input_filename( ).
check l_input_filename <> space.

check lr_day5->import_data( exporting i_filename = l_input_filename importing et_data = lt_input ) = 0.
check lines( lt_input ) > 0.

lr_day5->parse_input( lt_input ).
lr_day5->move_crates( ).
lr_day5->move_crates_9001( ).
l_response = lr_day5->get_top_crates( ).
write: / 'Top crates after move are', l_response.
l_response = lr_day5->get_top_crates_9001( ).
write: / 'Top crates after move CrateMover 9001 are', l_response.

*&---------------------------------------------------------------------*


class yc_cratemover_9000 implementation.
  method get_crate.
    clear r_crate.
    check p_top_crate > 0.
    read table pt_stack index p_top_crate into r_crate.
    delete  pt_stack index p_top_crate.
    p_top_crate = lines( pt_stack ).
  endmethod.


  method put_crate.
    append i_crate to pt_stack.
    p_top_crate = lines( pt_stack ).
  endmethod.


  method get_top_create_value.
    clear r_value.
    check p_top_crate > 0.
    read table pt_stack index p_top_crate into r_value.
  endmethod.
endclass.


class yc_cratemover_9001 implementation.
  method get_crates.
    check i_crates <= p_top_crate.
    append lines of pt_stack from p_top_crate - i_crates + 1 to p_top_crate to rt_crate.
    do i_crates times.
      delete pt_stack index p_top_crate.
      p_top_crate = lines( pt_stack ).
    enddo.
  endmethod.


  method put_crates.
    append lines of it_crate to pt_stack.
    p_top_crate = lines( pt_stack ).
  endmethod.

endclass.


class yc_day5 implementation.
  method parse_input.
    data l_line type string.
    data l_crate type char1.
    data l_stacks type i.
    data l_pos type i.
    data l_break type i.
    data lt_parts type standard table of string.
    data lr_cratemover_9000 type ref to yc_cratemover_9000.
    data lr_cratemover_9001 type ref to yc_cratemover_9001.
    data ls_move type ys_move.

    read table it_input with key table_line = '' transporting no fields.
    l_break = sy-tabix.

    do l_break - 1 times.
      clear lt_parts.
      read table it_input into l_line index l_break - sy-index.
      if sy-index = 1.
        condense l_line.
        split l_line at space into table lt_parts.
        l_stacks = lines(  lt_parts ).
        do l_stacks times.
          create object lr_cratemover_9000.
          append lr_cratemover_9000 to pt_stack.
          create object lr_cratemover_9001.
          append lr_cratemover_9001 to pt_stack_9001.
        enddo.
      else.
        do l_stacks times.
          l_pos = ( sy-index - 1 ) * 4  + 1.
          l_crate = l_line+l_pos(1).
          if l_crate <> space.
            read table pt_stack into lr_cratemover_9000 index sy-index.
            if sy-subrc = 0.
              lr_cratemover_9000->put_crate( l_crate ).
            endif.
            read table pt_stack_9001 into lr_cratemover_9001 index sy-index.
            if sy-subrc = 0.
              lr_cratemover_9001->put_crate( l_crate ).
            endif.
          endif.
        enddo.
      endif.
    enddo.

    loop at it_input into l_line from l_break + 1.
      clear lt_parts.
      clear ls_move.
      split l_line at space into table lt_parts.
      if lines( lt_parts ) = 6.
        read table lt_parts into ls_move-qty index 2.
        read table lt_parts into ls_move-from index 4.
        read table lt_parts into ls_move-to index 6.
        append ls_move to pt_move.
      endif.
    endloop.
  endmethod.


  method move_crates.
    data ls_move type ys_move.
    data lr_from_stack type ref to yc_cratemover_9000.
    data lr_to_stack type ref to yc_cratemover_9000.
    loop at pt_move into ls_move.
      read table pt_stack index ls_move-from into lr_from_stack.
      read table pt_stack index ls_move-to into lr_to_stack.
      do ls_move-qty times.
        lr_to_stack->put_crate( lr_from_stack->get_crate( ) ).
      enddo.
    endloop.
  endmethod.


  method move_crates_9001.
    data ls_move type ys_move.
    data lr_from_stack type ref to yc_cratemover_9001.
    data lr_to_stack type ref to yc_cratemover_9001.
    loop at pt_move into ls_move.
      read table pt_stack_9001 index ls_move-from into lr_from_stack.
      read table pt_stack_9001 index ls_move-to into lr_to_stack.
      lr_to_stack->put_crates( lr_from_stack->get_crates( ls_move-qty ) ).
    endloop.
  endmethod.


  method get_top_crates.
    data lr_stack type ref to yc_cratemover_9000.
    clear r_top_crates.
    loop at pt_stack into lr_stack.
      r_top_crates = |{ r_top_crates }{ lr_stack->get_top_create_value( ) }|.
    endloop.
    condense r_top_crates no-gaps.
  endmethod.


  method get_top_crates_9001.
    data lr_stack type ref to yc_cratemover_9001.
    clear r_top_crates.
    loop at pt_stack_9001 into lr_stack.
      r_top_crates = |{ r_top_crates }{ lr_stack->get_top_create_value( ) }|.
    endloop.
    condense r_top_crates no-gaps.
  endmethod.

endclass.
