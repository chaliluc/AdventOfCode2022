*&---------------------------------------------------------------------*
*& Report ZLC_ADVENT22_DAY1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zlc_advent22_day1.

class yc_day1 definition inheriting from zcl_lc_adv2022.
  public section.
    types:
      begin of ys_cal,
        elf type i,
        cal type i,
      end of ys_cal,
      yts_cal type sorted table of ys_cal with unique key elf.

    methods aggregate_input importing it_input type yc_day1=>yt_string_table optional preferred parameter it_input.
    methods get_elf_with_the_most_calories
      importing i_number_of_elves type i default 1 preferred parameter i_number_of_elves
      returning value(rs_cal)     type ys_cal.

  private section.
    data pts_cal type yts_cal.

endclass.


*&---------------------------------------------------------------------*
data l_input_filename type string.
data lr_day1 type ref to yc_day1.
data ls_elf_with_the_most_calories type yc_day1=>ys_cal.
data lt_input type yc_day1=>yt_string_table.

create object lr_day1.
l_input_filename = lr_day1->get_input_filename( ).
check l_input_filename <> space.

check lr_day1->import_data( exporting i_filename = l_input_filename importing et_data = lt_input ) = 0.
check lines( lt_input ) > 0.

lr_day1->aggregate_input( lt_input ).
ls_elf_with_the_most_calories = lr_day1->get_elf_with_the_most_calories( ).

if ls_elf_with_the_most_calories is initial.
  write: / 'Input error'.
else.
  write: / 'The elf with the most calories is', ls_elf_with_the_most_calories-elf, 'with', ls_elf_with_the_most_calories-cal, 'calories'.
endif.

skip 2.
uline.

clear ls_elf_with_the_most_calories.
ls_elf_with_the_most_calories = lr_day1->get_elf_with_the_most_calories( 3 ).

if ls_elf_with_the_most_calories is initial.
  write: / 'Input error'.
else.
  write: / 'The 3 elves with the most calories carry', ls_elf_with_the_most_calories-cal, 'calories'.
endif.
*&---------------------------------------------------------------------*


class yc_day1 implementation.
  method aggregate_input.
    data l_data type string.
    data l_elf type i value 1.
    data ls_cal type ys_cal.
    loop at it_input into l_data.
      if l_data = space.
        add 1 to l_elf.
        continue.
      endif.
      ls_cal-elf = l_elf.
      ls_cal-cal = l_data.
      collect ls_cal into pts_cal.
    endloop.
  endmethod.

  method get_elf_with_the_most_calories.
    data ls_cal type ys_cal.
    data lt_cal type standard table of ys_cal.
    lt_cal = pts_cal.
    sort lt_cal by cal descending.
    clear rs_cal.
    loop at lt_cal into ls_cal from 1 to i_number_of_elves .
      add ls_cal-cal to rs_cal-cal.
      if i_number_of_elves = 1.
        rs_cal-elf = ls_cal-elf.
      endif.
    endloop.
  endmethod.

endclass.
