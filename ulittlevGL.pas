unit ulittlevGL;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, SysCalls;

{$linklib lv_core}
{$linklib lv_draw}
{$linklib lv_font}
{$linklib lv_hal}
{$linklib lv_misc}
{$linklib lv_objx}
{$linklib lv_themes}

{ Pascal headers for Little vGL.

  Website : littlevgl.com

  From the above website
    MIT licence
    Copyright (c) 2016 Gábor Kiss-Vámosi
    Permission is hereby granted, free of charge, to any person obtaining a
    copy of this software and associated documentation files (the “Software”),
    to deal in the Software without restriction, including without limitation
    the rights to use, copy, modify, merge, publish, distribute, sublicense,
    and/or sell copies of the Software, and to permit persons to whom the
    Software is furnished to do so, subject to the following conditions:
    The above copyright notice and this permission notice shall be included
    in all copies or substantial portions of the Software.
    THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
    EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
    IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
    DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
    OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
    USE OR OTHER DEALINGS IN THE SOFTWARE.

  The same goes for this header file (c) 2019 pjde.

}

{$PACKRECORDS C}

const
  // ---------- lv_version.h ----------
  LVGL_VERSION_MAJOR                        = 6;
  LVGL_VERSION_MINOR                        = 1;
  LVGL_VERSION_PATCH                        = 1;
  LVGL_VERSION_INFO                         = '';

  // ---------- lv_types.h ----------
  LV_RES_INV                                = 0;    // Typically indicates that the object is deleted (become invalid) in the action
                                                    //  function or an operation was failed*/
  LV_RES_OK                                 = 1;    // The object is valid (no deleted) after the action

  // ---------- lv_obj.h ----------
  LV_MAX_ANCESTOR_NUM                       = 8;
  LV_EXT_CLICK_AREA_OFF                     = 0;
  LV_EXT_CLICK_AREA_TINY                    = 1;
  LV_EXT_CLICK_AREA_FULL                    = 2;

  // design mode enumerations
  LV_DESIGN_DRAW_MAIN                       = 0;    // Draw the main portion of the object
  LV_DESIGN_DRAW_POST                       = 1;    // Draw extras on the object
  LV_DESIGN_COVER_CHK                       = 2;    // Check if the object fully covers the 'mask_p' area

  // event type enumerations
  LV_EVENT_PRESSED                          = 0;    // The object has been pressed
  LV_EVENT_PRESSING                         = 1;    // The object is being pressed (called continuously while pressing)
  LV_EVENT_PRESS_LOST                       = 2;    // User is still pressing but slid cursor/finger off of the object
  LV_EVENT_SHORT_CLICKED                    = 3;    // User pressed object for a short period of time, then released it. Not called if dragged.
  LV_EVENT_LONG_PRESSED                     = 4;    // Object has been pressed for at least `LV_INDEV_LONG_PRESS_TIME`.  Not called if dragged.
  LV_EVENT_LONG_PRESSED_REPEAT              = 5;    // Called after `LV_INDEV_LONG_PRESS_TIME` in every
                                                    // `LV_INDEV_LONG_PRESS_REP_TIME` ms.  Not called if dragged.
  LV_EVENT_CLICKED                          = 6;    // Called on release if not dragged (regardless to long press)
  LV_EVENT_RELEASED                         = 7;    // Called in every cases when the object has been released
  LV_EVENT_DRAG_BEGIN                       = 8;
  LV_EVENT_DRAG_END                         = 9;
  LV_EVENT_DRAG_THROW_BEGIN                 = 10;
  LV_EVENT_KEY                              = 11;
  LV_EVENT_FOCUSED                          = 12;
  LV_EVENT_DEFOCUSED                        = 13;
  LV_EVENT_VALUE_CHANGED                    = 14;   // The object's value has changed (i.e. slider moved)
  LV_EVENT_INSERT                           = 15;
  LV_EVENT_REFRESH                          = 16;
  LV_EVENT_APPLY                            = 17;   // "Ok", "Apply" or similar specific button has clicked
  LV_EVENT_CANCEL                           = 18;   // "Close", "Cancel" or similar specific button has clicked
  LV_EVENT_DELETE                           = 19;   // Object is being deleted

  // General signals enumeration
  LV_SIGNAL_CLEANUP                         = 0;    // Object is being deleted
  LV_SIGNAL_CHILD_CHG                       = 1;    // Child was removed/added
  LV_SIGNAL_CORD_CHG                        = 2;    // Object coordinates/size have changed
  LV_SIGNAL_PARENT_SIZE_CHG                 = 3;    // Parent's size has changed
  LV_SIGNAL_STYLE_CHG                       = 4;    // Object's style has changed
  LV_SIGNAL_BASE_DIR_CHG                    = 5;    // The base dir has changed
  LV_SIGNAL_REFR_EXT_DRAW_PAD               = 6;    // Object's extra padding has changed
  LV_SIGNAL_GET_TYPE                        = 7;    // LittlevGL needs to retrieve the object's type

  // Input device related
  LV_SIGNAL_PRESSED                         = 8;    // The object has been pressed
  LV_SIGNAL_PRESSING                        = 9;    // The object is being pressed (called continuously while pressing)
  LV_SIGNAL_PRESS_LOST                      = 10;   // User is still pressing but slid cursor/finger off of the object
  LV_SIGNAL_RELEASED                        = 11;   // User pressed object for a short period of time, then released it. Not called if dragged.
  LV_SIGNAL_LONG_PRESS                      = 12;   // Object has been pressed for at least `LV_INDEV_LONG_PRESS_TIME`.  Not called if dragged.
  LV_SIGNAL_LONG_PRESS_REP                  = 13;   // Called after `LV_INDEV_LONG_PRESS_TIME` in every `LV_INDEV_LONG_PRESS_REP_TIME` ms.  Not called if dragged.
  LV_SIGNAL_DRAG_BEGIN                      = 14;
  LV_SIGNAL_DRAG_END                        = 15;

  // Group related
  LV_SIGNAL_FOCUS                           = 16;
  LV_SIGNAL_DEFOCUS                         = 17;
  LV_SIGNAL_CONTROL                         = 18;
  LV_SIGNAL_GET_EDITABLE                    = 19;

  // Object alignment enumerations
  LV_ALIGN_CENTER                           = 0;
  LV_ALIGN_IN_TOP_LEFT                      = 1;
  LV_ALIGN_IN_TOP_MID                       = 2;
  LV_ALIGN_IN_TOP_RIGHT                     = 3;
  LV_ALIGN_IN_BOTTOM_LEFT                   = 4;
  LV_ALIGN_IN_BOTTOM_MID                    = 5;
  LV_ALIGN_IN_BOTTOM_RIGHT                  = 6;
  LV_ALIGN_IN_LEFT_MID                      = 7;
  LV_ALIGN_IN_RIGHT_MID                     = 8;
  LV_ALIGN_OUT_TOP_LEFT                     = 9;
  LV_ALIGN_OUT_TOP_MID                      = 10;
  LV_ALIGN_OUT_TOP_RIGHT                    = 11;
  LV_ALIGN_OUT_BOTTOM_LEFT                  = 12;
  LV_ALIGN_OUT_BOTTOM_MID                   = 13;
  LV_ALIGN_OUT_BOTTOM_RIGHT                 = 14;
  LV_ALIGN_OUT_LEFT_TOP                     = 15;
  LV_ALIGN_OUT_LEFT_MID                     = 16;
  LV_ALIGN_OUT_LEFT_BOTTOM                  = 17;
  LV_ALIGN_OUT_RIGHT_TOP                    = 18;
  LV_ALIGN_OUT_RIGHT_MID                    = 19;
  LV_ALIGN_OUT_RIGHT_BOTTOM                 = 20;

  // dragging enumerations
  LV_DRAG_DIR_HOR                           = $1;   // Object can be dragged horizontally.
  LV_DRAG_DIR_VER                           = $2;   // Object can be dragged vertically.
  LV_DRAG_DIR_ALL                           = $3;   // Object can be dragged in all directions.

  // protection enumerations
  LV_PROTECT_NONE                           = $00;
  LV_PROTECT_CHILD_CHG                      = $01;  // Disable the child change signal. Used by the library
  LV_PROTECT_PARENT                         = $02;  // Prevent automatic parent change (e.g. in lv_page)
  LV_PROTECT_POS                            = $04;  // Prevent automatic positioning (e.g. in lv_cont layout)
  LV_PROTECT_FOLLOW                         = $08;  // Prevent the object be followed in automatic ordering (e.g. in
                                                    //  lv_cont PRETTY layout)
  LV_PROTECT_PRESS_LOST                     = $10;  // If the `indev` was pressing this object but swiped out while
                                                    //  pressing do not search other object.
  LV_PROTECT_CLICK_FOCUS                    = $20;  // Prevent focusing the object by clicking on it

type
  Tlv_obj = record    // may not need to elaborate as may not need to access directly    should be 68 bytes in size

      (*
    par : Plv_obj; // Pointer to the parent object
    child_ll : Tlv_ll;       //

    coords : Tlv_area; // Coordinates of the object (x1, y1, x2, y2)

     event_cb : Tlv_event_cb; // Event callback function
     signal_cb : Tlv_signal_cb; // Object type specific signal function
     design_cb : Tlv_design_cb; // Object type specific design function

    ext_attr : pointer;            // Object type specific extended data
    const lv_style_t * style_p; // Pointer to the object's style

#if LV_USE_GROUP != 0
    group_p : pointer; // Pointer to the group of the object
#endif

#if LV_USE_EXT_CLICK_AREA == LV_EXT_CLICK_AREA_TINY
    uint8_t ext_click_pad_hor; // Extra click padding in horizontal direction
    uint8_t ext_click_pad_ver; // Extra click padding in vertical direction
#endif

#if LV_USE_EXT_CLICK_AREA == LV_EXT_CLICK_AREA_FULL
    lv_area_t ext_click_pad;   // Extra click padding area.
#endif

    /*Attributes and states
    uint8_t click : 1;          // 1: Can be pressed by an input device
    uint8_t drag : 1;           // 1: Enable the dragging
    uint8_t drag_throw : 1;     // 1: Enable throwing with drag
    uint8_t drag_parent : 1;    // 1: Parent will be dragged instead
    uint8_t hidden : 1;         // 1: Object is hidden
    uint8_t top : 1;            // 1: If the object or its children is clicked it goes to the foreground
    uint8_t opa_scale_en : 1;   // 1: opa_scale is set
    uint8_t parent_event : 1;   // 1: Send the object's events to the parent too.
    lv_drag_dir_t drag_dir : 2; //  Which directions the object can be dragged in
    lv_bidi_dir_t base_dir : 2; // Base direction of texts related to this object
    uint8_t reserved : 3;       //  Reserved for future use
    uint8_t protect;            // Automatically happening actions can be prevented. 'OR'ed values from
                                   `lv_protect_t`
    lv_opa_t opa_scale;         // Scale down the opacity by this factor. Effects all children as well

    lv_coord_t ext_draw_pad; // EXTtend the size in every direction for drawing.

#if LV_USE_OBJ_REALIGN
    lv_reailgn_t realign;       // Information about the last call to ::lv_obj_align.
#endif

#if LV_USE_USER_DATA
    lv_obj_user_data_t user_data; // Custom user data for object.
#end  *)

  end;

  Tuint8 = byte;
  Tint8 = byte;
  Tuint16 = word;
  Tint16 = ShortInt;
  Tuint32 = LongWord;
  Tint32 = integer;

  Plv_obj = ^Tlv_obj;
  Tlv_res = Tuint8;
  Tlv_coord = Tint16; // to match conf settings
  Tlv_align = Tuint8;
  Tlv_style = record
  end;

  Plv_style = ^Tlv_style;
  Tlv_drag_dir = Tuint8;
  Tlv_bidi_dir = Tuint8;
  Tlv_event = Tuint8;
  Tlv_opa = Tuint8;
  Tlv_event_cb = procedure (obj : Plv_obj; event : Tlv_event); cdecl;
  Plv_event_cb = ^Tlv_event_cb;
  Tlv_signal = Tuint8;
  Tlv_design_mode = Tuint8;
  Tlv_point = record
    x : Tlv_coord;
    y : Tlv_coord;
  end;
  Plv_point = ^Tlv_point;
  Tlv_area = record
    x1 : Tlv_coord;
    y1 : Tlv_coord;
    x2 : Tlv_coord;
    y2 : Tlv_coord;
  end;
  Plv_area = ^Tlv_area;

  Tlv_design_cb = function (obj : Plv_obj; const mask_p : Plv_area; mode : Tlv_design_mode) : LongBool; cdecl;
  Plv_design_cb = ^Tlv_design_cb;
  Tlv_signal_cb = function (obj : Plv_obj; sign : Tlv_signal; param : pointer) : Tlv_res; cdecl;
  Plv_signal_cb = ^Tlv_signal_cb;
  Tlv_obj_type = record
    _type : array [0..LV_MAX_ANCESTOR_NUM - 1] of byte; // [0]: the actual type, [1]: ancestor, [2] #1's ancestor
                                                        // ... [x]: "lv_obj"
  end;
  Plv_obj_type = ^Tlv_obj_type;
  Tlv_obj_user_data = pointer;        // to match conf settings
  Plv_obj_user_data = ^Tlv_obj_user_data;

  Tlv_color = packed record // assume 32 bit
    case integer of
      0 :
        ( blue : Tuint8;
          green : Tuint8;
          red : Tuint8;
          alpha : Tuint8;
        );
      1 :
        (
          full : Tuint32;
        );
  end;
  Plv_color = ^Tlv_color;

  Tlv_log_level = Tint8;
  Tlv_log_print_g_cb = procedure (level : Tlv_log_level; fb : PChar; ln : Tuint32; desc : PChar); cdecl;

  Tlv_disp_buf = record                 // 28 bytes
    buf1 : pointer;                     // First display buffer. (4 -> 4)
    buf2 : pointer;                     // Second display buffer. (4 -> 8)
    // Internal, used by the library
    buf_act : pointer;                  // (4 -> 12)
    size : Tuint32;                     // In pixel count (4 -> 16)
    area : Tlv_area;                    // (4 * 2 -> 24)
    flushing : Tuint32;                 // bit 1 (4 -> 28)
  end;
  Plv_disp_buf = ^Tlv_disp_buf;

  Tlv_disp = record                     // 364 bytes
    fill : array [0 .. 363] of byte;
  end;
  Plv_disp = ^Tlv_disp;

  Tlv_disp_drv = record                 // 40 bytes
    hor_res : Tlv_coord;                // Horizontal resolution. (2 -> 2)
    ver_res : Tlv_coord;                // Vertical resolution. (2 -> 4)
    buffer : Plv_disp_buf;              // pointer to buffer (4 -> 8)
    rotated : Tuint32;                  // antialiasing / rotated. (4 -> 12)
    flush_cb : pointer;                 // pointer to procedure (4 -> 16)
    rounder_cb : pointer;               // pointer to procedure (4 -> 20)
    set_px_cb : pointer;                // pointer to procedure (4 -> 24)
    monitor_cb : pointer;               // pointer to procedure (4 -> 28)
    gpu_blend_cb : pointer;             // pointer to procedure (4 -> 32)
    gpu_fill_cb : pointer;              // pointer to procedure (4 -> 46)
    color_chroma_key : Tlv_color;       // (4 -> 40)
  end;
  Plv_disp_drv = ^Tlv_disp_drv;
  // ----------- lv_canvas.h ------------
  Tlv_canvas_style = Tuint8;
  Tlv_img_cf = Tuint8;                  // colour format
  Tlv_img_header = record
    data : Tuint32;                     // bit packed
{   The first 8 bit is very important to distinguish the different source types.
    For more info see `lv_img_get_src_type()` in lv_img.c
    cf : 5           Color format: See lv_img_color_format
    always_zero : 3  It the upper bits of the first byte. Always zero to look like a
                       non-printable character
    Reserved : 2;    Reserved to be used later
    w : 11           Width of the image map
    h : 11           Height of the image map }
  end;
  Plv_img_header = ^Tlv_img_header;
  Tlv_img_dsc = record
    header : Tlv_img_header;
    data_size : Tuint32;
    data : Puint8;
  end;
  Plv_img_dsc = ^Tlv_img_dsc;
  Tlv_img_style = Tuint8;

// ------------ lv_btn.h ---------------
  Tlv_btn_state = Tuint8;
  Tlv_btn_style = Tuint8;

// ------------ lv_label.h -------------
  Tlv_label_style = Tuint8;
  Tlv_label_long_mode = Tuint8;
  Tlv_label_align = Tuint8;

// ------------ lv_cont.h ---------------
  Tlv_layout = Tuint8;
  Tlv_fit = Tuint8;
  Tlv_cont_style = Tuint8;

(* lv_disp_t
  // Driver to the display*/
  driver : Tlv_disp_drv_t;                   // (40 -> 40)
  // A task which periodically checks the dirty areas and refreshes them
  rer_task : Plv_task;                      // (4 -> 44)
  // Screens of the display
  scr_ll : Tlv_ll_t;
  act_scr : Pvl_obj;                        // Currently active screen on this display (4 -> )
  top_layer : Plv_obj;                      // see lv_disp_get_layer_top  (4 -> )
  sys_layer : Plv_obj;                      // see lv_disp_get_layer_sys  (4 - >
  // Invalidated (marked to redraw) areas
  inv_areas : array [0 .. LV_INV_BUF_SIZE - 1] of Tlv_area;
  inv_area_joined : array [0 .. LV_INV_BUF_SIZE - 1] of Tuint8;
  inv_p : Tuint32;
  // Miscellaneous data
  last_activity_time : Tuint32;             // Last time there was activity on this display
*)

procedure lv_init; cdecl; external;
function lv_obj_create (parent : Plv_obj; copy : Plv_obj) : Plv_obj; cdecl; external;
function lv_obj_del (obj : Plv_obj) : Tlv_res; cdecl; external;
procedure lv_obj_del_async (obj : Plv_obj); cdecl; external;
procedure lv_obj_clean (obj : Plv_obj); cdecl; external;
procedure lv_obj_invalidate (const obj : Plv_obj); cdecl; external;

procedure lv_obj_set_parent (obj : Plv_obj; parent : Plv_obj); cdecl; external;
procedure lv_obj_move_foreground (obj : Plv_obj); cdecl; external;
procedure lv_obj_move_background (obj : Plv_obj); cdecl; external;

procedure lv_obj_set_pos (obj : Plv_obj; x, y : Tlv_coord); cdecl; external;
procedure lv_obj_set_x (obj : Plv_obj; x : Tlv_coord); cdecl; external;
procedure lv_obj_set_y (obj : Plv_obj; y : Tlv_coord); cdecl; external;
procedure lv_obj_set_size (obj : Plv_obj; w : Tlv_coord; h : Tlv_coord); cdecl; external;
procedure lv_obj_set_width (obj : Plv_obj; w : Tlv_coord); cdecl; external;
procedure lv_obj_set_height (obj : Plv_obj; h : Tlv_coord); cdecl; external;

procedure lv_obj_align (obj : Plv_obj; const base : Plv_obj; align : Tlv_align; x_mod, y_mod : Tlv_coord); cdecl; external;
procedure lv_obj_align_origo (obj : Plv_obj; const base : Plv_obj; align : Tlv_align; x_mod, y_mod : Tlv_coord); cdecl; external;
procedure lv_obj_realign (obj : Plv_obj); cdecl; external;
procedure lv_obj_set_auto_realign (obj : Plv_obj; en : LongBool); cdecl; external;
procedure lv_obj_set_ext_click_area (obj : Plv_obj; left, right, top, bottom : Tlv_coord); cdecl; external;

procedure lv_obj_set_style (obj : Plv_obj; const style : Plv_style); cdecl; external;
procedure lv_obj_refresh_style (obj : Plv_obj); cdecl; external;
procedure lv_obj_report_style_mod (style : Plv_style); cdecl; external;

procedure lv_obj_set_hidden (obj : Plv_obj; en : LongBool); cdecl; external;
procedure lv_obj_set_click (obj : Plv_obj; en : LongBool); cdecl; external;
procedure lv_obj_set_top (obj : Plv_obj; en : LongBool); cdecl; external;
procedure lv_obj_set_drag (obj : Plv_obj; en : LongBool); cdecl; external;
procedure lv_obj_set_drag_dir (obj : Plv_obj; drag_dir : Tlv_drag_dir); cdecl; external;

procedure lv_obj_set_drag_throw (obj : Plv_obj; en : LongBool); cdecl; external;
procedure lv_obj_set_drag_parent (obj : Plv_obj; en : LongBool); cdecl; external;
procedure lv_obj_set_parent_event (obj : Plv_obj; en : LongBool); cdecl; external;
procedure lv_obj_set_base_dir (obj : Plv_obj; dir : Tlv_bidi_dir); cdecl; external;
procedure lv_obj_set_opa_scale_enable (obj : Plv_obj; en : LongBool); cdecl; external;
procedure lv_obj_set_opa_scale (obj : Plv_obj; opa_scale : Tlv_opa); cdecl; external;
procedure lv_obj_set_protect (obj : Plv_obj; prot : Tuint8); cdecl; external;
procedure lv_obj_clear_protect (obj : Plv_obj; prot : Tuint8); cdecl; external;
procedure lv_obj_set_event_cb (obj : Plv_obj; event_cb : Tlv_event_cb); cdecl; external;
function lv_event_send (obj : Plv_obj; event : Tlv_event; const data : pointer) : Tlv_res; cdecl; external;
function lv_event_send_func (event_cb : Tlv_event_cb; obj : Plv_obj; event : Tlv_event; const data : pointer) : Tlv_res; cdecl; external;

function lv_event_get_data : pointer; cdecl; external;
procedure lv_obj_set_signal_cb (obj : Plv_obj;  signal_cb : Tlv_signal_cb); cdecl; external;
procedure lv_signal_send (obj : Plv_obj; signal : Tlv_signal; param : pointer); cdecl; external;
procedure lv_obj_set_design_cb (obj : Plv_obj;  design_cb : Tlv_design_cb); cdecl; external;
function lv_obj_allocate_ext_attr (obj : Plv_obj; ext_size : Tuint16) : pointer; cdecl; external;
procedure lv_obj_refresh_ext_draw_pad (obj : Plv_obj); cdecl; external;

function lv_obj_get_screen (const obj : Plv_obj) : Plv_obj; cdecl; external;
function lv_obj_get_disp (const obj : Plv_obj) : Plv_obj; cdecl; external;
function lv_obj_get_parent (const obj : Plv_obj) : Plv_obj; cdecl; external;
function lv_obj_get_child (obj : Plv_obj; const child : Plv_obj) : Plv_obj; cdecl; external;
function lv_obj_get_child_back (const obj : Plv_obj; const child : Plv_obj) : Plv_obj; cdecl; external;
function lv_obj_count_children (const obj : Plv_obj) : Tuint16; cdecl; external;
function lv_obj_count_children_recursive (const obj : Plv_obj) : Tuint16; cdecl; external;
procedure lv_obj_get_coords (const obj : Plv_obj; cords_p : Plv_area); cdecl; external;
procedure lv_obj_get_inner_coords (const obj : Plv_obj; coords_p : Plv_area); cdecl; external;
function lv_obj_get_x (const obj : Plv_obj) : Tlv_coord; cdecl; external;
function lv_obj_get_y (const obj : Plv_obj) : Tlv_coord; cdecl; external;
function lv_obj_get_width (const obj : Plv_obj) : Tlv_coord; cdecl; external;
function lv_obj_get_height (const obj : Plv_obj) : Tlv_coord; cdecl; external;
function lv_obj_get_width_fit (const obj : Plv_obj) : Tlv_coord; cdecl; external;
function lv_obj_get_height_fit (const obj : Plv_obj) : Tlv_coord; cdecl; external;
function lv_obj_get_auto_realign (const obj : Plv_obj) : LongBool; cdecl; external;
function lv_obj_get_ext_click_pad_left (const obj : Plv_obj) : Tlv_coord; cdecl; external;
function lv_obj_get_ext_click_pad_right (const obj : Plv_obj) : Tlv_coord; cdecl; external;
function lv_obj_get_ext_click_pad_top (const obj : Plv_obj) : Tlv_coord; cdecl; external;
function lv_obj_get_ext_click_pad_bottom (const obj : Plv_obj) : Tlv_coord; cdecl; external;
function lv_obj_get_ext_draw_pad (const obj : Plv_obj) : Tlv_coord; cdecl; external;
function lv_obj_get_style (const obj : Plv_obj) : Plv_style; cdecl; external;
function lv_obj_get_hidden (const obj : Plv_obj) : LongBool; cdecl; external;
function lv_obj_get_click (const obj : Plv_obj) : LongBool; cdecl; external;
function lv_obj_get_top (const obj : Plv_obj) : LongBool; cdecl; external;
function lv_obj_get_drag (const obj : Plv_obj) : LongBool; cdecl; external;
function lv_obj_get_drag_dir (const obj : Plv_obj) : Tlv_drag_dir; cdecl; external;
function lv_obj_get_drag_throw (const obj : Plv_obj) : LongBool; cdecl; external;
function lv_obj_get_drag_parent (const obj : Plv_obj) : LongBool; cdecl; external;
function lv_obj_get_parent_event (const obj : Plv_obj) : LongBool; cdecl; external;
function lv_obj_get_base_dir (const obj : Plv_obj) : Tlv_bidi_dir; cdecl; external;
function lv_obj_get_opa_scale_enable (const obj : Plv_obj) : Tlv_opa; cdecl; external;
function lv_obj_get_opa_scale (const obj : Plv_obj) : Tlv_opa; cdecl; external;
function lv_obj_get_protect (const obj : Plv_obj) : Tuint8; cdecl; external;
function lv_obj_is_protected (const obj : Plv_obj; prot : Tuint8) : LongBool; cdecl; external;
function lv_obj_get_signal_cb (const obj : Plv_obj) : Tlv_signal_cb; cdecl; external;
function lv_obj_get_design_cb (const obj : Plv_obj) : Tlv_design_cb; cdecl; external;
function lv_obj_get_event_cb (const obj : Plv_obj) : Tlv_event_cb; cdecl; external;
function lv_obj_get_ext_attr (const obj : Plv_obj) : pointer; cdecl; external;
procedure lv_obj_get_type (const obj : Plv_obj; buf : Plv_obj_type); cdecl; external;
function lv_obj_get_user_data (const obj : Plv_obj) : Tlv_obj_user_data; cdecl; external;
function lv_obj_get_user_data_ptr (const obj : Plv_obj) : Plv_obj_user_data; cdecl; external;
procedure lv_obj_set_user_data (obj : Plv_obj; data : Tlv_obj_user_data); cdecl; external;
function lv_obj_get_group (const obj : Plv_obj) : pointer; cdecl; external;
function lv_obj_is_focused (const obj : Plv_obj) : LongBool; cdecl; external;
function lv_obj_handle_get_type_signal (buf : Plv_obj_type; const name : PChar) : Tlv_res; cdecl; external;

procedure lv_task_handler; cdecl; external;

procedure lv_tick_inc (tick_period : Tuint32); cdecl; external;
function lv_tick_get : Tuint32; cdecl; external;
function lv_tick_elaps (prev_tick : Tuint32) : Tuint32; cdecl; external;

procedure lv_disp_drv_init (driver : Plv_disp_drv); cdecl; external;
procedure lv_disp_buf_init (disp_buf : Plv_disp_buf; buf1 : pointer; buf2 : pointer; size_in_px_cnt : Tuint32); cdecl; external;
function lv_disp_drv_register (driver : Plv_disp_drv) : Plv_disp; cdecl; external;
procedure lv_disp_drv_update (disp : Plv_disp; new_drv : Plv_disp_drv); cdecl; external;
procedure lv_disp_remove(disp : Plv_disp); cdecl; external;
procedure lv_disp_set_default (disp : Plv_disp); cdecl; external;
function lv_disp_get_default : Plv_disp; cdecl; external;
function lv_disp_get_hor_res (disp : Plv_disp) : Tlv_coord; cdecl; external;
function lv_disp_get_ver_res (disp : Plv_disp) : Tlv_coord; cdecl; external;
function lv_disp_get_antialiasing (disp : Plv_disp) : WordBool; cdecl; external;

procedure lv_disp_flush_ready (disp_drv : Plv_disp_drv); cdecl; external;
function lv_disp_get_next (disp : Plv_disp) : Plv_disp; cdecl; external;
function lv_disp_get_buf (disp : Plv_disp) : Plv_disp_buf; cdecl; external;
function lv_disp_get_inv_buf_size (disp : Plv_disp) : Tuint16; cdecl; external;
procedure lv_disp_pop_from_inv_buf (disp : Plv_disp; num : Tuint16); cdecl; external;
function lv_disp_is_double_buf (disp : Plv_disp) : LongBool; cdecl; external;
function lv_disp_is_true_double_buf (disp : Plv_disp) : LongBool; cdecl; external;

function lv_disp_get_scr_act (disp : Plv_disp) : Plv_obj; cdecl; external;
procedure lv_disp_load_scr (scr : Plv_obj); cdecl; external;
function lv_disp_get_layer_top (disp : Plv_disp) : Plv_obj; cdecl; external;
function lv_disp_get_layer_sys (disp : Plv_disp) : Plv_obj; cdecl; external;
procedure lv_disp_assign_screen (disp : Plv_disp; scr : Plv_obj); cdecl; external;
//function lv_disp_get_refr_task (disp : Plv_disp) : Plv_task; cdecl; external;
function lv_disp_get_inactive_time (const disp : Plv_disp) : Tuint32; cdecl; external;
procedure lv_disp_trig_activity (disp : Plv_disp); cdecl; external;

procedure lv_log_register_print_cb (print_cb : Tlv_log_print_g_cb); cdecl; external;

function lv_canvas_create (par : Plv_obj; const copy : Plv_obj) : Plv_obj; cdecl; external;
procedure lv_canvas_set_buffer (canvas : Plv_obj; buf : pointer; w, h : Tlv_coord; cf : Tlv_img_cf); cdecl; external;
procedure lv_canvas_set_px (canvas : Plv_obj; x, y : Tlv_coord; c : Tlv_color); cdecl; external;
procedure lv_canvas_set_palette (canvas : Plv_obj; id : Tuint8; c : Tlv_color); cdecl; external;
procedure lv_canvas_set_style (canvas : Plv_obj; _type : Tlv_canvas_style; const style : Plv_style); cdecl; external;
function lv_canvas_get_px (canvas : Plv_obj; x, y : Tlv_coord) : Tlv_color; cdecl; external;
function lv_canvas_get_img (canvas : Plv_obj) : Plv_img_dsc; cdecl; external;
function lv_canvas_get_style (const canvas : Plv_obj; _type : Tlv_canvas_style) : Plv_style; cdecl; external;
procedure lv_canvas_copy_buf (canvas : Plv_obj; const to_copy : pointer; x, y, w, h : Tlv_coord);  cdecl; external;
procedure lv_canvas_rotate (canvas : Plv_obj; img : Plv_img_dsc; angle : Tint16; offset_x, offset_y :Tlv_coord;
            pivot_x, pivot_y : Tint32); cdecl; external;
procedure lv_canvas_fill_bg (canvas : Plv_obj; color : Tlv_color);  cdecl; external;
procedure lv_canvas_draw_rect (canvas : Plv_obj; x, y, w, h : Tlv_coord; const style : Plv_style); cdecl; external;
procedure lv_canvas_draw_text (canvas : Plv_obj; x, y : Tlv_coord; max_w : Tlv_coord; const style : Plv_style;
                         const txt : PChar; align : Tlv_label_align); cdecl; external;
procedure lv_canvas_draw_img (canvas : Plv_obj; x, y : Tlv_coord; const src : pointer; const style : Plv_style); cdecl; external;
procedure lv_canvas_draw_line (canvas : Plv_obj; const points : Plv_point; point_cnt : Tuint32; const style : Plv_style); cdecl; external;
//procedure lv_canvas_draw_polygon (canvas : Plv_obj; const points : Plv_point; point_cnt : Tuint32; const style : Plv_style); cdecl; external;
//procedure lv_canvas_draw_arc (canvas : Plv_obj; x, y, r : Tlv_coord; start_angle, end_angle : Tint32; const style : Plv_style); cdecl; external;

function lv_cont_create (par : Plv_obj; const copy : Plv_obj) : Plv_obj; cdecl; external;
procedure lv_cont_set_layout (cont : Plv_obj; layout : Tlv_layout); cdecl; external;
procedure lv_cont_set_fit4 (cont : Plv_obj; left, right, top, bottom : Tlv_fit); cdecl; external;
function lv_cont_get_layout (cont : Plv_obj) : Tlv_layout; cdecl; external;
function lv_cont_get_fit_left (cont : Plv_obj) : Tlv_fit; cdecl; external;
function lv_cont_get_fit_right (cont : Plv_obj) : Tlv_fit; cdecl; external;
function lv_cont_get_fit_top (cont : Plv_obj) : Tlv_fit; cdecl; external;
function lv_cont_get_fit_bottom (cont : Plv_obj) : Tlv_fit; cdecl; external;

function lv_btn_create (par : Plv_obj; const copy : Plv_obj) : Plv_obj; cdecl; external;
procedure lv_btn_set_toggle (btn : Plv_obj; tgl : LongBool); cdecl; external;
procedure lv_btn_set_state (btn : Plv_obj; state : Tlv_btn_state); cdecl; external;
procedure lv_btn_toggle (btn : Plv_obj); cdecl; external;
procedure lv_btn_set_ink_in_time(btn : Plv_obj; time : Tuint16); cdecl; external;
procedure lv_btn_set_ink_wait_time(btn : Plv_obj; time : Tuint16); cdecl; external;
procedure lv_btn_set_ink_out_time(btn : Plv_obj; time : Tuint16); cdecl; external;
procedure lv_btn_set_style (btn : Plv_obj; _type : Tlv_btn_style; const style : Plv_style); cdecl; external;
function lv_btn_get_state (const btn : Plv_obj) : Tlv_btn_state; cdecl; external;
function lv_btn_get_toggle (const btn : Plv_obj) : LongBool; cdecl; external;
function lv_btn_get_ink_in_time (const btn : Plv_obj) : Tuint16; cdecl; external;
function lv_btn_get_ink_wait_time (const btn : Plv_obj) : Tuint16; cdecl; external;
function lv_btn_get_ink_out_time(const btn : Plv_obj)  : Tuint16; cdecl; external;
function lv_btn_get_style (const btn : Plv_obj; _type : Tlv_btn_style) : Plv_style; cdecl; external;

function lv_label_create (par : Plv_obj; const copy : Plv_obj) : Plv_obj; cdecl; external;
procedure lv_label_set_text (lbl : Plv_obj; const text : PChar); cdecl; external;
procedure lv_label_set_text_fmt(lbl : Plv_obj; fmt : PChar); varargs; cdecl; external;
procedure lv_label_set_array_text (lbl : Plv_obj; const _array : PChar; size : Tuint16); cdecl; external;
procedure lv_label_set_static_text (lbl : Plv_obj; const text : PChar); cdecl; external;
procedure lv_label_set_long_mode (lbl : Plv_obj; long_mode : Tlv_label_long_mode); cdecl; external;
procedure lv_label_set_align (lbl : Plv_obj; align : Tlv_label_align); cdecl; external;
procedure lv_label_set_recolor (lbl : Plv_obj; en : LongBool); cdecl; external;
procedure lv_label_set_body_draw (lbl : Plv_obj; en : LongBool); cdecl; external;
procedure lv_label_set_anim_speed (lbl : Plv_obj; anim_speed : Tuint16); cdecl; external;
procedure lv_label_set_text_sel_start (lbl : Plv_obj; index : Tuint16); cdecl; external;
procedure lv_label_set_text_sel_end (lbl : Plv_obj; index : Tuint16); cdecl; external;
function lv_label_get_text (const lbl : Plv_obj) : PChar; cdecl; external;
function lv_label_get_long_mode (const lbl : Plv_obj) : Tlv_label_long_mode; cdecl; external;
function lv_label_get_align (const lbl : Plv_obj) : Tlv_label_align; cdecl; external;
function lv_label_get_recolor (const lbl : Plv_obj) : LongBool; cdecl; external;
function lv_label_get_body_draw (const lbl : Plv_obj) : LongBool; cdecl; external;
function lv_label_get_anim_speed (const lbl : Plv_obj) : Tuint16; cdecl; external;
procedure lv_label_get_letter_pos (const lbl : Plv_obj; index : Tuint16; pos : Plv_point); cdecl; external;
function lv_label_get_letter_on (const lbl : Plv_obj; pos : Plv_point) : Tuint16; cdecl; external;
function lv_label_is_char_under_pos (const lbl : Plv_obj; pos : Plv_point) : LongBool; cdecl; external;
function lv_label_get_text_sel_start (const lbl : Plv_obj) : Tuint16; cdecl; external;
function lv_label_get_text_sel_end (const lbl : Plv_obj) : Tuint16; cdecl; external;
procedure lv_label_ins_text (lbl : Plv_obj; pos : Tuint32; const txt : PChar); cdecl; external;
procedure lv_label_cut_text (lbl : Plv_obj; pos, cnt : Tuint32); cdecl; external;

(*
 * Helps to quickly declare an event callback function.
 * Will be expanded to: `void <name> (lv_obj_t * obj, lv_event_t e)`
 *
 * Examples:
 * static LV_EVENT_CB_DECLARE(my_event1);  //Protoype declaration
 *
 * static LV_EVENT_CB_DECLARE(my_event1)
 * {
 *   if(e == LV_EVENT_CLICKED) {
 *      lv_obj_set_hidden(obj ,true);
 *   }
 * }
 */
#define LV_EVENT_CB_DECLARE(name) void name(lv_obj_t * obj, lv_event_t e)
*)

// -------- macros -------------
function lv_scr_act : Plv_obj;

implementation

{
#define LV_VERSION_CHECK(x,y,z) (x == LVGL_VERSION_MAJOR && (y < LVGL_VERSION_MINOR || (y == LVGL_VERSION_MINOR && z <= LVGL_VERSION_PATCH)))

#define LV_CANVAS_BUF_SIZE_TRUE_COLOR(w, h) LV_IMG_BUF_SIZE_TRUE_COLOR(w, h)
#define LV_CANVAS_BUF_SIZE_TRUE_COLOR_CHROMA_KEYED(w, h) LV_IMG_BUF_SIZE_TRUE_COLOR_CHROMA_KEYED(w, h)
#define LV_CANVAS_BUF_SIZE_TRUE_COLOR_ALPHA(w, h) LV_IMG_BUF_SIZE_TRUE_COLOR_ALPHA(w, h)

/*+ 1: to be sure no fractional row*/
#define LV_CANVAS_BUF_SIZE_ALPHA_1BIT(w, h) LV_IMG_BUF_SIZE_ALPHA_1BIT(w, h)
#define LV_CANVAS_BUF_SIZE_ALPHA_2BIT(w, h) LV_IMG_BUF_SIZE_ALPHA_2BIT(w, h)
#define LV_CANVAS_BUF_SIZE_ALPHA_4BIT(w, h) LV_IMG_BUF_SIZE_ALPHA_4BIT(w, h)
#define LV_CANVAS_BUF_SIZE_ALPHA_8BIT(w, h) LV_IMG_BUF_SIZE_ALPHA_8BIT(w, h)

/*4 * X: for palette*/
#define LV_CANVAS_BUF_SIZE_INDEXED_1BIT(w, h) LV_IMG_BUF_SIZE_INDEXED_1BIT(w, h)
#define LV_CANVAS_BUF_SIZE_INDEXED_2BIT(w, h) LV_IMG_BUF_SIZE_INDEXED_2BIT(w, h)
#define LV_CANVAS_BUF_SIZE_INDEXED_4BIT(w, h) LV_IMG_BUF_SIZE_INDEXED_4BIT(w, h)
#define LV_CANVAS_BUF_SIZE_INDEXED_8BIT(w, h) LV_IMG_BUF_SIZE_INDEXED_8BIT(w, h)
}

procedure lv_btn_set_layout (btn : Plv_obj; layout : Tlv_layout);
begin
  lv_cont_set_layout (btn, layout);
end;

procedure lv_btn_set_fit4 (btn : Plv_obj; left, right, top, bottom : Tlv_fit);
begin
  lv_cont_set_fit4 (btn, left, right, top, bottom);
end;

procedure lv_btn_set_fit2 (btn : Plv_obj; hor, ver : Tlv_fit);
begin
  lv_cont_set_fit4 (btn, hor, hor, ver, ver);
end;

procedure lv_btn_set_fit (btn : Plv_obj; fit : Tlv_fit);
begin
  lv_cont_set_fit4 (btn, fit, fit, fit, fit);
end;

function lv_btn_get_layout (const btn : Plv_obj) : Tlv_layout;
begin
  Result := lv_cont_get_layout (btn);
end;

function lv_btn_get_fit_left (const btn : Plv_obj) : Tlv_fit;
begin
  Result := lv_cont_get_fit_left (btn);
end;

function lv_btn_get_fit_right (const btn : Plv_obj) : Tlv_fit;
begin
  Result := lv_cont_get_fit_right (btn);
end;

function lv_btn_get_fit_top (const btn : Plv_obj) : Tlv_fit;
begin
  Result := lv_cont_get_fit_top (btn);
end;

function lv_btn_get_fit_bottom (const btn : Plv_obj) : Tlv_fit;
begin
  Result := lv_cont_get_fit_bottom (btn);
end;

procedure lv_label_set_style (lbl : Plv_obj; _type : Tlv_label_style; const style : Plv_style);
begin
  lv_obj_set_style (lbl, style);
end;

function lv_label_get_style (const lbl : Plv_obj; _type : Tlv_label_style) : Plv_style;
begin
  Result := lv_obj_get_style (lbl);
end;

function lv_scr_act : Plv_obj;
begin
  Result := lv_disp_get_scr_act (lv_disp_get_default);
end;

function lv_layer_top : Plv_obj;
begin
  Result := lv_disp_get_layer_top (lv_disp_get_default);
end;

function lv_layer_sys : Plv_obj;
begin
  Result := lv_disp_get_layer_sys (lv_disp_get_default);
end;

procedure lv_scr_load (scr : Plv_obj);
begin
  lv_disp_load_scr (scr);
end;


procedure lv_cont_set_fit2 (cont : Plv_obj; hor, ver : Tlv_fit);
begin
  lv_cont_set_fit4 (cont, hor, hor, ver, ver);
end;

procedure lv_cont_set_fit (cont : Plv_obj; fit : Tlv_fit);
begin
  lv_cont_set_fit4 (cont, fit, fit, fit, fit);
end;

procedure lv_cont_set_style (cont : Plv_obj; _type : Tlv_cont_style; const style : Plv_style);
begin
  lv_obj_set_style (cont, style);
end;

function lv_cont_get_style (const cont : Plv_obj; _type : Tlv_cont_style) : Plv_style;
begin
  Result := lv_obj_get_style (cont);
end;

end.

