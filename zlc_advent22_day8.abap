*&---------------------------------------------------------------------*
*& Report ZLC_ADVENT22_DAY8
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zlc_advent22_day8.

class yc_day8 definition inheriting from zcl_lc_adv2022.
  public section.
    types: yt_row  type standard table of i with default key,
           yt_grid type standard table of yt_row with default key.
    methods parse_input importing it_input type yt_string_table optional preferred parameter it_input.
    methods get_visible_trees returning value(r_visible_tree) type i.
    methods get_highest_scenic_score returning value(r_score) type i.

  private section.
    data pt_grid type yt_grid.
    data p_col type i.
    data p_row type i.
    methods is_visible
      importing i_row            type i
                i_col            type i
      returning value(r_visible) type i.
    methods get_scenic_score
      importing i_row          type i
                i_col          type i
      returning value(r_score) type i.
endclass.


*&---------------------------------------------------------------------*
data l_input_filename type string.
data lr_day8 type ref to yc_day8.
data lt_input type yc_day8=>yt_string_table.
data l_visible_trees type i.
data l_scenic_score type i.

create object lr_day8.
l_input_filename = lr_day8->get_input_filename( ).
check l_input_filename <> space.

check lr_day8->import_data( exporting i_filename = l_input_filename importing et_data = lt_input ) = 0.
check lines( lt_input ) > 0.

lr_day8->parse_input( lt_input ).
l_visible_trees = lr_day8->get_visible_trees( ).
write: / 'There are', l_visible_trees, 'visible trees'.

l_scenic_score = lr_day8->get_highest_scenic_score( ).
write: / 'The highest scenic score for a tree is', l_scenic_score.

*&---------------------------------------------------------------------*


class yc_day8 implementation.
  method parse_input.
    data l_line type string.
    data l_height type i.
    data l_pos type i.
    data l_number type i.
    data lt_row type yt_row.
    loop at it_input into l_line.
      clear lt_row.
      do strlen( l_line ) times.
        l_pos = sy-index - 1.
        l_number = l_line+l_pos(1).
        append l_number to lt_row.
      enddo.
      append lt_row to pt_grid.
    endloop.
    p_col = strlen( l_line ).
    p_row = lines( pt_grid ).

  endmethod.


  method get_visible_trees.
    data l_row type i.
    data l_col type i.
    r_visible_tree = p_col * 2 + p_row * 2 - 4.
    do p_row - 2 times.
      l_row = 1 + sy-index.
      do p_col - 2 times.
        l_col = 1 + sy-index.
        r_visible_tree = r_visible_tree + is_visible( i_row = l_row i_col = l_col ).
      enddo.
    enddo.

  endmethod.


  method get_highest_scenic_score.
    data l_row type i.
    data l_col type i.
    data l_score type i.
    r_score = 0.
    do p_row - 2 times.
      l_row = 1 + sy-index.
      do p_col - 2 times.
        l_col = 1 + sy-index.
        r_score = nmax( val1 = r_score val2 = get_scenic_score( i_row = l_row i_col = l_col ) ).
      enddo.
    enddo.
  endmethod.


  method is_visible.
    data l_height type i.
    r_visible = 0.
    l_height = pt_grid[ i_row ][ i_col ].

    "Check up
    do i_row - 1 times.
      if l_height > pt_grid[ i_row - sy-index ][ i_col ].
        r_visible = 1.
      else.
        r_visible = 0.
        exit.
      endif.
    enddo.
    if r_visible = 1. return. endif.

    "Check down
    do p_row - i_row times.
      if l_height > pt_grid[ i_row + sy-index ][ i_col ].
        r_visible = 1.
      else.
        r_visible = 0.
        exit.
      endif.
    enddo.
    if r_visible = 1. return. endif.

    "Check left
    do i_col - 1 times.
      if l_height > pt_grid[ i_row ][ i_col - sy-index ].
        r_visible = 1.
      else.
        r_visible = 0.
        exit.
      endif.
    enddo.
    if r_visible = 1. return. endif.

    "Check right
    do p_col - i_col times.
      if l_height > pt_grid[ i_row ][ i_col + sy-index ].
        r_visible = 1.
      else.
        r_visible = 0.
        exit.
      endif.
    enddo.

  endmethod.


  method get_scenic_score.
    data l_height type i.
    data l_up type i.
    data l_down type i.
    data l_left type i.
    data l_right type i.

    l_height = pt_grid[ i_row ][ i_col ].

    "Check up
    do i_row - 1 times.
      add 1 to l_up.
      if l_height <= pt_grid[ i_row - sy-index ][ i_col ].
        exit.
      endif.
    enddo.

    "Check down
    do p_row - i_row times.
      add 1 to l_down.
      if l_height <= pt_grid[ i_row + sy-index ][ i_col ].
        exit.
      endif.
    enddo.

    "Check left
    do i_col - 1 times.
      add 1 to l_left.
      if l_height <= pt_grid[ i_row ][ i_col - sy-index ].
        exit.
      endif.
    enddo.

    "Check right
    do p_col - i_col times.
      add 1 to l_right.
      if l_height <= pt_grid[ i_row ][ i_col + sy-index ].
        exit.
      endif.
    enddo.

    r_score = l_up * l_down * l_left * l_right.

  endmethod.

endclass.
