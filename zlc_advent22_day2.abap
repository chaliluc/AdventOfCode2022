*&---------------------------------------------------------------------*
*& Report ZLC_ADVENT22_DAY2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zlc_advent22_day2.

class yc_day2 definition inheriting from zcl_lc_adv2022.
  public section.
    methods get_total_score
      importing it_input type yt_string_table optional preferred parameter it_input
      returning value(r_score) type i.
    methods get_total_score_v2
      importing it_input type yt_string_table optional preferred parameter it_input
      returning value(r_score) type i.

  private section.
    methods calculate_score
      importing i_round type string optional preferred parameter i_round
      returning value(r_score) type i.
    methods calculate_score_v2
      importing i_round type string optional preferred parameter i_round
      returning value(r_score) type i.
    methods get_value
      importing i_play type c optional preferred parameter i_play
      returning value(r_value) type i.
    methods get_my_play
      importing i_opponent type c i_outcome type c
      returning value(r_my_play) type char1.
    methods get_round_score
      importing i_round type string optional preferred parameter i_round
      returning value(r_score) type i.

endclass.


*&---------------------------------------------------------------------*
data l_input_filename type string.
data l_total_score type i.
data lr_day2 type ref to yc_day2.
data lt_input type yc_day2=>yt_string_table.

create object lr_day2.
l_input_filename = lr_day2->get_input_filename( ).
check l_input_filename <> space.

check lr_day2->import_data( exporting i_filename = l_input_filename importing et_data = lt_input ) = 0.
check lines( lt_input ) > 0.

l_total_score = lr_day2->get_total_score(  lt_input ).
if l_total_score < 0.
  write: / 'Input error'.
else.
  write: / 'Total score', l_total_score.
endif.

l_total_score = lr_day2->get_total_score_v2(  lt_input ).
if l_total_score < 0.
  write: / 'Input error'.
else.
  write: / 'Total score', l_total_score.
endif.
*&---------------------------------------------------------------------*


class yc_day2 implementation.
  method get_total_score.
    data l_round type string.
    data l_round_score type i.
    r_score = 0.
    if lt_input is initial.
      r_score = -1.
      return.
    endif.

    loop at it_input into l_round.
      l_round_score = calculate_score( l_round ).
      if l_round_score < 0.
        r_score = -2.
        return.
      endif.
      add l_round_score to r_score.
    endloop.

  endmethod.


  method get_total_score_v2.
    data l_round type string.
    data l_round_score type i.
    r_score = 0.
    if lt_input is initial.
      r_score = -1.
      return.
    endif.

    loop at it_input into l_round.
      l_round_score = calculate_score_v2( l_round ).
      if l_round_score < 0.
        r_score = -2.
        return.
      endif.
      add l_round_score to r_score.
    endloop.

  endmethod.


  method calculate_score.
    data l_opponent(1) type c.
    data l_me(1) type c.
    data l_round type string.

    split i_round at space into l_opponent l_me.
    if l_opponent is initial or l_me is initial.
      r_score = -1.
      return.
    endif.

    l_round = i_round.
    condense l_round no-gaps.
    r_score = get_round_score( l_round ) + get_value( l_me ).

  endmethod.


  method calculate_score_v2.
    data l_opponent(1) type c.
    data l_outcome(1) type c.
    data l_me(1) type c.
    data l_round type string.

    split i_round at space into l_opponent l_outcome.
    if l_opponent is initial or l_outcome is initial.
      r_score = -1.
      return.
    endif.

    l_me = get_my_play( i_opponent = l_opponent i_outcome = l_outcome ).
    l_round = |{ l_opponent }{ l_me }|.
    condense l_round no-gaps.
    r_score = get_round_score( l_round ) + get_value( l_me ).

  endmethod.


  method get_value.
    case i_play.
      when 'A' or 'X'.
        r_value = 1.

      when 'B' or 'Y'.
        r_value = 2.

      when 'C' or 'Z'.
        r_value = 3.

      when others.
        r_value = 0.

    endcase.
  endmethod.


  method get_my_play.
    case i_outcome.
      "Win
      when 'Z'.
        r_my_play = cond #( when i_opponent = 'A' then 'Y'
                            when i_opponent = 'B' then 'Z'
                            when i_opponent = 'C' then 'X'
                            else space ).
      "Lose
      when 'X'.
        r_my_play = cond #( when i_opponent = 'A' then 'Z'
                            when i_opponent = 'B' then 'X'
                            when i_opponent = 'C' then 'Y'
                            else space ).
      "Draw
      when 'Y'.
        r_my_play = cond #( when i_opponent = 'A' then 'X'
                            when i_opponent = 'B' then 'Y'
                            when i_opponent = 'C' then 'Z'
                            else space ).

      when others.
        r_my_play = space.

    endcase.

  endmethod.


  method get_round_score.
    case i_round.
      "Win
      when 'AY' or 'BZ' or 'CX'.
        r_score = 6.

      "Draw
      when 'AX' or 'BY' or 'CZ'.
        r_score = 3.

      when others.
        r_score = 0.
    endcase.
  endmethod.

endclass.
