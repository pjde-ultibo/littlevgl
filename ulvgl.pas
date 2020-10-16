unit ulvgl;

{$mode objfpc}{$H+}
{$hints off}

interface

uses
  Classes, SysUtils, SysCalls;

{$linklib lvgl}


{ Pascal headers for lvGL.

  Website : lvlgl.io

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

  The same goes for this header file (c) 2020 pjde.

}

{$PACKRECORDS C}

const
// ---------- lv_version.h ----------
  LVGL_VERSION_MAJOR                        = 7;
  LVGL_VERSION_MINOR                        = 6;
  LVGL_VERSION_PATCH                        = 0;
  LVGL_VERSION_INFO                         = '';

// ------------ lv_hal_disp.h --------------
  LV_DISP_SIZE_SMALL                        = 0;
  LV_DISP_SIZE_MEDIUM                       = 1;
  LV_DISP_SIZE_LARGE                        = 2;
  LV_DISP_SIZE_EXTRA_LARGE                  = 3;

  // ---------- lv_types.h ----------
  LV_RES_INV                                = 0;    // Typically indicates that the object is deleted (become invalid) in the action
                                                    //  function or an operation was failed
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
  LV_EVENT_GESTURE                          = 11;   // The object has been gesture
  LV_EVENT_KEY                              = 12;
  LV_EVENT_FOCUSED                          = 13;
  LV_EVENT_DEFOCUSED                        = 14;
  LV_EVENT_LEAVE                            = 15;
  LV_EVENT_VALUE_CHANGED                    = 16;   // The object's value has changed (i.e. slider moved)
  LV_EVENT_INSERT                           = 17;
  LV_EVENT_REFRESH                          = 18;
  LV_EVENT_APPLY                            = 19;   // "Ok", "Apply" or similar specific button has clicked
  LV_EVENT_CANCEL                           = 20;   // "Close", "Cancel" or similar specific button has clicked
  LV_EVENT_DELETE                           = 21;   // Object is being deleted

  _LV_EVENT_LAST                            = 22;   // Number of events

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

  LV_GESTURE_DIR_TOP                        = 0;    // Gesture dir up.
  LV_GESTURE_DIR_BOTTOM                     = 1;    // Gesture dir down.
  LV_GESTURE_DIR_LEFT                       = 2;    // Gesture dir left.
  LV_GESTURE_DIR_RIGHT                      = 3;    // Gesture dir right.

  LV_INDEV_TYPE_NONE                        = 0;    // Uninitialized state
  LV_INDEV_TYPE_POINTER                     = 1;    // Touch pad, mouse, external button
  LV_INDEV_TYPE_KEYPAD                      = 2;    // Keypad or keyboard
  LV_INDEV_TYPE_BUTTON                      = 3;    // External (hardware button) which is assigned to a specific point of the
                                                    // screen
  LV_INDEV_TYPE_ENCODER                     = 4;    // Encoder with only Left, Right turn and a Button

  LV_INDEV_STATE_REL                        = 0;
  LV_INDEV_STATE_PR                         = 1;

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

  LV_THEME_MATERIAL_FLAG_DARK               = $01;
  LV_THEME_MATERIAL_FLAG_LIGHT              = $02;
  LV_THEME_MATERIAL_FLAG_NO_TRANSITION      = $10;
  LV_THEME_MATERIAL_FLAG_NO_FOCUS           = $20;

  LV_DPI                                    = 130;

// arcs
  LV_ARC_PART_BG                            = 0;
  LV_OBJ_PART_MAIN                          = 0;
  LV_ARC_PART_INDIC                         = 1;
  LV_ARC_PART_KNOB                          = 2;
  _LV_ARC_PART_VIRTUAL_LAST                 = 3;
 // _LV_ARC_PART_REAL_LAST = _LV_OBJ_PART_REAL_LAST;

  LV_ARC_TYPE_NORMAL                        = 0;
  LV_ARC_TYPE_SYMMETRIC                     = 1;
  LV_ARC_TYPE_REVERSE                       = 2;

  LV_BAR_ANIM_STATE_START                   = 0;  // Bar animation start value. (Not the real value of the Bar just indicates process animation)
  LV_BAR_ANIM_STATE_END                     = 256;  // Bar animation end value.  (Not the real value of the Bar just indicates process animation)
  LV_BAR_ANIM_STATE_INV                     = -1;    // Mark no animation is in progress
  LV_BAR_ANIM_STATE_NORM                    = 8;

  LV_BAR_TYPE_NORMAL                        = 0;
  LV_BAR_TYPE_SYMMETRICAL                   = 1;
  LV_BAR_TYPE_CUSTOM                        = 2;

  LV_BAR_PART_BG                            = 0;    // Bar background style.
  LV_BAR_PART_INDIC                         = 1;    // Bar fill area style.
  _LV_BAR_PART_VIRTUAL_LAST                 = 2;

  LV_FONT_WIDTH_FRACT_DIGIT                 = 4;
  LV_FONT_KERN_POSITIVE                     = 0;
  LV_FONT_KERN_NEGATIVE                     = 1;

  LV_CALENDAR_PART_BG                       = 0; // Background and "normal" date numbers style
  LV_CALENDAR_PART_HEADER                   = 1; // Calendar header style
  LV_CALENDAR_PART_DAY_NAMES                = 2; // Day name style
  LV_CALENDAR_PART_DATE                     = 3; // Day name style

    (*
    LV_OBJ_PART_MAIN = 0;
    _LV_OBJ_PART_VIRTUAL_LAST = _LV_OBJ_PART_VIRTUAL_FIRST;
    _LV_OBJ_PART_REAL_LAST =    _LV_OBJ_PART_REAL_FIRST;
    LV_OBJ_PART_ALL = $FF;
      *)

  _LV_OBJ_PART_REAL_LAST = 2;               // find actual value and delete <--------------

  LV_LINEMETER_PART_MAIN                    = 0;
  _LV_LINEMETER_PART_VIRTUAL_LAST           = 1;
  _LV_LINEMETER_PART_REAL_LAST              = _LV_OBJ_PART_REAL_LAST;

  LV_GAUGE_PART_MAIN                        = LV_LINEMETER_PART_MAIN;
  LV_GAUGE_PART_MAJOR                       = _LV_LINEMETER_PART_VIRTUAL_LAST;
  LV_GAUGE_PART_NEEDLE                      = LV_GAUGE_PART_MAJOR + 1;
  _LV_GAUGE_PART_VIRTUAL_LAST               = _LV_LINEMETER_PART_VIRTUAL_LAST;
  _LV_GAUGE_PART_REAL_LAST                  = _LV_LINEMETER_PART_REAL_LAST;

  LV_TABVIEW_TAB_POS_NONE                   = 0;
  LV_TABVIEW_TAB_POS_TOP                    = 1;
  LV_TABVIEW_TAB_POS_BOTTOM                 = 2;
  LV_TABVIEW_TAB_POS_LEFT                   = 3;
  LV_TABVIEW_TAB_POS_RIGHT                  = 4;

  LV_BORDER_SIDE_NONE                       = $00;
  LV_BORDER_SIDE_BOTTOM                     = $01;
  LV_BORDER_SIDE_TOP                        = $02;
  LV_BORDER_SIDE_LEFT                       = $04;
  LV_BORDER_SIDE_RIGHT                      = $08;
  LV_BORDER_SIDE_FULL                       = $0F;
  LV_BORDER_SIDE_INTERNAL                   = $10;
  _LV_BORDER_SIDE_LAST                      = $11;

  LV_LABEL_PART_MAIN                        = 0;

  LV_LABEL_ALIGN_LEFT                       = 0; // Align text to left
  LV_LABEL_ALIGN_CENTER                     = 1; // Align text to center
  LV_LABEL_ALIGN_RIGHT                      = 2; // Align text to right
  LV_LABEL_ALIGN_AUTO                       = 3; // Use LEFT or RIGHT depending on the direction of the text (LTR/RTL)

  LV_GRAD_DIR_NONE                          = 0;
  LV_GRAD_DIR_VER                           = 1;
  LV_GRAD_DIR_HOR                           = 2;
  _LV_GRAD_DIR_LAST                         = 3;

   LV_CONT_PART_MAIN                         = LV_OBJ_PART_MAIN;
//  _LV_CONT_PART_VIRTUAL_LAST                = _LV_OBJ_PART_VIRTUAL_LAST;
  _LV_CONT_PART_REAL_LAST                   = _LV_OBJ_PART_REAL_LAST;

  LV_PAGE_PART_BG                           = LV_CONT_PART_MAIN;
//  LV_PAGE_PART_SCROLLBAR                    = _LV_OBJ_PART_VIRTUAL_LAST;
//  LV_PAGE_PART_EDGE_FLASH                   = LV_PAGE_PART_SCROLLBAR + 1;
//  _LV_PAGE_PART_VIRTUAL_LAST                = LV_PAGE_PART_EDGE_FLASH + 1;

  LV_PAGE_PART_SCROLLABLE                   = _LV_OBJ_PART_REAL_LAST;
  _LV_PAGE_PART_REAL_LAST                   = LV_PAGE_PART_SCROLLABLE + 1;

  LV_LIST_PART_BG                           = LV_PAGE_PART_BG; // List background style
//  LV_LIST_PART_SCROLLBAR                    = LV_PAGE_PART_SCROLLBAR; // List scrollbar style.
//  LV_LIST_PART_EDGE_FLASH                   = LV_PAGE_PART_EDGE_FLASH; // List edge flash style.
//  _LV_LIST_PART_VIRTUAL_LAST                = _LV_PAGE_PART_VIRTUAL_LAST,
  LV_LIST_PART_SCROLLABLE                   = LV_PAGE_PART_SCROLLABLE; // List scrollable area style.
  _LV_LIST_PART_REAL_LAST                   = _LV_PAGE_PART_REAL_LAST;

  // Text decorations (Use 'OR'ed values)
  LV_TEXT_DECOR_NONE                        = $00;
  LV_TEXT_DECOR_UNDERLINE                   = $01;
  LV_TEXT_DECOR_STRIKETHROUGH               = $02;
  _LV_TEXT_DECOR_LAST                       = $03;

  LV_LED_BRIGHT_MIN                         = 120;
  LV_LED_BRIGHT_MAX                         = 255;

  LV_STYLE_STATE_POS                        = 8;
  LV_STYLE_STATE_MASK                       = $7F00;
  LV_STYLE_INHERIT_MASK                     = $8000;

  LV_STYLE_ID_VALUE                         = $00;   // max 9 pcs
  LV_STYLE_ID_COLOR                         = $09;   // max 3 pcs
  LV_STYLE_ID_OPA                           = $0C;   // max 2 pcs
  LV_STYLE_ID_PTR                           = $0E;   // max 2 pcs

  LV_STYLE_RADIUS                           = $01;
  LV_STYLE_CLIP_CORNER                      = $02;
  LV_STYLE_SIZE                             = $03;
  LV_STYLE_TRANSFORM_WIDTH                  = $04;
  LV_STYLE_TRANSFORM_HEIGHT                 = $05;
  LV_STYLE_TRANSFORM_ANGLE                  = $07;
  LV_STYLE_TRANSFORM_ZOOM                   = $08;
  LV_STYLE_OPA_SCALE                        = $800C;

  LV_STYLE_PAD_TOP                          = $10;
  LV_STYLE_PAD_BOTTOM                       = $11;
  LV_STYLE_PAD_LEFT                         = $12;
  LV_STYLE_PAD_RIGHT                        = $13;
  LV_STYLE_PAD_INNER                        = $14;
  LV_STYLE_MARGIN_TOP                       = $15;
  LV_STYLE_MARGIN_BOTTOM                    = $16;
  LV_STYLE_MARGIN_LEFT                      = $17;
  LV_STYLE_MARGIN_RIGHT                     = $18;

  LV_STYLE_BG_BLEND_MODE                    = $20;
  LV_STYLE_BG_MAIN_STOP                     = $21;
  LV_STYLE_BG_GRAD_STOP                     = $22;
  LV_STYLE_BG_GRAD_DIR                      = $23;
  LV_STYLE_BG_COLOR                         = $29;
  LV_STYLE_BG_GRAD_COLOR                    = $2A;
  LV_STYLE_BG_OPA                           = $2C;

  LV_STYLE_BORDER_WIDTH                     = $30;
  LV_STYLE_BORDER_SIDE                      = $31;
  LV_STYLE_BORDER_BLEND_MODE                = $32;
  LV_STYLE_BORDER_POST                      = $33;
  LV_STYLE_BORDER_COLOR                     = $39;
  LV_STYLE_BORDER_OPA                       = $3C;

  LV_STYLE_OUTLINE_WIDTH                    = $40;
  LV_STYLE_OUTLINE_PAD                      = $41;
  LV_STYLE_OUTLINE_BLEND_MODE               = $42;
  LV_STYLE_OUTLINE_COLOR                    = $49;
  LV_STYLE_OUTLINE_OPA                      = $4C;

  LV_STYLE_SHADOW_WIDTH                     = $50;
  LV_STYLE_SHADOW_OFS_X                     = $51;
  LV_STYLE_SHADOW_OFS_Y                     = $52;
  LV_STYLE_SHADOW_SPREAD                    = $53;
  LV_STYLE_SHADOW_BLEND_MODE                = $54;
  LV_STYLE_SHADOW_COLOR                     = $59;
  LV_STYLE_SHADOW_OPA                       = $5C;

  LV_STYLE_PATTERN_BLEND_MODE               = $60;
  LV_STYLE_PATTERN_REPEAT                   = $61;
  LV_STYLE_PATTERN_RECOLOR                  = $69;
  LV_STYLE_PATTERN_OPA                      = $6C;
  LV_STYLE_PATTERN_RECOLOR_OPA              = $6D;
  LV_STYLE_PATTERN_IMAGE                    = $6E;

  LV_STYLE_VALUE_LETTER_SPACE               = $70;
  LV_STYLE_VALUE_LINE_SPACE                 = $71;
  LV_STYLE_VALUE_BLEND_MODE                 = $72;
  LV_STYLE_VALUE_OFS_X                      = $73;
  LV_STYLE_VALUE_OFS_Y                      = $74;
  LV_STYLE_VALUE_ALIGN                      = $75;
  LV_STYLE_VALUE_COLOR                      = $79;
  LV_STYLE_VALUE_OPA                        = $7C;
  LV_STYLE_VALUE_FONT                       = $7E;
  LV_STYLE_VALUE_STR                        = $7F;

  LV_STYLE_TEXT_LETTER_SPACE                = $8080;
  LV_STYLE_TEXT_LINE_SPACE                  = $8081;
  LV_STYLE_TEXT_DECOR                       = $8082;
  LV_STYLE_TEXT_BLEND_MODE                  = $8083;
  LV_STYLE_TEXT_COLOR                       = $8089;
  LV_STYLE_TEXT_SEL_COLOR                   = $808A;
  LV_STYLE_TEXT_OPA                         = $808C;
  LV_STYLE_TEXT_FONT                        = $808E;

  LV_STYLE_LINE_WIDTH                       = $90;
  LV_STYLE_LINE_BLEND_MODE                  = $91;
  LV_STYLE_LINE_DASH_WIDTH                  = $92;
  LV_STYLE_LINE_DASH_GAP                    = $93;
  LV_STYLE_LINE_ROUNDED                     = $94;
  LV_STYLE_LINE_COLOR                       = $99;
  LV_STYLE_LINE_OPA                         = $9C;

  LV_STYLE_IMAGE_BLEND_MODE                 = $80A0;
  LV_STYLE_IMAGE_RECOLOR                    = $80A9;
  LV_STYLE_IMAGE_OPA                        = $80AC;
  LV_STYLE_IMAGE_RECOLOR_OPA                = $80AD;

  LV_STYLE_TRANSITION_TIME                  = $B0;
  LV_STYLE_TRANSITION_DELAY                 = $B1;
  LV_STYLE_TRANSITION_PROP_1                = $B2;
  LV_STYLE_TRANSITION_PROP_2                = $B3;
  LV_STYLE_TRANSITION_PROP_3                = $B4;
  LV_STYLE_TRANSITION_PROP_4                = $B5;
  LV_STYLE_TRANSITION_PROP_5                = $B6;
  LV_STYLE_TRANSITION_PROP_6                = $B7;
  LV_STYLE_TRANSITION_PATH                  = $BE;

  LV_STYLE_SCALE_WIDTH                      = $C0;
  LV_STYLE_SCALE_BORDER_WIDTH               = $C1;
  LV_STYLE_SCALE_END_BORDER_WIDTH           = $C2;
  LV_STYLE_SCALE_END_LINE_WIDTH             = $C3;
  LV_STYLE_SCALE_GRAD_COLOR                 = $C9;
  LV_STYLE_SCALE_END_COLOR                  = $CA;

  LV_SLIDER_TYPE_NORMAL                     = 0;
  LV_SLIDER_TYPE_SYMMETRICAL                = 1;
  LV_SLIDER_TYPE_RANGE                      = 2;

  LV_SLIDER_PART_BG                         = 0; // Slider background style.
  LV_SLIDER_PART_INDIC                      = 1; // Slider indicator (filled area) style.
  LV_SLIDER_PART_KNOB                       = 2; // Slider knob style.

  LV_ANIM_OFF                               = 0;
  LV_ANIM_ON                                = 1;

  LV_SWITCH_PART_BG                         = LV_BAR_PART_BG;                 // Switch background.
  LV_SWITCH_PART_INDIC                      = LV_BAR_PART_INDIC;           // Switch fill area.
  LV_SWITCH_PART_KNOB                       = _LV_BAR_PART_VIRTUAL_LAST;    // Switch knob.
  _LV_SWITCH_PART_VIRTUAL_LAST              = LV_SWITCH_PART_KNOB + 1;

  LV_CHART_TYPE_NONE                        = $00; // Don't draw the series
  LV_CHART_TYPE_LINE                        = $01; // Connect the points with lines
  LV_CHART_TYPE_COLUMN                      = $02; // Draw columns
  LV_CHART_TYPE_SCATTER                     = $03; // X/Y chart, points and/or lines

  LV_BTN_STATE_RELEASED                     = 0;
  LV_BTN_STATE_PRESSED                      = 1;
  LV_BTN_STATE_DISABLED                     = 2;
  LV_BTN_STATE_CHECKED_RELEASED             = 3;
  LV_BTN_STATE_CHECKED_PRESSED              = 4;
  LV_BTN_STATE_CHECKED_DISABLED             = 5;
  _LV_BTN_STATE_LAST                        = 6; // Number of states

  LV_BTNMATRIX_CTRL_HIDDEN                  = $0008; // Button hidden
  LV_BTNMATRIX_CTRL_NO_REPEAT               = $0010; // Do not repeat press this button.
  LV_BTNMATRIX_CTRL_DISABLED                = $0020; // Disable this button.
  LV_BTNMATRIX_CTRL_CHECKABLE               = $0040; // Button *can* be toggled.
  LV_BTNMATRIX_CTRL_CHECK_STATE             = $0080; // Button is currently toggled (e.g. checked).
  LV_BTNMATRIX_CTRL_CLICK_TRIG              = $0100; // 1: Send LV_EVENT_SELECTED on CLICK, 0: Send LV_EVENT_SELECTED on PRESS

  LV_BTNMATRIX_PART_BG                      = 0;
  LV_BTNMATRIX_PART_BTN                     = 1;

  LV_DROPDOWN_DIR_DOWN                      = 0;
  LV_DROPDOWN_DIR_UP                        = 1;
  LV_DROPDOWN_DIR_LEFT                      = 2;
  LV_DROPDOWN_DIR_RIGHT                     = 3;

  LV_DROPDOWN_PART_MAIN                     = LV_OBJ_PART_MAIN;
  LV_DROPDOWN_PART_LIST                     = _LV_OBJ_PART_REAL_LAST;
  LV_DROPDOWN_PART_SCROLLBAR                = LV_DROPDOWN_PART_LIST + 1;
  LV_DROPDOWN_PART_SELECTED                 = LV_DROPDOWN_PART_LIST + 2;

  LV_SCROLLBAR_MODE_OFF                     = $00; // Never show scroll bars
  LV_SCROLLBAR_MODE_ON                      = $01; // Always show scroll bars
  LV_SCROLLBAR_MODE_DRAG                    = $02; // Show scroll bars when page is being dragged
  LV_SCROLLBAR_MODE_AUTO                    = $03; // Show scroll bars when the scrollable container is large enough to be scrolled
  LV_SCROLLBAR_MODE_HIDE                    = $04; // Hide the scroll bar temporally
  LV_SCROLLBAR_MODE_UNHIDE                  = $08; // Unhide the previously hidden scroll bar. Recover original mode too

  LV_PAGE_EDGE_LEFT                         = $01;
  LV_PAGE_EDGE_TOP                          = $02;
  LV_PAGE_EDGE_RIGHT                        = $04;
  LV_PAGE_EDGE_BOTTOM                       = $08;

  LV_LAYOUT_OFF                             = 0; // No layout
  LV_LAYOUT_CENTER                          = 1; // Center objects
  LV_LAYOUT_COLUMN_LEFT                     = 2; // Column left align
  LV_LAYOUT_COLUMN_MID                      = 3; // Column middle align
  LV_LAYOUT_COLUMN_RIGHT                    = 4; // Column right align
  LV_LAYOUT_ROW_TOP                         = 5; // Row top align
  LV_LAYOUT_ROW_MID                         = 6; // Row middle align
  LV_LAYOUT_ROW_BOTTOM                      = 7; // Row bottom align
  LV_LAYOUT_PRETTY_TOP                      = 8; // Row top align
  LV_LAYOUT_PRETTY_MID                      = 9; // Row middle align
  LV_LAYOUT_PRETTY_BOTTOM                   = 10; // Row bottom align
  LV_LAYOUT_GRID                            = 11; // Align same-sized object into a grid
  _LV_LAYOUT_LAST                           = 12;

   LV_FIT_NONE                               = 0; // Do not change the size automatically
  LV_FIT_TIGHT                              = 1; // Shrink wrap around the children
  LV_FIT_PARENT                             = 2; // Align the size to the parent's edge
  LV_FIT_MAX                                = 3; // Align the size to the parent's edge first but if there is an object out of it
                                                 // then get larger
  _LV_FIT_LAST                              = 4;

  LV_STATE_DEFAULT                          = $00;
  LV_STATE_CHECKED                          = $01;
  LV_STATE_FOCUSED                          = $02;
  LV_STATE_EDITED                           = $04;
  LV_STATE_HOVERED                          = $08;
  LV_STATE_PRESSED                          = $00;
  LV_STATE_DISABLED                         = $20;

  LV_OPA_TRANSP                             = 0;
  LV_OPA_0                                  = 0;
  LV_OPA_10                                 = 25;
  LV_OPA_20                                 = 51;
  LV_OPA_30                                 = 76;
  LV_OPA_40                                 = 102;
  LV_OPA_50                                 = 127;
  LV_OPA_60                                 = 153;
  LV_OPA_70                                 = 178;
  LV_OPA_80                                 = 204;
  LV_OPA_90                                 = 229;
  LV_OPA_100                                = 255;
  LV_OPA_COVER                              = 255;

  LV_TABLE_PART_BG                          = 0;
  LV_TABLE_PART_CELL1                       = 1;
  LV_TABLE_PART_CELL2                       = 2;
  LV_TABLE_PART_CELL3                       = 3;
  LV_TABLE_PART_CELL4                       = 4;

  LV_CHART_PART_BG                          = LV_OBJ_PART_MAIN;
 // LV_CHART_PART_SERIES_BG                   = _LV_OBJ_PART_VIRTUAL_LAST;
//  LV_CHART_PART_SERIES                      = LV_CHART_PART_SERIES_BG + 1;


  LV_ROLLER_MODE_NORMAL                     = 0; // Normal mode (roller ends at the end of the options).
  LV_ROLLER_MODE_INIFINITE                  = 1; // Infinite mode (roller can be scrolled forever).

type
  Tlv_obj = record    // may not need to elaborate as may not need to access directly    should be 68 bytes in size
  end;

  Tuint8 = byte;
  Tint8 = byte;
  Tuint16 = word;
  Tint16 = SmallInt;
  Tuint32 = LongWord;
  Tint32 = integer;

  Plv_obj = ^Tlv_obj;
  Tlv_res = Tuint8;
  Tlv_coord = Tint16; // to match conf settings
  Plv_coord = ^Tlv_coord;
  Tlv_align = Tuint8;
  Tlv_state = Tuint8;
  Tlv_style = record
  end;

  Plv_style = ^Tlv_style;
  Tlv_drag_dir = Tuint8;
  Tlv_bidi_dir = Tuint8;
  Tlv_event = Tuint8;
  Tlv_opa = Tuint8;
  Plv_opa = ^Tlv_opa;
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
  Tlv_disp_size = Tuint32;     // enum
  Tlv_gesture_dir = Tuint8;

  Tlv_indev = record
 (*  driver : Tlv_indev_drv;
   proc : Tlv_indev_proc;
   cursor : Plv_obj;     // Cursor for LV_INPUT_TYPE_POINTER
   group : Plv_group;    // Keypad destination group
   btn_points : Plv_point; // Array points assigned to the button ()screen will be pressed
   *)                                //   here by the buttons
  end;
  Plv_indev = ^Tlv_indev;
  Tlv_indev_type = Tuint8;

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
  Tlv_font_user_data = pointer;

  Tlv_color = packed record // assume 32 bit
    case integer of
      0 :
        (
          blue : Tuint8;
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

  Tlv_task = record
  end;
  Plv_task = ^Tlv_task;

  Tlv_disp_buf = record                 // 28 bytes
    buf1 : pointer;                     // First display buffer. (4 -> 4)
    buf2 : pointer;                     // Second display buffer. (4 -> 8)
    // Internal, used by the library
    buf_act : pointer;                  // (4 -> 12)
    size : Tuint32;                     // In pixel count (4 -> 16)
    area : Tlv_area;                    // (4 * 2 -> 24)
    flushing : Tuint32;                 // bit 1 (4 -> 28)
    flushing_last : Tuint32;
    last_area : Tuint32;
    lasp_part : Tuint32;
  end;
  Plv_disp_buf = ^Tlv_disp_buf;

  Tlv_disp = record                     // 364 bytes
    fill : array [0 .. 363] of byte;
  end;
  Plv_disp = ^Tlv_disp;

  Tlv_disp_drv = record                 // 44 bytes
    hor_res : Tlv_coord;                // Horizontal resolution. (2 -> 2)
    ver_res : Tlv_coord;                // Vertical resolution. (2 -> 4)
    buffer : Plv_disp_buf;              // pointer to buffer (4 -> 8)
    dpi : Tuint32;                      // dpi. (4 -> 12)
    flush_cb : pointer;                 // pointer to procedure (4 -> 16)
    rounder_cb : pointer;               // pointer to procedure (4 -> 20)
    set_px_cb : pointer;                // pointer to procedure (4 -> 24)
    monitor_cb : pointer;               // pointer to procedure (4 -> 28)
    wait_cb : pointer;                  // pointer to procedure (4 -> 32)
    gpu_blend_cb : pointer;             // pointer to procedure (4 -> 36)
    gpu_fill_cb : pointer;              // pointer to procedure (4 -> 40)
    color_chroma_key : Tlv_color;       // (4 -> 44)
  end;
  Plv_disp_drv = ^Tlv_disp_drv;

//     bool ( *read_cb)(struct _lv_indev_drv_t * indev_drv, lv_indev_data_t * data);     /**< Function pointer to read input device data.
// void ( *feedback_cb)(struct _lv_indev_drv_t *, uint8_t);      /** Called when an action happened on the input device.

  Tlv_indev_state = Tuint8;
  Tlv_indev_data = record
    point : Tlv_point; // For LV_INDEV_TYPE_POINTER the currently pressed point
    key : Tuint32;     // For LV_INDEV_TYPE_KEYPAD the currently pressed key
    btn_id : Tuint32;  // For LV_INDEV_TYPE_BUTTON the currently pressed button
    enc_diff : Tint16; // For LV_INDEV_TYPE_ENCODER number of steps since the previous read
    state : Tlv_indev_state; // LV_INDEV_STATE_REL or LV_INDEV_STATE_PR
  end;
  Plv_indev_data = ^Tlv_indev_data;

  Tlv_indev_drv = record  // 28 bytes
    _type : Tlv_indev_type;     // Input device type
    read_cb : pointer; // 4 to function
    feedback_cb : pointer;  // 4 to procedure
(*
#if LV_USE_USER_DATA
    lv_indev_drv_user_data_t user_data;
#endif
  *)
    disp : Plv_disp;     // 4 Pointer to the assigned display


    read_task : pointer; // Plv_task;   // 4
    drag_limit : Tuint8;     // 1 Number of pixels to slide before actually drag the object
    drag_throw : Tuint8;  // 1 Drag throw slow-down in [%]. Greater value means faster slow-down */
    gesture_min_velocity : Tuint8;   // 1 At least this difference should between two points to evaluate as gesture */
    gesture_limit : Tuint8;      // 1 At least this difference should be to send a gesture
    long_press_time : Tuint16;  // 2 Long press time in milliseconds
    long_press_rep_time : Tuint16;    // 2 Repeated trigger period in long press [ms]
  end;
  Plv_indev_drv = ^Tlv_indev_drv;

// ----------- lv_blend.h ------------
  Tlv_blend_mode = Tuint8;

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

// ------------ lv_anim.h --------------
  Tlv_anim_enable = Tuint8;
  Tlv_anim_value = Tlv_coord;

// ------------ lv_style.h --------------
  Tlv_style_list = record  // no need to actually define this in detail 8 bytes
  end;
  Plv_style_list = ^Tlv_style_list;

  Tlv_border_side = Tuint8;
  Tlv_grad_dir = Tuint8;
  Tlv_text_decor = Tuint8;
  Tlv_style_attr = Tuint8;

  Tlv_style_property = Tuint16;
  Tlv_style_int = Tint16;
  Plv_style_int = ^Tlv_style_int;

// #define LV_STYLE_ATTR_GET_INHERIT(f) ((f)&0x80)
// #define LV_STYLE_ATTR_GET_STATE(f) ((f)&0x7F)

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

// ------------ lv_arc.h ---------------
  Tlv_arc_part = Tuint8;
  Tlv_arc_type = Tuint8;

// ------------ lv_arc.h ---------------
  Tlv_roller_mode = Tuint8;

// ------------ lv_bar.h ---------------
  Tlv_bar_type = Tuint8;
  Tlv_bar_part = Tuint8;

// ------------ lv_btnmatrix.h ---------------
  Tlv_btnmatrix_ctrl = Tuint16;
  Tlv_btnmatrix_part = Tuint8;


// ------------ lv_list.h ---------------
  Tlv_list_style_t = Tuint8;

// ------------ lv_font.h ---------------
  Tlv_font = record
    get_glyph_desc : pointer;            // 4 to function
    get_glyph_bitmap : pointer;          // 4 to function
    line_height : Tlv_coord;             // 2 The real line height where any text fits
    baseline : Tlv_coord;                // 2 Base line measured from the top of the line_height
    subpx : Tuint8;                      // 1 bit 2 - An element of `lv_font_subpx_t
    underline_position : Tint8;          // 1 Distance between the top of the underline and base line (< 0 means below the base line)
    underline_thickness : Tint8;         // 1 Thickness of the underline
    dsc : pointer;                       // 4 Store implementation specific or run_time data or caching here
//    user_data : Tlv_font_user_data;      // 4 Custom user data for font. - Not using LV_USE_DATA
  end;
  Plv_font = ^Tlv_font;

// ------------ lv_bar.h ---------------


// ------------ lv_chart.h ---------------
  Tlv_chart_axis = Tuint8;

  Tlv_chart_series = record
    points : Plv_coord;
    color : Tlv_color;
    start_point : Tuint16;
    ext_buf_assigned : Tuint8;
    y_axis : Tlv_chart_axis;
  end;
  Plv_chart_series = ^Tlv_chart_series;
  Tlv_chart_axis_options = Tuint8;
  Tlv_chart_update_mode = Tuint8;
  Tlv_chart_type = Tuint8;

  // ------------ lv_calendar.h ---------------
  Tlv_calendar_date = record
    year : Tuint16;
    month : Tuint8;
    day : Tuint8;
  end;
  Plv_calendar_date = ^Tlv_calendar_date;

  Tlv_calendar_ext = record
    today : Tlv_calendar_date;               // Date of today
    showed_date : Tlv_calendar_date;         // Currently visible month (day is ignored)
    highlighted_dates : Plv_calendar_date;   // Apply different style on these days (pointer to an
                                             //  array defined by the user)
    btn_pressing : Tint8;                    // -1: prev month pressing, +1 next month pressing on the header
    highlighted_dates_num : Tuint16;         // Number of elements in `highlighted_days`
    pressed_date : Tlv_calendar_date;
    day_names : PPChar;                      // Pointer to an array with the name of the days (NULL: use default names)
    month_names : PPChar;                    // Pointer to an array with the name of the month (NULL. use default names)

    style_header : Tlv_style_list;
    style_day_names : Tlv_style_list;
    style_date_nums : Tlv_style_list;
  end;

  // Calendar parts
  Tlv_calendar_part = Tuint8;

// ------------ lv_linemeter.h ---------------

  Tlv_linemeter_ext = record
    scale_angle : Tuint16; // Angle of the scale in deg. (0..360)
    angle_ofs : Tuint16;
    line_cnt : Tuint16;     // Count of lines
    cur_value : Tint32;
    min_value : Tint32;
    max_value : Tint32;
    mirrored : Tuint8;
  end;

  Tlv_linemeter_part = Tuint8;

// ------------ lv_gauge.h ----------------
  Tlv_gauge_ext = record
    lmeter : Tlv_linemeter_ext; // Ext. of ancestor
    // New data for this type
    values : Pint32;        // Array of the set values (for needles)
    needle_colors : Plv_color; // Color of the needles (lv_color_t my_colors[needle_num])
    needle_img : pointer;
    needle_img_pivot : Tlv_point;
    style_needle : Tlv_style_list;
    style_strong : Tlv_style_list;
    needle_count : Tuint8;             // Number of needles
    label_count  : Tuint8;              // Number of labels on the scale
    format_cb : pointer; // to callback function
  end;

  Tlv_gauge_style = Tuint8;

// ------------ lv_page.h ----------------
  Tlv_scrollbar_mode = Tuint8;
  Tlv_page_edge = Tuint8;

// ------------ lv_switch.h ----------------
  Tlv_switch_ext = record
    style_knob : Tlv_style_list; // Style of the knob
    state : Tuint8;              // The current state
  end;
  Plv_switch_ext = ^Tlv_switch_ext;
  Tlv_switch_part = Tuint8;

// ------------ lv_slider.h ----------------
  Tlv_slider_type = Tuint8;

// ------------ lv_dropdown.h ----------------
  Tlv_dropdown_dir = Tuint8;
  Tlv_dropdown_part = Tuint8;

// ------------ lv_tabview.h ----------------
  Tlv_tabview_btns_pos = Tuint8;

  Tlv_tabview_ext = record
    btns : Plv_obj;
    indic : Plv_obj;
    content : Plv_obj; // A background page which holds tab's pages
    tab_name_ptr : PPChar;
    point_last : Tlv_point;
    tab_cur : Tuint16;
    tab_cnt : Tuint16;
  //#if LV_USE_ANIMATION
  //    uint16_t anim_time;
  //#endif
    btn_pos : Tlv_tabview_btns_pos;
  end;

{
    LV_TABVIEW_PART_BG = LV_OBJ_PART_MAIN,
    _LV_TABVIEW_PART_VIRTUAL_LAST = _LV_OBJ_PART_VIRTUAL_LAST,

    LV_TABVIEW_PART_BG_SCRLLABLE = _LV_OBJ_PART_REAL_LAST,
    LV_TABVIEW_PART_TAB_BG,
    LV_TABVIEW_PART_TAB_BTN,
    LV_TABVIEW_PART_INDIC,
    _LV_TABVIEW_PART_REAL_LAST,
}
  Tlv_tabview_part = Tuint8;


// ------------ lv_themes.h ----------------
(*
typedef void ( *lv_theme_apply_cb_t)(struct _lv_theme_t *, lv_obj_t *, lv_theme_style_t);
typedef void ( *lv_theme_apply_xcb_t)(lv_obj_t *, lv_theme_style_t); /*Deprecated: use `apply_cb` instead*/
*)


  Tlv_theme_style = Tint32;      // enum

  Plv_theme = ^Tlv_theme;
  Tlv_theme = record
    apply_cb : pointer;   // pointer to apply function
    apply_xcp : pointer; // Deprecated: use `apply_cb` instead*/
    base : Plv_theme;  // Apply the current theme's style on top of this theme.
    color_primary : Tlv_color;
    color_secondary : Tlv_color;
    font_small : Plv_font;
    font_normal : Plv_font;
    font_subtitle : Plv_font;
    font_title : Plv_font;
    flags : Tuint32;
    user_data : pointer;
  end;

const
  LV_COLOR_WHITE : Tlv_color                = (blue : $FF; green : $FF; red : $FF; alpha : $FF);
  LV_COLOR_SILVER  : Tlv_color              = (blue : $C0; green : $C0; red : $C0; alpha : $FF);
  LV_COLOR_GRAY : Tlv_color                 = (blue : $80; green : $80; red : $80; alpha : $FF);
  LV_COLOR_BLACK : Tlv_color                = (blue : $00; green : $00; red : $00; alpha : $FF);
  LV_COLOR_RED : Tlv_color                  = (blue : $00; green : $00; red : $FF; alpha : $FF);
  LV_COLOR_MAROON : Tlv_color               = (blue : $00; green : $00; red : $80; alpha : $FF);
  LV_COLOR_YELLOW : Tlv_color               = (blue : $00; green : $FF; red : $FF; alpha : $FF);
  LV_COLOR_OLIVE : Tlv_color                = (blue : $00; green : $80; red : $80; alpha : $FF);
  LV_COLOR_LIME : Tlv_color                 = (blue : $00; green : $FF; red : $00; alpha : $FF);
  LV_COLOR_GREEN : Tlv_color                = (blue : $00; green : $80; red : $00; alpha : $FF);
  LV_COLOR_CYAN : Tlv_color                 = (blue : $FF; green : $FF; red : $00; alpha : $FF);
  LV_COLOR_TEAL : Tlv_color                 = (blue : $80; green : $80; red : $00; alpha : $FF);
  LV_COLOR_BLUE : Tlv_color                 = (blue : $FF; green : $00; red : $00; alpha : $FF);
  LV_COLOR_NAVY : Tlv_color                 = (blue : $80; green : $00; red : $00; alpha : $FF);
  LV_COLOR_MAGENTA : Tlv_color              = (blue : $FF; green : $00; red : $FF; alpha : $FF);
  LV_COLOR_PURPLE : Tlv_color               = (blue : $80; green : $00; red : $80; alpha : $FF);
  LV_COLOR_ORANGE : Tlv_color               = (blue : $00; green : $A5; red : $FF; alpha : $FF);
  LV_COLOR_AQUA : Tlv_color                 = (blue : $FF; green : $FF; red : $00; alpha : $FF);

  LV_THEME_DEFAULT_COLOR_PRIMARY : Tlv_color = (blue : $01; green : $A2; red : $B1; alpha : $FF); // lv_color_hex(0x01a2b1)
  LV_THEME_DEFAULT_COLOR_SECONDARY : Tlv_color = (blue : $44; green : $D1; red : $B6; alpha : $FF); // lv_color_hex(0x44d1b6)


procedure lv_log_register_print_cb (print_cb : Tlv_log_print_g_cb); cdecl; external;
procedure lv_init; cdecl; external;

function lv_obj_create (parent : Plv_obj; copy : Plv_obj) : Plv_obj; cdecl; external;
function lv_obj_del (obj : Plv_obj) : Tlv_res; cdecl; external;
//procedure lv_obj_del_anim_ready_cb (a : Plv_anim); cdecl; external;
procedure lv_obj_del_async (obj : Plv_obj); cdecl; external;
procedure lv_obj_clean (obj : Plv_obj); cdecl; external;
procedure lv_obj_invalidate_area(const obj : Plv_obj; const area : Plv_area); cdecl; external;
procedure lv_obj_invalidate (const obj : Plv_obj); cdecl; external;

function lv_obj_area_is_visible (const obj : Plv_obj; area : Plv_area) : LongBool; cdecl; external;
function lv_obj_is_visible (const obj : Plv_obj) : LongBool; cdecl; external;
procedure lv_obj_set_parent (obj : Plv_obj; parent : Plv_obj); cdecl; external;
procedure lv_obj_move_foreground (obj : Plv_obj); cdecl; external;
procedure lv_obj_move_background (obj : Plv_obj); cdecl; external;

procedure lv_obj_set_pos (obj : Plv_obj; x, y : Tlv_coord); cdecl; external;
procedure lv_obj_set_x (obj : Plv_obj; x : Tlv_coord); cdecl; external;
procedure lv_obj_set_y (obj : Plv_obj; y : Tlv_coord); cdecl; external;
procedure lv_obj_set_size (obj : Plv_obj; w : Tlv_coord; h : Tlv_coord); cdecl; external;
procedure lv_obj_set_width (obj : Plv_obj; w : Tlv_coord); cdecl; external;
procedure lv_obj_set_height (obj : Plv_obj; h : Tlv_coord); cdecl; external;

procedure lv_obj_set_width_fit (obj : Plv_obj; w : Tlv_coord); cdecl; external;
procedure lv_obj_set_height_fit (obj : Plv_obj; h : Tlv_coord); cdecl; external;
procedure lv_obj_set_width_margin (obj : Plv_obj; w : Tlv_coord); cdecl; external;
procedure lv_obj_set_height_margin (obj : Plv_obj; h : Tlv_coord); cdecl; external;

procedure lv_obj_align (obj : Plv_obj; const base : Plv_obj; align : Tlv_align; x_mod, y_mod : Tlv_coord); cdecl; external;
//procedure lv_obj_align_origo (obj : Plv_obj; const base : Plv_obj; align : Tlv_align; x_mod, y_mod : Tlv_coord); cdecl; external;
procedure lv_obj_align_x (obj : Plv_obj; const base : Plv_obj; align : Tlv_align; x_ofs : Tlv_coord); cdecl; external;
procedure lv_obj_align_y (obj : Plv_obj; const base : Plv_obj; align : Tlv_align; y_ofs : Tlv_coord); cdecl; external;
procedure lv_obj_align_mid (obj : Plv_obj; const base : Plv_obj; align : Tlv_align; x_ofs, y_ofs : Tlv_coord); cdecl; external;
procedure lv_obj_align_mid_x (obj : Plv_obj; const base : Plv_obj; align : Tlv_align; x_ofs : Tlv_coord); cdecl; external;
procedure lv_obj_align_mid_y (obj : Plv_obj; const base : Plv_obj; align : Tlv_align; y_ofs : Tlv_coord); cdecl; external;

procedure lv_obj_realign (obj : Plv_obj); cdecl; external;
procedure lv_obj_set_auto_realign (obj : Plv_obj; en : LongBool); cdecl; external;

procedure lv_obj_set_ext_click_area (obj : Plv_obj; left, right, top, bottom : Tlv_coord); cdecl; external;
procedure lv_obj_add_style (obj : Plv_obj; part : Tuint8; style : Plv_style); cdecl; external;
procedure lv_obj_remove_style (obj : Plv_obj; part : Tuint8; style : Plv_style); cdecl; external;
procedure lv_obj_clean_style_list (obj : Plv_obj; part : Tuint8); cdecl; external;
procedure lv_obj_reset_style_list (obj : Plv_obj; part : Tuint8); cdecl; external;
//procedure lv_obj_refresh_style (obj : Plv_obj); cdecl; external;
procedure lv_obj_refresh_style (obj : Plv_obj; part : Tuint8; prop : Tlv_style_property); cdecl; external;
procedure lv_obj_report_style_mod (style : Plv_style); cdecl; external;
procedure lv_obj_set_style (obj : Plv_obj; const style : Plv_style); cdecl; external;
procedure _lv_obj_set_style_local_color (obj : Plv_obj; _type : Tuint8; prop : Tlv_style_property; color : Tlv_color); cdecl; external;
procedure _lv_obj_set_style_local_int (obj : Plv_obj; _type : Tuint8; prop : Tlv_style_property; value : Tlv_style_int); cdecl; external;
procedure _lv_obj_set_style_local_opa (obj : Plv_obj; _type : Tuint8; prop : Tlv_style_property; opa : Tlv_opa); cdecl; external;
procedure _lv_obj_set_style_local_ptr (obj : Plv_obj; _type : Tuint8; prop : Tlv_style_property; const value : pointer); cdecl; external;

function lv_obj_remove_style_local_prop (obj : Plv_obj; part : Tuint8; prop : Tlv_style_property) : LongBool; cdecl; external;
procedure _lv_obj_disable_style_caching (obj : Plv_obj; dir : LongBool); cdecl; external;

procedure lv_obj_set_hidden (obj : Plv_obj; en : LongBool); cdecl; external;
procedure lv_obj_set_adv_hittest (obj : Plv_obj; en : LongBool); cdecl; external;
procedure lv_obj_set_click (obj : Plv_obj; en : LongBool); cdecl; external;

procedure lv_obj_set_top (obj : Plv_obj; en : LongBool); cdecl; external;
procedure lv_obj_set_drag (obj : Plv_obj; en : LongBool); cdecl; external;
procedure lv_obj_set_drag_dir (obj : Plv_obj; drag_dir : Tlv_drag_dir); cdecl; external;

procedure lv_obj_set_drag_throw (obj : Plv_obj; en : LongBool); cdecl; external;

procedure lv_obj_set_drag_parent (obj : Plv_obj; en : LongBool); cdecl; external;
procedure lv_obj_set_focus_parent(obj : Plv_obj; en : LongBool); cdecl; external;
procedure lv_obj_set_gesture_parent(obj : Plv_obj; en : LongBool); cdecl; external;
procedure lv_obj_set_parent_event (obj : Plv_obj; en : LongBool); cdecl; external;
procedure lv_obj_set_base_dir (obj : Plv_obj; dir : Tlv_bidi_dir); cdecl; external;

procedure lv_obj_add_protect (obj : Plv_obj; prot : Tuint8); cdecl; external;
procedure lv_obj_clear_protect (obj : Plv_obj; prot : Tuint8); cdecl; external;
procedure lv_obj_set_state (obj : Plv_obj; state : Tlv_state); cdecl; external;
procedure lv_obj_add_state (lobj : Plv_obj; state : Tlv_state); cdecl; external;
procedure lv_obj_clear_state (obj : Plv_obj; state : Tlv_state); cdecl; external;
procedure lv_obj_finish_transitions (obj : Plv_obj; part : Tuint8); cdecl; external;

procedure lv_obj_set_opa_scale_enable (obj : Plv_obj; en : LongBool); cdecl; external;
procedure lv_obj_set_opa_scale (obj : Plv_obj; opa_scale : Tlv_opa); cdecl; external;
procedure lv_obj_set_protect (obj : Plv_obj; prot : Tuint8); cdecl; external;

procedure lv_obj_set_event_cb (obj : Plv_obj; event_cb : Tlv_event_cb); cdecl; external;
function lv_event_send (obj : Plv_obj; event : Tlv_event; const data : pointer) : Tlv_res; cdecl; external;
function lv_event_send_refresh (obj : Plv_obj) : Tlv_res; cdecl; external;
procedure lv_event_send_refresh_recursive (obj : Plv_obj); cdecl; external;
function lv_event_send_func (event_cb : Tlv_event_cb; obj : Plv_obj; event : Tlv_event; const data : pointer) : Tlv_res; cdecl; external;

function lv_event_get_data : pointer; cdecl; external;
procedure lv_obj_set_signal_cb (obj : Plv_obj; signal_cb : Tlv_signal_cb); cdecl; external;
procedure lv_signal_send (obj : Plv_obj; signal : Tlv_signal; param : pointer); cdecl; external;
procedure lv_obj_set_design_cb (obj : Plv_obj; design_cb : Tlv_design_cb); cdecl; external;
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

function lv_obj_get_height_margin(obj : Plv_obj) : Tlv_coord; cdecl; external;
function lv_obj_get_width_margin(obj : Plv_obj) : Tlv_coord; cdecl; external;
function lv_obj_get_width_grid(obj : Plv_obj; _div, span : Tuint8) : Tlv_coord; cdecl; external;
function lv_obj_get_height_grid(obj : Plv_obj; _div, span : Tuint8) : Tlv_coord; cdecl; external;

function lv_obj_get_auto_realign (const obj : Plv_obj) : LongBool; cdecl; external;
function lv_obj_get_ext_click_pad_left (const obj : Plv_obj) : Tlv_coord; cdecl; external;
function lv_obj_get_ext_click_pad_right (const obj : Plv_obj) : Tlv_coord; cdecl; external;
function lv_obj_get_ext_click_pad_top (const obj : Plv_obj) : Tlv_coord; cdecl; external;
function lv_obj_get_ext_click_pad_bottom (const obj : Plv_obj) : Tlv_coord; cdecl; external;
function lv_obj_get_ext_draw_pad (const obj : Plv_obj) : Tlv_coord; cdecl; external;

function lv_obj_get_style_list (const obj : Plv_obj; part : Tuint8) : Plv_style_list; cdecl; external;
function _lv_obj_get_style_int (const obj : Plv_obj; part : Tuint8; prop : Tlv_style_property) : Tlv_style_int; cdecl; external;
function _lv_obj_get_style_color (const obj : Plv_obj; part : Tuint8; prop : Tlv_style_property) : Tlv_color; cdecl; external;
function _lv_obj_get_style_opa (const obj : Plv_obj; part : Tuint8; prop : Tlv_style_property) : Tlv_opa; cdecl; external;
function _lv_obj_get_style_ptr (const obj : Plv_obj; part : Tuint8; prop : Tlv_style_property) : pointer; cdecl; external;
function lv_obj_get_local_style (obj : Plv_obj; part : Tuint8) : Plv_style; cdecl; external;
function lv_obj_get_style (const obj : Plv_obj) : Plv_style; cdecl; external;
function lv_obj_get_hidden (const obj : Plv_obj) : LongBool; cdecl; external;
function lv_obj_get_adv_hittest (const obj : Plv_obj) : LongBool; cdecl; external;

function lv_obj_get_click (const obj : Plv_obj) : LongBool; cdecl; external;
function lv_obj_get_top (const obj : Plv_obj) : LongBool; cdecl; external;
function lv_obj_get_drag (const obj : Plv_obj) : LongBool; cdecl; external;

function lv_obj_get_drag_dir (const obj : Plv_obj) : Tlv_drag_dir; cdecl; external;
function lv_obj_get_drag_throw (const obj : Plv_obj) : LongBool; cdecl; external;
function lv_obj_get_drag_parent (const obj : Plv_obj) : LongBool; cdecl; external;
function lv_obj_get_focus_parent (const obj : Plv_obj) : LongBool; cdecl; external;
function lv_obj_get_parent_event (const obj : Plv_obj) : LongBool; cdecl; external;
function lv_obj_get_gesture_parent (const obj : Plv_obj) : LongBool; cdecl; external;

function lv_obj_get_base_dir (const obj : Plv_obj) : Tlv_bidi_dir; cdecl; external;
function lv_obj_get_protect (const obj : Plv_obj) : Tuint8; cdecl; external;
function lv_obj_is_protected (const obj : Plv_obj; prot : Tuint8) : LongBool; cdecl; external;
function lv_obj_get_opa_scale_enable (const obj : Plv_obj) : Tlv_opa; cdecl; external;
function lv_obj_get_opa_scale (const obj : Plv_obj) : Tlv_opa; cdecl; external;
function lv_obj_get_state (const obj : Plv_obj; part : Tuint8) : Tlv_state; cdecl; external;
function lv_obj_get_signal_cb (const obj : Plv_obj) : Tlv_signal_cb; cdecl; external;
function lv_obj_get_design_cb (const obj : Plv_obj) : Tlv_design_cb; cdecl; external;
function lv_obj_get_event_cb (const obj : Plv_obj) : Tlv_event_cb; cdecl; external;
function lv_obj_is_point_on_coords (obj : Plv_obj; const point : Plv_point) : LongBool; cdecl; external;
function lv_obj_hittest (obj : Plv_obj; point : Plv_point) : LongBool; cdecl; external;
function lv_obj_get_ext_attr (const obj : Plv_obj) : pointer; cdecl; external;
procedure lv_obj_get_type (const obj : Plv_obj; buf : Plv_obj_type); cdecl; external;
function lv_obj_get_user_data (const obj : Plv_obj) : Tlv_obj_user_data; cdecl; external;
function lv_obj_get_user_data_ptr (const obj : Plv_obj) : Plv_obj_user_data; cdecl; external;
procedure lv_obj_set_user_data (obj : Plv_obj; data : Tlv_obj_user_data); cdecl; external;
function lv_obj_get_group (const obj : Plv_obj) : pointer; cdecl; external;
function lv_obj_is_focused (const obj : Plv_obj) : LongBool; cdecl; external;
function lv_obj_get_focused_obj (const obj : Plv_obj) : Plv_obj; cdecl; external;
function lv_obj_handle_get_type_signal (buf : Plv_obj_type; const name : PChar) : Tlv_res; cdecl; external;
//procedure lv_obj_init_draw_rect_dsc (obj : Plv_obj; _type : Tuint8; draw_dsc : Plv_draw_rect_dsc); cdecl; external;
//procedure lv_obj_init_draw_label_dsc (obj : Plv_obj; _type : Tuint8; draw_dsc : Plv_draw_rect_dsc); cdecl; external;
//procedure lv_obj_init_draw_img_dsc (obj : Plv_obj; _type : Tuint8; draw_dsc : Plv_draw_img_dsc); cdecl; external;
//procedure lv_obj_init_draw_line_dsc (obj : Plv_obj; _type : Tuint8; draw_dsc : Plv_draw_line_dsc); cdecl; external;
function lv_obj_get_draw_rect_ext_pad_size (obj : Plv_obj; part : Tuint8) : Tlv_coord; cdecl; external;
procedure lv_obj_fade_in (obj : Plv_obj; time, delay : Tuint32); cdecl; external;
procedure lv_obj_fade_out (obj : Plv_obj; time, delay : Tuint32); cdecl; external;
function lv_debug_check_obj_type (const obj : Plv_obj; const obj_type : PChar) : LongBool; cdecl; external;
function lv_debug_check_obj_valid (const obj : Plv_obj) : LongBool; cdecl; external;

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

function lv_disp_get_dpi (disp : Plv_disp) : Tlv_coord; cdecl; external;
function lv_disp_get_size_category (disp : Plv_disp) : Tlv_disp_size; cdecl; external;

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

procedure _lv_indev_init; cdecl; external;
procedure _lv_indev_read_task (tassk : Plv_task); cdecl; external;
function lv_indev_get_act : Plv_indev; cdecl; external;
function lv_indev_get_type (const indev : Plv_indev) : Tlv_indev_type; cdecl; external;
procedure lv_indev_reset (indev : Plv_indev; obj : Plv_obj); cdecl; external;
procedure lv_indev_reset_long_press (indev : Plv_indev); cdecl; external;
procedure lv_indev_enable (indev : Plv_indev; en : LongBool); cdecl; external;
procedure lv_indev_set_cursor (indev : Plv_indev; cur_obj : Plv_obj); cdecl; external;
//procedure lv_indev_set_group (indev : Plv_indev; group : Plv_group); cdecl; external;
procedure lv_indev_set_button_points (indev : Plv_indev; const points : array of Tlv_point); cdecl; external;
procedure lv_indev_get_point (const indev : Plv_indev; point : Plv_point); cdecl; external;
function lv_indev_get_gesture_dir (const indev : Plv_indev) : Tlv_gesture_dir; cdecl; external;
function lv_indev_get_key (const indev : Plv_indev) : Tuint32; cdecl; external;
function lv_indev_is_dragging (const indev : Plv_indev) : LongBool; cdecl; external;
procedure lv_indev_get_vect (const indev : Plv_indev; point : Plv_point); cdecl; external;
function lv_indev_finish_drag (indev : Plv_indev) : Tlv_res; cdecl; external;
procedure lv_indev_wait_release (indev : Plv_indev); cdecl; external;
function lv_indev_get_obj_act : Plv_obj; cdecl; external;
function lv_indev_search_obj (obj : Plv_obj; point : Tlv_point) : Plv_obj; cdecl; external;
function lv_indev_get_read_task (indev : Plv_indev) : Plv_task; cdecl; external;

procedure lv_indev_drv_init (driver : Plv_indev_drv); cdecl; external;
function lv_indev_drv_register (driver : Plv_indev_drv) : Plv_indev; cdecl; external;
procedure lv_indev_drv_update (indev : Plv_indev; new_drv : Plv_indev_drv); cdecl; external;
function lv_indev_get_next (indev : Plv_indev) : Plv_indev; cdecl; external;
//function _lv_indev_read (indev : Plv_indev; data : Plv_indev_data) : LongBool; cdecl; external;

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
    (*
procedure lv_canvas_draw_polygon (canvas : Plv_obj; const lv_point_t points[], uint32_t point_cnt,
                            const lv_draw_rect_dsc_t * poly_draw_dsc);
procedure lv_canvas_draw_arc (canvas : Plv_obj; lv_coord_t x, lv_coord_t y, lv_coord_t r, int32_t start_angle,
                        int32_t end_angle, const lv_draw_line_dsc_t * arc_draw_dsc);
      *)


function lv_cont_create (par : Plv_obj; const copy : Plv_obj) : Plv_obj; cdecl; external;
procedure lv_cont_set_layout (cont : Plv_obj; layout : Tlv_layout); cdecl; external;
procedure lv_cont_set_fit4 (cont : Plv_obj; left, right, top, bottom : Tlv_fit); cdecl; external;
function lv_cont_get_layout (cont : Plv_obj) : Tlv_layout; cdecl; external;
function lv_cont_get_fit_left (cont : Plv_obj) : Tlv_fit; cdecl; external;
function lv_cont_get_fit_right (cont : Plv_obj) : Tlv_fit; cdecl; external;
function lv_cont_get_fit_top (cont : Plv_obj) : Tlv_fit; cdecl; external;
function lv_cont_get_fit_bottom (cont : Plv_obj) : Tlv_fit; cdecl; external;
procedure lv_cont_set_fit2 (cont : Plv_obj; hor, ver : Tlv_fit);
procedure lv_cont_set_fit (cont : Plv_obj; fit : Tlv_fit);
procedure lv_cont_set_style (cont : Plv_obj; _type : Tlv_cont_style; const style : Plv_style);
function lv_cont_get_style (const cont : Plv_obj; _type : Tlv_cont_style) : Plv_style;

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
procedure lv_btn_set_layout (btn : Plv_obj; layout : Tlv_layout);
procedure lv_btn_set_fit4 (btn : Plv_obj; left, right, top, bottom : Tlv_fit);
procedure lv_btn_set_fit2 (btn : Plv_obj; hor, ver : Tlv_fit);
procedure lv_btn_set_fit (btn : Plv_obj; fit : Tlv_fit);
function lv_btn_get_layout (const btn : Plv_obj) : Tlv_layout;
function lv_btn_get_fit_left (const btn : Plv_obj) : Tlv_fit;
function lv_btn_get_fit_right (const btn : Plv_obj) : Tlv_fit;
function lv_btn_get_fit_top (const btn : Plv_obj) : Tlv_fit;
function lv_btn_get_fit_bottom (const btn : Plv_obj) : Tlv_fit;

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

// themes
procedure lv_theme_set_act (th : Plv_theme); cdecl; external;
function lv_theme_get_act : Plv_theme; cdecl; external;
procedure lv_theme_apply (obj : Plv_obj; name : Tlv_theme_style); cdecl; external;
procedure lv_theme_copy (theme : Plv_theme; const copy : Plv_theme); cdecl; external;
procedure lv_theme_set_base (new_theme : Plv_theme; base : Plv_theme); cdecl; external;
procedure lv_theme_set_apply_cb (theme : Plv_theme; apply_cb : pointer); cdecl; external;
function lv_theme_get_font_small : Plv_font; cdecl; external;
function lv_theme_get_font_normal : Plv_font; cdecl; external;
function lv_theme_get_font_subtitle : Plv_font; cdecl; external;
function lv_theme_get_font_title : Plv_font; cdecl; external;
function lv_theme_get_color_primary : Tlv_color; cdecl; external;
function lv_theme_get_color_secondary : Tlv_color; cdecl; external;
function lv_theme_get_flags : Tuint32; cdecl; external;

function lv_theme_empty_init (color_primary, color_secondary : Tlv_color; flags : Tuint32;
                                const font_small, font_normal, font_subtitle,
                                font_title : Plv_font) : Plv_theme; cdecl; external;
function lv_theme_material_init (color_primary, color_secondary : Tlv_color; flags : Tuint32;
                                const font_small, font_normal, font_subtitle,
                                font_title : Plv_font) : Plv_theme; cdecl; external;
function lv_theme_mono_init (color_primary, color_secondary : Tlv_color; flags : Tuint32;
                                const font_small, font_normal, font_subtitle,
                                font_title : Plv_font) : Plv_theme; cdecl; external;
// widgets
// arcs
function lv_arc_create (par : Plv_obj; const copy : Plv_obj) : Plv_obj; cdecl; external;
procedure lv_arc_set_start_angle (arc : Plv_obj; start : Tuint16); cdecl; external;
procedure lv_arc_set_end_angle (arc : Plv_obj; _end : Tuint16); cdecl; external;
procedure lv_arc_set_angles (arc : Plv_obj; start, _end : Tuint16); cdecl; external;
procedure lv_arc_set_bg_start_angle (arc : Plv_obj; start : Tuint16); cdecl; external;
procedure lv_arc_set_bg_end_angle (arc : Plv_obj; _end : Tuint16); cdecl; external;
procedure lv_arc_set_bg_angles (arc : Plv_obj; start, _end : Tuint16); cdecl; external;
procedure lv_arc_set_rotation (arc : Plv_obj; rotation_angle : Tuint16); cdecl; external;
procedure lv_arc_set_type (arc : Plv_obj;  _type : Tlv_arc_type); cdecl; external;
procedure lv_arc_set_value (arc : Plv_obj; value : Tint16); cdecl; external;
procedure lv_arc_set_range (arc : Plv_obj; min, max : Tuint16); cdecl; external;
procedure lv_arc_set_chg_rate (arc : Plv_obj; threshold : Tuint16); cdecl; external;
procedure lv_arc_set_adjustable (arc : Plv_obj; adjustable : LongBool); cdecl; external;
function lv_arc_get_angle_start (arc : Plv_obj) : Tuint16; cdecl; external;
function lv_arc_get_angle_end (arc : Plv_obj) : Tint16; cdecl; external;
function lv_arc_get_bg_angle_start (arc : Plv_obj) : Tint16; cdecl; external;
function lv_arc_get_bg_angle_end (arc : Plv_obj) : Tint16; cdecl; external;
function lv_arc_get_type (const arc : Plv_obj) : Tlv_arc_type; cdecl; external;
function lv_arc_get_value (const arc : Plv_obj) : Tint16; cdecl; external;
function lv_arc_get_min_value (const arc : Plv_obj) : Tint16; cdecl; external;
function lv_arc_get_max_value (const arc : Plv_obj) : Tint16; cdecl; external;
function lv_arc_is_dragged (const arc : Plv_obj) : LongBool; cdecl; external;
function lv_arc_get_adjustable (arc : Plv_obj) : LongBool; cdecl; external;

function lv_bar_create (par : Plv_obj; const copy : Plv_obj) : Plv_obj; cdecl; external;
procedure lv_bar_set_value (bar : Plv_obj; value : Tint16; anim : Tlv_anim_enable); cdecl; external;
procedure lv_bar_set_start_value (bar : Plv_obj; start_value : Tint16; anim : Tlv_anim_enable); cdecl; external;
procedure lv_bar_set_range (bar : Plv_obj; min, max : Tint16); cdecl; external;
procedure lv_bar_set_type (bar : Plv_obj; _type : Tlv_bar_type); cdecl; external;
procedure lv_bar_set_anim_time (bar : Plv_obj; anim_time : Tuint16); cdecl; external;
function lv_bar_get_value (const bar : Plv_obj) : Tint16; cdecl; external;
function lv_bar_get_start_value (const bar : Plv_obj) : Tint16; cdecl; external;
function lv_bar_get_min_value (const bar : Plv_obj) : Tint16; cdecl; external;
function lv_bar_get_max_value (const bar : Plv_obj) : Tint16; cdecl; external;
function lv_bar_get_type (bar : Plv_obj) : Tlv_bar_type; cdecl; external;
function lv_bar_get_anim_time (const bar : Plv_obj) : Tint16; cdecl; external;

// btn matrix
function lv_btnmatrix_create (par : Plv_obj; const copy : Plv_obj) : Plv_obj; cdecl; external;
procedure lv_btnmatrix_set_map (btnm : Plv_obj; const map : PChar); cdecl; external;
procedure lv_btnmatrix_set_ctrl_map (btnm : Plv_obj;  const cntrl_map : array of Tlv_btnmatrix_ctrl); cdecl; external;
procedure lv_btnmatrix_set_focused_btn (btnm : Plv_obj; id : Tuint16); cdecl; external;
procedure lv_btnmatrix_set_recolor (const btnm : Plv_obj; en : LongBool); cdecl; external;
procedure lv_btnmatrix_set_btn_ctrl (const btnm : Plv_obj; btn_id : Tuint16; ctrl : Tlv_btnmatrix_ctrl); cdecl; external;
procedure lv_btnmatrix_clear_btn_ctrl (const btnm : Plv_obj; btn_id : Tuint16; ctrl : Tlv_btnmatrix_ctrl); cdecl; external;
procedure lv_btnmatrix_set_btn_ctrl_all (btnm : Plv_obj; ctrl : Tlv_btnmatrix_ctrl); cdecl; external;
procedure lv_btnmatrix_clear_btn_ctrl_all (btnm : Plv_obj; ctrl : Tlv_btnmatrix_ctrl); cdecl; external;
procedure lv_btnmatrix_set_btn_width (btnm : Plv_obj; btn_id : Tuint16; width : Tuint8); cdecl; external;
procedure lv_btnmatrix_set_one_check (btnm : Plv_obj; one_chk : LongBool); cdecl; external;
procedure lv_btnmatrix_set_align (btnm : Plv_obj; align : Tlv_label_align); cdecl; external;
function lv_btnmatrix_get_map_array (const btnm : Plv_obj) : PPChar; cdecl; external;
function lv_btnmatrix_get_recolor (const btnm : Plv_obj) : LongBool; cdecl; external;
function lv_btnmatrix_get_active_btn (const btnm : Plv_obj) : Tuint16; cdecl; external;
function lv_btnmatrix_get_active_btn_text (const btnm : Plv_obj) : PChar; cdecl; external;
function lv_btnmatrix_get_focused_btn (const btnm : Plv_obj) : Tuint16; cdecl; external;
function lv_btnmatrix_get_btn_text (const btnm : Plv_obj; btn_id : Tuint16) : PChar; cdecl; external;
function lv_btnmatrix_get_btn_ctrl (btnm : Plv_obj; btn_id : Tuint16; ctrl : Tlv_btnmatrix_ctrl) : LongBool; cdecl; external;
function lv_btnmatrix_get_one_check (const btnm : Plv_obj) : LongBool; cdecl; external;
function lv_btnmatrix_get_align (const btnm : Plv_obj) : Tlv_label_align; cdecl; external;

// calendar
function lv_calendar_create (par : Plv_obj; const copy : Plv_obj) : Plv_obj; cdecl; external;
procedure lv_calendar_set_today_date (calendar : Plv_obj; today : Plv_calendar_date); cdecl; external;
procedure lv_calendar_set_showed_date (calendar : Plv_obj; showed : Plv_calendar_date); cdecl; external;
procedure lv_calendar_set_highlighted_dates(calendar : Plv_obj; highlighted : array of Tlv_calendar_date; date_num : Tuint16); cdecl; external;
procedure lv_calendar_set_day_names (calendar : Plv_obj; const day_names : PPChar); cdecl; external;
procedure lv_calendar_set_month_names (calendar : Plv_obj; const month_names : PPChar); cdecl; external;
function lv_calendar_get_today_date (const calendar : Plv_obj) : Plv_calendar_date; cdecl; external;
function lv_calendar_get_showed_date (const calendar : Plv_obj) : Plv_calendar_date; cdecl; external;
function lv_calendar_get_pressed_date (const calendar : Plv_obj) : Plv_calendar_date; cdecl; external;
function lv_calendar_get_highlighted_dates (const calendar : Plv_obj) : Plv_calendar_date; cdecl; external;
function lv_calendar_get_highlighted_dates_num (const calendar : Plv_obj) : Tuint16; cdecl; external;
function lv_calendar_get_day_names (const calendar : Plv_obj) : PPChar; cdecl; external;
function lv_calendar_get_month_names (const calendar : Plv_obj) : PPChar; cdecl; external;

// linemeter
function lv_linemeter_create (par : Plv_obj; const copy : Plv_obj) : Plv_obj; cdecl; external;
procedure lv_linemeter_set_value (lmeter : Plv_obj; value : Tint32); cdecl; external;
procedure lv_linemeter_set_range (lmeter : Plv_obj; min, max : Tint32); cdecl; external;
procedure lv_linemeter_set_scale (lmeter : Plv_obj; angle : Tuint16; line_cnt : Tuint16); cdecl; external;
procedure lv_linemeter_set_angle_offset (lmeter : Plv_obj; angle : Tuint16); cdecl; external;
procedure lv_linemeter_set_mirror (lmeter : Plv_obj; mirror : LongBool); cdecl; external;
function lv_linemeter_get_value (const lmeter : Plv_obj) : Tint32; cdecl; external;
function lv_linemeter_get_min_value (const lmeter : Plv_obj) : Tint32; cdecl; external;
function lv_linemeter_get_max_value (const lmeter : Plv_obj) : Tint32; cdecl; external;
function lv_linemeter_get_line_count (const lmeter : Plv_obj) : Tint16; cdecl; external;
function lv_linemeter_get_scale_angle (const lmeter : Plv_obj) : Tint16; cdecl; external;
function lv_linemeter_get_angle_offset (lmeter : Plv_obj) : Tint16; cdecl; external;
procedure lv_linemeter_draw_scale (lmeter : Plv_obj; const clip_area : Plv_area; part : Tuint8); cdecl; external;
function lv_linemeter_get_mirror (lmeter : Plv_obj) : LongBool; cdecl; external;

// gauge
function lv_gauge_create (par : Plv_obj; const copy : Plv_obj) : Plv_obj; cdecl; external;
procedure lv_gauge_set_needle_count (gauge : Plv_obj; needle_cnt : Tuint8; const colors : array of Tlv_color); cdecl; external;
procedure lv_gauge_set_value (gauge : Plv_obj; needle_id : Tuint8; value : Tint32); cdecl; external;
procedure lv_gauge_set_scale (gauge : Plv_obj; angle : Tuint16; line_cnt : Tuint8; label_cnt : Tuint8); cdecl; external;
procedure lv_gauge_set_needle_img (gauge : Plv_obj; const img : pointer; pivot_x, pivot_y : Tlv_coord); cdecl; external;
procedure lv_gauge_set_formatter_cb (gauge : Plv_obj; format_cb : pointer); cdecl; external; //  lv_gauge_format_cb_t format_cb);
function lv_gauge_get_value(gauge : Plv_obj; needle : Tuint8) : Tint32;cdecl; external;
function lv_gauge_get_needle_count (const gauge : Plv_obj) : Tint8; cdecl; external;
function lv_gauge_get_label_count (const gauge : Plv_obj) : Tint8; cdecl; external;
function lv_gauge_get_needle_img (gauge : Plv_obj) : pointer; cdecl; external;
function lv_gauge_get_needle_img_pivot_x (gauge : Plv_obj) : Tlv_coord; cdecl; external;
function lv_gauge_get_needle_img_pivot_y (gauge : Plv_obj) : Tlv_coord; cdecl; external;

procedure lv_gauge_set_range (gauge : Plv_obj; min, max : Tint32); inline;
procedure lv_gauge_set_critical_value (gauge : Plv_obj; value : Tint32); inline;
procedure lv_gauge_set_angle_offset (gauge : Plv_obj; angle : Tuint16); inline;
function lv_gauge_get_min_value (const lmeter : Plv_obj) : Tint32; inline;
function lv_gauge_get_max_value (const lmeter : Plv_obj) : Tint32; inline;
function lv_gauge_get_critical_value (const gauge : Plv_obj) : Tint32; inline;
function lv_gauge_get_line_count (const gauge : Plv_obj) : Tint16; inline;
function lv_gauge_get_scale_angle (const gauge : Plv_obj) : Tint16; inline;
function lv_gauge_get_angle_offset (gauge : Plv_obj) : Tint16; inline;

// page
function lv_page_create (par : Plv_obj; const copy : Plv_obj) : Plv_obj; cdecl; external;
procedure lv_page_clean (page : Plv_obj); cdecl; external;

function lv_page_get_scrollable (const page : Plv_obj) : Plv_obj; cdecl; external;
function lv_page_get_anim_time (const page : Plv_obj) : Tuint16; cdecl; external;
procedure lv_page_set_scrollbar_mode (page : Plv_obj; sb_mode : Tlv_scrollbar_mode); cdecl; external;
procedure lv_page_set_anim_time (page : Plv_obj; anim_time : Tuint16); cdecl; external;
procedure lv_page_set_scroll_propagation (page : Plv_obj; en : LongBool); cdecl; external;
procedure lv_page_set_edge_flash (page : Plv_obj; en : LongBool); cdecl; external;

function lv_page_get_scrollbar_mode (const page : Plv_obj) : Tlv_scrollbar_mode; cdecl; external;
function lv_page_get_scroll_propagation (page : Plv_obj) : LongBool; cdecl; external;
function lv_page_get_edge_flash (page : Plv_obj) : LongBool; cdecl; external;
function lv_page_get_width_fit (page : Plv_obj) : Tlv_coord; cdecl; external;
function lv_page_get_height_fit (page : Plv_obj) : Tlv_coord; cdecl; external;
function lv_page_get_width_grid (page : Plv_obj; _div, span : Tuint8) : Tlv_coord; cdecl; external;
function lv_page_get_height_grid (lpage : Plv_obj; _div, span : Tuint8) : Tlv_coord; cdecl; external;

function lv_page_on_edge (page : Plv_obj; edge : Tlv_page_edge) : LongBool; cdecl; external;
procedure lv_page_glue_obj (obj : Plv_obj;  glue : LongBool); cdecl; external;
procedure lv_page_focus (page : Plv_obj; const obj : Plv_obj; anim_en : Tlv_anim_enable); cdecl; external;

procedure lv_page_scroll_hor (page : Plv_obj; dist : Tlv_coord); cdecl; external;
procedure lv_page_scroll_ver (page : Plv_obj; dist : Tlv_coord); cdecl; external;
procedure lv_page_start_edge_flash (page : Plv_obj; edgle : Tlv_page_edge); cdecl; external;

function lv_page_get_scrl_width (const page : Plv_obj) : Tlv_coord;
function lv_page_get_scrl_height (const page : Plv_obj) : Tlv_coord;
function lv_page_get_scrl_layout (const page : Plv_obj) : Tlv_layout;
function lv_page_get_scrl_fit_left (const page : Plv_obj) : Tlv_fit;
function lv_page_get_scrl_fit_right (const page : Plv_obj) : Tlv_fit;
function lv_page_get_scrl_fit_top (const page : Plv_obj) : Tlv_fit;
function lv_page_get_scrl_fit_bottom (const page : Plv_obj) : Tlv_fit;
procedure lv_page_set_scrollable_fit4 (page : Plv_obj; left, right, top, bottom : Tlv_fit);
procedure lv_page_set_scrollable_fit2 (page : Plv_obj; hor, ver : Tlv_fit);
procedure lv_page_set_scrollable_fit (page : Plv_obj; fit : Tlv_fit);
procedure lv_page_set_scrl_width (page : Plv_obj; w : Tlv_coord);
procedure lv_page_set_scrl_height (page : Plv_obj; h : Tlv_coord);
procedure lv_page_set_scrl_layout (page : Plv_obj; layout : Tlv_layout);

// table
function lv_table_create (par : Plv_obj; const copy : Plv_obj) : Plv_obj; cdecl; external;
procedure lv_table_set_cell_value (table : Plv_obj; row, col : Tuint16; const txt : PChar); cdecl; external;
procedure lv_table_set_row_cnt (table : Plv_obj; row_cnt : Tuint16); cdecl; external;
procedure lv_table_set_col_cnt (table : Plv_obj; col_cnt : Tuint16); cdecl; external;
procedure lv_table_set_col_width (table : Plv_obj; col_id : Tuint16; w : Tlv_coord); cdecl; external;
procedure lv_table_set_cell_align (table : Plv_obj; row, col : Tuint16; align : Tlv_label_align); cdecl; external;
procedure lv_table_set_cell_type (table : Plv_obj; row, col : Tuint16; _type : Tuint8); cdecl; external;
procedure lv_table_set_cell_crop (table : Plv_obj; row, col : Tuint16; crop : LongBool); cdecl; external;
procedure lv_table_set_cell_merge_right (table : Plv_obj; row, col : Tuint16; en : LongBool); cdecl; external;
function lv_table_get_cell_value (table : Plv_obj; row, col : Tuint16) : PChar; cdecl; external;
function lv_table_get_row_cnt (table : Plv_obj) : Tuint16; cdecl; external;
function lv_table_get_col_cnt (table : Plv_obj) : Tuint16; cdecl; external;
function lv_table_get_col_width (table : Plv_obj; col_id : Tuint16) : Tlv_coord; cdecl; external;
function lv_table_get_cell_align (table : Plv_obj; row, col : Tuint16) : Tlv_label_align; cdecl; external;
function lv_table_get_cell_type (table : Plv_obj; row, col : Tuint16) : Tlv_label_align; cdecl; external;
function lv_table_get_cell_crop (table : Plv_obj; row, col : Tuint16) : Tlv_label_align; cdecl; external;
function lv_table_get_cell_merge_right (table : Plv_obj; row, col : Tuint16) : LongBool; cdecl; external;
function lv_table_get_pressed_cell (table : Plv_obj; row, col : Tuint16) : Tlv_res; cdecl; external;

// led
function lv_led_create (par : Plv_obj; const copy : Plv_obj) : Plv_obj; cdecl; external;
procedure lv_led_set_bright (led : Plv_obj; bright : Tuint8); cdecl; external;
procedure lv_led_on (led : Plv_obj); cdecl; external;
procedure lv_led_off (led : Plv_obj); cdecl; external;
procedure lv_led_toggle (led : Plv_obj); cdecl; external;
function lv_led_get_bright (const led : Plv_obj) : Tuint8; cdecl; external;

// tabview
function lv_tabview_create (par : Plv_obj; const copy : Plv_obj) : Plv_obj; cdecl; external;
function lv_tabview_add_tab (tabview : Plv_obj; const name : PChar) : Plv_obj; cdecl; external;
procedure lv_tabview_clean_tab (tab : Plv_obj); cdecl; external;
procedure lv_tabview_set_tab_act (tabview : Plv_obj; id : Tuint16; anim : Tlv_anim_enable); cdecl; external;
procedure lv_tabview_set_tab_name (tabview : Plv_obj; id : Tuint16; name : PChar); cdecl; external;
procedure lv_tabview_set_anim_time (tabview : Plv_obj; anim_time : Tuint16); cdecl; external;
procedure lv_tabview_set_btns_pos (tabview : Plv_obj; btn_pos : Tlv_tabview_btns_pos); cdecl; external;
function lv_tabview_get_tab_act (const tabview : Plv_obj) : Tuint16; cdecl; external;
function lv_tabview_get_tab_count (const tabview : Plv_obj) : Tuint16; cdecl; external;
function lv_tabview_get_tab (const tabview : Plv_obj; id : Tuint16) : Plv_obj; cdecl; external;
function lv_tabview_get_anim_time (const tabview : Plv_obj) : Tuint16; cdecl; external;
function lv_tabview_get_btns_pos (const tabview : Plv_obj) : Tlv_tabview_btns_pos; cdecl; external;

// style
procedure lv_style_init (style : Plv_style); cdecl; external;
procedure lv_style_copy (style_dest : Plv_style; const style_src : Plv_style); cdecl; external;
procedure lv_style_list_init (list : Plv_style_list); cdecl; external;
procedure lv_style_list_copy (list_dest : Plv_style_list; const list_src : Plv_style_list); cdecl; external;
procedure _lv_style_list_add_style( list : Plv_style_list; style : Plv_style); cdecl; external;
procedure _lv_style_list_remove_style (list :  Plv_style_list; style : Plv_style); cdecl; external;
procedure _lv_style_list_reset (style_list : Plv_style_list); cdecl; external;
function lv_style_list_get_style (list : Plv_style_list; id : Tuint8) : Plv_style;
procedure lv_style_reset (style : Plv_style); cdecl; external;
function _lv_style_get_mem_size (const style : Plv_style) : Tuint16;  cdecl; external;
function lv_style_remove_prop (style : Plv_style; prop : Tlv_style_property) : LongBool; cdecl; external;
procedure _lv_style_set_int (style : Plv_style; prop : Tlv_style_property; value : Tlv_style_int); cdecl; external;
procedure _lv_style_set_color (style : Plv_style; prop : Tlv_style_property; color : Tlv_color); cdecl; external;
procedure _lv_style_set_opa (style : Plv_style; prop : Tlv_style_property; opa : Tlv_opa); cdecl; external;
procedure _lv_style_set_ptr (style : Plv_style; prop : Tlv_style_property; const p : pointer); cdecl; external;
function _lv_style_get_int (const style : Plv_style; prop : Tlv_style_property; res : pointer) : Tint16; cdecl; external;
function _lv_style_get_color (const style : Plv_style; prop : Tlv_style_property; res : pointer) : Tint16; cdecl; external;
function _lv_style_get_opa (const style : Plv_style; prop : Tlv_style_property; res : pointer) : Tint16; cdecl; external;
function _lv_style_get_ptr (const style : Plv_style; prop : Tlv_style_property; res : pointer) : Tint16; cdecl; external;
function lv_style_list_get_local_style (list : Plv_style_list) : Plv_style; cdecl; external;
function  _lv_style_list_get_transition_style (list : Plv_style_list) : Plv_style; cdecl; external;
function  _lv_style_list_add_trans_style (list : Plv_style_list) : Plv_style; cdecl; external;
procedure _lv_style_list_set_local_int (list : Plv_style_list; prop : Tlv_style_property; value : Tlv_style_int); cdecl; external;
procedure _lv_style_list_set_local_color (list : Plv_style_list; prop : Tlv_style_property; value : Tlv_color); cdecl; external;
procedure _lv_style_list_set_local_opa (list : Plv_style_list; prop : Tlv_style_property; value : Tlv_opa); cdecl; external;
procedure _lv_style_list_set_local_ptr (list : Plv_style_list; prop : Tlv_style_property; const value : pointer); cdecl; external;
function _lv_style_list_get_int (list : Plv_style_list; prop : Tlv_style_property; res : Plv_style_int) : Tlv_res; cdecl; external;
function _lv_style_list_get_color (list : Plv_style_list; prop : Tlv_style_property; res : Plv_color) : Tlv_res; cdecl; external;
function _lv_style_list_get_opa (list : Plv_style_list; prop : Tlv_style_property; res : Plv_opa) : Tlv_res; cdecl; external;
function _lv_style_list_get_ptr (list : Plv_style_list; prop : Tlv_style_property; const res : PPointer) : Tlv_res; cdecl; external;
function lv_debug_check_style (const style : Plv_style) : LongBool; cdecl; external;
function lv_debug_check_style_list (const list : Plv_style_list) : LongBool; cdecl; external;

// slider
function lv_slider_create (par : Plv_obj; const copy : Plv_obj) : Plv_obj; cdecl; external;
procedure lv_slider_set_value (slider : Plv_obj; value : Tint16; anim : Tlv_anim_enable); inline;
procedure lv_slider_set_left_value (slider : Plv_obj; left_value : Tint16; anim : Tlv_anim_enable); inline;
procedure lv_slider_set_range (slider : Plv_obj; min, max : Tint16); inline;
procedure lv_slider_set_anim_time (slider : Plv_obj; anim_time : Tuint16); inline;
procedure lv_slider_set_type (slider : Plv_obj; _type : Tlv_slider_type); inline;

function lv_slider_get_value (const slider : Plv_obj) : Tint16; cdecl; external;
function lv_slider_get_left_value (const slider : Plv_obj) : Tint16; inline;
function lv_slider_get_min_value (const slider : Plv_obj) : Tint16; inline;
function lv_slider_get_max_value (const slider : Plv_obj) : Tint16; inline;

function lv_slider_is_dragged (const slider : Plv_obj) : LongBool; cdecl; external;
function lv_slider_get_anim_time (slider : Plv_obj) : Tint16; inline;
function lv_slider_get_type (slider : Plv_obj) : Tlv_slider_type; inline;

// switch
function lv_switch_create (par : Plv_obj; const copy : Plv_obj) : Plv_obj; cdecl; external;
procedure lv_switch_set_anim_time (sw : Plv_obj; anim_time : Tint16); inline;
function lv_switch_get_state (const sw : Plv_obj) : LongBool; inline;
function lv_switch_get_anim_time (const sw : Plv_obj) : Tuint16; inline;
procedure lv_switch_on (sw : Plv_obj; anim : Tlv_anim_enable); cdecl; external;
procedure lv_switch_off (sw : Plv_obj; anim : Tlv_anim_enable); cdecl; external;
function lv_switch_toggle (sw : Plv_obj; anim : Tlv_anim_enable) : LongBool; cdecl; external;

// chart
function lv_chart_create (par : Plv_obj; const copy : Plv_obj) : Plv_obj; cdecl; external;
function lv_chart_add_series (chart : Plv_obj; color : Tlv_color) : Plv_chart_series; cdecl; external;
procedure lv_chart_clear_series (chart : Plv_obj; series : Plv_chart_series); cdecl; external;
procedure lv_chart_set_div_line_count (chart : Plv_obj; hdiv, vdiv : Tuint8); cdecl; external;
procedure lv_chart_set_y_range (chart : Plv_obj; axis : Tlv_chart_axis; ymin, ymax : Tlv_coord); cdecl; external;
procedure lv_chart_set_type (chart : Plv_obj; _type : Tlv_chart_type); cdecl; external;
procedure lv_chart_set_point_count (chart : Plv_obj; point_cnt : Tuint16); cdecl; external;
procedure lv_chart_init_points (chart : Plv_obj; ser : Plv_chart_series; y : Tlv_coord); cdecl; external;
procedure lv_chart_set_points (chart : Plv_obj; ser : Plv_chart_series; y_array : array of Tlv_coord); cdecl; external;
procedure lv_chart_set_next (chart : Plv_obj; ser : Plv_chart_series; y : Tlv_coord); cdecl; external;
procedure lv_chart_set_update_mode (chart : Plv_obj; update_mode : Tlv_chart_update_mode); cdecl; external;
procedure lv_chart_set_x_tick_length (chart : Plv_obj; major_tick_len, minor_tick_len : Tuint8); cdecl; external;
procedure lv_chart_set_y_tick_length (chart : Plv_obj; major_tick_len, minor_tick_len : Tuint8); cdecl; external;
procedure lv_chart_set_secondary_y_tick_length (chart : Plv_obj; major_tick_len, minor_tick_len : Tuint8); cdecl; external;
procedure lv_chart_set_x_tick_texts (chart : Plv_obj; const list_of_values : PChar; num_tick_marks : Tuint8;
                                    opions : Tlv_chart_axis_options); cdecl; external;
procedure lv_chart_set_secondary_y_tick_texts (chart : Plv_obj; const list_of_values : PChar; num_tick_marks : Tuint8;
                                         options : Tlv_chart_axis_options); cdecl; external;
procedure lv_chart_set_y_tick_texts (chart : Plv_obj; const list_of_values : PChar; num_tick_marks : Tuint8;
                               options : Tlv_chart_axis_options); cdecl; external;
procedure lv_chart_set_x_start_point (chart : Plv_obj; ser : Plv_chart_series; id : Tuint16); cdecl; external;
procedure lv_chart_set_ext_array (chart : Plv_obj; ser : Plv_chart_series; _array : array of Tlv_coord; point_cnt : Tuint16); cdecl; external;
procedure lv_chart_set_point_id (chart : Plv_obj; ser : Plv_chart_series; value : Tlv_coord; id : Tuint16); cdecl; external;
procedure lv_chart_set_series_axis (chart : Plv_obj; ser : Plv_chart_series; axis : Tlv_chart_axis); cdecl; external;
function lv_chart_get_type (const chart : Plv_obj) : Tlv_chart_type; cdecl; external;
function lv_chart_get_point_count (const chart : Plv_obj) : Tuint16; cdecl; external;
function lv_chart_get_x_start_point (ser : Plv_chart_series) : Tuint16; cdecl; external;
function lv_chart_get_point_id (chart : Plv_obj; ser : Plv_chart_series; id  : Tuint16) : Tlv_coord; cdecl; external;
function lv_chart_get_series_axis (chart : Plv_obj; ser : Plv_chart_series) : Tlv_chart_axis; cdecl; external;
procedure lv_chart_refresh (chart : Plv_obj); cdecl; external;

// checkbox
function lv_checkbox_create (par : Plv_obj; const copy : Plv_obj) : Plv_obj; cdecl; external;
procedure lv_checkbox_set_text(cb : Plv_obj; const txt : PChar); cdecl; external;
procedure lv_checkbox_set_text_static(cb : Plv_obj; const txt : PChar); cdecl; external;
procedure lv_checkbox_set_checked (cb : Plv_obj; checked : LongBool);
procedure lv_checkbox_set_disabled (cb : Plv_obj);
procedure lv_checkbox_set_state (cb : Plv_obj; state : Tlv_btn_state);
function lv_checkbox_get_text (const cb : Plv_obj) : PChar; cdecl; external;
function lv_checkbox_is_checked (const cb : Plv_obj) : LongBool;
function lv_checkbox_is_inactive (const cb : Plv_obj) : LongBool;
function lv_checkbox_get_state (const cb : Plv_obj) : Tlv_btn_state;

// list
function lv_list_create (par : Plv_obj; const copy : Plv_obj) : Plv_obj; cdecl; external;
procedure lv_list_clean (list : Plv_obj); cdecl; external;
function lv_list_add_btn (list : Plv_obj; const img_src : pointer; const txt : PChar) : Plv_obj; cdecl; external;
function lv_list_remove (const list : Plv_obj; index : Tuint16) : LongBool; cdecl; external;
procedure lv_list_focus_btn (list : Plv_obj; btn : Plv_obj); cdecl; external;
procedure lv_list_set_scrollbar_mode (list : Plv_obj; mode : Tlv_scrollbar_mode);
procedure lv_list_set_scroll_propagation(list : Plv_obj; en : LongBool);
procedure lv_list_set_edge_flash(list : Plv_obj; en : LongBool);
procedure lv_list_set_anim_time(list : Plv_obj; anim_time : Tuint16);
procedure lv_list_set_layout (list : Plv_obj; layout : Tlv_layout); cdecl; external;
function lv_list_get_btn_text (const btn : Plv_obj) : PChar; cdecl; external;
function lv_list_get_btn_label (const btn : Plv_obj) : Plv_obj; cdecl; external;
function lv_list_get_btn_img (const btn : Plv_obj) : Plv_obj; cdecl; external;
function lv_list_get_prev_btn (const list : Plv_obj; prev_btn : Plv_obj) : Plv_obj; cdecl; external;
function lv_list_get_next_btn (const list : Plv_obj; prev_btn : Plv_obj) : Plv_obj; cdecl; external;
function lv_list_get_btn_index (const list : Plv_obj; const btn : Plv_obj) : Tint32; cdecl; external;
function lv_list_get_size (const list : Plv_obj) : Tuint16; cdecl; external;
function lv_list_get_btn_selected (const list : Plv_obj) : Plv_obj;cdecl; external;
function lv_list_get_layout (list : Plv_obj) : Tlv_layout; cdecl; external;
function lv_list_get_scrollbar_mode (const list : Plv_obj) : Tlv_scrollbar_mode;
function lv_list_get_scroll_propagation(list : Plv_obj) : LongBool;
function lv_list_get_edge_flash (list : Plv_obj) : LongBool;
function lv_list_get_anim_time (const list : Plv_obj) : Tuint16;
procedure lv_list_up (const list : Plv_obj); cdecl; external;
procedure lv_list_down (const list : Plv_obj); cdecl; external;
procedure lv_list_focus (const btn : Plv_obj; anim : Tlv_anim_enable); cdecl; external;

// roller
function lv_roller_create (par : Plv_obj; const copy : Plv_obj) : Plv_obj; cdecl; external;
procedure lv_roller_set_options (roller : Plv_obj; const pptions : PChar; mode : Tlv_roller_mode); cdecl; external;
procedure lv_roller_set_align (roller : Plv_obj; align : Tlv_label_align); cdecl; external;
procedure lv_roller_set_selected (roller : Plv_obj; sel_opt : Tuint16; anim : Tlv_anim_enable); cdecl; external;
procedure lv_roller_set_visible_row_count (roller : Plv_obj; row_cnt : Tuint8); cdecl; external;
procedure lv_roller_set_auto_fit (roller : Plv_obj; auto_fit : LongBool); cdecl; external;
procedure lv_roller_set_anim_time (roller : Plv_obj; anim_time : Tuint16);

function lv_roller_get_selected (const roller : Plv_obj) : Tuint16; cdecl; external;
function lv_roller_get_option_cnt (const roller : Plv_obj) : Tuint16; cdecl; external;
procedure lv_roller_get_selected_str (const roller : Plv_obj; buf : PChar; buf_size : Tuint32); cdecl; external;
function lv_roller_get_align (const roller : Plv_obj) : Tlv_label_align; cdecl; external;
function lv_roller_get_auto_fit (roller : Plv_obj) : LongBool; cdecl; external;
function lv_roller_get_options (const roller : Plv_obj) : PChar; cdecl; external;
function lv_roller_get_anim_time (const roller : Plv_obj) : Tuint16;

// drop down
function lv_dropdown_create (par : Plv_obj; const copy : Plv_obj) : Plv_obj; cdecl; external;
procedure lv_dropdown_set_text (ddlist : Plv_obj; const txt : PChar); cdecl; external;
procedure lv_dropdown_clear_options (ddlist : Plv_obj); cdecl; external;
procedure lv_dropdown_set_options (ddlist : Plv_obj; const options : PChar); cdecl; external;
procedure lv_dropdown_set_options_static (ddlist : Plv_obj; const options : PChar); cdecl; external;
procedure lv_dropdown_add_option (ddlist : Plv_obj; const option : PChar; pos : Tuint32); cdecl; external;
procedure lv_dropdown_set_selected (ddlist : Plv_obj; sel_opt : Tuint16); cdecl; external;
procedure lv_dropdown_set_dir (ddlist : Plv_obj; dir : Tlv_dropdown_dir); cdecl; external;
procedure lv_dropdown_set_max_height (ddlist : Plv_obj; h : Tlv_coord); cdecl; external;
procedure lv_dropdown_set_symbol (ddlist : Plv_obj; const symbol : PChar); cdecl; external;
procedure lv_dropdown_set_show_selected (ddlist : Plv_obj; show : LongBool); cdecl; external;
function lv_dropdown_get_text (ddlist : Plv_obj) : PChar; cdecl; external;
function lv_dropdown_get_options (const ddlist : Plv_obj) : PChar; cdecl; external;
function lv_dropdown_get_selected (const ddlist : Plv_obj) : Tuint16; cdecl; external;
function lv_dropdown_get_option_cnt (const ddlist : Plv_obj) : Tuint16; cdecl; external;
procedure lv_dropdown_get_selected_str (const ddlist : Plv_obj; buf : PChar; buf_size : Tuint32); cdecl; external;
function lv_dropdown_get_max_height (const ddlist : Plv_obj) : Tlv_coord; cdecl; external;
function lv_dropdown_get_symbol (ddlist : Plv_obj) : PChar; cdecl; external;
function lv_dropdown_get_dir (const ddlist : Plv_obj) : Tlv_dropdown_dir; cdecl; external;
function lv_dropdown_get_show_selected (ddlist : Plv_obj) : LongBool; cdecl; external;
procedure lv_dropdown_open (ddlist : Plv_obj); cdecl; external;
procedure lv_dropdown_close (ddlist : Plv_obj); cdecl; external;

// text area
function lv_textarea_create (par : Plv_obj; const copy : Plv_obj) : Plv_obj; cdecl; external;
procedure lv_textarea_add_char (ta : Plv_obj; c : Tuint32); cdecl; external;
procedure lv_textarea_add_text (ta : Plv_obj; const txt : PChar); cdecl; external;
procedure lv_textarea_del_char (ta : Plv_obj); cdecl; external;
procedure lv_textarea_del_char_forward (ta : Plv_obj); cdecl; external;
procedure lv_textarea_set_text (ta : Plv_obj; const txt : PChar); cdecl; external;
procedure lv_textarea_set_placeholder_text (ta : Plv_obj; const txt : PChar); cdecl; external;
procedure lv_textarea_set_cursor_pos (ta : Plv_obj; pos : Tint32); cdecl; external;
procedure lv_textarea_set_cursor_hidden (ta : Plv_obj; hide : LongBool); cdecl; external;
procedure lv_textarea_set_cursor_click_pos (ta : Plv_obj; en : LongBool); cdecl; external;
procedure lv_textarea_set_pwd_mode (ta : Plv_obj; en : LongBool); cdecl; external;
procedure lv_textarea_set_one_line (ta : Plv_obj; en : LongBool); cdecl; external;
procedure lv_textarea_set_text_align (ta : Plv_obj; align : Tlv_label_align); cdecl; external;
procedure lv_textarea_set_accepted_chars(ta : Plv_obj; const list : PChar); cdecl; external;
procedure lv_textarea_set_max_length (ta : Plv_obj; num : Tuint32); cdecl; external;
procedure lv_textarea_set_insert_replace (ta : Plv_obj;const txt : PChar); cdecl; external;
procedure lv_textarea_set_text_sel (ta : Plv_obj; en : LongBool); cdecl; external;
procedure lv_textarea_set_pwd_show_time (ta : Plv_obj; time : Tuint16); cdecl; external;
procedure lv_textarea_set_cursor_blink_time (ta : Plv_obj; time : Tuint16); cdecl; external;

function lv_textarea_get_text (const ta : Plv_obj) : PChar; cdecl; external;
function lv_textarea_get_placeholder_text(ta : Plv_obj) : PChar; cdecl; external;
function lv_textarea_get_label (const ta : Plv_obj) : Plv_obj; cdecl; external;
function lv_textarea_get_cursor_pos (const ta : Plv_obj) : Tuint32; cdecl; external;
function lv_textarea_get_cursor_hidden (const ta : Plv_obj) : LongBool; cdecl; external;
function lv_textarea_get_cursor_click_pos (ta : Plv_obj) : LongBool; cdecl; external;
function lv_textarea_get_pwd_mode (const ta : Plv_obj) : LongBool; cdecl; external;
function lv_textarea_get_one_line (const ta : Plv_obj) : LongBool; cdecl; external;
function lv_textarea_get_accepted_chars (ta : Plv_obj) : PChar; cdecl; external;
function lv_textarea_get_max_length (ta : Plv_obj) : Tuint32; cdecl; external;
function lv_textarea_text_is_selected (const ta : Plv_obj) : LongBool; cdecl; external;
function lv_textarea_get_text_sel_en (ta : Plv_obj) : LongBool; cdecl; external;
function lv_textarea_get_pwd_show_time (ta : Plv_obj) : Tuint16; cdecl; external;
function lv_textarea_get_cursor_blink_time (ta : Plv_obj) : Tuint16; cdecl; external;
procedure lv_textarea_clear_selection (ta : Plv_obj); cdecl; external;
procedure lv_textarea_cursor_right (ta : Plv_obj); cdecl; external;
procedure lv_textarea_cursor_left (ta : Plv_obj); cdecl; external;
procedure lv_textarea_cursor_down (ta : Plv_obj); cdecl; external;
procedure lv_textarea_cursor_up (ta : Plv_obj); cdecl; external;

// -------- macros -------------
function lv_scr_act : Plv_obj;

// style macros
function lv_obj_get_style_radius (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
procedure lv_obj_set_style_local_radius (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
procedure lv_style_set_radius (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
function lv_obj_get_style_clip_corner (const obj : Plv_obj; part : Tuint8) : LongBool;
procedure lv_obj_set_style_local_clip_corner (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : LongBool);
procedure lv_style_set_clip_corner (style : Plv_style; state : Tlv_state; value : LongBool);
function lv_obj_get_style_size (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
procedure lv_obj_set_style_local_size (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
procedure lv_style_set_size (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
function lv_obj_get_style_transform_width (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
procedure lv_obj_set_style_local_transform_width (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
procedure lv_style_set_transform_width (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
function lv_obj_get_style_transform_height (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
procedure lv_obj_set_style_local_transform_height (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
procedure lv_style_set_transform_height (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
function lv_obj_get_style_transform_angle (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
procedure lv_obj_set_style_local_transform_angle (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
procedure lv_style_set_transform_angle (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
function lv_obj_get_style_transform_zoom (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
procedure lv_obj_set_style_local_transform_zoom (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
procedure lv_style_set_transform_zoom (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
function lv_obj_get_style_opa_scale (const obj : Plv_obj; part : Tuint8) : Tlv_opa;
procedure lv_obj_set_style_local_opa_scale (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_opa);
procedure lv_style_set_opa_scale (style : Plv_style; state : Tlv_state; value : Tlv_opa);
function lv_obj_get_style_pad_top (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
procedure lv_obj_set_style_local_pad_top (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
procedure lv_style_set_pad_top (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
function lv_obj_get_style_pad_bottom (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
procedure lv_obj_set_style_local_pad_bottom (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
procedure lv_style_set_pad_bottom (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
function lv_obj_get_style_pad_left (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
procedure lv_obj_set_style_local_pad_left (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
procedure lv_style_set_pad_left (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
function lv_obj_get_style_pad_right (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
procedure lv_obj_set_style_local_pad_right (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
procedure lv_style_set_pad_right (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
function lv_obj_get_style_pad_inner (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
procedure lv_obj_set_style_local_pad_inner (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
procedure lv_style_set_pad_inner (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
function lv_obj_get_style_margin_top (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
procedure lv_obj_set_style_local_margin_top (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
procedure lv_style_set_margin_top (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
function lv_obj_get_style_margin_bottom (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
procedure lv_obj_set_style_local_margin_bottom (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
procedure lv_style_set_margin_bottom (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
function lv_obj_get_style_margin_left (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
procedure lv_obj_set_style_local_margin_left (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
procedure lv_style_set_margin_left (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
function lv_obj_get_style_margin_right (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
procedure lv_obj_set_style_local_margin_right (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
procedure lv_style_set_margin_right (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
function lv_obj_get_style_bg_blend_mode (const obj : Plv_obj; part : Tuint8) : Tlv_blend_mode;
procedure lv_obj_set_style_local_bg_blend_mode (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_blend_mode);
procedure lv_style_set_bg_blend_mode (style : Plv_style; state : Tlv_state; value : Tlv_blend_mode);
function lv_obj_get_style_bg_main_stop (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
procedure lv_obj_set_style_local_bg_main_stop (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
procedure lv_style_set_bg_main_stop (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
function lv_obj_get_style_bg_grad_stop (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
procedure lv_obj_set_style_local_bg_grad_stop (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
procedure lv_style_set_bg_grad_stop (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
function lv_obj_get_style_bg_grad_dir (const obj : Plv_obj; part : Tuint8) : Tlv_grad_dir;
procedure lv_obj_set_style_local_bg_grad_dir (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_grad_dir);
procedure lv_style_set_bg_grad_dir (style : Plv_style; state : Tlv_state; value : Tlv_grad_dir);
function lv_obj_get_style_bg_color (const obj : Plv_obj; part : Tuint8) : Tlv_color;
procedure lv_obj_set_style_local_bg_color (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_color);
procedure lv_style_set_bg_color (style : Plv_style; state : Tlv_state; value : Tlv_color);
function lv_obj_get_style_bg_grad_color (const obj : Plv_obj; part : Tuint8) : Tlv_color;
procedure lv_obj_set_style_local_bg_grad_color (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_color);
procedure lv_style_set_bg_grad_color (style : Plv_style; state : Tlv_state; value : Tlv_color);
function lv_obj_get_style_bg_opa (const obj : Plv_obj; part : Tuint8) : Tlv_opa;
procedure lv_obj_set_style_local_bg_opa (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_opa);
procedure lv_style_set_bg_opa (style : Plv_style; state : Tlv_state; value : Tlv_opa);
function lv_obj_get_style_border_width (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
procedure lv_obj_set_style_local_border_width (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
procedure lv_style_set_border_width (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
function lv_obj_get_style_border_side (const obj : Plv_obj; part : Tuint8) : Tlv_border_side;
procedure lv_obj_set_style_local_border_side (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_border_side);
procedure lv_style_set_border_side (style : Plv_style; state : Tlv_state; value : Tlv_border_side);
function lv_obj_get_style_border_blend_mode (const obj : Plv_obj; part : Tuint8) : Tlv_blend_mode;
procedure lv_obj_set_style_local_border_blend_mode (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_blend_mode);
procedure lv_style_set_border_blend_mode (style : Plv_style; state : Tlv_state; value : Tlv_blend_mode);
function lv_obj_get_style_border_post (const obj : Plv_obj; part : Tuint8) : LongBool;
procedure lv_obj_set_style_local_border_post (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : LongBool);
procedure lv_style_set_border_post (style : Plv_style; state : Tlv_state; value : LongBool);
function lv_obj_get_style_border_color (const obj : Plv_obj; part : Tuint8) : Tlv_color;
procedure lv_obj_set_style_local_border_color (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_color);
procedure lv_style_set_border_color (style : Plv_style; state : Tlv_state; value : Tlv_color);
function lv_obj_get_style_border_opa (const obj : Plv_obj; part : Tuint8) : Tlv_opa;
procedure lv_obj_set_style_local_border_opa (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_opa);
procedure lv_style_set_border_opa (style : Plv_style; state : Tlv_state; value : Tlv_opa);
function lv_obj_get_style_outline_width (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
procedure lv_obj_set_style_local_outline_width (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
procedure lv_style_set_outline_width (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
function lv_obj_get_style_outline_pad (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
procedure lv_obj_set_style_local_outline_pad (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
procedure lv_style_set_outline_pad (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
function lv_obj_get_style_outline_blend_mode (const obj : Plv_obj; part : Tuint8) : Tlv_blend_mode;
procedure lv_obj_set_style_local_outline_blend_mode (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_blend_mode);
procedure lv_style_set_outline_blend_mode (style : Plv_style; state : Tlv_state; value : Tlv_blend_mode);
function lv_obj_get_style_outline_color (const obj : Plv_obj; part : Tuint8) : Tlv_color;
procedure lv_obj_set_style_local_outline_color (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_color);
procedure lv_style_set_outline_color (style : Plv_style; state : Tlv_state; value : Tlv_color);
function lv_obj_get_style_outline_opa (const obj : Plv_obj; part : Tuint8) : Tlv_opa;
procedure lv_obj_set_style_local_outline_opa (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_opa);
procedure lv_style_set_outline_opa (style : Plv_style; state : Tlv_state; value : Tlv_opa);
function lv_obj_get_style_shadow_width (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
procedure lv_obj_set_style_local_shadow_width (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
procedure lv_style_set_shadow_width (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
function lv_obj_get_style_shadow_ofs_x (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
procedure lv_obj_set_style_local_shadow_ofs_x (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
procedure lv_style_set_shadow_ofs_x (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
function lv_obj_get_style_shadow_ofs_y (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
procedure lv_obj_set_style_local_shadow_ofs_y (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
procedure lv_style_set_shadow_ofs_y (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
function lv_obj_get_style_shadow_spread (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
procedure lv_obj_set_style_local_shadow_spread (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
procedure lv_style_set_shadow_spread (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
function lv_obj_get_style_shadow_blend_mode (const obj : Plv_obj; part : Tuint8) : Tlv_blend_mode;
procedure lv_obj_set_style_local_shadow_blend_mode (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_blend_mode);
procedure lv_style_set_shadow_blend_mode (style : Plv_style; state : Tlv_state; value : Tlv_blend_mode);
function lv_obj_get_style_shadow_color (const obj : Plv_obj; part : Tuint8) : Tlv_color;
procedure lv_obj_set_style_local_shadow_color (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_color);
procedure lv_style_set_shadow_color (style : Plv_style; state : Tlv_state; value : Tlv_color);
function lv_obj_get_style_shadow_opa (const obj : Plv_obj; part : Tuint8) : Tlv_opa;
procedure lv_obj_set_style_local_shadow_opa (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_opa);
procedure lv_style_set_shadow_opa (style : Plv_style; state : Tlv_state; value : Tlv_opa);
function lv_obj_get_style_pattern_repeat (const obj : Plv_obj; part : Tuint8) : LongBool;
procedure lv_obj_set_style_local_pattern_repeat (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : LongBool);
procedure lv_style_set_pattern_repeat (style : Plv_style; state : Tlv_state; value : LongBool);
function lv_obj_get_style_pattern_blend_mode (const obj : Plv_obj; part : Tuint8) : Tlv_blend_mode;
procedure lv_obj_set_style_local_pattern_blend_mode (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_blend_mode);
procedure lv_style_set_pattern_blend_mode (style : Plv_style; state : Tlv_state; value : Tlv_blend_mode);
function lv_obj_get_style_pattern_recolor (const obj : Plv_obj; part : Tuint8) : Tlv_color;
procedure lv_obj_set_style_local_pattern_recolor (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_color);
procedure lv_style_set_pattern_recolor (style : Plv_style; state : Tlv_state; value : Tlv_color);
function lv_obj_get_style_pattern_opa (const obj : Plv_obj; part : Tuint8) : Tlv_opa;
procedure lv_obj_set_style_local_pattern_opa (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_opa);
procedure lv_style_set_pattern_opa (style : Plv_style; state : Tlv_state; value : Tlv_opa);
function lv_obj_get_style_pattern_recolor_opa (const obj : Plv_obj; part : Tuint8) : Tlv_opa;
procedure lv_obj_set_style_local_pattern_recolor_opa (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_opa);
procedure lv_style_set_pattern_recolor_opa (style : Plv_style; state : Tlv_state; value : Tlv_opa);
function lv_obj_get_style_pattern_image (const obj : Plv_obj; part : Tuint8) : pointer;
procedure lv_obj_set_style_local_pattern_image (obj : Plv_obj; part : Tuint8; state : Tlv_state; const value : pointer);
procedure lv_style_set_pattern_image (style : Plv_style; state : Tlv_state; const value : pointer);
function lv_obj_get_style_value_letter_space (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
procedure lv_obj_set_style_local_value_letter_space (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
procedure lv_style_set_value_letter_space (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
function lv_obj_get_style_value_line_space (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
procedure lv_obj_set_style_local_value_line_space (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
procedure lv_style_set_value_line_space (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
function lv_obj_get_style_value_blend_mode (const obj : Plv_obj; part : Tuint8) : Tlv_blend_mode;
procedure lv_obj_set_style_local_value_blend_mode (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_blend_mode);
procedure lv_style_set_value_blend_mode (style : Plv_style; state : Tlv_state; value : Tlv_blend_mode);
function lv_obj_get_style_value_ofs_x (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
procedure lv_obj_set_style_local_value_ofs_x (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
procedure lv_style_set_value_ofs_x (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
function lv_obj_get_style_value_ofs_y (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
procedure lv_obj_set_style_local_value_ofs_y (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
procedure lv_style_set_value_ofs_y (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
function lv_obj_get_style_value_align (const obj : Plv_obj; part : Tuint8) : Tlv_align;
procedure lv_obj_set_style_local_value_align (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_align);
procedure lv_style_set_value_align (style : Plv_style; state : Tlv_state; value : Tlv_align);
function lv_obj_get_style_value_color (const obj : Plv_obj; part : Tuint8) : Tlv_color;
procedure lv_obj_set_style_local_value_color (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_color);
procedure lv_style_set_value_color (style : Plv_style; state : Tlv_state; value : Tlv_color);
function lv_obj_get_style_value_opa (const obj : Plv_obj; part : Tuint8) : Tlv_opa;
procedure lv_obj_set_style_local_value_opa (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_opa);
procedure lv_style_set_value_opa (style : Plv_style; state : Tlv_state; value : Tlv_opa);
function lv_obj_get_style_value_font (const obj : Plv_obj; part : Tuint8) : Plv_font;
procedure lv_obj_set_style_local_value_font (obj : Plv_obj; part : Tuint8; state : Tlv_state; const value : Plv_font);
procedure lv_style_set_value_font (style : Plv_style; state : Tlv_state; const value : Plv_font);
function lv_obj_get_style_value_str (const obj : Plv_obj; part : Tuint8) : PChar;
procedure lv_obj_set_style_local_value_str (obj : Plv_obj; part : Tuint8; state : Tlv_state; const value : PChar);
procedure lv_style_set_value_str (style : Plv_style; state : Tlv_state; const value : PChar);
function lv_obj_get_style_text_letter_space (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
procedure lv_obj_set_style_local_text_letter_space (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
procedure lv_style_set_text_letter_space (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
function lv_obj_get_style_text_line_space (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
procedure lv_obj_set_style_local_text_line_space (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
procedure lv_style_set_text_line_space (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
function lv_obj_get_style_text_decor (const obj : Plv_obj; part : Tuint8) : Tlv_text_decor;
procedure lv_obj_set_style_local_text_decor (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_text_decor);
procedure lv_style_set_text_decor (style : Plv_style; state : Tlv_state; value : Tlv_text_decor);
function lv_obj_get_style_text_blend_mode (const obj : Plv_obj; part : Tuint8) : Tlv_blend_mode;
procedure lv_obj_set_style_local_text_blend_mode (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_blend_mode);
procedure lv_style_set_text_blend_mode (style : Plv_style; state : Tlv_state; value : Tlv_blend_mode);
function lv_obj_get_style_text_color (const obj : Plv_obj; part : Tuint8) : Tlv_color;
procedure lv_obj_set_style_local_text_color (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_color);
procedure lv_style_set_text_color (style : Plv_style; state : Tlv_state; value : Tlv_color);
function lv_obj_get_style_text_sel_color (const obj : Plv_obj; part : Tuint8) : Tlv_color;
procedure lv_obj_set_style_local_text_sel_color (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_color);
procedure lv_style_set_text_sel_color (style : Plv_style; state : Tlv_state; value : Tlv_color);
function lv_obj_get_style_text_opa (const obj : Plv_obj; part : Tuint8) : Tlv_opa;
procedure lv_obj_set_style_local_text_opa (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_opa);
procedure lv_style_set_text_opa (style : Plv_style; state : Tlv_state; value : Tlv_opa);
function lv_obj_get_style_text_font (const obj : Plv_obj; part : Tuint8) : Plv_font;
procedure lv_obj_set_style_local_text_font (obj : Plv_obj; part : Tuint8; state : Tlv_state; const value : Plv_font);
procedure lv_style_set_text_font (style : Plv_style; state : Tlv_state; const value : Plv_font);
function lv_obj_get_style_line_width (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
procedure lv_obj_set_style_local_line_width (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
procedure lv_style_set_line_width (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
function lv_obj_get_style_line_blend_mode (const obj : Plv_obj; part : Tuint8) : Tlv_blend_mode;
procedure lv_obj_set_style_local_line_blend_mode (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_blend_mode);
procedure lv_style_set_line_blend_mode (style : Plv_style; state : Tlv_state; value : Tlv_blend_mode);
function lv_obj_get_style_line_dash_width (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
procedure lv_obj_set_style_local_line_dash_width (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
procedure lv_style_set_line_dash_width (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
function lv_obj_get_style_line_dash_gap (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
procedure lv_obj_set_style_local_line_dash_gap (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
procedure lv_style_set_line_dash_gap (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
function lv_obj_get_style_line_rounded (const obj : Plv_obj; part : Tuint8) : LongBool;
procedure lv_obj_set_style_local_line_rounded (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : LongBool);
procedure lv_style_set_line_rounded (style : Plv_style; state : Tlv_state; value : LongBool);
function lv_obj_get_style_line_color (const obj : Plv_obj; part : Tuint8) : Tlv_color;
procedure lv_obj_set_style_local_line_color (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_color);
procedure lv_style_set_line_color (style : Plv_style; state : Tlv_state; value : Tlv_color);
function lv_obj_get_style_line_opa (const obj : Plv_obj; part : Tuint8) : Tlv_opa;
procedure lv_obj_set_style_local_line_opa (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_opa);
procedure lv_style_set_line_opa (style : Plv_style; state : Tlv_state; value : Tlv_opa);
function lv_obj_get_style_image_blend_mode (const obj : Plv_obj; part : Tuint8) : Tlv_blend_mode;
procedure lv_obj_set_style_local_image_blend_mode (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_blend_mode);
procedure lv_style_set_image_blend_mode (style : Plv_style; state : Tlv_state; value : Tlv_blend_mode);
function lv_obj_get_style_image_recolor (const obj : Plv_obj; part : Tuint8) : Tlv_color;
procedure lv_obj_set_style_local_image_recolor (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_color);
procedure lv_style_set_image_recolor (style : Plv_style; state : Tlv_state; value : Tlv_color);
function lv_obj_get_style_image_opa (const obj : Plv_obj; part : Tuint8) : Tlv_opa;
procedure lv_obj_set_style_local_image_opa (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_opa);
procedure lv_style_set_image_opa (style : Plv_style; state : Tlv_state; value : Tlv_opa);
function lv_obj_get_style_image_recolor_opa (const obj : Plv_obj; part : Tuint8) : Tlv_opa;
procedure lv_obj_set_style_local_image_recolor_opa (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_opa);
procedure lv_style_set_image_recolor_opa (style : Plv_style; state : Tlv_state; value : Tlv_opa);
function lv_obj_get_style_transition_time (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
procedure lv_obj_set_style_local_transition_time (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
procedure lv_style_set_transition_time (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
function lv_obj_get_style_transition_delay (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
procedure lv_obj_set_style_local_transition_delay (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
procedure lv_style_set_transition_delay (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
function lv_obj_get_style_transition_prop_1 (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
procedure lv_obj_set_style_local_transition_prop_1 (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
procedure lv_style_set_transition_prop_1 (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
function lv_obj_get_style_transition_prop_2 (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
procedure lv_obj_set_style_local_transition_prop_2 (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
procedure lv_style_set_transition_prop_2 (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
function lv_obj_get_style_transition_prop_3 (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
procedure lv_obj_set_style_local_transition_prop_3 (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
procedure lv_style_set_transition_prop_3 (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
function lv_obj_get_style_transition_prop_4 (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
procedure lv_obj_set_style_local_transition_prop_4 (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
procedure lv_style_set_transition_prop_4 (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
function lv_obj_get_style_transition_prop_5 (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
procedure lv_obj_set_style_local_transition_prop_5 (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
procedure lv_style_set_transition_prop_5 (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
function lv_obj_get_style_transition_prop_6 (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
procedure lv_obj_set_style_local_transition_prop_6 (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
procedure lv_style_set_transition_prop_6 (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
function lv_obj_get_style_transition_path (const obj : Plv_obj; part : Tuint8) : pointer;
procedure lv_obj_set_style_local_transition_path (obj : Plv_obj; part : Tuint8; state : Tlv_state; const value : pointer);
procedure lv_style_set_transition_path (style : Plv_style; state : Tlv_state; const value : pointer);
function lv_obj_get_style_scale_width (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
procedure lv_obj_set_style_local_scale_width (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
procedure lv_style_set_scale_width (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
function lv_obj_get_style_scale_border_width (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
procedure lv_obj_set_style_local_scale_border_width (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
procedure lv_style_set_scale_border_width (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
function lv_obj_get_style_scale_end_border_width (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
procedure lv_obj_set_style_local_scale_end_border_width (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
procedure lv_style_set_scale_end_border_width (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
function lv_obj_get_style_scale_end_line_width (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
procedure lv_obj_set_style_local_scale_end_line_width (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
procedure lv_style_set_scale_end_line_width (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
function lv_obj_get_style_scale_grad_color (const obj : Plv_obj; part : Tuint8) : Tlv_color;
procedure lv_obj_set_style_local_scale_grad_color (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_color);
procedure lv_style_set_scale_grad_color (style : Plv_style; state : Tlv_state; value : Tlv_color);
function lv_obj_get_style_scale_end_color (const obj : Plv_obj; part : Tuint8) : Tlv_color;
procedure lv_obj_set_style_local_scale_end_color (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_color);
procedure lv_style_set_scale_end_color (style : Plv_style; state : Tlv_state; value : Tlv_color);

function lv_dpx (n : Tlv_coord) : Tlv_coord;

implementation

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

procedure lv_gauge_set_range (gauge : Plv_obj; min, max : Tint32); inline;
begin
  lv_linemeter_set_range (gauge, min, max);
end;

procedure lv_gauge_set_critical_value (gauge : Plv_obj; value : Tint32); inline;
begin
  lv_linemeter_set_value (gauge, value);
end;

procedure lv_gauge_set_angle_offset (gauge : Plv_obj; angle : Tuint16); inline;
begin
  lv_linemeter_set_angle_offset (gauge, angle);
end;

function lv_gauge_get_min_value (const lmeter : Plv_obj) : Tint32; inline;
begin
  Result := lv_linemeter_get_min_value (lmeter);
end;

function lv_gauge_get_max_value (const lmeter : Plv_obj) : Tint32; inline;
begin
  Result := lv_linemeter_get_max_value (lmeter);
end;

function lv_gauge_get_critical_value (const gauge : Plv_obj) : Tint32; inline;
begin
  Result := lv_linemeter_get_value (gauge);
end;

function lv_gauge_get_line_count (const gauge : Plv_obj) : Tint16; inline;
begin
  Result := lv_linemeter_get_line_count (gauge);
end;

function lv_gauge_get_scale_angle (const gauge : Plv_obj) : Tint16; inline;
begin
  Result := lv_linemeter_get_scale_angle (gauge);
end;

function lv_gauge_get_angle_offset (gauge : Plv_obj) : Tint16; inline;
begin
  Result := lv_linemeter_get_angle_offset (gauge);
end;

function lv_style_list_get_style (list : Plv_style_list; id : Tuint8) : Plv_style; inline;
begin
//    if (list^.has_trans) and (list->skip_trans) then id := id + 1;
//  if (list^.style_cnt = 0) or (id >= list^.style_cnt) then
  //      begin
    //      Result := nil;
      //    exit;
        //end;
//    Result := list^.style_list[id];
  Result := nil; // elaborate
end;

procedure lv_slider_set_value (slider : Plv_obj; value : Tint16; anim : Tlv_anim_enable); inline;
begin
  lv_bar_set_value (slider, value, anim);
end;

procedure lv_slider_set_left_value (slider : Plv_obj; left_value : Tint16; anim : Tlv_anim_enable); inline;
begin
  lv_bar_set_start_value (slider, left_value, anim);
end;

procedure lv_slider_set_range (slider : Plv_obj; min, max : Tint16); inline;
begin
  lv_bar_set_range (slider, min, max);
end;

procedure lv_slider_set_anim_time (slider : Plv_obj; anim_time : Tuint16); inline;
begin
  lv_bar_set_anim_time (slider, anim_time);
end;

procedure lv_slider_set_type (slider : Plv_obj; _type : Tlv_slider_type); inline;
begin
  if _type = LV_SLIDER_TYPE_NORMAL then
    lv_bar_set_type (slider, LV_BAR_TYPE_NORMAL)
  else if _type = LV_SLIDER_TYPE_SYMMETRICAL then
    lv_bar_set_type (slider, LV_BAR_TYPE_SYMMETRICAL)
  else if _type = LV_SLIDER_TYPE_RANGE then
    lv_bar_set_type (slider, LV_BAR_TYPE_CUSTOM);
end;

function lv_slider_get_left_value (const slider : Plv_obj) : Tint16; inline;
begin
  Result := lv_bar_get_start_value (slider);
end;

function lv_slider_get_min_value (const slider : Plv_obj) : Tint16; inline;
begin
  Result := lv_bar_get_min_value (slider);
end;

function lv_slider_get_max_value (const slider : Plv_obj) : Tint16; inline;
begin
  Result := lv_bar_get_max_value (slider);
end;

function lv_slider_get_anim_time (slider : Plv_obj) : Tint16; inline;
begin
  Result := lv_bar_get_anim_time (slider);
end;

function lv_slider_get_type (slider : Plv_obj) : Tlv_slider_type; inline;
var
  _type : Tlv_bar_type;
begin
  _type := lv_bar_get_type (slider);
  if _type = LV_BAR_TYPE_SYMMETRICAL then
    Result := LV_SLIDER_TYPE_SYMMETRICAL
  else if _type = LV_BAR_TYPE_CUSTOM then
    Result := LV_SLIDER_TYPE_RANGE
  else
    Result := LV_SLIDER_TYPE_NORMAL;
end;

procedure lv_switch_set_anim_time (sw : Plv_obj; anim_time : Tint16); inline;
begin
  lv_bar_set_anim_time (sw, anim_time);
end;

function lv_switch_get_state (const sw : Plv_obj) : LongBool; inline;
var
  ext : Plv_switch_ext;
begin
  ext := lv_obj_get_ext_attr (sw);
  Result := ext^.state > 0;
end;

function lv_switch_get_anim_time (const sw : Plv_obj) : Tuint16; inline;
begin
  Result := lv_bar_get_anim_time (sw);
end;

function lv_page_get_scrl_width (const page : Plv_obj) : Tlv_coord;
begin
  Result := lv_obj_get_width (lv_page_get_scrollable (page));
end;

function lv_page_get_scrl_height (const page : Plv_obj) : Tlv_coord;
begin
  Result := lv_obj_get_height (lv_page_get_scrollable (page));
end;

function lv_page_get_scrl_layout (const page : Plv_obj) : Tlv_layout;
begin
  Result := lv_cont_get_layout (lv_page_get_scrollable (page));
end;

function lv_page_get_scrl_fit_left (const page : Plv_obj) : Tlv_fit;
begin
  Result := lv_cont_get_fit_left (lv_page_get_scrollable (page));
end;

function lv_page_get_scrl_fit_right (const page : Plv_obj) : Tlv_fit;
begin
  Result := lv_cont_get_fit_right (lv_page_get_scrollable (page));
end;

function lv_page_get_scrl_fit_top (const page : Plv_obj) : Tlv_fit;
begin
  Result := lv_cont_get_fit_top (lv_page_get_scrollable (page));
end;

function lv_page_get_scrl_fit_bottom (const page : Plv_obj) : Tlv_fit;
begin
  Result := lv_cont_get_fit_bottom (lv_page_get_scrollable (page));
end;

procedure lv_page_set_scrollable_fit4 (page : Plv_obj; left, right, top, bottom : Tlv_fit);
begin
    lv_cont_set_fit4(lv_page_get_scrollable(page), left, right, top, bottom);
end;

procedure lv_page_set_scrollable_fit2 (page : Plv_obj; hor, ver : Tlv_fit);
begin
  lv_cont_set_fit2(lv_page_get_scrollable(page), hor, ver);
end;

procedure lv_page_set_scrollable_fit (page : Plv_obj; fit : Tlv_fit);
begin
  lv_cont_set_fit (lv_page_get_scrollable (page), fit);
end;

procedure lv_page_set_scrl_width (page : Plv_obj; w : Tlv_coord);
begin
  lv_obj_set_width (lv_page_get_scrollable (page), w);
end;

procedure lv_page_set_scrl_height (page : Plv_obj; h : Tlv_coord);
begin
  lv_obj_set_height (lv_page_get_scrollable (page), h);
end;

procedure lv_page_set_scrl_layout (page : Plv_obj; layout : Tlv_layout);
begin
  lv_cont_set_layout (lv_page_get_scrollable (page), layout);
end;

procedure lv_textarea_set_scrollbar_mode (ta : Plv_obj; mode : Tlv_scrollbar_mode);
begin
  lv_page_set_scrollbar_mode (ta, mode);
end;

procedure lv_textarea_set_scroll_propagation (ta : Plv_obj; en : LongBool);
begin
  lv_page_set_scroll_propagation (ta, en);
end;

procedure lv_textarea_set_edge_flash (ta : Plv_obj; en : LongBool);
begin
    lv_page_set_edge_flash (ta, en);
end;

function lv_textarea_get_scrollbar_mode (const ta : Plv_obj) : Tlv_scrollbar_mode;
begin
  Result := lv_page_get_scrollbar_mode(ta);
end;

function lv_textarea_get_scroll_propagation (ta : Plv_obj) : LongBool;
begin
  Result := lv_page_get_scroll_propagation (ta);
end;

function lv_textarea_get_edge_flash (ta : Plv_obj) : LongBool;
begin
  Result := lv_page_get_edge_flash (ta);
end;

// style macros
function lv_obj_get_style_radius (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
begin
	Result := _lv_obj_get_style_int (obj, part, LV_STYLE_RADIUS);
end;
procedure lv_obj_set_style_local_radius (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_obj_set_style_local_int (obj, part, LV_STYLE_RADIUS or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_radius (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_style_set_int (style, LV_STYLE_RADIUS or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_clip_corner (const obj : Plv_obj; part : Tuint8) : LongBool;
begin
	Result := LongBool (_lv_obj_get_style_int (obj, part, LV_STYLE_CLIP_CORNER));
end;
procedure lv_obj_set_style_local_clip_corner (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : LongBool);
begin
	_lv_obj_set_style_local_int (obj, part, LV_STYLE_CLIP_CORNER or (state shl LV_STYLE_STATE_POS), Tlv_style_int (value));
end;
procedure lv_style_set_clip_corner (style : Plv_style; state : Tlv_state; value : LongBool);
begin
	_lv_style_set_int (style, LV_STYLE_CLIP_CORNER or (state shl LV_STYLE_STATE_POS), Tlv_style_int (value));
end;
function lv_obj_get_style_size (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
begin
	Result := _lv_obj_get_style_int (obj, part, LV_STYLE_SIZE);
end;
procedure lv_obj_set_style_local_size (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_obj_set_style_local_int (obj, part, LV_STYLE_SIZE or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_size (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_style_set_int (style, LV_STYLE_SIZE or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_transform_width (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
begin
	Result :=  _lv_obj_get_style_int (obj, part, LV_STYLE_TRANSFORM_WIDTH);
end;
procedure lv_obj_set_style_local_transform_width (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_obj_set_style_local_int (obj, part, LV_STYLE_TRANSFORM_WIDTH or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_transform_width (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_style_set_int (style, LV_STYLE_TRANSFORM_WIDTH or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_transform_height (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
begin
	Result := _lv_obj_get_style_int (obj, part, LV_STYLE_TRANSFORM_HEIGHT);
end;
procedure lv_obj_set_style_local_transform_height (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_obj_set_style_local_int (obj, part, LV_STYLE_TRANSFORM_HEIGHT or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_transform_height (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_style_set_int (style, LV_STYLE_TRANSFORM_HEIGHT or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_transform_angle (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
begin
	Result := _lv_obj_get_style_int (obj, part, LV_STYLE_TRANSFORM_ANGLE);
end;
procedure lv_obj_set_style_local_transform_angle (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_obj_set_style_local_int (obj, part, LV_STYLE_TRANSFORM_ANGLE or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_transform_angle (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_style_set_int (style, LV_STYLE_TRANSFORM_ANGLE or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_transform_zoom (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
begin
	Result := _lv_obj_get_style_int (obj, part, LV_STYLE_TRANSFORM_ZOOM);
end;
procedure lv_obj_set_style_local_transform_zoom (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_obj_set_style_local_int (obj, part, LV_STYLE_TRANSFORM_ZOOM or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_transform_zoom (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_style_set_int (style, LV_STYLE_TRANSFORM_ZOOM or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_opa_scale (const obj : Plv_obj; part : Tuint8) : Tlv_opa;
begin
	Result := _lv_obj_get_style_opa (obj, part, LV_STYLE_OPA_SCALE);
end;
procedure lv_obj_set_style_local_opa_scale (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_opa);
begin
	_lv_obj_set_style_local_opa (obj, part, LV_STYLE_OPA_SCALE or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_opa_scale (style : Plv_style; state : Tlv_state; value : Tlv_opa);
begin
	_lv_style_set_opa (style, LV_STYLE_OPA_SCALE or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_pad_top (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
begin
	Result := _lv_obj_get_style_int (obj, part, LV_STYLE_PAD_TOP);
end;
procedure lv_obj_set_style_local_pad_top (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_obj_set_style_local_int (obj, part, LV_STYLE_PAD_TOP or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_pad_top (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_style_set_int (style, LV_STYLE_PAD_TOP or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_pad_bottom (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
begin
	Result := _lv_obj_get_style_int (obj, part, LV_STYLE_PAD_BOTTOM);
end;
procedure lv_obj_set_style_local_pad_bottom (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_obj_set_style_local_int (obj, part, LV_STYLE_PAD_BOTTOM or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_pad_bottom (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_style_set_int (style, LV_STYLE_PAD_BOTTOM or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_pad_left (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
begin
	Result := _lv_obj_get_style_int (obj, part, LV_STYLE_PAD_LEFT);
end;
procedure lv_obj_set_style_local_pad_left (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_obj_set_style_local_int (obj, part, LV_STYLE_PAD_LEFT or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_pad_left (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_style_set_int (style, LV_STYLE_PAD_LEFT or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_pad_right (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
begin
	Result := _lv_obj_get_style_int (obj, part, LV_STYLE_PAD_RIGHT);
end;
procedure lv_obj_set_style_local_pad_right (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_obj_set_style_local_int (obj, part, LV_STYLE_PAD_RIGHT or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_pad_right (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_style_set_int (style, LV_STYLE_PAD_RIGHT or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_pad_inner (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
begin
	Result := _lv_obj_get_style_int (obj, part, LV_STYLE_PAD_INNER);
end;
procedure lv_obj_set_style_local_pad_inner (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_obj_set_style_local_int (obj, part, LV_STYLE_PAD_INNER or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_pad_inner (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_style_set_int (style, LV_STYLE_PAD_INNER or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_margin_top (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
begin
	Result := _lv_obj_get_style_int (obj, part, LV_STYLE_MARGIN_TOP);
end;
procedure lv_obj_set_style_local_margin_top (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_obj_set_style_local_int (obj, part, LV_STYLE_MARGIN_TOP or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_margin_top (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_style_set_int (style, LV_STYLE_MARGIN_TOP or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_margin_bottom (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
begin
	Result := _lv_obj_get_style_int (obj, part, LV_STYLE_MARGIN_BOTTOM);
end;
procedure lv_obj_set_style_local_margin_bottom (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_obj_set_style_local_int (obj, part, LV_STYLE_MARGIN_BOTTOM or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_margin_bottom (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_style_set_int (style, LV_STYLE_MARGIN_BOTTOM or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_margin_left (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
begin
	Result := _lv_obj_get_style_int (obj, part, LV_STYLE_MARGIN_LEFT);
end;
procedure lv_obj_set_style_local_margin_left (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_obj_set_style_local_int (obj, part, LV_STYLE_MARGIN_LEFT or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_margin_left (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_style_set_int (style, LV_STYLE_MARGIN_LEFT or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_margin_right (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
begin
	Result := _lv_obj_get_style_int (obj, part, LV_STYLE_MARGIN_RIGHT);
end;
procedure lv_obj_set_style_local_margin_right (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_obj_set_style_local_int (obj, part, LV_STYLE_MARGIN_RIGHT or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_margin_right (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_style_set_int (style, LV_STYLE_MARGIN_RIGHT or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_bg_blend_mode (const obj : Plv_obj; part : Tuint8) : Tlv_blend_mode;
begin
	Result := Tlv_blend_mode (_lv_obj_get_style_int (obj, part, LV_STYLE_BG_BLEND_MODE));
end;
procedure lv_obj_set_style_local_bg_blend_mode (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_blend_mode);
begin
	_lv_obj_set_style_local_int (obj, part, LV_STYLE_BG_BLEND_MODE or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_bg_blend_mode (style : Plv_style; state : Tlv_state; value : Tlv_blend_mode);
begin
	_lv_style_set_int (style, LV_STYLE_BG_BLEND_MODE or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_bg_main_stop (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
begin
	Result := _lv_obj_get_style_int (obj, part, LV_STYLE_BG_MAIN_STOP);
end;
procedure lv_obj_set_style_local_bg_main_stop (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_obj_set_style_local_int (obj, part, LV_STYLE_BG_MAIN_STOP or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_bg_main_stop (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_style_set_int (style, LV_STYLE_BG_MAIN_STOP or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_bg_grad_stop (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
begin
	Result := _lv_obj_get_style_int (obj, part, LV_STYLE_BG_GRAD_STOP);
end;
procedure lv_obj_set_style_local_bg_grad_stop (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_obj_set_style_local_int (obj, part, LV_STYLE_BG_GRAD_STOP or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_bg_grad_stop (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_style_set_int (style, LV_STYLE_BG_GRAD_STOP or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_bg_grad_dir (const obj : Plv_obj; part : Tuint8) : Tlv_grad_dir;
begin
	Result := Tlv_grad_dir (_lv_obj_get_style_int (obj, part, LV_STYLE_BG_GRAD_DIR));
end;
procedure lv_obj_set_style_local_bg_grad_dir (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_grad_dir);
begin
	_lv_obj_set_style_local_int (obj, part, LV_STYLE_BG_GRAD_DIR or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_bg_grad_dir (style : Plv_style; state : Tlv_state; value : Tlv_grad_dir);
begin
	_lv_style_set_int (style, LV_STYLE_BG_GRAD_DIR or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_bg_color (const obj : Plv_obj; part : Tuint8) : Tlv_color;
begin
	Result := _lv_obj_get_style_color (obj, part, LV_STYLE_BG_COLOR);
end;
procedure lv_obj_set_style_local_bg_color (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_color);
begin
	_lv_obj_set_style_local_color (obj, part, LV_STYLE_BG_COLOR or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_bg_color (style : Plv_style; state : Tlv_state; value : Tlv_color);
begin
	_lv_style_set_color (style, LV_STYLE_BG_COLOR or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_bg_grad_color (const obj : Plv_obj; part : Tuint8) : Tlv_color;
begin
	Result := _lv_obj_get_style_color (obj, part, LV_STYLE_BG_GRAD_COLOR);
end;
procedure lv_obj_set_style_local_bg_grad_color (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_color);
begin
	_lv_obj_set_style_local_color (obj, part, LV_STYLE_BG_GRAD_COLOR or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_bg_grad_color (style : Plv_style; state : Tlv_state; value : Tlv_color);
begin
	_lv_style_set_color (style, LV_STYLE_BG_GRAD_COLOR or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_bg_opa (const obj : Plv_obj; part : Tuint8) : Tlv_opa;
begin
	Result := _lv_obj_get_style_opa (obj, part, LV_STYLE_BG_OPA);
end;
procedure lv_obj_set_style_local_bg_opa (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_opa);
begin
	_lv_obj_set_style_local_opa (obj, part, LV_STYLE_BG_OPA or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_bg_opa (style : Plv_style; state : Tlv_state; value : Tlv_opa);
begin
	_lv_style_set_opa (style, LV_STYLE_BG_OPA or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_border_width (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
begin
	Result := _lv_obj_get_style_int (obj, part, LV_STYLE_BORDER_WIDTH);
end;
procedure lv_obj_set_style_local_border_width (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_obj_set_style_local_int (obj, part, LV_STYLE_BORDER_WIDTH or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_border_width (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_style_set_int (style, LV_STYLE_BORDER_WIDTH or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_border_side (const obj : Plv_obj; part : Tuint8) : Tlv_border_side;
begin
	Result := _lv_obj_get_style_int (obj, part, LV_STYLE_BORDER_SIDE);
end;
procedure lv_obj_set_style_local_border_side (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_border_side);
begin
	_lv_obj_set_style_local_int (obj, part, LV_STYLE_BORDER_SIDE or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_border_side (style : Plv_style; state : Tlv_state; value : Tlv_border_side);
begin
	_lv_style_set_int (style, LV_STYLE_BORDER_SIDE or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_border_blend_mode (const obj : Plv_obj; part : Tuint8) : Tlv_blend_mode;
begin
	Result := _lv_obj_get_style_int (obj, part, LV_STYLE_BORDER_BLEND_MODE);
end;
procedure lv_obj_set_style_local_border_blend_mode (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_blend_mode);
begin
	_lv_obj_set_style_local_int (obj, part, LV_STYLE_BORDER_BLEND_MODE or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_border_blend_mode (style : Plv_style; state : Tlv_state; value : Tlv_blend_mode);
begin
	_lv_style_set_int (style, LV_STYLE_BORDER_BLEND_MODE or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_border_post (const obj : Plv_obj; part : Tuint8) : LongBool;
begin
	Result := LongBool (_lv_obj_get_style_int (obj, part, LV_STYLE_BORDER_POST));
end;
procedure lv_obj_set_style_local_border_post (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : LongBool);
begin
	_lv_obj_set_style_local_int (obj, part, LV_STYLE_BORDER_POST or (state shl LV_STYLE_STATE_POS), Tlv_style_int (value));
end;
procedure lv_style_set_border_post (style : Plv_style; state : Tlv_state; value : LongBool);
begin
	_lv_style_set_int (style, LV_STYLE_BORDER_POST or (state shl LV_STYLE_STATE_POS), Tlv_style_int (value));
end;
function lv_obj_get_style_border_color (const obj : Plv_obj; part : Tuint8) : Tlv_color;
begin
	Result := _lv_obj_get_style_color (obj, part, LV_STYLE_BORDER_COLOR);
end;
procedure lv_obj_set_style_local_border_color (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_color);
begin
	_lv_obj_set_style_local_color (obj, part, LV_STYLE_BORDER_COLOR or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_border_color (style : Plv_style; state : Tlv_state; value : Tlv_color);
begin
	_lv_style_set_color (style, LV_STYLE_BORDER_COLOR or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_border_opa (const obj : Plv_obj; part : Tuint8) : Tlv_opa;
begin
	Result := _lv_obj_get_style_opa (obj, part, LV_STYLE_BORDER_OPA);
end;
procedure lv_obj_set_style_local_border_opa (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_opa);
begin
	_lv_obj_set_style_local_opa (obj, part, LV_STYLE_BORDER_OPA or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_border_opa (style : Plv_style; state : Tlv_state; value : Tlv_opa);
begin
	_lv_style_set_opa (style, LV_STYLE_BORDER_OPA or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_outline_width (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
begin
	Result := _lv_obj_get_style_int (obj, part, LV_STYLE_OUTLINE_WIDTH);
end;
procedure lv_obj_set_style_local_outline_width (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_obj_set_style_local_int (obj, part, LV_STYLE_OUTLINE_WIDTH or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_outline_width (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_style_set_int (style, LV_STYLE_OUTLINE_WIDTH or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_outline_pad (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
begin
	Result := _lv_obj_get_style_int (obj, part, LV_STYLE_OUTLINE_PAD);
end;
procedure lv_obj_set_style_local_outline_pad (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_obj_set_style_local_int (obj, part, LV_STYLE_OUTLINE_PAD or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_outline_pad (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_style_set_int (style, LV_STYLE_OUTLINE_PAD or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_outline_blend_mode (const obj : Plv_obj; part : Tuint8) : Tlv_blend_mode;
begin
	Result := Tlv_blend_mode (_lv_obj_get_style_int (obj, part, LV_STYLE_OUTLINE_BLEND_MODE));
end;
procedure lv_obj_set_style_local_outline_blend_mode (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_blend_mode);
begin
	_lv_obj_set_style_local_int (obj, part, LV_STYLE_OUTLINE_BLEND_MODE or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_outline_blend_mode (style : Plv_style; state : Tlv_state; value : Tlv_blend_mode);
begin
	_lv_style_set_int (style, LV_STYLE_OUTLINE_BLEND_MODE or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_outline_color (const obj : Plv_obj; part : Tuint8) : Tlv_color;
begin
	Result := _lv_obj_get_style_color (obj, part, LV_STYLE_OUTLINE_COLOR);
end;
procedure lv_obj_set_style_local_outline_color (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_color);
begin
	_lv_obj_set_style_local_color (obj, part, LV_STYLE_OUTLINE_COLOR or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_outline_color (style : Plv_style; state : Tlv_state; value : Tlv_color);
begin
	_lv_style_set_color (style, LV_STYLE_OUTLINE_COLOR or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_outline_opa (const obj : Plv_obj; part : Tuint8) : Tlv_opa;
begin
	Result := _lv_obj_get_style_opa (obj, part, LV_STYLE_OUTLINE_OPA);
end;
procedure lv_obj_set_style_local_outline_opa (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_opa);
begin
	_lv_obj_set_style_local_opa (obj, part, LV_STYLE_OUTLINE_OPA or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_outline_opa (style : Plv_style; state : Tlv_state; value : Tlv_opa);
begin
	_lv_style_set_opa (style, LV_STYLE_OUTLINE_OPA or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_shadow_width (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
begin
	Result := _lv_obj_get_style_int (obj, part, LV_STYLE_SHADOW_WIDTH);
end;
procedure lv_obj_set_style_local_shadow_width (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_obj_set_style_local_int (obj, part, LV_STYLE_SHADOW_WIDTH or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_shadow_width (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_style_set_int (style, LV_STYLE_SHADOW_WIDTH or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_shadow_ofs_x (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
begin
	Result := _lv_obj_get_style_int (obj, part, LV_STYLE_SHADOW_OFS_X);
end;
procedure lv_obj_set_style_local_shadow_ofs_x (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_obj_set_style_local_int (obj, part, LV_STYLE_SHADOW_OFS_X or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_shadow_ofs_x (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_style_set_int (style, LV_STYLE_SHADOW_OFS_X or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_shadow_ofs_y (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
begin
	Result := _lv_obj_get_style_int (obj, part, LV_STYLE_SHADOW_OFS_Y);
end;
procedure lv_obj_set_style_local_shadow_ofs_y (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_obj_set_style_local_int (obj, part, LV_STYLE_SHADOW_OFS_Y or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_shadow_ofs_y (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_style_set_int (style, LV_STYLE_SHADOW_OFS_Y or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_shadow_spread (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
begin
	Result := _lv_obj_get_style_int (obj, part, LV_STYLE_SHADOW_SPREAD);
end;
procedure lv_obj_set_style_local_shadow_spread (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_obj_set_style_local_int (obj, part, LV_STYLE_SHADOW_SPREAD or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_shadow_spread (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_style_set_int (style, LV_STYLE_SHADOW_SPREAD or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_shadow_blend_mode (const obj : Plv_obj; part : Tuint8) : Tlv_blend_mode;
begin
	Result := _lv_obj_get_style_int (obj, part, LV_STYLE_SHADOW_BLEND_MODE);
end;
procedure lv_obj_set_style_local_shadow_blend_mode (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_blend_mode);
begin
	_lv_obj_set_style_local_int (obj, part, LV_STYLE_SHADOW_BLEND_MODE or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_shadow_blend_mode (style : Plv_style; state : Tlv_state; value : Tlv_blend_mode);
begin
	_lv_style_set_int (style, LV_STYLE_SHADOW_BLEND_MODE or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_shadow_color (const obj : Plv_obj; part : Tuint8) : Tlv_color;
begin
	Result := _lv_obj_get_style_color (obj, part, LV_STYLE_SHADOW_COLOR);
end;
procedure lv_obj_set_style_local_shadow_color (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_color);
begin
	_lv_obj_set_style_local_color (obj, part, LV_STYLE_SHADOW_COLOR or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_shadow_color (style : Plv_style; state : Tlv_state; value : Tlv_color);
begin
	_lv_style_set_color (style, LV_STYLE_SHADOW_COLOR or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_shadow_opa (const obj : Plv_obj; part : Tuint8) : Tlv_opa;
begin
	Result := _lv_obj_get_style_opa (obj, part, LV_STYLE_SHADOW_OPA);
end;
procedure lv_obj_set_style_local_shadow_opa (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_opa);
begin
	_lv_obj_set_style_local_opa (obj, part, LV_STYLE_SHADOW_OPA or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_shadow_opa (style : Plv_style; state : Tlv_state; value : Tlv_opa);
begin
	_lv_style_set_opa (style, LV_STYLE_SHADOW_OPA or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_pattern_repeat (const obj : Plv_obj; part : Tuint8) : LongBool;
begin
	Result := LongBool (_lv_obj_get_style_int (obj, part, LV_STYLE_PATTERN_REPEAT));
end;
procedure lv_obj_set_style_local_pattern_repeat (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : LongBool);
begin
	_lv_obj_set_style_local_int (obj, part, LV_STYLE_PATTERN_REPEAT or (state shl LV_STYLE_STATE_POS), Tlv_style_int (value));
end;
procedure lv_style_set_pattern_repeat (style : Plv_style; state : Tlv_state; value : LongBool);
begin
	_lv_style_set_int (style, LV_STYLE_PATTERN_REPEAT or (state shl LV_STYLE_STATE_POS), Tlv_style_int (value));
end;
function lv_obj_get_style_pattern_blend_mode (const obj : Plv_obj; part : Tuint8) : Tlv_blend_mode;
begin
	Result := _lv_obj_get_style_int (obj, part, LV_STYLE_PATTERN_BLEND_MODE);
end;
procedure lv_obj_set_style_local_pattern_blend_mode (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_blend_mode);
begin
	_lv_obj_set_style_local_int (obj, part, LV_STYLE_PATTERN_BLEND_MODE or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_pattern_blend_mode (style : Plv_style; state : Tlv_state; value : Tlv_blend_mode);
begin
	_lv_style_set_int (style, LV_STYLE_PATTERN_BLEND_MODE or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_pattern_recolor (const obj : Plv_obj; part : Tuint8) : Tlv_color;
begin
	Result := _lv_obj_get_style_color (obj, part, LV_STYLE_PATTERN_RECOLOR);
end;
procedure lv_obj_set_style_local_pattern_recolor (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_color);
begin
	_lv_obj_set_style_local_color (obj, part, LV_STYLE_PATTERN_RECOLOR or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_pattern_recolor (style : Plv_style; state : Tlv_state; value : Tlv_color);
begin
	_lv_style_set_color (style, LV_STYLE_PATTERN_RECOLOR or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_pattern_opa (const obj : Plv_obj; part : Tuint8) : Tlv_opa;
begin
	Result := _lv_obj_get_style_opa (obj, part, LV_STYLE_PATTERN_OPA);
end;
procedure lv_obj_set_style_local_pattern_opa (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_opa);
begin
	_lv_obj_set_style_local_opa (obj, part, LV_STYLE_PATTERN_OPA or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_pattern_opa (style : Plv_style; state : Tlv_state; value : Tlv_opa);
begin
	_lv_style_set_opa (style, LV_STYLE_PATTERN_OPA or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_pattern_recolor_opa (const obj : Plv_obj; part : Tuint8) : Tlv_opa;
begin
	Result := _lv_obj_get_style_opa (obj, part, LV_STYLE_PATTERN_RECOLOR_OPA);
end;
procedure lv_obj_set_style_local_pattern_recolor_opa (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_opa);
begin
	_lv_obj_set_style_local_opa (obj, part, LV_STYLE_PATTERN_RECOLOR_OPA or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_pattern_recolor_opa (style : Plv_style; state : Tlv_state; value : Tlv_opa);
begin
	_lv_style_set_opa (style, LV_STYLE_PATTERN_RECOLOR_OPA or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_pattern_image (const obj : Plv_obj; part : Tuint8) : pointer;
begin
	Result :=  _lv_obj_get_style_ptr (obj, part, LV_STYLE_PATTERN_IMAGE);
end;
procedure lv_obj_set_style_local_pattern_image (obj : Plv_obj; part : Tuint8; state : Tlv_state; const value : pointer);
begin
	_lv_obj_set_style_local_ptr (obj, part, LV_STYLE_PATTERN_IMAGE or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_pattern_image (style : Plv_style; state : Tlv_state; const value : pointer);
begin
	_lv_style_set_ptr (style, LV_STYLE_PATTERN_IMAGE or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_value_letter_space (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
begin
	Result := _lv_obj_get_style_int (obj, part, LV_STYLE_VALUE_LETTER_SPACE);
end;
procedure lv_obj_set_style_local_value_letter_space (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_obj_set_style_local_int (obj, part, LV_STYLE_VALUE_LETTER_SPACE or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_value_letter_space (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_style_set_int (style, LV_STYLE_VALUE_LETTER_SPACE or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_value_line_space (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
begin
	Result := _lv_obj_get_style_int (obj, part, LV_STYLE_VALUE_LINE_SPACE);
end;
procedure lv_obj_set_style_local_value_line_space (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
begin
_lv_obj_set_style_local_int (obj, part, LV_STYLE_VALUE_LINE_SPACE or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_value_line_space (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_style_set_int (style, LV_STYLE_VALUE_LINE_SPACE or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_value_blend_mode (const obj : Plv_obj; part : Tuint8) : Tlv_blend_mode;
begin
	Result := _lv_obj_get_style_int (obj, part, LV_STYLE_VALUE_BLEND_MODE);
end;
procedure lv_obj_set_style_local_value_blend_mode (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_blend_mode);
begin
	_lv_obj_set_style_local_int (obj, part, LV_STYLE_VALUE_BLEND_MODE or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_value_blend_mode (style : Plv_style; state : Tlv_state; value : Tlv_blend_mode);
begin
	_lv_style_set_int (style, LV_STYLE_VALUE_BLEND_MODE or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_value_ofs_x (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
begin
	Result := _lv_obj_get_style_int (obj, part, LV_STYLE_VALUE_OFS_X);
end;
procedure lv_obj_set_style_local_value_ofs_x (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_obj_set_style_local_int (obj, part, LV_STYLE_VALUE_OFS_X or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_value_ofs_x (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_style_set_int (style, LV_STYLE_VALUE_OFS_X or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_value_ofs_y (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
begin
	Result := _lv_obj_get_style_int (obj, part, LV_STYLE_VALUE_OFS_Y);
end;
procedure lv_obj_set_style_local_value_ofs_y (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_obj_set_style_local_int (obj, part, LV_STYLE_VALUE_OFS_Y or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_value_ofs_y (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_style_set_int (style, LV_STYLE_VALUE_OFS_Y or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_value_align (const obj : Plv_obj; part : Tuint8) : Tlv_align;
begin
	Result := _lv_obj_get_style_int (obj, part, LV_STYLE_VALUE_ALIGN);
end;
procedure lv_obj_set_style_local_value_align (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_align);
begin
	_lv_obj_set_style_local_int (obj, part, LV_STYLE_VALUE_ALIGN or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_value_align (style : Plv_style; state : Tlv_state; value : Tlv_align);
begin
	_lv_style_set_int (style, LV_STYLE_VALUE_ALIGN or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_value_color (const obj : Plv_obj; part : Tuint8) : Tlv_color;
begin
	Result := _lv_obj_get_style_color (obj, part, LV_STYLE_VALUE_COLOR);
end;
procedure lv_obj_set_style_local_value_color (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_color);
begin
	_lv_obj_set_style_local_color (obj, part, LV_STYLE_VALUE_COLOR or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_value_color (style : Plv_style; state : Tlv_state; value : Tlv_color);
begin
	_lv_style_set_color (style, LV_STYLE_VALUE_COLOR or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_value_opa (const obj : Plv_obj; part : Tuint8) : Tlv_opa;
begin
	Result := _lv_obj_get_style_opa (obj, part, LV_STYLE_VALUE_OPA);
end;
procedure lv_obj_set_style_local_value_opa (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_opa);
begin
	_lv_obj_set_style_local_opa (obj, part, LV_STYLE_VALUE_OPA or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_value_opa (style : Plv_style; state : Tlv_state; value : Tlv_opa);
begin
	_lv_style_set_opa (style, LV_STYLE_VALUE_OPA or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_value_font (const obj : Plv_obj; part : Tuint8) : Plv_font;
begin
	Result := _lv_obj_get_style_ptr (obj, part, LV_STYLE_VALUE_FONT);
end;
procedure lv_obj_set_style_local_value_font (obj : Plv_obj; part : Tuint8; state : Tlv_state; const value : Plv_font);
begin
	_lv_obj_set_style_local_ptr (obj, part, LV_STYLE_VALUE_FONT or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_value_font (style : Plv_style; state : Tlv_state; const value : Plv_font);
begin
	_lv_style_set_ptr (style, LV_STYLE_VALUE_FONT or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_value_str (const obj : Plv_obj; part : Tuint8) : PChar;
begin
	Result := PChar (_lv_obj_get_style_ptr (obj, part, LV_STYLE_VALUE_STR));
end;
procedure lv_obj_set_style_local_value_str (obj : Plv_obj; part : Tuint8; state : Tlv_state; const value : PChar);
begin
	_lv_obj_set_style_local_ptr (obj, part, LV_STYLE_VALUE_STR or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_value_str (style : Plv_style; state : Tlv_state; const value : PChar);
begin
	_lv_style_set_ptr (style, LV_STYLE_VALUE_STR or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_text_letter_space (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
begin
	Result := _lv_obj_get_style_int (obj, part, LV_STYLE_TEXT_LETTER_SPACE);
end;
procedure lv_obj_set_style_local_text_letter_space (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_obj_set_style_local_int (obj, part, LV_STYLE_TEXT_LETTER_SPACE or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_text_letter_space (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_style_set_int (style, LV_STYLE_TEXT_LETTER_SPACE or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_text_line_space (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
begin
	Result := _lv_obj_get_style_int (obj, part, LV_STYLE_TEXT_LINE_SPACE);
end;
procedure lv_obj_set_style_local_text_line_space (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_obj_set_style_local_int (obj, part, LV_STYLE_TEXT_LINE_SPACE or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_text_line_space (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_style_set_int (style, LV_STYLE_TEXT_LINE_SPACE or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_text_decor (const obj : Plv_obj; part : Tuint8) : Tlv_text_decor;
begin
	Result :=_lv_obj_get_style_int (obj, part, LV_STYLE_TEXT_DECOR);
end;
procedure lv_obj_set_style_local_text_decor (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_text_decor);
begin
	_lv_obj_set_style_local_int (obj, part, LV_STYLE_TEXT_DECOR or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_text_decor (style : Plv_style; state : Tlv_state; value : Tlv_text_decor);
begin
	_lv_style_set_int (style, LV_STYLE_TEXT_DECOR or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_text_blend_mode (const obj : Plv_obj; part : Tuint8) : Tlv_blend_mode;
begin
	Result := _lv_obj_get_style_int (obj, part, LV_STYLE_TEXT_BLEND_MODE);
end;
procedure lv_obj_set_style_local_text_blend_mode (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_blend_mode);
begin
	_lv_obj_set_style_local_int (obj, part, LV_STYLE_TEXT_BLEND_MODE or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_text_blend_mode (style : Plv_style; state : Tlv_state; value : Tlv_blend_mode);
begin
	_lv_style_set_int (style, LV_STYLE_TEXT_BLEND_MODE or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_text_color (const obj : Plv_obj; part : Tuint8) : Tlv_color;
begin
	Result := _lv_obj_get_style_color (obj, part, LV_STYLE_TEXT_COLOR);
end;
procedure lv_obj_set_style_local_text_color (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_color);
begin
	_lv_obj_set_style_local_color (obj, part, LV_STYLE_TEXT_COLOR or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_text_color (style : Plv_style; state : Tlv_state; value : Tlv_color);
begin
	_lv_style_set_color (style, LV_STYLE_TEXT_COLOR or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_text_sel_color (const obj : Plv_obj; part : Tuint8) : Tlv_color;
begin
	Result := _lv_obj_get_style_color (obj, part, LV_STYLE_TEXT_SEL_COLOR);
end;
procedure lv_obj_set_style_local_text_sel_color (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_color);
begin
	_lv_obj_set_style_local_color (obj, part, LV_STYLE_TEXT_SEL_COLOR or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_text_sel_color (style : Plv_style; state : Tlv_state; value : Tlv_color);
begin
	_lv_style_set_color (style, LV_STYLE_TEXT_SEL_COLOR or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_text_opa (const obj : Plv_obj; part : Tuint8) : Tlv_opa;
begin
	Result := _lv_obj_get_style_opa (obj, part, LV_STYLE_TEXT_OPA);
end;
procedure lv_obj_set_style_local_text_opa (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_opa);
begin
	_lv_obj_set_style_local_opa (obj, part, LV_STYLE_TEXT_OPA or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_text_opa (style : Plv_style; state : Tlv_state; value : Tlv_opa);
begin
	_lv_style_set_opa (style, LV_STYLE_TEXT_OPA or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_text_font (const obj : Plv_obj; part : Tuint8) : Plv_font;
begin
	Result := _lv_obj_get_style_ptr (obj, part, LV_STYLE_TEXT_FONT);
end;
procedure lv_obj_set_style_local_text_font (obj : Plv_obj; part : Tuint8; state : Tlv_state; const value : Plv_font);
begin
	_lv_obj_set_style_local_ptr (obj, part, LV_STYLE_TEXT_FONT or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_text_font (style : Plv_style; state : Tlv_state; const value : Plv_font);
begin
	_lv_style_set_ptr (style, LV_STYLE_TEXT_FONT or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_line_width (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
begin
	Result := _lv_obj_get_style_int (obj, part, LV_STYLE_LINE_WIDTH);
end;
procedure lv_obj_set_style_local_line_width (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_obj_set_style_local_int (obj, part, LV_STYLE_LINE_WIDTH or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_line_width (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_style_set_int (style, LV_STYLE_LINE_WIDTH or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_line_blend_mode (const obj : Plv_obj; part : Tuint8) : Tlv_blend_mode;
begin
	Result := _lv_obj_get_style_int (obj, part, LV_STYLE_LINE_BLEND_MODE);
end;
procedure lv_obj_set_style_local_line_blend_mode (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_blend_mode);
begin
	_lv_obj_set_style_local_int (obj, part, LV_STYLE_LINE_BLEND_MODE or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_line_blend_mode (style : Plv_style; state : Tlv_state; value : Tlv_blend_mode);
begin
	_lv_style_set_int (style, LV_STYLE_LINE_BLEND_MODE or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_line_dash_width (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
begin
	Result := _lv_obj_get_style_int (obj, part, LV_STYLE_LINE_DASH_WIDTH);
end;
procedure lv_obj_set_style_local_line_dash_width (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_obj_set_style_local_int (obj, part, LV_STYLE_LINE_DASH_WIDTH or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_line_dash_width (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_style_set_int (style, LV_STYLE_LINE_DASH_WIDTH or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_line_dash_gap (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
begin
	Result := _lv_obj_get_style_int (obj, part, LV_STYLE_LINE_DASH_GAP);
end;
procedure lv_obj_set_style_local_line_dash_gap (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_obj_set_style_local_int (obj, part, LV_STYLE_LINE_DASH_GAP or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_line_dash_gap (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_style_set_int (style, LV_STYLE_LINE_DASH_GAP or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_line_rounded (const obj : Plv_obj; part : Tuint8) : LongBool;
begin
	Result := LongBool (_lv_obj_get_style_int (obj, part, LV_STYLE_LINE_ROUNDED));
end;
procedure lv_obj_set_style_local_line_rounded (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : LongBool);
begin
	_lv_obj_set_style_local_int (obj, part, LV_STYLE_LINE_ROUNDED or (state shl LV_STYLE_STATE_POS), Tlv_style_int (value));
end;
procedure lv_style_set_line_rounded (style : Plv_style; state : Tlv_state; value : LongBool);
begin
	_lv_style_set_int (style, LV_STYLE_LINE_ROUNDED or (state shl LV_STYLE_STATE_POS), Tlv_style_int (value));
end;
function lv_obj_get_style_line_color (const obj : Plv_obj; part : Tuint8) : Tlv_color;
begin
	Result := _lv_obj_get_style_color (obj, part, LV_STYLE_LINE_COLOR);
end;
procedure lv_obj_set_style_local_line_color (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_color);
begin
	_lv_obj_set_style_local_color (obj, part, LV_STYLE_LINE_COLOR or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_line_color (style : Plv_style; state : Tlv_state; value : Tlv_color);
begin
	_lv_style_set_color (style, LV_STYLE_LINE_COLOR or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_line_opa (const obj : Plv_obj; part : Tuint8) : Tlv_opa;
begin
	Result := _lv_obj_get_style_opa (obj, part, LV_STYLE_LINE_OPA);
end;
procedure lv_obj_set_style_local_line_opa (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_opa);
begin
	_lv_obj_set_style_local_opa (obj, part, LV_STYLE_LINE_OPA or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_line_opa (style : Plv_style; state : Tlv_state; value : Tlv_opa);
begin
	_lv_style_set_opa (style, LV_STYLE_LINE_OPA or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_image_blend_mode (const obj : Plv_obj; part : Tuint8) : Tlv_blend_mode;
begin
	Result := _lv_obj_get_style_int (obj, part, LV_STYLE_IMAGE_BLEND_MODE);
end;
procedure lv_obj_set_style_local_image_blend_mode (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_blend_mode);
begin
	_lv_obj_set_style_local_int (obj, part, LV_STYLE_IMAGE_BLEND_MODE or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_image_blend_mode (style : Plv_style; state : Tlv_state; value : Tlv_blend_mode);
begin
	_lv_style_set_int (style, LV_STYLE_IMAGE_BLEND_MODE or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_image_recolor (const obj : Plv_obj; part : Tuint8) : Tlv_color;
begin
	Result := _lv_obj_get_style_color (obj, part, LV_STYLE_IMAGE_RECOLOR);
end;
procedure lv_obj_set_style_local_image_recolor (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_color);
begin
	_lv_obj_set_style_local_color (obj, part, LV_STYLE_IMAGE_RECOLOR or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_image_recolor (style : Plv_style; state : Tlv_state; value : Tlv_color);
begin
	_lv_style_set_color (style, LV_STYLE_IMAGE_RECOLOR or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_image_opa (const obj : Plv_obj; part : Tuint8) : Tlv_opa;
begin
	Result := _lv_obj_get_style_opa (obj, part, LV_STYLE_IMAGE_OPA);
end;
procedure lv_obj_set_style_local_image_opa (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_opa);
begin
	_lv_obj_set_style_local_opa (obj, part, LV_STYLE_IMAGE_OPA or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_image_opa (style : Plv_style; state : Tlv_state; value : Tlv_opa);
begin
	_lv_style_set_opa (style, LV_STYLE_IMAGE_OPA or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_image_recolor_opa (const obj : Plv_obj; part : Tuint8) : Tlv_opa;
begin
	Result := _lv_obj_get_style_opa (obj, part, LV_STYLE_IMAGE_RECOLOR_OPA);
end;
procedure lv_obj_set_style_local_image_recolor_opa (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_opa);
begin
	_lv_obj_set_style_local_opa (obj, part, LV_STYLE_IMAGE_RECOLOR_OPA or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_image_recolor_opa (style : Plv_style; state : Tlv_state; value : Tlv_opa);
begin
	_lv_style_set_opa (style, LV_STYLE_IMAGE_RECOLOR_OPA or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_transition_time (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
begin
	Result := _lv_obj_get_style_int (obj, part, LV_STYLE_TRANSITION_TIME);
end;
procedure lv_obj_set_style_local_transition_time (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_obj_set_style_local_int (obj, part, LV_STYLE_TRANSITION_TIME or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_transition_time (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_style_set_int (style, LV_STYLE_TRANSITION_TIME or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_transition_delay (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
begin
	Result := _lv_obj_get_style_int (obj, part, LV_STYLE_TRANSITION_DELAY);
end;
procedure lv_obj_set_style_local_transition_delay (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_obj_set_style_local_int (obj, part, LV_STYLE_TRANSITION_DELAY or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_transition_delay (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_style_set_int (style, LV_STYLE_TRANSITION_DELAY or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_transition_prop_1 (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
begin
	Result := _lv_obj_get_style_int (obj, part, LV_STYLE_TRANSITION_PROP_1);
end;
procedure lv_obj_set_style_local_transition_prop_1 (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_obj_set_style_local_int (obj, part, LV_STYLE_TRANSITION_PROP_1 or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_transition_prop_1 (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_style_set_int (style, LV_STYLE_TRANSITION_PROP_1 or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_transition_prop_2 (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
begin
	Result := _lv_obj_get_style_int (obj, part, LV_STYLE_TRANSITION_PROP_2);
end;
procedure lv_obj_set_style_local_transition_prop_2 (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_obj_set_style_local_int (obj, part, LV_STYLE_TRANSITION_PROP_2 or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_transition_prop_2 (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_style_set_int (style, LV_STYLE_TRANSITION_PROP_2 or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_transition_prop_3 (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
begin
	Result := _lv_obj_get_style_int (obj, part, LV_STYLE_TRANSITION_PROP_3);
end;
procedure lv_obj_set_style_local_transition_prop_3 (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_obj_set_style_local_int (obj, part, LV_STYLE_TRANSITION_PROP_3 or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_transition_prop_3 (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_style_set_int (style, LV_STYLE_TRANSITION_PROP_3 or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_transition_prop_4 (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
begin
  Result := _lv_obj_get_style_int (obj, part, LV_STYLE_TRANSITION_PROP_4);
end;
procedure lv_obj_set_style_local_transition_prop_4 (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_obj_set_style_local_int (obj, part, LV_STYLE_TRANSITION_PROP_4 or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_transition_prop_4 (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_style_set_int (style, LV_STYLE_TRANSITION_PROP_4 or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_transition_prop_5 (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
begin
	Result := _lv_obj_get_style_int (obj, part, LV_STYLE_TRANSITION_PROP_5);
end;
procedure lv_obj_set_style_local_transition_prop_5 (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_obj_set_style_local_int (obj, part, LV_STYLE_TRANSITION_PROP_5 or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_transition_prop_5 (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_style_set_int (style, LV_STYLE_TRANSITION_PROP_5 or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_transition_prop_6 (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
begin
	Result := _lv_obj_get_style_int (obj, part, LV_STYLE_TRANSITION_PROP_6);
end;
procedure lv_obj_set_style_local_transition_prop_6 (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_obj_set_style_local_int (obj, part, LV_STYLE_TRANSITION_PROP_6 or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_transition_prop_6 (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_style_set_int (style, LV_STYLE_TRANSITION_PROP_6 or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_transition_path (const obj : Plv_obj; part : Tuint8) : pointer;
begin
	Result := _lv_obj_get_style_ptr (obj, part, LV_STYLE_TRANSITION_PATH);
end;
procedure lv_obj_set_style_local_transition_path (obj : Plv_obj; part : Tuint8; state : Tlv_state; const value : pointer);
begin
	_lv_obj_set_style_local_ptr (obj, part, LV_STYLE_TRANSITION_PATH or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_transition_path (style : Plv_style; state : Tlv_state; const value : pointer);
begin
	_lv_style_set_ptr (style, LV_STYLE_TRANSITION_PATH or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_scale_width (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
begin
	Result := _lv_obj_get_style_int (obj, part, LV_STYLE_SCALE_WIDTH);
end;
procedure lv_obj_set_style_local_scale_width (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_obj_set_style_local_int (obj, part, LV_STYLE_SCALE_WIDTH or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_scale_width (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_style_set_int (style, LV_STYLE_SCALE_WIDTH or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_scale_border_width (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
begin
	Result := _lv_obj_get_style_int (obj, part, LV_STYLE_SCALE_BORDER_WIDTH);
end;
procedure lv_obj_set_style_local_scale_border_width (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_obj_set_style_local_int (obj, part, LV_STYLE_SCALE_BORDER_WIDTH or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_scale_border_width (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_style_set_int (style, LV_STYLE_SCALE_BORDER_WIDTH or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_scale_end_border_width (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
begin
	Result := _lv_obj_get_style_int (obj, part, LV_STYLE_SCALE_END_BORDER_WIDTH);
end;
procedure lv_obj_set_style_local_scale_end_border_width (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_obj_set_style_local_int (obj, part, LV_STYLE_SCALE_END_BORDER_WIDTH or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_scale_end_border_width (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_style_set_int (style, LV_STYLE_SCALE_END_BORDER_WIDTH or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_scale_end_line_width (const obj : Plv_obj; part : Tuint8) : Tlv_style_int;
begin
	Result := _lv_obj_get_style_int (obj, part, LV_STYLE_SCALE_END_LINE_WIDTH);
end;
procedure lv_obj_set_style_local_scale_end_line_width (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_obj_set_style_local_int (obj, part, LV_STYLE_SCALE_END_LINE_WIDTH or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_scale_end_line_width (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
begin
	_lv_style_set_int (style, LV_STYLE_SCALE_END_LINE_WIDTH or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_scale_grad_color (const obj : Plv_obj; part : Tuint8) : Tlv_color;
begin
	Result := _lv_obj_get_style_color (obj, part, LV_STYLE_SCALE_GRAD_COLOR);
end;
procedure lv_obj_set_style_local_scale_grad_color (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_color);
begin
	_lv_obj_set_style_local_color (obj, part, LV_STYLE_SCALE_GRAD_COLOR or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_scale_grad_color (style : Plv_style; state : Tlv_state; value : Tlv_color);
begin
	_lv_style_set_color (style, LV_STYLE_SCALE_GRAD_COLOR or (state shl LV_STYLE_STATE_POS), value);
end;
function lv_obj_get_style_scale_end_color (const obj : Plv_obj; part : Tuint8) : Tlv_color;
begin
	Result := _lv_obj_get_style_color (obj, part, LV_STYLE_SCALE_END_COLOR);
end;
procedure lv_obj_set_style_local_scale_end_color (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_color);
begin
	_lv_obj_set_style_local_color (obj, part, LV_STYLE_SCALE_END_COLOR or (state shl LV_STYLE_STATE_POS), value);
end;
procedure lv_style_set_scale_end_color (style : Plv_style; state : Tlv_state; value : Tlv_color);
begin
	_lv_style_set_color (style, LV_STYLE_SCALE_END_COLOR or (state shl LV_STYLE_STATE_POS), value);
end;

procedure lv_obj_set_style_local_pad_all (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
begin
  lv_obj_set_style_local_pad_top (obj, part, state, value);
  lv_obj_set_style_local_pad_bottom (obj, part, state, value);
  lv_obj_set_style_local_pad_left (obj, part, state, value);
  lv_obj_set_style_local_pad_right (obj, part, state, value);
end;

procedure lv_style_set_pad_all (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
begin
  lv_style_set_pad_top (style, state, value);
  lv_style_set_pad_bottom (style, state, value);
  lv_style_set_pad_left (style, state, value);
  lv_style_set_pad_right (style, state, value);
end;

procedure lv_obj_set_style_local_pad_hor (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
begin
  lv_obj_set_style_local_pad_left (obj, part, state, value);
  lv_obj_set_style_local_pad_right (obj, part, state, value);
end;

procedure lv_style_set_pad_hor (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
begin
  lv_style_set_pad_left (style, state, value);
  lv_style_set_pad_right (style, state, value);
end;

procedure lv_obj_set_style_local_pad_ver (obj : Plv_obj; part : Tuint8; state : Tlv_state; value : Tlv_style_int);
begin
  lv_obj_set_style_local_pad_top (obj, part, state, value);
  lv_obj_set_style_local_pad_bottom (obj, part, state, value);
end;

procedure lv_style_set_pad_ver (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
begin
  lv_style_set_pad_top (style, state, value);
  lv_style_set_pad_bottom (style, state, value);
end;
(*
procedure lv_obj_set_style_local_margin_all (obj : Plv_obj; part : Tuint8; state : Tlv_state;
                                                     value : Tlv_style_int);
begin
  lv_obj_set_style_local_margin_top (obj, part, state, value);
  lv_obj_set_style_local_margin_bottom (obj, part, state, value);
  lv_obj_set_style_local_margin_left (obj, part, state, value);
  lv_obj_set_style_local_margin_right (obj, part, state, value);
end;

procedure lv_style_set_margin_all (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
begin
  lv_style_set_margin_top (style, state, value);
  lv_style_set_margin_bottom (style, state, value);
  lv_style_set_margin_left (style, state, value);
  lv_style_set_margin_right (style, state, value);
end;

procedure lv_obj_set_style_local_margin_hor (obj : Plv_obj; part : Tuint8; state : Tlv_state;
                                                     value : Tlv_style_int);
begin
  lv_obj_set_style_local_margin_left (obj, part, state, value);
  lv_obj_set_style_local_margin_right (obj, part, state, value);
end;

procedure lv_style_set_margin_hor (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
begin
  lv_style_set_margin_left (style, state, value);
  lv_style_set_margin_right (style, state, value);
end;

procedure lv_obj_set_style_local_margin_ver(obj : Plv_obj; part : Tuint8; state : Tlv_state;
                                                     value : Tlv_style_int);
begin
  lv_obj_set_style_local_margin_top (obj, part, state, value);
  lv_obj_set_style_local_margin_bottom (obj, part, state, value);
end;

procedure lv_style_set_margin_ver (style : Plv_style; state : Tlv_state; value : Tlv_style_int);
begin
  lv_style_set_margin_top (style, state, value);
  lv_style_set_margin_bottom (style, state, value);
end;
          *)

function lv_dpx (n : Tlv_coord) : Tlv_coord;
begin
  if n = 0 then
    Result := 0
  else
    begin
      if (lv_disp_get_dpi (nil) * n + 80) div 160 > 1 then
        Result := (lv_disp_get_dpi (nil) * n + 80) div 160
      else
        Result := 1;
    end;
end;

procedure lv_roller_set_anim_time (roller : Plv_obj; anim_time : Tuint16);
begin
  lv_page_set_anim_time (roller, anim_time);
end;

function lv_roller_get_anim_time (const roller : Plv_obj) : Tuint16;
begin
  Result :=  lv_page_get_anim_time (roller);
end;

procedure lv_list_set_scrollbar_mode (list : Plv_obj; mode : Tlv_scrollbar_mode);
begin
  lv_page_set_scrollbar_mode (list, mode);
end;
procedure lv_list_set_scroll_propagation(list : Plv_obj; en : LongBool);
begin
  lv_page_set_scroll_propagation(list, en);
end;

procedure lv_list_set_edge_flash(list : Plv_obj; en : LongBool);
begin
  lv_page_set_edge_flash (list, en);
end;

procedure lv_list_set_anim_time(list : Plv_obj; anim_time : Tuint16);
begin
  lv_page_set_anim_time (list, anim_time);
end;

function lv_list_get_scrollbar_mode (const list : Plv_obj) : Tlv_scrollbar_mode;
begin
  Result := lv_page_get_scrollbar_mode (list);
end;

function lv_list_get_scroll_propagation(list : Plv_obj) : LongBool;
begin
  Result := lv_page_get_scroll_propagation (list);
end;

function lv_list_get_edge_flash (list : Plv_obj) : LongBool;
begin
  Result := lv_page_get_edge_flash (list);
end;

function lv_list_get_anim_time (const list : Plv_obj) : Tuint16;
begin
  Result := lv_page_get_anim_time (list);
end;

procedure lv_checkbox_set_checked (cb : Plv_obj; checked : LongBool);
begin
  if checked then
    lv_btn_set_state (cb, LV_BTN_STATE_CHECKED_RELEASED)
  else
    lv_btn_set_state (cb, LV_BTN_STATE_RELEASED);
end;
procedure lv_checkbox_set_disabled (cb : Plv_obj);
begin
  lv_btn_set_state (cb, LV_BTN_STATE_DISABLED);
end;
procedure lv_checkbox_set_state (cb : Plv_obj; state : Tlv_btn_state);
begin
  lv_btn_set_state (cb, state);
end;
function lv_checkbox_is_checked (const cb : Plv_obj) : LongBool;
begin
  if lv_btn_get_state (cb) = LV_BTN_STATE_RELEASED then
    Result := false
  else
    Result := true;
end;
function lv_checkbox_is_inactive (const cb : Plv_obj) : LongBool;
begin
  if  lv_btn_get_state (cb) = LV_BTN_STATE_DISABLED then
    Result := true
  else
    Result := false;
end;
function lv_checkbox_get_state (const cb : Plv_obj) : Tlv_btn_state;
begin
  Result := lv_btn_get_state (cb);
end;


end.

