unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.StrUtils,
  System.Math,
  HlpHashLibTypes,
  HlpHash,
  HlpIHashResult,
  {CRC32}
  HlpCRC32Fast,
  {MD5}
  HlpMD5,
  {SHA1}
  HlpSHA1,
  {XXH32}
  HlpXXHASH32,
  System.Classes, Vcl.Graphics, System.IOUtils, System.Types,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.StdCtrls, Vcl.FileCtrl,
  Vcl.Menus, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    StringGrid1: TStringGrid;
    AllFilesLabl: TLabel;
    OpenDialog1: TOpenDialog;
    StatusLabl: TLabel;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Open1: TMenuItem;
    Exit1: TMenuItem;
    N3: TMenuItem;
    About1: TMenuItem;
    ReadingLabl1: TLabel;
    ReadingLabl2: TLabel;
    BottomLabl: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormActivate(Sender: TObject);
    procedure RunHash(FFilename: String; HashType, HashLen: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  protected
    procedure Resizing(State: TWindowState); override;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  ErExit: Word;

implementation

{$R *.dfm}

function FileSize(fileName: wideString): Int64;
var
  sr: TSearchRec;
begin
  if FindFirst(fileName, faAnyFile, sr) = 0 then
    result := Int64(sr.FindData.nFileSizeHigh) shl Int64(32) +
      Int64(sr.FindData.nFileSizeLow)
  else
    result := -1;
  FindClose(sr);
end;

function ConvertBytes(Bytes: Int64): string;
const
  Description: Array [0 .. 8] of string = ('Bytes', 'KB', 'MB', 'GB', 'TB',
    'PB', 'EB', 'ZB', 'YB');
var
  i: Integer;
begin
  i := 0;

  while Bytes > Power(1024, i + 1) do
    Inc(i);

  result := FormatFloat('###0', Bytes / IntPower(1024, i)) + ' ' +
    Description[i];
end;

function GetCount(Dir: string): Integer;
var
  i: Integer;
begin
  i := 0;
  for Dir in TDirectory.GetFiles(Dir, '*', TSearchOption.soAllDirectories) do
    i := i + 1;
  result := i;
end;

procedure SeparateHexFromLine(fileName: String; HashLength: Integer;
  var HashHexList, HashFileLoc: TStringlist);
var
  TempStrLst: TStringlist;
  intIndex, i: Integer;
  Source, Target: string;
begin
  TempStrLst := TStringlist.Create;
  TempStrLst.LoadFromFile(fileName);
  Try
    // Remove lines which commented
    intIndex := 0;
    while intIndex < TempStrLst.Count do
    begin
      if (AnsiContainsStr(TempStrLst.Strings[intIndex], ';')) then
        TempStrLst.Delete(intIndex)
      else
        Inc(intIndex);
    end;

    // GetHashHex
    for i := 0 to (TempStrLst.Count - 1) do
    begin
      Source := TempStrLst.Strings[i];
      Target := Copy(Source, 0, HashLength); // HashLenght for crc32 = 8
      HashHexList.Add(Target);
    end;

    // GetHashFileLoc
    for i := 0 to (TempStrLst.Count - 1) do
    begin
      Source := TempStrLst.Strings[i];
      Target := Copy(Source, HashLength + 3, Length(Source));
      HashFileLoc.Add(Target);
    end;
  Finally
    TempStrLst.Free;
  End;
end;

procedure TForm1.Resizing(State: TWindowState);
var
  GetWidth, SG0, SG1, SG2, SG3: Integer;
begin
  if Form1.Visible then
  begin
    inherited;
    case State of
      TWindowState.wsMaximized:
        begin
          GetWidth := StringGrid1.ClientRect.Width;

          SG0 := Round(GetWidth / 1.6) + 8;
          SG1 := Round(GetWidth / 5.21) - 2;
          SG2 := Round(GetWidth / 14.8);
          SG3 := Round(GetWidth / 9.25);

          StringGrid1.ColWidths[0] := SG0;
          StringGrid1.ColWidths[1] := SG1;
          StringGrid1.ColWidths[2] := SG2;
          StringGrid1.ColWidths[3] := SG3 - 4;
        end;
      TWindowState.wsNormal:
        begin
          GetWidth := StringGrid1.ClientRect.Width;

          SG0 := Round(GetWidth / 1.6) + 8;
          SG1 := Round(GetWidth / 5.21) - 2;
          SG2 := Round(GetWidth / 14.8);
          SG3 := Round(GetWidth / 9.25);

          StringGrid1.ColWidths[0] := SG0;
          StringGrid1.ColWidths[1] := SG1;
          StringGrid1.ColWidths[2] := SG2;
          StringGrid1.ColWidths[3] := SG3 - 4;
        end;
    end;
  end;
end;

procedure TForm1.About1Click(Sender: TObject);
begin
  //
  ShowMessage('IChecksum GUI Verifier' + #13#13 + '---------------------------'
    + #13#10 + 'Created By Jiva newstone' + #13#10 + 'Based On HashLib4Pascal');
end;

function GetFileHash(FromName: STRING; const HashType: Integer;
  VAR error: Word): String;
const
  BUFFERSIZE = Int32(64 * 1024);
var
  BytesRead: Integer;
  FromFile: System.file;
  TotalBytes: Int64;
  { CRC32 }
  ICHKSUM1: TCRC32_PKZIP;
  { MD5 }
  ICHKSUM2: TMD5;
  { SHA1 }
  ICHKSUM3: TSHA1;
  { XXH32 }
  ICHKSUM4: TXXHASH32;
  LData: THashLibByteArray;
begin
  try
    ASSIGN(FromFile, FromName);
{$I-}
    Reset(FromFile, 1);
{$I+}
    error := IOResult;
    case HashType of
      0:
        begin
          ICHKSUM1 := TCRC32_PKZIP.Create;
          ICHKSUM1.Initialize;
        end;
      1:
        begin
          ICHKSUM2 := TMD5.Create;
          ICHKSUM2.Initialize;
        end;
      2:
        begin
          ICHKSUM3 := TSHA1.Create;
          ICHKSUM3.Initialize;
        end;
      3:
        begin
          ICHKSUM4 := TXXHASH32.Create;
          ICHKSUM4.Initialize;
        end;
    end;
    if error = 0 then
    begin
      TotalBytes := 0;
      SetLength(LData, BUFFERSIZE);
      repeat
{$I-}
        BlockRead(FromFile, LData[0], BUFFERSIZE, BytesRead);
{$I+}
        error := IOResult;
        if (error = 0) AND (BytesRead > 0) then
        begin
          case HashType of
            0:
              begin
                ICHKSUM1.TransformBytes(LData, 0, BytesRead);
              end;
            1:
              begin
                ICHKSUM2.TransformBytes(LData, 0, BytesRead);
              end;
            2:
              begin
                ICHKSUM3.TransformBytes(LData, 0, BytesRead);
              end;
            3:
              begin
                ICHKSUM4.TransformBytes(LData, 0, BytesRead);
              end;
          end;
          Form1.ReadingLabl2.Caption := ConvertBytes(TotalBytes);
          TotalBytes := TotalBytes + BytesRead;
          Application.ProcessMessages;
        end
        until (BytesRead = 0) OR (error > 0);
        System.CLOSE(FromFile)
      end;
    finally
      case HashType of
        0:
          begin
            result := ICHKSUM1.TransformFinal.ToString();
          end;
        1:
          begin
            result := ICHKSUM2.TransformFinal.ToString();
          end;
        2:
          begin
            result := ICHKSUM3.TransformFinal.ToString();
          end;
        3:
          begin
            result := ICHKSUM4.TransformFinal.ToString();
          end;
      end;
    end
  end;

  procedure TForm1.RunHash(FFilename: String; HashType, HashLen: Integer);
  var
    SFVFile, SFVCheckFolder, HashStr: String;
    i, J, Ok, Bad, Missing: Integer;
    HashFileList, HashHexList: TStringlist;
    ICHKSUM1: TCRC32_PKZIP;
    Rect: TRect;
  begin
    SFVFile := FFilename;
    if SFVFile <> '' then
    begin
      StringGrid1.RowCount := 2;
      HashFileList := TStringlist.Create;
      HashHexList := TStringlist.Create;
      SFVCheckFolder := ExtractFilePath(SFVFile);
      if ExtractFileExt(SFVFile) = '.sfv' then
      begin
        HashLen := 8;
        HashType := 0;
      end;
      if ExtractFileExt(SFVFile) = '.md5' then
      begin
        HashLen := 32;
        HashType := 1;
      end;
      if ExtractFileExt(SFVFile) = '.sh1' then
      begin
        HashLen := 40;
        HashType := 2;
      end;
      if ExtractFileExt(SFVFile) = '.xxh' then
      begin
        HashLen := 8;
        HashType := 3;
      end;
      SeparateHexFromLine(SFVFile, HashLen, HashHexList, HashFileList);
      StringGrid1.RowCount := HashFileList.Count + 1;
      AllFilesLabl.Caption := 'All File(s) : ' + HashFileList.Count.ToString;
      ErExit := 0;
      Ok := 0;
      Bad := 0;
      Missing := 0;
      J := 0;
      StatusLabl.Visible := false;
      ReadingLabl1.Visible := true;
      ReadingLabl2.Visible := true;
      try
        for i := 0 to HashFileList.Count - 1 do
        begin
          if ErExit = 1 then
            break;
          Inc(J);
          StringGrid1.Cells[0, J] := ExtractFileName(HashFileList.Strings[i]);
          if (FileExists(SFVCheckFolder + HashFileList.Strings[i])) then
          begin
            StringGrid1.Cells[2, J] :=
              ConvertBytes(FileSize(SFVCheckFolder + HashFileList.Strings[i]));
          end
          else
          begin
            StringGrid1.Cells[1, J] := '-';
            StringGrid1.Cells[2, J] := '0 Bytes';
            StringGrid1.Cells[3, J] := 'Missing';
            Inc(Missing);
          end;
          Application.ProcessMessages;
          HashStr := GetFileHash(SFVCheckFolder + HashFileList.Strings[i],
            HashType, ErExit);
          if FileExists(SFVCheckFolder + HashFileList.Strings[i]) then
            StringGrid1.Cells[1, J] := HashStr;
          if HashStr = HashHexList.Strings[i] then
          begin
            StringGrid1.Cells[3, J] := 'Good';
            Inc(Ok);
          end
          else
          begin
            if FileExists(SFVCheckFolder + HashFileList.Strings[i]) then
            begin
              StringGrid1.Cells[3, J] := 'Bad';
              Inc(Bad);
            end;
          end;
          Application.ProcessMessages;
        end;
      finally
        ReadingLabl1.Visible := false;
        ReadingLabl2.Visible := false;
        StatusLabl.Visible := true;
        StatusLabl.Caption := ('Good : ' + IntToStr(Ok) + ' | Bad : ' +
          IntToStr(Bad) + ' | Missing : ' + IntToStr(Missing));
      end;
    end;
  end;

  procedure TForm1.Exit1Click(Sender: TObject);
  begin
    ErExit := 1;
    Form1.CLOSE;
  end;

  procedure TForm1.Open1Click(Sender: TObject);
  var
    SFVFile, SFVCheckFolder, HashStr: String;
    i, J, Ok, Bad, Missing, HashLen, HashType: Integer;
    HashFileList, HashHexList: TStringlist;
  begin
    OpenDialog1.InitialDir := GetCurrentDir;
    if OpenDialog1.Execute then
    begin
      SFVFile := OpenDialog1.fileName;
    end;
    if SFVFile <> '' then
    begin
      StringGrid1.RowCount := 2;
      HashFileList := TStringlist.Create;
      HashHexList := TStringlist.Create;
      SFVCheckFolder := ExtractFilePath(SFVFile);
      if ExtractFileExt(SFVFile) = '.sfv' then
      begin
        HashLen := 8;
        HashType := 0;
      end;
      if ExtractFileExt(SFVFile) = '.md5' then
      begin
        HashLen := 32;
        HashType := 1;
      end;
      if ExtractFileExt(SFVFile) = '.sh1' then
      begin
        HashLen := 40;
        HashType := 2;
      end;
      if ExtractFileExt(SFVFile) = '.xxh' then
      begin
        HashLen := 8;
        HashType := 3;
      end;
      SeparateHexFromLine(SFVFile, HashLen, HashHexList, HashFileList);
      StringGrid1.RowCount := HashFileList.Count + 1;
      AllFilesLabl.Caption := 'All File(s) : ' + HashFileList.Count.ToString;
      ErExit := 0;
      Ok := 0;
      Bad := 0;
      Missing := 0;
      J := 0;
      StatusLabl.Visible := false;
      ReadingLabl1.Visible := true;
      ReadingLabl2.Visible := true;
      try
        for i := 0 to HashFileList.Count - 1 do
        begin
          if ErExit = 1 then
            break;
          Inc(J);
          StringGrid1.Cells[0, J] := ExtractFileName(HashFileList.Strings[i]);
          if (FileExists(SFVCheckFolder + HashFileList.Strings[i])) then
          begin
            StringGrid1.Cells[2, J] :=
              ConvertBytes(FileSize(SFVCheckFolder + HashFileList.Strings[i]));
          end
          else
          begin
            StringGrid1.Cells[1, J] := '-';
            StringGrid1.Cells[2, J] := '0 Bytes';
            StringGrid1.Cells[3, J] := 'Missing';
            Inc(Missing);
          end;
          Application.ProcessMessages;
          HashStr := GetFileHash(SFVCheckFolder + HashFileList.Strings[i],
            HashType, ErExit);
          if FileExists(SFVCheckFolder + HashFileList.Strings[i]) then
            StringGrid1.Cells[1, J] := HashStr;
          if HashStr = HashHexList.Strings[i] then
          begin
            StringGrid1.Cells[3, J] := 'Good';
            Inc(Ok);
          end
          else
          begin
            if FileExists(SFVCheckFolder + HashFileList.Strings[i]) then
            begin
              StringGrid1.Cells[3, J] := 'Bad';
              Inc(Bad);
            end;
          end;
          Application.ProcessMessages;
        end;
      finally
        ReadingLabl1.Visible := false;
        ReadingLabl2.Visible := false;
        StatusLabl.Visible := true;
        StatusLabl.Caption := ('Good : ' + IntToStr(Ok) + ' | Bad : ' +
          IntToStr(Bad) + ' | Missing : ' + IntToStr(Missing));
      end;
    end;
  end;

  procedure TForm1.FormActivate(Sender: TObject);
  begin
    if ParamStr(1) <> '' then
    begin
      if ExtractFileExt(ParamStr(1)) = '.sfv' then
      begin
        RunHash(ParamStr(1), 0, 8);
        StringGrid1.Cells[1, 0] := 'Hash (CRC32)';
      end;
      if ExtractFileExt(ParamStr(1)) = '.md5' then
      begin
        RunHash(ParamStr(1), 1, 32);
        StringGrid1.Cells[1, 0] := 'Hash (MD5)';
      end;
      if ExtractFileExt(ParamStr(1)) = '.sh1' then
      begin
        RunHash(ParamStr(1), 2, 40);
        StringGrid1.Cells[1, 0] := 'Hash (SHA1)';
      end;
      if ExtractFileExt(ParamStr(1)) = '.xxh' then
      begin
        RunHash(ParamStr(1), 3, 8);
        StringGrid1.Cells[1, 0] := 'Hash (XXHASH32)';
      end;
    end
    else
      Form1.Open1Click(nil);
  end;

  procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
  begin
    ErExit := 1;
  end;

  procedure TForm1.FormCreate(Sender: TObject);
  var
    GetWidth, SG0, SG1, SG2, SG3: Integer;
  begin
    StringGrid1.Row := 1;
    StringGrid1.ColCount := 4;
    StringGrid1.RowCount := 2;
    GetWidth := StringGrid1.ClientRect.Width;

    SG0 := Round(GetWidth / 1.6) + 8;
    SG1 := Round(GetWidth / 5.21) - 2;
    SG2 := Round(GetWidth / 14.8);
    SG3 := Round(GetWidth / 9.25);

    StringGrid1.ColWidths[0] := SG0;
    StringGrid1.ColWidths[1] := SG1;
    StringGrid1.ColWidths[2] := SG2;
    StringGrid1.ColWidths[3] := SG3 - 4;

    StringGrid1.Cells[0, 0] := 'Filename';
    StringGrid1.Cells[1, 0] := 'Hash';
    StringGrid1.Cells[2, 0] := 'Size';
    StringGrid1.Cells[3, 0] := 'Status';
  end;

  procedure TForm1.StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
    Rect: TRect; State: TGridDrawState);
  var
    s: String;
    aCanvas: TCanvas;
  begin
    if (ACol = 0) or (ARow = 0) then
      Exit;
    if (ACol = 1) or (ACol = 2) then
      Exit;
    s := (Sender as TStringGrid).Cells[3, ARow];

    aCanvas := (Sender as TStringGrid).Canvas;
    aCanvas.FillRect(Rect);
    if (s = 'Good') then
    begin
      aCanvas.Brush.Color := $90EE90;
      aCanvas.FillRect(Rect);
      aCanvas.TextOut(Rect.Left + 4, Rect.Top + 2, (Sender as TStringGrid)
        .Cells[3, ARow]);
    end;
    if (s = 'Bad') then
    begin
      aCanvas.Brush.Color := $6262FF;
      aCanvas.FillRect(Rect);
      aCanvas.TextOut(Rect.Left + 4, Rect.Top + 2, (Sender as TStringGrid)
        .Cells[3, ARow]);
    end;
    if (s = 'Missing') then
    begin
      aCanvas.Brush.Color := $94FFFF;
      aCanvas.FillRect(Rect);
      aCanvas.TextOut(Rect.Left + 4, Rect.Top + 2, (Sender as TStringGrid)
        .Cells[3, ARow]);
    end;
  end;

end.
