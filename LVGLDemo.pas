program LVGLDemo;

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

procedure lv_test (no_ : integer); cdecl; external;

var
  FramebufferDevice : PFramebufferDevice;
  FramebufferProperties : TFramebufferProperties;
  x : integer;
  IPAddress : string;
  tabview, tab1, tab2, tab3 : Plv_obj;
  cursor : Plv_obj;
  b, l, c, g, s : Plv_obj;
  s1, s2 : Plv_chart_series;
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

  // manifest
  tabview := lv_tabview_create (lv_scr_act, nil);
  tab1 := lv_tabview_add_tab (tabview, 'Buttons & Text');
  tab2 := lv_tabview_add_tab (tabview, 'Calendar & Chart');
  tab3 := lv_tabview_add_tab (tabview, 'Sliders & Gauges');
  for x := 0 to 3 do
    begin
      b := lv_btn_create (tab1, nil);                       // Add a button
      lv_obj_set_pos (b, 50 + (x * 200), 10);               // Set its position
      lv_obj_set_size (b, 100, 50);                         // Set its size
      l := lv_label_create (b, nil);
      lv_label_set_text (l, PChar ('Button ' + IntToStr (x + 1)));
    end;

  l := lv_label_create (tab1, nil);                     // Add a label
  lv_obj_set_pos (l, 10, 100);                          // Set its position
  lv_obj_set_size (l, 100, 50);                         // Set its size
  lv_label_set_text (l, 'This is a piece of text');

  c := lv_checkbox_create (tab1, nil);
  lv_obj_set_pos (c, 10, 200);                          // Set its position
  lv_obj_set_size (c, 100, 50);                         // Set its size

  fl := lv_label_create (tab1, nil);                     // Add a label
  lv_obj_set_pos (fl, 10, 400);                          // Set its position
  lv_obj_set_size (fl, 100, 50);                         // Set its size

  c := lv_calendar_create (tab2, nil);
  lv_obj_set_pos (c, 410, 20);                             // Set its position
  lv_obj_set_size (c, 300, 350);                          // Set its size

  c := lv_chart_create (tab2, nil);
  lv_chart_set_type (c, LV_CHART_TYPE_COLUMN);
  lv_obj_set_pos (c, 10, 10);                             // Set its position
  lv_obj_set_size (c, 280, 350);                          // Set its size

  s1 := lv_chart_add_series (c, LV_THEME_DEFAULT_COLOR_PRIMARY);
  s2 := lv_chart_add_series (c, LV_THEME_DEFAULT_COLOR_SECONDARY);
  lv_chart_set_next (c, s1, 10);
  lv_chart_set_next (c, s1, 90);
  lv_chart_set_next (c, s1, 30);
  lv_chart_set_next (c, s1, 60);
  lv_chart_set_next (c, s1, 10);
  lv_chart_set_next (c, s1, 90);
  lv_chart_set_next (c, s1, 30);
  lv_chart_set_next (c, s1, 60);
  lv_chart_set_next (c, s1, 10);
  lv_chart_set_next (c, s1, 90);

  lv_chart_set_next (c, s2, 32);
  lv_chart_set_next (c, s2, 66);
  lv_chart_set_next (c, s2, 5);
  lv_chart_set_next (c, s2, 47);
  lv_chart_set_next (c, s2, 32);
  lv_chart_set_next (c, s2, 32);
  lv_chart_set_next (c, s2, 66);
  lv_chart_set_next (c, s2, 5);
  lv_chart_set_next (c, s2, 47);
  lv_chart_set_next (c, s2, 66);
  lv_chart_set_next (c, s2, 5);
  lv_chart_set_next (c, s2, 47);

  needle_colors[0] := LV_COLOR_BLUE;
  needle_colors[1] := LV_COLOR_ORANGE;
  needle_colors[2] := LV_COLOR_PURPLE;
  g := lv_gauge_create (tab3, nil);
  lv_gauge_set_needle_count (g, 3, needle_colors);
  lv_obj_set_size (g, 200, 200);
  lv_obj_set_pos (c, 40, 40);                             // Set its position
  lv_gauge_set_value (g, 0, 10 + Random (30));
  lv_gauge_set_value (g, 1, 20 + Random (24));
  lv_gauge_set_value (g, 2, 30 + Random (50));
  for x := 0 to 3 do
    begin
      s := lv_slider_create (tab3, nil);
      lv_obj_set_pos (s, 400 + (x * 100), 50);
      lv_obj_set_size (s, 20, 300);
    end;
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
