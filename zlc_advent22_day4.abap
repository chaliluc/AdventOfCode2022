*&---------------------------------------------------------------------*
*& Report ZLC_ADVENT22_DAY4
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zlc_advent22_day4.

class yc_day4 definition inheriting from zcl_lc_adv2022.
  public section.
    methods get_fully_contained_pairs
      importing it_input       type yt_string_table optional preferred parameter it_input
      returning value(r_pairs) type i.

    methods get_overlap_pairs
      importing it_input       type yt_string_table optional preferred parameter it_input
      returning value(r_pairs) type i.

  private section.
    methods is_assignment_contained
      importing
                i_ass1             type string
                i_ass2             type string
      returning value(r_contained) type abap_bool.

    methods make_assignment_string
      importing i_assignment        type string optional preferred parameter i_assignment
      returning value(r_assignment) type string.

    methods is_assignment_overlap
      importing
                i_ass1           type string
                i_ass2           type string
      returning value(r_overlap) type abap_bool.

endclass.


*&---------------------------------------------------------------------*
data l_input_filename type string.
data lr_day4 type ref to yc_day4.
data lt_input type yc_day4=>yt_string_table.
data l_pairs type i.

create object lr_day4.
l_input_filename = lr_day4->get_input_filename( ).
check l_input_filename <> space.

check lr_day4->import_data( exporting i_filename = l_input_filename importing et_data = lt_input ) = 0.
check lines( lt_input ) > 0.

l_pairs = lr_day4->get_fully_contained_pairs( lt_input ).
write: / 'Assignments pairs with fully contained ranges:', l_pairs.

l_pairs = lr_day4->get_overlap_pairs( lt_input ).
write: / 'Assignments pairs with some overlap:', l_pairs.

*&---------------------------------------------------------------------*


class yc_day4 implementation.
  method get_fully_contained_pairs.
    data l_pair type string.
    data l_assignment1 type string.
    data l_assignment2 type string.
    clear r_pairs.
    loop at it_input into l_pair.
      split l_pair at ',' into l_assignment1 l_assignment2.
      r_pairs = r_pairs + cond #( when is_assignment_contained( i_ass1 = l_assignment1 i_ass2 = l_assignment2 ) = abap_true then 1 else 0 ).
    endloop.
  endmethod.


  method get_overlap_pairs.
    data l_pair type string.
    data l_assignment1 type string.
    data l_assignment2 type string.
    clear r_pairs.
    loop at it_input into l_pair.
      split l_pair at ',' into l_assignment1 l_assignment2.
      r_pairs = r_pairs + cond #( when is_assignment_overlap( i_ass1 = l_assignment1 i_ass2 = l_assignment2 ) = abap_true then 1 else 0 ).
    endloop.
  endmethod.


  method is_assignment_contained.
    data l_assignment1 type string.
    data l_assignment2 type string.
    data l_test type string.
    clear r_contained.
    l_test = l_assignment1 = make_assignment_string( i_ass1 ).
    l_assignment2 = make_assignment_string( i_ass2 ).
    overlay l_test with l_assignment2.
    if l_test = l_assignment1.
      r_contained = abap_true.
    else.
      l_test = l_assignment2.
      overlay l_test with l_assignment1.
      if l_test = l_assignment2.
        r_contained = abap_true.
      endif.
    endif.
  endmethod.


  method make_assignment_string.
    data l_from type i.
    data l_from_s type string.
    data l_to type i.
    data l_to_s type string.
    data l_id type numc2.
    clear r_assignment.
    split i_assignment at '-' into l_from_s l_to_s.
    l_from = l_from_s.
    l_to = l_to_s.
    do 99 times.
      if sy-index >= l_from and sy-index <= l_to.
        l_id = sy-index.
        r_assignment = |{ r_assignment }{ l_id }|.
      else.
        r_assignment = |{ r_assignment }  |.
      endif.
    enddo.
  endmethod.


  method is_assignment_overlap.
    data l_from type i.
    data l_from_s type string.
    data l_to type i.
    data l_to_s type string.
    data l_id type numc2.
    data lth_assign type hashed table of i with unique key table_line.
    clear r_overlap.
    split i_ass1 at '-' into l_from_s l_to_s.
    l_from = l_from_s.
    l_to = l_to_s.
    do l_to - l_from + 1 times.
      insert sy-index + l_from into table lth_assign.
    enddo.
    split i_ass2 at '-' into l_from_s l_to_s.
    l_from = l_from_s.
    l_to = l_to_s.
    do l_to - l_from + 1 times.
      insert sy-index + l_from into table lth_assign.
      if sy-subrc <> 0.
        r_overlap = abap_true.
        return.
      endif.
    enddo.
  endmethod.

endclass.
