object Form1: TForm1
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'IChecksum Verifier'
  ClientHeight = 490
  ClientWidth = 772
  Color = clBtnFace
  CustomTitleBar.CaptionAlignment = taCenter
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDesktopCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object StringGrid1: TStringGrid
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 766
    Height = 439
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelInner = bvNone
    BevelOuter = bvNone
    Color = clBtnFace
    ColCount = 3
    DefaultColWidth = 50
    FixedCols = 0
    RowCount = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    GradientEndColor = clWhite
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 0
    OnDrawCell = StringGrid1DrawCell
    ExplicitLeft = 8
    ExplicitTop = 5
  end
  object BottomLabl: TPanel
    Left = 0
    Top = 445
    Width = 772
    Height = 40
    Align = alTop
    Anchors = [akLeft, akRight, akBottom]
    BevelOuter = bvNone
    TabOrder = 1
    object AllFilesLabl: TLabel
      Left = 8
      Top = 22
      Width = 67
      Height = 14
      Caption = 'All File(s) : 0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object ReadingLabl1: TLabel
      Left = 8
      Top = 5
      Width = 55
      Height = 14
      Caption = 'Reading...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object ReadingLabl2: TLabel
      Left = 68
      Top = 5
      Width = 41
      Height = 14
      Caption = '0 Bytes'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object StatusLabl: TLabel
      Left = 8
      Top = 5
      Width = 139
      Height = 14
      Caption = 'Status : Waiting for input'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = 'CRC32|*.sfv|MD5|*.md5|SHA1|*.sh1|XXHASH32|*.xxh'
    Left = 728
    Top = 448
  end
  object MainMenu1: TMainMenu
    Left = 432
    Top = 360
    object File1: TMenuItem
      Caption = '&File'
      object Open1: TMenuItem
        Caption = 'Open'
        OnClick = Open1Click
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'E&xit'
        OnClick = Exit1Click
      end
    end
    object About1: TMenuItem
      Caption = 'About'
      OnClick = About1Click
    end
  end
end
