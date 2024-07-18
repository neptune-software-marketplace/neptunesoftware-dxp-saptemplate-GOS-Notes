class zcl_nad_core_gos_note definition
  public
  final
  create public .

public section.

  interfaces /neptune/if_nad_server .

  types:begin of ty_comment,
          obj_descr    type string,
          content      type string,
          creat_name   type string,
          creat_fnam   type string,
          creat_date   type string,
          creat_time   type string,
    end of ty_comment.

  data wa_comment type ty_comment.
protected section.
private section.

  methods SAVE
    importing
      !AJAX_VALUE type STRING
      !SERVER type ref to /NEPTUNE/CL_NAD_SERVER .
ENDCLASS.



CLASS ZCL_NAD_CORE_GOS_NOTE IMPLEMENTATION.


method /neptune/if_nad_server~handle_on_ajax.


  case ajax_id.

    when 'SAVE'.
      call method save
        exporting
          ajax_value = ajax_value
          server     = server.

  endcase.


endmethod.


method save.

data: lv_folder_id type soodk,
      lv_object_id type soobjinfi1-object_id,
      lv_rolea     type borident,
      lv_roleb     type borident,
      lv_pre       type string,
      lv_data      type string,
      lv_doc_type  type soodk-objtp,
      lv_doc_data  type sodocchgi1,
      lv_doc_info  type sofolenti1,
      wa_content   type solisti1,
      it_content   type standard table of solisti1.

data: it_string    type table of string,
      wa_string    type string.


* Any Comment ?
  check wa_comment-content is not initial.

* Get Text
  split wa_comment-content at cl_abap_char_utilities=>cr_lf into table it_string.

  loop at it_string into wa_string.
    wa_content-line = wa_string.
    append wa_content to it_content.
    clear  wa_content.
  endloop.

* Get Root Folder
  call function 'SO_FOLDER_ROOT_ID_GET'
       exporting
         owner     = sy-uname
         region    = 'B'
       importing
         folder_id = lv_folder_id.

* Document Information
  lv_object_id           = lv_folder_id.
  lv_doc_data-obj_name   = 'COMMENT'.
  lv_doc_data-obj_descr  = wa_comment-obj_descr.
  lv_doc_data-obj_langu  = sy-langu.
  lv_doc_type            = 'TXT'.

* Insert Document
  call function 'SO_DOCUMENT_INSERT_API1'
    exporting
        folder_id                  = lv_object_id
        document_data              = lv_doc_data
        document_type              = lv_doc_type
    importing
        document_info              = lv_doc_info
    tables
        object_content             = it_content
    exceptions
        folder_not_exist           = 1
        document_type_not_exist    = 2
        operation_no_authorization = 3
        parameter_error            = 4
        x_error                    = 5
        enqueue_error              = 6
        others                     = 7.

* Relation Keys
  split ajax_value at '|' into lv_rolea-objtype
                               lv_rolea-objkey.

  lv_roleb-objtype = 'MESSAGE'.
  concatenate lv_folder_id
              lv_doc_info-object_id
              into lv_roleb-objkey respecting blanks.

*Create Relation
 call function 'BINARY_RELATION_CREATE_COMMIT'
   exporting
     obj_rolea            = lv_rolea
     obj_roleb            = lv_roleb
     relationtype         = 'NOTE'
   exceptions
     no_model             = 1
     internal_error       = 2
     unknown              = 3
     others               = 4.


endmethod.
ENDCLASS.
