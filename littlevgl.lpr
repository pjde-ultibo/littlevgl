program littlevgl;

{$mode objfpc}{$H+}
{$hints off}
{$notes off}
{$define use_tftp}    // if PI not connected to LAN and set for DHCP then remove this

uses
  RaspberryPi3,
  GlobalConfig,
  GlobalConst,
  GlobalTypes,
  Platform,
  Threads,
  SysUtils,
  Classes,
  Ultibo, ulittlevGL,
  FrameBuffer,
{$ifdef use_tftp}
  uTFTP,
{$endif}
  Console, Winsock2, ulog

  { Add additional units here };

function test : integer; cdecl; external;    // returns size of lv_obj structure
procedure haltest1; cdecl; external;         // prints size of display structures
//procedure canvastest; cdecl; external;         // prints size of img structures

const
  ny : array [boolean] of string = ('NO', 'YES');
  disp_buf_size = 10 * 480; //
//  disp_buf_size = 120; //
  osx = 100;
  osy = 100;

type

  Tint32 = integer;

var
  Console1, Console2, Console3 : TWindowHandle;
  IPAddress : string;
  ch : char;
  btn, lbl : Plv_obj;
  disp_buf : Tlv_disp_buf;
  disp_drv : Tlv_disp_drv;
  disp : Plv_disp;
  frame_buf : PFrameBufferDevice;
  buf : array [0 .. disp_buf_size - 1] of Tlv_color;

procedure Log1 (s : string);
begin
  ConsoleWindowWriteLn (Console1, s);
end;

procedure Log2 (s : string);
begin
  ConsoleWindowWriteLn (Console2, s);
end;

procedure Log3 (s : string);
begin
  ConsoleWindowWriteLn (Console3, s);
end;

procedure my_flush_cb (disp_drv : Plv_disp_drv; const area : Plv_area; color_p : Plv_color); cdecl;
var
  w, h : LongWord;
begin
  Log1 (format ('Flushing Callback - %d,%d %d,%d col ', [area^.x1, area^.y1, area^.x2, area^.y2]) {+ IntToHex (color_p^.full, 8)});
  // The most simple case (but also the slowest) to put all pixels to the screen one-by-one //
  w := (area^.x2 - area^.x1) + 1;
  h := (area^.y2 - area^.y1) + 1;
  // FramebufferDeviceFillRect (frame_buf, osx + area^.x1, osy + area^.y1, w, h, color_p^.full, FRAMEBUFFER_FLAG_DMA);
  // IMPORTANT!!!
  // Inform the graphics library that you are ready with the flushing
  lv_disp_flush_ready (disp_drv);
end;

procedure my_gpu_fill_cb (disp_drv : Plv_disp_drv; dest_buf : Plv_color; dest_width : Tlv_coord; const fill_area : Plv_area; color : Tlv_color); cdecl;
// var
//   integer x, y;
begin
  // It's an example code which should be done by your GPU
  Log1 (format ('GPU FILL dest_width %d fill_area - %d,%d %d,%d', [dest_width, fill_area^.x1, fill_area^.y1, fill_area^.x2, fill_area^.y2]));
{  dest_buf := PLv_color (cardinal (dest_buf) + (dest_width * fill_area^.y1)); // Go to the first line
  for y := fill_area^.y1 to fill_area^.>y2 do
    begin
      for x: = fill_area^.x1 to fill_area^x2 do
        dest_buf[x] = color;
      dest_buf := Plv_color (cardinal (dest_buf) + dest_width);    // Go to the next line
    end; }
end;


procedure my_gpu_blend_cb (disp_drv : Plv_disp_drv; dest : Plv_color; const src : Plv_color; length : Tuint32; opa : Tlv_opa); cdecl;
begin
// It's an example code which should be done by your GPU*/
 {   uint32_t i;
    for(i = 0; i < length; i++)
      begin
        dest[i] = lv_color_mix (dest[i], src[i], opa);
      end;
    }
end;

procedure my_rounder_cb (disp_drv : Plv_disp_drv; area : Plv_area); cdecl;
begin
{  /* Update the areas as needed. Can be only larger.
   * For example to always have lines 8 px height:*/
   area->y1 = area->y1 & 0x07;
   area->y2 = (area->y2 & 0x07) + 8;    }
end;

procedure my_set_px_cb (disp_drv : Plv_disp_drv; buff : PByte; buf_w : Tlv_coord; x, y : Tlv_coord; color : Tlv_color; opa : Tlv_opa); cdecl;
begin
  Log1 (format ('Set PX x %d y %d', [x, y]));
{    /* Write to the buffer as required for the display.
     * Write only 1-bit for monochrome displays mapped vertically:*/
 buf += buf_w * (y >> 3) + x;
 if(lv_color_brightness(color) > 128) ( * buf) |= (1 << (y % 8));
 else ( * buf) &= ~(1 << (y % 8));  }
end;

procedure my_monitor_cb (disp_drv : Plv_disp_drv; ms : Tuint32; px : Tuint32); cdecl;
begin
  Log1 (format ('%d px refreshed in %d ms', [px, ms]));
end;

procedure print_cb (level : Tlv_log_level; fb : PChar; ln : Tuint32; desc : PChar); cdecl;
begin
  Log3 (fb + ' Line ' + IntToStr (ln) + ' - ' + desc);
end;

procedure Msg2 (Sender : TObject; s : string);
begin
  Log2 ('TFTP - ' + s);
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

procedure WaitForSDDrive;
begin
  while not DirectoryExists ('C:\') do sleep (500);
end;

begin
  Console1 := ConsoleWindowCreate (ConsoleDeviceGetDefault, CONSOLE_POSITION_LEFT, true);
  Console2 := ConsoleWindowCreate (ConsoleDeviceGetDefault, CONSOLE_POSITION_TOPRIGHT, false);
  Console3 := ConsoleWindowCreate (ConsoleDeviceGetDefault, CONSOLE_POSITION_BOTTOMRIGHT, false);
  SetLogProc (@Log1);
  Log3 ('Test program for littlevGL pjde 2019');
  Log3 ('littlevGL (c) 2016 Gabor Kiss-Vamosi');
  WaitForSDDrive;
  Log3 ('SD Drive ready.');
  IPAddress := WaitForIPComplete;
  Log3 ('Network ready. Local Address : ' + IPAddress + '.');

{$ifdef use_tftp}
  Log2 ('TFTP - Enabled.');
  Log2 ('TFTP - Syntax "tftp -i ' + IPAddress + ' PUT kernel7.img"');
  SetOnMsg (@Msg2);
{$endif}

  frame_buf := FramebufferDeviceGetDefault;
  lv_init;                                    // initialise lv
  lv_log_register_print_cb (@print_cb);       // set debug print callback

  ch := #0;
  while true do
    begin
      if ConsoleGetKey (ch, nil) then
         case (ch) of
          '1' :
            begin
              lv_disp_buf_init (@disp_buf, @buf, nil, disp_buf_size);
              lv_disp_drv_init (@disp_drv);
              disp_drv.buffer := @disp_buf;
              disp_drv.flush_cb := @my_flush_cb;
//            disp_drv.gpu_fill_cb := @my_gpu_fill_cb;
//            disp_drv.gpu_blend_cb := @my_gpu_blend_cb;
//            disp_drv.set_px_cb := @my_set_px_cb;
              disp_drv.monitor_cb := @my_monitor_cb;
              disp := lv_disp_drv_register (@disp_drv);
              Log ('Display ' + IntToStr (lv_disp_get_hor_res (disp)) + ' x ' + IntToStr (lv_disp_get_ver_res (disp)));
              Log ('Display ' + IntToStr (lv_disp_get_hor_res (nil)) + ' x ' + IntToStr (lv_disp_get_ver_res (nil)));
            end;
          '2' :
            begin
              btn := lv_btn_create (lv_scr_act, nil);                 // Add a button the current screen
              lv_obj_set_pos (btn, 10, 10);                           // Set its position
              lv_obj_set_size (btn, 100, 50);                         // Set its size

//              lv_obj_set_event_cb (btn, btn_event_cb);              // Assign a callback to the button
//              lbl := lv_label_create (btn, nil);                      // Add a label to the button
//              lv_label_set_text (lbl, 'Button');                      // Set the label's text
            end;
          '3' : lv_task_handler;
          '4' : lv_tick_inc (1);
          '?' : Log ('Still running.');    // to make sure we haven't crashed
          'c', 'C' : ConsoleWindowClear (Console1);
          end;
      end;
  ThreadHalt (0);
end.

