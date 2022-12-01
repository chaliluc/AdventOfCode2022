class zcl_lc_adv2022 definition
  public
  create public .

  public section.

    types:
      yt_string_table type standard table of string .

    constants g_path type string value 'C:\temp\AdventOfCode2022' ##NO_TEXT.

    methods get_input_filename
      returning
        value(r_filename) type string .
    methods import_data
      importing
        !i_filename    type string
      exporting
        !et_data       type yt_string_table
      returning
        value(r_subrc) type i .
  protected section.
  private section.
endclass.



class zcl_lc_adv2022 implementation.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_LC_ADV2022->GET_INPUT_FILENAME
* +-------------------------------------------------------------------------------------------------+
* | [<-()] R_FILENAME                     TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method get_input_filename.
    data lt_filename type filetable.
    data l_rc type i.

    cl_gui_frontend_services=>file_open_dialog(
      exporting
        window_title            = 'Select input file name'
        default_extension       = 'txt'
        initial_directory       = g_path
        multiselection          = abap_false
      changing
        file_table              = lt_filename
        rc                      = l_rc
      exceptions
        others                  = 4  ).

    if sy-subrc <> 0.
      clear r_filename.
    else.
      read table lt_filename index 1 into r_filename.
    endif.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_LC_ADV2022->IMPORT_DATA
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_FILENAME                     TYPE        STRING
* | [<---] ET_DATA                        TYPE        YT_STRING_TABLE
* | [<-()] R_SUBRC                        TYPE        I
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method import_data.

    clear et_data.
    cl_gui_frontend_services=>gui_upload( exporting filename = i_filename
                                          changing data_tab  = et_data
                                          exceptions others = 4 ).
    if sy-subrc <> 0.
      r_subrc = 4.
      return.
    endif.

  endmethod.
endclass.
