program TFTPTest;

{$mode objfpc}{$H+}

uses
  RaspberryPi3,
  GlobalConfig,
  GlobalConst,
  GlobalTypes,
  Platform,
  Threads,
  SysUtils,
  Classes,
  Ultibo,
  Console,
  Winsock2,
  Shell,
  uTFTP;

var
  IPAddress : string;
  WindowHandle : TWindowHandle;

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

procedure Msg (Sender : TObject; s : string);
begin
  ConsoleWindowWriteLn (WindowHandle, s);
end;

procedure WaitForSDDrive;
begin
  while not DirectoryExists ('C:\') do sleep (500);
end;

begin
   // open console window
  WindowHandle := ConsoleWindowCreate (ConsoleDeviceGetDefault, CONSOLE_POSITION_FULL, false);
  ConsoleWindowWriteLn (WindowHandle, 'TFTP Demo.');
  // wait for IP address and SD Card to be initialised.
  WaitForSDDrive;
  IPAddress := WaitForIPComplete;
  ConsoleWindowWriteLn (WindowHandle, 'Local Address ' + IPAddress);
  SetOnMsg (@Msg);
  ThreadHalt (0);
end.

