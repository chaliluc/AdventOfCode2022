*&---------------------------------------------------------------------*
*& Report ZLC_ADVENT22_DAY3
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zlc_advent22_day3.

class yc_day3 definition inheriting from zcl_lc_adv2022.
  public section.
    methods get_priorities
      importing it_input          type yt_string_table optional preferred parameter it_input
      returning value(r_priority) type i.
    methods get_badges_priorities
      importing it_input          type yt_string_table optional preferred parameter it_input
      returning value(r_priority) type i.

  private section.
    constants c_priority type string value ' abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'.
    methods get_priority
      importing i_comp1           type string
                i_comp2           type string
      returning value(r_priority) type i.
    methods get_badge_priority
      importing i_line1           type string
                i_line2           type string
                i_line3           type string
      returning value(r_priority) type i.

endclass.


*&---------------------------------------------------------------------*
data l_input_filename type string.
data lr_day3 type ref to yc_day3.
data lt_input type yc_day3=>yt_string_table.
data l_priorities type i.

create object lr_day3.
l_input_filename = lr_day3->get_input_filename( ).
check l_input_filename <> space.

check lr_day3->import_data( exporting i_filename = l_input_filename importing et_data = lt_input ) = 0.
check lines( lt_input ) > 0.

l_priorities = lr_day3->get_priorities( lt_input ).
write: / 'The sum of the priorities is', l_priorities.

l_priorities = lr_day3->get_badges_priorities( lt_input ).
write: / 'The sum of the badges priorities is', l_priorities.
*&---------------------------------------------------------------------*


class yc_day3 implementation.
  method get_priorities.
    data l_input type string.
    data l_length type i.
    data l_comp1 type string.
    data l_comp2 type string.
    r_priority = 0.
    loop at it_input into l_input.
      l_length = strlen( l_input ) / 2.
      l_comp1 = l_input(l_length).
      l_comp2 = l_input+l_length.
      r_priority = r_priority + get_priority( i_comp1 = l_comp1 i_comp2 = l_comp2 ).
    endloop.
  endmethod.


  method get_badges_priorities.
    data l_line1 type string.
    data l_line2 type string.
    data l_line3 type string.
    data l_index type sy-index.
    r_priority = 0.
    do lines( it_input ) / 3 times.
      l_index = sy-index - 1.
      read table it_input index l_index * 3  + 1 into l_line1.
      read table it_input index l_index * 3  + 2 into l_line2.
      read table it_input index l_index * 3  + 3 into l_line3.
      r_priority = r_priority + get_badge_priority( i_line1 = l_line1 i_line2 = l_line2 i_line3 = l_line3 ).
    enddo.
  endmethod.


  method get_priority.
    data l_length type i.
    data l_pos type i.
    r_priority = 0.
    l_length = strlen( i_comp1 ).
    do l_length times.
      l_pos = sy-index - 1.
      find first occurrence of i_comp1+l_pos(1) in i_comp2.
      if sy-subrc = 0.
        find first occurrence of i_comp1+l_pos(1) in c_priority match offset r_priority.
        return.
      endif.
    enddo.
  endmethod.


  method get_badge_priority.
    data l_length type i.
    data l_pos type i.
    r_priority = 0.
    l_length = strlen( i_line1 ).
    do l_length times.
      l_pos = sy-index - 1.
      find first occurrence of i_line1+l_pos(1) in i_line2.
      if sy-subrc = 0.
        find first occurrence of i_line1+l_pos(1) in i_line3.
        if sy-subrc = 0.
          find first occurrence of i_line1+l_pos(1) in c_priority match offset r_priority.
          return.
        endif.
      endif.
    enddo.
  endmethod.

endclass.
