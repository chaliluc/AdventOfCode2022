*&---------------------------------------------------------------------*
*& Report ZLC_ADVENT22_DAY6
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zlc_advent22_day6.

class yc_day6 definition inheriting from zcl_lc_adv2022.
  public section.
    constants c_packet type i value 4.
    constants c_message type i value 14.
    methods get_start
      importing i_start_of     type i
                it_input       type yt_string_table
      returning value(r_start) type i.

endclass.


*&---------------------------------------------------------------------*
data l_input_filename type string.
data lr_day6 type ref to yc_day6.
data lt_input type yc_day6=>yt_string_table.
data l_start type i.

create object lr_day6.
l_input_filename = lr_day6->get_input_filename( ).
check l_input_filename <> space.

check lr_day6->import_data( exporting i_filename = l_input_filename importing et_data = lt_input ) = 0.
check lines( lt_input ) > 0.

l_start = lr_day6->get_start( i_start_of = lr_day6->c_packet it_input = lt_input ).
write: / 'Start of first packet in position', l_start.

l_start = lr_day6->get_start( i_start_of = lr_day6->c_message it_input = lt_input ).
write: / 'Start of first message in position', l_start.

*&---------------------------------------------------------------------*


class yc_day6 implementation.
  method get_start.
    data l_line type string.
    data l_pos type i.
    data l_offset type i.
    data lth_char type hashed table of string with unique key table_line.
    r_start = -1.
    read table it_input index 1 into l_line.
    do strlen( l_line ) - i_start_of times.
      l_pos = sy-index - 1.
      clear lth_char.
      do i_start_of times.
        l_offset = l_pos + sy-index - 1.
        insert l_line+l_offset(1) into table lth_char.
        if sy-subrc <> 0.
          exit.
        endif.
      enddo.
      if lines( lth_char ) = i_start_of.
        r_start = l_pos + i_start_of.
        return.
      endif.
    enddo.
  endmethod.

endclass.
