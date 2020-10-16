program LVGLDemo2;

{$mode objfpc}{$H+}
{
     Ultibo Demo Program for LVGL
     pjde 2020

     MIT licence
     LVGL Copyright (c) 2016 Gábor Kiss-Vámosi
     For licencing aggreement refer uLVGL.pas
}

uses
  InitUnit, RaspberryPi3, GlobalConst, GlobalTypes, GlobalConfig, Platform,
  SysUtils, Threads, Mouse, Framebuffer, uTFTP, SysCalls,
  Winsock2, ulvgl;

{$linklib lvgl}
{$hints off}
{$notes off}

var
  FramebufferDevice : PFramebufferDevice;
  FramebufferProperties : TFramebufferProperties;
  x : integer;
  IPAddress : string;
  tabview, tab1, tab2, tab3 : Plv_obj;
  cursor : Plv_obj;
  b, l, c, g, s : Plv_obj;
  s1, s2 : Plv_chart_series;

  tv, t1, t2, t3, kb : Plv_obj;
  style_box : Tlv_style;

  fl : Plv_obj;
  needle_colors : array [0..2] of Tlv_color;

  MouseHandle : TThreadHandle;
  TickHandle : TThreadHandle;

  ScreenWidth : LongWord;
  ScreenHeight : LongWord;
  VideoBuffer : pointer;

  MouseCX : integer = 0;
  MouseCY : integer = 0;
  MouseBt : integer = 0;

  disp_buf : Tlv_disp_buf;
	disp_drv : Tlv_disp_drv;
  indev_drv : Tlv_indev_drv;
  mouse_indev : Plv_indev;
  buf : pointer;

procedure my_print_cb (level : Tlv_log_level; fb : PChar; ln : Tuint32; desc : PChar); cdecl; export;
begin
//
end;


procedure slider_event_cb (slider : Plv_obj; e : Tlv_event); cdecl;
var
  s : string;
begin
  if e = LV_EVENT_VALUE_CHANGED then
    begin
      if lv_slider_get_type (slider) = LV_SLIDER_TYPE_NORMAL then
        begin
          s := format ('%d', [lv_slider_get_value (slider)]);
          lv_obj_set_style_local_value_str (slider, LV_SLIDER_PART_KNOB, LV_STATE_DEFAULT, PChar (s));
        end
      else
        begin
          s := format ('%d-%d', [lv_slider_get_left_value (slider), lv_slider_get_value (slider)]);
          lv_obj_set_style_local_value_str (slider, LV_SLIDER_PART_INDIC, LV_STATE_DEFAULT, PChar (s));
        end;
    end;
end;

procedure ultibo_fbddev_flush (drv : Plv_disp_drv; const area : Plv_area; color_p : Plv_color); cdecl;
var
  act_x1, act_x2, act_y1, act_y2 : integer;
  y : integer;
  s, d : PCardinal;
begin
  if area^.x1 < 0 then act_x1 := 0 else act_x1 := area^.x1;
  if area^.y1 < 0 then act_y1 := 0 else act_y1 := area^.y1;
  if area^.x2 > ScreenWidth - 1 then act_x2 := ScreenWidth - 1 else act_x2 := area^.x2;
  if area^.y2 > ScreenHeight - 1 then act_y2 := ScreenHeight - 1 else act_y2 := area^.y2;
  s := pointer (color_p);
	for y := act_y1 to act_y2 do
	  begin
		  cardinal (d) := cardinal (VideoBuffer) + (act_x1 + y * ScreenWidth) * 4;
      move (s^, d^, (act_x2 + 1 - act_x1) * 4);
      inc (s, (act_x2 + 1 - act_x1));
    end;
  lv_disp_flush_ready (drv);
end;

function input_read (drv : Plv_indev_drv; data : Plv_indev_data) : LongBool; cdecl;
begin
  if MouseBt > 0 then
    data^.state := LV_INDEV_STATE_PR
  else
    data^.state := LV_INDEV_STATE_REL;
  data^.point.x := MouseCX;
	data^.point.y := MouseCY;
	Result := false; // Return `false` because we are not buffering and no more data to read
end;

function WaitForIPComplete : string;
var
  TCP : TWinsock2TCPClient;
begin
  TCP := TWinsock2TCPClient.Create;
  Result := TCP.LocalAddress;
  if (Result = '') or (Result = '0.0.0.0') or (Result = '255.255.255.255') then
    begin
      while (Result = '') or (Result = '0.0.0.0') or (Result = '255.255.255.255') do
        begin
          sleep (1000);
          Result := TCP.LocalAddress;
        end;
    end;
  TCP.Free;
end;


function MouseThread (Parameter : Pointer) : PtrInt;
var
  MouseData : TMouseData;
  Count : LongWord;
  ScalingX : Double;
  ScalingY : Double;
begin
  while True do
    begin
      if MouseRead (@MouseData, SizeOf (TMouseData), Count) = ERROR_SUCCESS then
        begin
          if MouseData.Buttons = 0 then
            MouseBt := 0
          else
            begin
              if (MouseData.Buttons and (MOUSE_LEFT_BUTTON or MOUSE_RIGHT_BUTTON)) = (MOUSE_LEFT_BUTTON or MOUSE_RIGHT_BUTTON) then
                MouseBt := 3
              else if (MouseData.Buttons and MOUSE_LEFT_BUTTON) = MOUSE_LEFT_BUTTON then
                MouseBt := 1
              else if (MouseData.Buttons and MOUSE_RIGHT_BUTTON) = MOUSE_RIGHT_BUTTON then
                MouseBt := 2
              else
                MouseBt := 4;
            end;
          Result := 1;
        end;
      if (MouseData.Buttons and MOUSE_ABSOLUTE_X) = MOUSE_ABSOLUTE_X then
        begin
          ScalingX := MouseData.MaximumX / ScreenWidth;
          if ScalingX <= 0 then ScalingX := 1.0;
          MouseCX := Trunc (MouseData.OffsetX / ScalingX);
        end
      else
        MouseCX := MouseCX + MouseData.OffsetX;
      if MouseCX < 0 then MouseCX := 0;
      if MouseCX > (ScreenWidth - 1) then MouseCX := ScreenWidth - 1;

      {Check if the Y value is absolute}
      if (MouseData.Buttons and MOUSE_ABSOLUTE_Y) = MOUSE_ABSOLUTE_Y then
        begin
          {Use maximum Y to scale the Y value to the screen}
          ScalingY := MouseData.MaximumY / ScreenHeight;
          if ScalingY <= 0 then ScalingY := 1.0;
          MouseCY := Trunc (MouseData.OffsetY / ScalingY);
        end
      else
        MouseCY := mouseCY + MouseData.OffsetY;
      if MouseCY < 0 then MouseCY := 0;
      if MouseCY > (ScreenHeight - 1) then MouseCY := ScreenHeight - 1;
    end;
end;

function TickThread (Parameter : Pointer) : PtrInt;
begin
  while true do
    begin
      usleep (5000);
      lv_tick_inc (5);      	// Tell LVGL that 5 milliseconds has elapsed
	  end;
  Result := 0;
end;

procedure TFTPMsgs (Sender : TObject; s : string);
begin
  if Assigned (fl) then
    lv_label_set_text (fl, PChar (s));
end;

procedure controls_create (parent : Plv_obj);
var
  h, btn, lbl, ta, slider : Plv_obj;
  disp_size : Tlv_disp_size;
  grid_w, fit_w : Tlv_coord;
begin
  lv_page_set_scrl_layout (parent, LV_LAYOUT_PRETTY_TOP);

  disp_size := lv_disp_get_size_category (nil);
  if disp_size <= LV_DISP_SIZE_SMALL then
    grid_w := lv_page_get_width_grid (parent, 2, 1)
  else
    grid_w := lv_page_get_width_grid (parent, 1, 1);

(*

#if LV_DEMO_WIDGETS_SLIDESHOW == 0
    static const char * btns[] = {"Cancel", "Ok", ""};

    lv_obj_t * m = lv_msgbox_create(lv_scr_act(), NULL);
    lv_msgbox_add_btns(m, btns);
    lv_obj_t * btnm = lv_msgbox_get_btnmatrix(m);
    lv_btnmatrix_set_btn_ctrl(btnm, 1, LV_BTNMATRIX_CTRL_CHECK_STATE);
#endif
  *)

    h := lv_cont_create (parent, nil);
    lv_cont_set_layout (h, LV_LAYOUT_PRETTY_MID);
    lv_obj_add_style (h, LV_CONT_PART_MAIN, @style_box);
    lv_obj_set_drag_parent (h, true);

//    lv_obj_set_style_local_value_str (h, LV_CONT_PART_MAIN, LV_STATE_DEFAULT, 'Basics');

    lv_cont_set_fit2 (h, LV_FIT_NONE, LV_FIT_TIGHT);
    lv_obj_set_width (h, grid_w);
    btn := lv_btn_create (h, nil);
    lv_btn_set_fit2 (btn, LV_FIT_NONE, LV_FIT_TIGHT);
    if disp_size <= LV_DISP_SIZE_SMALL then
      lv_obj_set_width (btn, lv_obj_get_width_grid (h, 1, 1))
    else
      lv_obj_set_width (btn, lv_obj_get_width_grid (h, 2, 1));
    lbl := lv_label_create (btn, nil);
    lv_label_set_text (lbl, 'Button');

    btn := lv_btn_create(h, btn);
    lv_btn_toggle (btn);
    lbl := lv_label_create (btn, nil);
    lv_label_set_text (lbl, 'Button');

    lv_switch_create (h, nil);

    lv_checkbox_create (h, nil);

    fit_w := lv_obj_get_width_fit (h);

    slider := lv_slider_create (h, nil);
    lv_slider_set_value (slider, 40, LV_ANIM_OFF);
    lv_obj_set_event_cb (slider, @slider_event_cb);
    lv_obj_set_width_margin (slider, fit_w);

    // Use the knobs style value the display the current value in focused state
    lv_obj_set_style_local_margin_top (slider, LV_SLIDER_PART_BG, LV_STATE_DEFAULT, LV_DPX (25));
    lv_obj_set_style_local_value_font (slider, LV_SLIDER_PART_KNOB, LV_STATE_DEFAULT, lv_theme_get_font_small());
    lv_obj_set_style_local_value_ofs_y (slider, LV_SLIDER_PART_KNOB, LV_STATE_FOCUSED, - LV_DPX (25));
    lv_obj_set_style_local_value_opa (slider, LV_SLIDER_PART_KNOB, LV_STATE_DEFAULT, LV_OPA_TRANSP);
    lv_obj_set_style_local_value_opa (slider, LV_SLIDER_PART_KNOB, LV_STATE_FOCUSED, LV_OPA_COVER);
    lv_obj_set_style_local_transition_time (slider, LV_SLIDER_PART_KNOB, LV_STATE_DEFAULT, 300);
    lv_obj_set_style_local_transition_prop_5 (slider, LV_SLIDER_PART_KNOB, LV_STATE_DEFAULT, LV_STYLE_VALUE_OFS_Y);
    lv_obj_set_style_local_transition_prop_6 (slider, LV_SLIDER_PART_KNOB, LV_STATE_DEFAULT, LV_STYLE_VALUE_OPA);


    slider := lv_slider_create (h, slider);
    lv_slider_set_type (slider, LV_SLIDER_TYPE_RANGE);
    lv_slider_set_value (slider, 70, LV_ANIM_OFF);
    lv_slider_set_left_value (slider, 30, LV_ANIM_OFF);
    lv_obj_set_style_local_value_ofs_y (slider, LV_SLIDER_PART_INDIC, LV_STATE_DEFAULT, - LV_DPX(25));
    lv_obj_set_style_local_value_font (slider, LV_SLIDER_PART_INDIC, LV_STATE_DEFAULT, lv_theme_get_font_small());
    lv_obj_set_style_local_value_opa (slider, LV_SLIDER_PART_INDIC, LV_STATE_DEFAULT, LV_OPA_COVER);
    lv_obj_set_event_cb (slider, @slider_event_cb);
    lv_event_send (slider, LV_EVENT_VALUE_CHANGED, nil);      // refresh the text
    if lv_obj_get_width(slider) > fit_w then
      lv_obj_set_width (slider, fit_w);

    h := lv_cont_create (parent, h);
    lv_cont_set_fit (h, LV_FIT_NONE);
    lv_obj_set_style_local_value_str (h, LV_CONT_PART_MAIN, LV_STATE_DEFAULT, 'Text input');

    ta := lv_textarea_create (h, nil);
    lv_cont_set_fit2 (ta, LV_FIT_PARENT, LV_FIT_NONE);
    lv_textarea_set_text (ta, '');
    lv_textarea_set_placeholder_text (ta, 'E-mail address');
    lv_textarea_set_one_line (ta, true);
    lv_textarea_set_cursor_hidden (ta, true);
//    lv_obj_set_event_cb (ta, ta_event_cb);

    ta := lv_textarea_create (h, ta);
    lv_textarea_set_pwd_mode (ta, true);
    lv_textarea_set_placeholder_text (ta, 'Password');

    ta := lv_textarea_create (h, nil);
    lv_cont_set_fit2 (ta, LV_FIT_PARENT, LV_FIT_NONE);
    lv_textarea_set_text (ta, '');
    lv_textarea_set_placeholder_text (ta, 'Message');
    lv_textarea_set_cursor_hidden (ta, true);
//    lv_obj_set_event_cb (ta, ta_event_cb);
    lv_cont_set_fit4 (ta, LV_FIT_PARENT, LV_FIT_PARENT, LV_FIT_NONE, LV_FIT_PARENT);
end;

procedure visuals_create (parent : Plv_obj);
var
  disp_size : Tlv_disp_size;
  grid_h_chart, grid_w_chart : Tlv_coord;
  grid_w_meter, meter_h, meter_size, led_size : Tlv_coord;
  chart, chart2, led_h, bar, lmeter, lbl, gauge, arc, bar_h, led : Plv_obj;
  s1, s2 : Plv_chart_series;
begin
  lv_page_set_scrl_layout (parent, LV_LAYOUT_PRETTY_TOP);

  disp_size := lv_disp_get_size_category (nil);

  grid_h_chart := lv_page_get_height_grid (parent, 1, 1);
  if disp_size <= LV_DISP_SIZE_LARGE then
    grid_w_chart := lv_page_get_width_grid (parent, 1, 1)
  else
    grid_w_chart := lv_page_get_width_grid (parent, 2, 1);

  chart := lv_chart_create (parent, nil);
  lv_obj_add_style (chart, LV_CHART_PART_BG, @style_box);
//  if disp_size <= LV_DISP_SIZE_SMALL then
//    lv_obj_set_style_local_text_font (chart, LV_CHART_PART_SERIES_BG, LV_STATE_DEFAULT, lv_theme_get_font_small());

  lv_obj_set_drag_parent (chart, true);
//  lv_obj_set_style_local_value_str (chart, LV_CONT_PART_MAIN, LV_STATE_DEFAULT, 'Line chart');
  lv_obj_set_width_margin (chart, grid_w_chart);
  lv_obj_set_height_margin (chart, grid_h_chart);
  lv_chart_set_div_line_count (chart, 3, 0);
  lv_chart_set_point_count (chart, 8);
  lv_chart_set_type (chart, LV_CHART_TYPE_LINE);
  if disp_size > LV_DISP_SIZE_SMALL then
    begin
      lv_obj_set_style_local_pad_left (chart, LV_CHART_PART_BG, LV_STATE_DEFAULT, 4 * (LV_DPI div 10));
      lv_obj_set_style_local_pad_bottom (chart, LV_CHART_PART_BG, LV_STATE_DEFAULT, 3 * (LV_DPI div 10));
      lv_obj_set_style_local_pad_right (chart, LV_CHART_PART_BG, LV_STATE_DEFAULT, 2 * (LV_DPI div 10));
      lv_obj_set_style_local_pad_top (chart, LV_CHART_PART_BG, LV_STATE_DEFAULT, 2 * (LV_DPI div 10));
      lv_chart_set_y_tick_length (chart, 0, 0);
      lv_chart_set_x_tick_length (chart, 0, 0);
//      lv_chart_set_y_tick_texts (chart, '600\n500\n400\n300\n200', 0, LV_CHART_AXIS_DRAW_LAST_TICK);
//      lv_chart_set_x_tick_texts (chart, 'Jan\nFeb\nMar\nApr\nMay\nJun\nJul\nAug', 0, LV_CHART_AXIS_DRAW_LAST_TICK);
    end;
  s1 := lv_chart_add_series (chart, LV_THEME_DEFAULT_COLOR_PRIMARY);
  s2 := lv_chart_add_series (chart, LV_THEME_DEFAULT_COLOR_SECONDARY);

  lv_chart_set_next (chart, s1, 10);
  lv_chart_set_next (chart, s1, 90);
  lv_chart_set_next (chart, s1, 30);
  lv_chart_set_next (chart, s1, 60);
  lv_chart_set_next (chart, s1, 10);
  lv_chart_set_next (chart, s1, 90);
  lv_chart_set_next (chart, s1, 30);
  lv_chart_set_next (chart, s1, 60);
  lv_chart_set_next (chart, s1, 10);
  lv_chart_set_next (chart, s1, 90);

  lv_chart_set_next (chart, s2, 32);
  lv_chart_set_next (chart, s2, 66);
  lv_chart_set_next (chart, s2, 5);
  lv_chart_set_next (chart, s2, 47);
  lv_chart_set_next (chart, s2, 32);
  lv_chart_set_next (chart, s2, 32);
  lv_chart_set_next (chart, s2, 66);
  lv_chart_set_next (chart, s2, 5);
  lv_chart_set_next (chart, s2, 47);
  lv_chart_set_next (chart, s2, 66);
  lv_chart_set_next (chart, s2, 5);
  lv_chart_set_next (chart, s2, 47);

  chart2 := lv_chart_create (parent, chart);
  lv_chart_set_type (chart2, LV_CHART_TYPE_COLUMN);
  lv_obj_set_style_local_value_str (chart2, LV_CONT_PART_MAIN, LV_STATE_DEFAULT, 'Column chart');

  s1 := lv_chart_add_series (chart2, LV_THEME_DEFAULT_COLOR_PRIMARY);
  s2 := lv_chart_add_series (chart2, LV_THEME_DEFAULT_COLOR_SECONDARY);

  lv_chart_set_next (chart2, s1, 10);
  lv_chart_set_next (chart2, s1, 90);
  lv_chart_set_next (chart2, s1, 30);
  lv_chart_set_next (chart2, s1, 60);
  lv_chart_set_next (chart2, s1, 10);
  lv_chart_set_next (chart2, s1, 90);
  lv_chart_set_next (chart2, s1, 30);
  lv_chart_set_next (chart2, s1, 60);
  lv_chart_set_next (chart2, s1, 10);
  lv_chart_set_next (chart2, s1, 90);

  lv_chart_set_next (chart2, s2, 32);
  lv_chart_set_next (chart2, s2, 66);
  lv_chart_set_next (chart2, s2, 5);
  lv_chart_set_next (chart2, s2, 47);
  lv_chart_set_next (chart2, s2, 32);
  lv_chart_set_next (chart2, s2, 32);
  lv_chart_set_next (chart2, s2, 66);
  lv_chart_set_next (chart2, s2, 5);
  lv_chart_set_next (chart2, s2, 47);
  lv_chart_set_next (chart2, s2, 66);
  lv_chart_set_next (chart2, s2, 5);
  lv_chart_set_next (chart2, s2, 47);

  if disp_size <= LV_DISP_SIZE_SMALL then
    grid_w_meter := lv_page_get_width_grid (parent, 1, 1)
  else if disp_size <= LV_DISP_SIZE_MEDIUM then
    grid_w_meter := lv_page_get_width_grid (parent, 2, 1)
  else
    grid_w_meter := lv_page_get_width_grid (parent, 3, 1);

  meter_h := lv_page_get_height_fit (parent);
  meter_size := min (grid_w_meter, meter_h);

  lmeter := lv_linemeter_create (parent, nil);
  lv_obj_set_drag_parent (lmeter, true);
  lv_linemeter_set_value (lmeter, 50);
  lv_obj_set_size (lmeter, meter_size, meter_size);
  lv_obj_add_style (lmeter, LV_LINEMETER_PART_MAIN, @style_box);
  lv_obj_set_style_local_value_str (lmeter, LV_LINEMETER_PART_MAIN, LV_STATE_DEFAULT, 'Line meter');

  lbl := lv_label_create (lmeter, nil);
  lv_obj_align (lbl, lmeter, LV_ALIGN_CENTER, 0, 0);
  lv_obj_set_style_local_text_font (lbl, LV_LABEL_PART_MAIN, LV_STATE_DEFAULT, lv_theme_get_font_title);

(*    lv_anim_t a;
  lv_anim_init (@a);
  lv_anim_set_var (@a, lmeter);
  lv_anim_set_exec_cb (@a, (lv_anim_exec_xcb_t)linemeter_anim);
  lv_anim_set_values (@a, 0, 100);
  lv_anim_set_time (@a, 4000);
  lv_anim_set_playback_time (@a, 1000);
  lv_anim_set_repeat_count (@a, LV_ANIM_REPEAT_INFINITE);
  lv_anim_start (@a);  *)

  gauge := lv_gauge_create (parent, nil);
  lv_obj_set_drag_parent (gauge, true);
  lv_obj_set_size (gauge, meter_size, meter_size);
  lv_obj_add_style (gauge, LV_GAUGE_PART_MAIN, @style_box);
  lv_obj_set_style_local_value_str (gauge, LV_GAUGE_PART_MAIN, LV_STATE_DEFAULT, 'Gauge');

  lbl := lv_label_create (gauge, lbl);
  lv_obj_align (lbl, gauge, LV_ALIGN_CENTER, 0, grid_w_meter div 3);

  (*
  lv_anim_set_var (@a, gauge);
  lv_anim_set_exec_cb (@a, (lv_anim_exec_xcb_t)gauge_anim);
  lv_anim_start (@a);
    *)

  arc := lv_arc_create (parent, nil);
  lv_obj_set_drag_parent (arc, true);
  lv_arc_set_bg_angles (arc, 0, 360);
  lv_arc_set_rotation (arc, 270);
  lv_arc_set_angles (arc, 0, 0);
  lv_obj_set_size (arc,  meter_size, meter_size);
  lv_obj_add_style (arc, LV_ARC_PART_BG, @style_box);
  lv_obj_set_style_local_value_str (arc, LV_ARC_PART_BG, LV_STATE_DEFAULT, 'Arc');

  lbl := lv_label_create (arc, lbl);
  lv_obj_align (lbl, arc, LV_ALIGN_CENTER, 0, 0);

  (*
  lv_anim_set_var (@a, arc);
  lv_anim_set_exec_cb (@a, (lv_anim_exec_xcb_t)arc_anim);
  lv_anim_set_values (@a, 0, 360);
  lv_anim_set_repeat_count (@a, LV_ANIM_REPEAT_INFINITE);
  lv_anim_start (@a);  *)

  // Create a bar and use the backgrounds value style property to display the current value
  bar_h := lv_cont_create (parent, nil);
  lv_cont_set_fit2 (bar_h, LV_FIT_NONE, LV_FIT_TIGHT);
  lv_obj_add_style (bar_h, LV_CONT_PART_MAIN, @style_box);
  lv_obj_set_style_local_value_str (bar_h, LV_CONT_PART_MAIN, LV_STATE_DEFAULT, 'Bar');

  if disp_size <= LV_DISP_SIZE_SMALL then
    lv_obj_set_width (bar_h, lv_page_get_width_grid (parent, 1, 1))
  else if disp_size <= LV_DISP_SIZE_MEDIUM then
    lv_obj_set_width (bar_h, lv_page_get_width_grid (parent, 2, 1))
  else
    lv_obj_set_width (bar_h, lv_page_get_width_grid (parent, 3, 2));

  bar := lv_bar_create (bar_h, nil);
  lv_obj_set_width (bar, lv_obj_get_width_fit (bar_h));
  lv_obj_set_style_local_value_font (bar, LV_BAR_PART_BG, LV_STATE_DEFAULT, lv_theme_get_font_small);
  lv_obj_set_style_local_value_align (bar, LV_BAR_PART_BG, LV_STATE_DEFAULT, LV_ALIGN_OUT_BOTTOM_MID);
  lv_obj_set_style_local_value_ofs_y (bar, LV_BAR_PART_BG, LV_STATE_DEFAULT, LV_DPI div 20);
  lv_obj_set_style_local_margin_bottom (bar, LV_BAR_PART_BG, LV_STATE_DEFAULT, LV_DPI div 7);
  lv_obj_align (bar, nil, LV_ALIGN_CENTER, 0, 0);

  led_h := lv_cont_create (parent, nil);
  lv_cont_set_layout(led_h, LV_LAYOUT_PRETTY_MID);
  if disp_size <= LV_DISP_SIZE_SMALL then
    lv_obj_set_width (led_h, lv_page_get_width_grid (parent, 1, 1))
  else if disp_size <= LV_DISP_SIZE_MEDIUM then
    lv_obj_set_width (led_h, lv_page_get_width_grid (parent, 2, 1))
  else
    lv_obj_set_width (led_h, lv_page_get_width_grid (parent, 3, 1));

  lv_obj_set_height (led_h, lv_obj_get_height (bar_h));
  lv_obj_add_style (led_h, LV_CONT_PART_MAIN, @style_box);
  lv_obj_set_drag_parent (led_h, true);
  lv_obj_set_style_local_value_str (led_h, LV_CONT_PART_MAIN, LV_STATE_DEFAULT, 'LEDs');

  led := lv_led_create (led_h, nil);
  led_size := lv_obj_get_height_fit (led_h);
  lv_obj_set_size (led, led_size, led_size);
  lv_led_off (led);

  led := lv_led_create (led_h, led);
  lv_led_set_bright (led, (LV_LED_BRIGHT_MAX - LV_LED_BRIGHT_MIN) div 2 + LV_LED_BRIGHT_MIN);

  led := lv_led_create (led_h, led);
  lv_led_on (led);

  if disp_size = LV_DISP_SIZE_MEDIUM then
    begin
      lv_obj_add_protect (led_h, LV_PROTECT_POS);
      lv_obj_align (led_h, bar_h, LV_ALIGN_OUT_BOTTOM_MID, 0, lv_obj_get_style_margin_top (led_h, LV_OBJ_PART_MAIN) + lv_obj_get_style_pad_inner(parent, LV_PAGE_PART_SCROLLABLE));
    end;


//  lv_task_create (bar_anim, 100, LV_TASK_PRIO_LOW, bar);
end;

procedure selectors_create (parent :  Plv_obj);
var
  grid_w, grid_h : Tlv_coord;
  table_w_max : Tlv_coord;
  cal, btnm, h, roller, dd, page, list : Plv_obj;
  i : cardinal;
  table1 : Plv_obj;
  style_cell4 : Tlv_style;
  disp_size : Tlv_disp_size;
begin
  lv_page_set_scrl_layout (parent, LV_LAYOUT_PRETTY_MID);

  disp_size := lv_disp_get_size_category (nil);
  grid_h := lv_page_get_height_grid (parent, 1, 1);

  if disp_size <= LV_DISP_SIZE_SMALL then
    grid_w := lv_page_get_width_grid (parent, 1, 1)
  else
    grid_w := lv_page_get_width_grid (parent, 2, 1);

  cal := lv_calendar_create (parent, nil);
  lv_obj_set_drag_parent (cal, true);
  if disp_size > LV_DISP_SIZE_MEDIUM then
    lv_obj_set_size (cal, min (grid_h, grid_w), min (grid_h, grid_w))
  else
    begin
      lv_obj_set_size (cal, grid_w, grid_w);
      if disp_size <= LV_DISP_SIZE_SMALL then
        lv_obj_set_style_local_text_font (cal, LV_CALENDAR_PART_BG, LV_STATE_DEFAULT, lv_theme_get_font_small());
    end;

(*    static lv_calendar_date_t hl[] = {
            {.year = 2020, .month = 1, .day = 5},
            {.year = 2020, .month = 1, .day = 9},
    };

  *)
    h := lv_cont_create (parent, nil);
    lv_obj_set_drag_parent (h, true);
    if disp_size <= LV_DISP_SIZE_SMALL then
      begin
        lv_cont_set_fit2 (h, LV_FIT_NONE, LV_FIT_TIGHT);
        lv_obj_set_width (h, lv_page_get_width_fit (parent));
        lv_cont_set_layout (h, LV_LAYOUT_COLUMN_MID);
      end
    else if disp_size <= LV_DISP_SIZE_MEDIUM then
      begin
        lv_obj_set_size (h, lv_obj_get_width (cal), lv_obj_get_height (cal));
        lv_cont_set_layout (h, LV_LAYOUT_PRETTY_TOP);
      end
    else
      begin
        lv_obj_set_click (h, false);
        lv_obj_set_style_local_bg_opa (h, LV_CONT_PART_MAIN, LV_STATE_DEFAULT, LV_OPA_TRANSP);
        lv_obj_set_style_local_border_opa (h, LV_CONT_PART_MAIN, LV_STATE_DEFAULT, LV_OPA_TRANSP);
        lv_obj_set_style_local_pad_left (h, LV_CONT_PART_MAIN, LV_STATE_DEFAULT, 0);
        lv_obj_set_style_local_pad_right (h, LV_CONT_PART_MAIN, LV_STATE_DEFAULT, 0);
        lv_obj_set_style_local_pad_top (h, LV_CONT_PART_MAIN, LV_STATE_DEFAULT, 0);
        lv_obj_set_size (h, min (grid_h, grid_w), min (grid_h, grid_w));
        lv_cont_set_layout (h, LV_LAYOUT_PRETTY_TOP);
      end;

    roller := lv_roller_create (h, nil);
    lv_obj_add_style (roller, LV_CONT_PART_MAIN, @style_box);
    lv_obj_set_style_local_value_str (roller, LV_CONT_PART_MAIN, LV_STATE_DEFAULT, 'Roller');
    lv_roller_set_auto_fit (roller, false);
    lv_roller_set_align (roller, LV_LABEL_ALIGN_CENTER);
    lv_roller_set_visible_row_count (roller, 4);
    if disp_size <= LV_DISP_SIZE_SMALL then
       lv_obj_set_width (roller, lv_obj_get_width_grid (h, 1, 1))
    else
       lv_obj_set_width (roller, lv_obj_get_width_grid (h, 2, 1));
    dd := lv_dropdown_create (h, nil);
    lv_obj_add_style(dd, LV_CONT_PART_MAIN, @style_box);
    lv_obj_set_style_local_value_str (dd, LV_CONT_PART_MAIN, LV_STATE_DEFAULT, 'Dropdown');
    if disp_size <= LV_DISP_SIZE_SMALL then
      lv_obj_set_width (dd, lv_obj_get_width_grid (h,  1, 1))
    else
      lv_obj_set_width (dd, lv_obj_get_width_grid (h,  2, 1));

    lv_dropdown_set_options (dd, 'Alpha'#10'Bravo'#10'Charlie'#10'Delta'#10'Echo'#10'Foxtrot'#10'Golf'#10'Hotel'#10'India'#10'Juliette'#10'Kilo'#10'Lima'#10'Mike'#10'November'#10 +
            'Oscar'#10'Papa'#10'Quebec'#10'Romeo'#10'Sierra'#10'Tango'#10'Uniform'#10'Victor'#10'Whiskey'#10'Xray'#10'Yankee'#10'Zulu');

    list := lv_list_create (parent, nil);
    lv_list_set_scroll_propagation (list, true);
    lv_obj_set_size (list, grid_w, grid_h);

    (*

    const char * txts[] = {LV_SYMBOL_SAVE, "Save", LV_SYMBOL_CUT, "Cut", LV_SYMBOL_COPY, "Copy",
            LV_SYMBOL_OK, "This is a quite long text to scroll on the list", LV_SYMBOL_EDIT, "Edit", LV_SYMBOL_WIFI, "Wifi",
            LV_SYMBOL_BLUETOOTH, "Bluetooth",  LV_SYMBOL_GPS, "GPS", LV_SYMBOL_USB, "USB",
            LV_SYMBOL_SD_CARD, "SD card", LV_SYMBOL_CLOSE, "Close", NULL};


    for(i = 0; txts[i] != NULL; i += 2) {
        btn = lv_list_add_btn(list, txts[i], txts[i + 1]);
        lv_btn_set_checkable(btn, true);

        /*Make a button disabled*/
        if(i == 4) {
            lv_btn_set_state(btn, LV_BTN_STATE_DISABLED);
        }
    } *)

  //  lv_calendar_set_highlighted_dates (cal, hl, 2);



    lv_style_init (@style_cell4);
    lv_style_set_bg_opa (@style_cell4, LV_STATE_DEFAULT, LV_OPA_50);
    lv_style_set_bg_color (@style_cell4, LV_STATE_DEFAULT, LV_COLOR_GRAY);

    page := lv_page_create (parent, nil);
    lv_obj_set_size (page, grid_w, grid_h);
    table_w_max := lv_page_get_width_fit (page);
    lv_page_set_scroll_propagation (page, true);

    table1 := lv_table_create (page, nil);
    lv_obj_add_style (table1, LV_TABLE_PART_CELL4, @style_cell4);
    // Clean the background style of the table because it is placed on a page
    lv_obj_clean_style_list (table1, LV_TABLE_PART_BG);
    lv_obj_set_drag_parent (table1, true);
//    lv_obj_set_event_cb (table1, table_event_cb);
    if disp_size > LV_DISP_SIZE_SMALL then
      lv_table_set_col_cnt (table1, 3)
    else
      lv_table_set_col_cnt (table1, 2);
    if disp_size > LV_DISP_SIZE_SMALL then
      begin
        lv_table_set_col_width (table1, 0, max (30, 1 * table_w_max div 5));
        lv_table_set_col_width (table1, 1, max (60, 2 * table_w_max div 5));
        lv_table_set_col_width (table1, 2, max (60, 2 * table_w_max div 5));
      end
    else
      begin
        lv_table_set_col_width (table1, 0, max (30, 1 * table_w_max div 4 - 1));
        lv_table_set_col_width (table1, 1, max (60, 3 * table_w_max div 4 - 1));
      end;

    lv_table_set_cell_value (table1, 0, 0, '#');
    lv_table_set_cell_value (table1, 1, 0, '1');
    lv_table_set_cell_value (table1, 2, 0, '2');
    lv_table_set_cell_value (table1, 3, 0, '3');
    lv_table_set_cell_value (table1, 4, 0, '4');
    lv_table_set_cell_value (table1, 5, 0, '5');
    lv_table_set_cell_value (table1, 6, 0, '6');

    lv_table_set_cell_value (table1, 0, 1, 'NAME');
    lv_table_set_cell_value (table1, 1, 1, 'Mark');
    lv_table_set_cell_value (table1, 2, 1, 'Jacob');
    lv_table_set_cell_value (table1, 3, 1, 'John');
    lv_table_set_cell_value (table1, 4, 1, 'Emily');
    lv_table_set_cell_value (table1, 5, 1, 'Ivan');
    lv_table_set_cell_value (table1, 6, 1, 'George');

    if disp_size > LV_DISP_SIZE_SMALL then
      begin
        lv_table_set_cell_value (table1, 0, 2, 'CITY');
        lv_table_set_cell_value (table1, 1, 2, 'Moscow');
        lv_table_set_cell_value (table1, 2, 2, 'New York');
        lv_table_set_cell_value (table1, 3, 2, 'Oslo');
        lv_table_set_cell_value (table1, 4, 2, 'London');
        lv_table_set_cell_value (table1, 5, 2, 'Texas');
        lv_table_set_cell_value (table1, 6, 2, 'Athen');
      end;
end;

procedure lv_demo_widgets;
var
    disp_size : Tlv_disp_size;

begin
    tv := lv_tabview_create (lv_scr_act, nil);

          (*
    #if LV_USE_THEME_MATERIAL
    if LV_THEME_DEFAULT_INIT = lv_theme_material_init then
      begin
        lv_disp_size_t disp_size = lv_disp_get_size_category (nil);
        if(disp_size >= LV_DISP_SIZE_MEDIUM) then
          begin
            lv_obj_set_style_local_pad_left(tv, LV_TABVIEW_PART_TAB_BG, LV_STATE_DEFAULT, LV_HOR_RES / 2);
            lv_obj_t * sw = lv_switch_create(lv_scr_act(), NULL);
            if(lv_theme_get_flags() & LV_THEME_MATERIAL_FLAG_DARK)
                lv_switch_on(sw, LV_ANIM_OFF);
            lv_obj_set_event_cb(sw, color_chg_event_cb);
            lv_obj_set_pos(sw, LV_DPX(10), LV_DPX(10));
            lv_obj_set_style_local_value_str(sw, LV_SWITCH_PART_BG, LV_STATE_DEFAULT, "Dark");
            lv_obj_set_style_local_value_align(sw, LV_SWITCH_PART_BG, LV_STATE_DEFAULT, LV_ALIGN_OUT_RIGHT_MID);
            lv_obj_set_style_local_value_ofs_x(sw, LV_SWITCH_PART_BG, LV_STATE_DEFAULT, LV_DPI/35);
        end;
        }
      end;
    }
            *)

    t1 := lv_tabview_add_tab (tv, 'Controls');
    t2 := lv_tabview_add_tab (tv, 'Visuals');
    t3 := lv_tabview_add_tab (tv, 'Selectors');
    lv_style_init (@style_box);
    lv_style_set_value_align (@style_box, LV_STATE_DEFAULT, LV_ALIGN_OUT_TOP_LEFT);
    lv_style_set_value_ofs_y (@style_box, LV_STATE_DEFAULT, - LV_DPX (10));
    lv_style_set_margin_top (@style_box, LV_STATE_DEFAULT, LV_DPX (30));
    controls_create (t1);
    visuals_create (t2);
    selectors_create (t3);
end;







begin
  fl := nil;
  FramebufferDevice := FramebufferDeviceGetDefault;
  FramebufferDeviceGetProperties (FramebufferDevice, @FramebufferProperties);
  FramebufferDeviceFillRect (FramebufferDevice, 0, 0, FramebufferProperties.PhysicalWidth,
                            FramebufferProperties.PhysicalHeight, COLOR_BLACK, FRAMEBUFFER_TRANSFER_DMA);
  while not DirectoryExists ('C:\') do Sleep (100);
  IPAddress := WaitForIPComplete;

  ScreenWidth := 800;
  ScreenHeight := 480;
  buf := GetMem (ScreenWidth * ScreenHeight * 4);
  VideoBuffer := GetMem (ScreenWidth * ScreenHeight * 4);

  lv_init;                                                  // initialise lv
  lv_log_register_print_cb (@my_print_cb);                  // set debug print callback
  lv_disp_buf_init (@disp_buf, buf, nil, ScreenWidth * ScreenHeight * 4);
  lv_disp_drv_init (@disp_drv);
  disp_drv.buffer := @disp_buf;
  disp_drv.flush_cb := @ultibo_fbddev_flush;
  lv_disp_drv_register (@disp_drv);
  lv_indev_drv_init (@indev_drv);      // Basic initialization
  indev_drv._type := LV_INDEV_TYPE_POINTER;
  indev_drv.read_cb := @input_read;
  // Register the driver in LVGL and save the created input device object*/
  mouse_indev := lv_indev_drv_register (@indev_drv);
  // Quick cursor
  cursor := lv_label_create (lv_scr_act, nil);
  lv_label_set_text (cursor, '*');
  lv_obj_align (cursor, nil, LV_ALIGN_CENTER, 0, 0);
  lv_indev_set_cursor (mouse_indev, cursor);

  lv_demo_widgets;

  SetOnMsg (@TFTPMsgs);
  BeginThread (@MouseThread, nil, MouseHandle, THREAD_STACK_DEFAULT_SIZE);
  BeginThread (@TickThread, nil, TickHandle, THREAD_STACK_DEFAULT_SIZE);
  while true do
    begin
      lv_task_handler;
      FramebufferDevicePutRect (FramebufferDevice, 0, 0, VideoBuffer, ScreenWidth, ScreenHeight, 0, FRAMEBUFFER_TRANSFER_DMA);
    end;
  ThreadHalt (0);
end.
