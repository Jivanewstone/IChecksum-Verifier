unit HlpCRC;

// A vast majority if not all of the parameters for these CRC standards
// were gotten from http://reveng.sourceforge.net/crc-catalogue/.

{$I HashLib.inc}

interface

uses
  SysUtils,
  TypInfo,
  HlpHashLibTypes,
  HlpHash,
  HlpIHash,
  HlpHashResult,
  HlpIHashResult;

resourcestring
  SUnSupportedCRCType = 'UnSupported CRC Type: "%s"';
  SWidthOutOfRange = 'Width Must be Between 3 and 64. "%d"';

{$REGION 'CRC Standards'}

type
  /// <summary>
  /// Enum of all defined and implemented CRC standards.
  /// </summary>
  TCRCStandard = (

    /// <summary>
    /// CRC standard named "CRC3_GSM".
    /// </summary>
    CRC3_GSM,

    /// <summary>
    /// CRC standard named "CRC3_ROHC".
    /// </summary>
    CRC3_ROHC,

    /// <summary>
    /// CRC standard named "CRC4_INTERLAKEN".
    /// </summary>
    CRC4_INTERLAKEN,

    /// <summary>
    /// CRC standard named "CRC4_ITU".
    /// </summary>
    CRC4_ITU,

    /// <summary>
    /// CRC standard named "CRC5_EPC".
    /// </summary>
    CRC5_EPC,

    /// <summary>
    /// CRC standard named "CRC5_ITU".
    /// </summary>
    CRC5_ITU,

    /// <summary>
    /// CRC standard named "CRC5_USB".
    /// </summary>
    CRC5_USB,

    /// <summary>
    /// CRC standard named "CRC6_CDMA2000A".
    /// </summary>
    CRC6_CDMA2000A,

    /// <summary>
    /// CRC standard named "CRC6_CDMA2000B".
    /// </summary>
    CRC6_CDMA2000B,

    /// <summary>
    /// CRC standard named "CRC6_DARC".
    /// </summary>
    CRC6_DARC,

    /// <summary>
    /// CRC standard named "CRC6_GSM".
    /// </summary>
    CRC6_GSM,

    /// <summary>
    /// CRC standard named "CRC6_ITU".
    /// </summary>
    CRC6_ITU,

    /// <summary>
    /// CRC standard named "CRC7".
    /// </summary>
    CRC7,

    /// <summary>
    /// CRC standard named "CRC7_ROHC".
    /// </summary>
    CRC7_ROHC,

    /// <summary>
    /// CRC standard named "CRC7_UMTS".
    /// </summary>
    CRC7_UMTS,

    /// <summary>
    /// CRC standard named "CRC8".
    /// </summary>
    CRC8,

    /// <summary>
    /// CRC standard named "CRC8_AUTOSAR".
    /// </summary>
    CRC8_AUTOSAR,

    /// <summary>
    /// CRC standard named "CRC8_BLUETOOTH".
    /// </summary>
    CRC8_BLUETOOTH,

    /// <summary>
    /// CRC standard named "CRC8_CDMA2000".
    /// </summary>
    CRC8_CDMA2000,

    /// <summary>
    /// CRC standard named "CRC8_DARC".
    /// </summary>
    CRC8_DARC,

    /// <summary>
    /// CRC standard named "CRC8_DVBS2".
    /// </summary>
    CRC8_DVBS2,

    /// <summary>
    /// CRC standard named "CRC8_EBU".
    /// </summary>
    CRC8_EBU,

    /// <summary>
    /// CRC standard named "CRC8_GSMA".
    /// </summary>
    CRC8_GSMA,

    /// <summary>
    /// CRC standard named "CRC8_GSMB".
    /// </summary>
    CRC8_GSMB,

    /// <summary>
    /// CRC standard named "CRC8_ICODE".
    /// </summary>
    CRC8_ICODE,

    /// <summary>
    /// CRC standard named "CRC8_ITU".
    /// </summary>
    CRC8_ITU,

    /// <summary>
    /// CRC standard named "CRC8_LTE".
    /// </summary>
    CRC8_LTE,

    /// <summary>
    /// CRC standard named "CRC8_MAXIM".
    /// </summary>
    CRC8_MAXIM,

    /// <summary>
    /// CRC standard named "CRC8_OPENSAFETY".
    /// </summary>
    CRC8_OPENSAFETY,

    /// <summary>
    /// CRC standard named "CRC8_ROHC".
    /// </summary>
    CRC8_ROHC,

    /// <summary>
    /// CRC standard named "CRC8_SAEJ1850".
    /// </summary>
    CRC8_SAEJ1850,

    /// <summary>
    /// CRC standard named "CRC8_WCDMA".
    /// </summary>
    CRC8_WCDMA,

    /// <summary>
    /// CRC standard named "CRC8_MIFAREMAD".
    /// </summary>
    CRC8_MIFAREMAD,

    /// <summary>
    /// CRC standard named "CRC8_NRSC5".
    /// </summary>
    CRC8_NRSC5,

    /// <summary>
    /// CRC standard named "CRC10".
    /// </summary>
    CRC10,

    /// <summary>
    /// CRC standard named "CRC10_CDMA2000".
    /// </summary>
    CRC10_CDMA2000,

    /// <summary>
    /// CRC standard named "CRC10_GSM".
    /// </summary>
    CRC10_GSM,

    /// <summary>
    /// CRC standard named "CRC11".
    /// </summary>
    CRC11,

    /// <summary>
    /// CRC standard named "CRC11_UMTS".
    /// </summary>
    CRC11_UMTS,

    /// <summary>
    /// CRC standard named "CRC12_CDMA2000".
    /// </summary>
    CRC12_CDMA2000,

    /// <summary>
    /// CRC standard named "CRC12_DECT".
    /// </summary>
    CRC12_DECT,

    /// <summary>
    /// CRC standard named "CRC12_GSM".
    /// </summary>
    CRC12_GSM,

    /// <summary>
    /// CRC standard named "CRC12_UMTS".
    /// </summary>
    CRC12_UMTS,

    /// <summary>
    /// CRC standard named "CRC13_BBC".
    /// </summary>
    CRC13_BBC,

    /// <summary>
    /// CRC standard named "CRC14_DARC".
    /// </summary>
    CRC14_DARC,

    /// <summary>
    /// CRC standard named "CRC14_GSM".
    /// </summary>
    CRC14_GSM,

    /// <summary>
    /// CRC standard named "CRC15".
    /// </summary>
    CRC15,

    /// <summary>
    /// CRC standard named "CRC15_MPT1327".
    /// </summary>
    CRC15_MPT1327,

    /// <summary>
    /// CRC standard named "ARC".
    /// </summary>
    ARC,

    /// <summary>
    /// CRC standard named "CRC16_AUGCCITT".
    /// </summary>
    CRC16_AUGCCITT,

    /// <summary>
    /// CRC standard named "CRC16_BUYPASS".
    /// </summary>
    CRC16_BUYPASS,

    /// <summary>
    /// CRC standard named "CRC16_CCITTFALSE".
    /// </summary>
    CRC16_CCITTFALSE,

    /// <summary>
    /// CRC standard named "CRC16_CDMA2000".
    /// </summary>
    CRC16_CDMA2000,

    /// <summary>
    /// CRC standard named "CRC16_CMS".
    /// </summary>
    CRC16_CMS,

    /// <summary>
    /// CRC standard named "CRC16_DDS110".
    /// </summary>
    CRC16_DDS110,

    /// <summary>
    /// CRC standard named "CRC16_DECTR".
    /// </summary>
    CRC16_DECTR,

    /// <summary>
    /// CRC standard named "CRC16_DECTX".
    /// </summary>
    CRC16_DECTX,

    /// <summary>
    /// CRC standard named "CRC16_DNP".
    /// </summary>
    CRC16_DNP,

    /// <summary>
    /// CRC standard named "CRC16_EN13757".
    /// </summary>
    CRC16_EN13757,

    /// <summary>
    /// CRC standard named "CRC16_GENIBUS".
    /// </summary>
    CRC16_GENIBUS,

    /// <summary>
    /// CRC standard named "CRC16_GSM".
    /// </summary>
    CRC16_GSM,

    /// <summary>
    /// CRC standard named "CRC16_LJ1200".
    /// </summary>
    CRC16_LJ1200,

    /// <summary>
    /// CRC standard named "CRC16_MAXIM".
    /// </summary>
    CRC16_MAXIM,

    /// <summary>
    /// CRC standard named "CRC16_MCRF4XX".
    /// </summary>
    CRC16_MCRF4XX,

    /// <summary>
    /// CRC standard named "CRC16_OPENSAFETYA".
    /// </summary>
    CRC16_OPENSAFETYA,

    /// <summary>
    /// CRC standard named "CRC16_OPENSAFETYB".
    /// </summary>
    CRC16_OPENSAFETYB,

    /// <summary>
    /// CRC standard named "CRC16_PROFIBUS".
    /// </summary>
    CRC16_PROFIBUS,

    /// <summary>
    /// CRC standard named "CRC16_RIELLO".
    /// </summary>
    CRC16_RIELLO,

    /// <summary>
    /// CRC standard named "CRC16_T10DIF".
    /// </summary>
    CRC16_T10DIF,

    /// <summary>
    /// CRC standard named "CRC16_TELEDISK".
    /// </summary>
    CRC16_TELEDISK,

    /// <summary>
    /// CRC standard named "CRC16_TMS37157".
    /// </summary>
    CRC16_TMS37157,

    /// <summary>
    /// CRC standard named "CRC16_USB".
    /// </summary>
    CRC16_USB,

    /// <summary>
    /// CRC standard named "CRCA".
    /// </summary>
    CRCA,

    /// <summary>
    /// CRC standard named "KERMIT".
    /// </summary>
    KERMIT,

    /// <summary>
    /// CRC standard named "MODBUS".
    /// </summary>
    MODBUS,

    /// <summary>
    /// CRC standard named "X25".
    /// </summary>
    X25,

    /// <summary>
    /// CRC standard named "XMODEM".
    /// </summary>
    XMODEM,

    /// <summary>
    /// CRC standard named "CRC16_NRSC5".
    /// </summary>
    CRC16_NRSC5,

    /// <summary>
    /// CRC standard named "CRC17_CANFD".
    /// </summary>
    CRC17_CANFD,

    /// <summary>
    /// CRC standard named "CRC21_CANFD".
    /// </summary>
    CRC21_CANFD,

    /// <summary>
    /// CRC standard named "CRC24".
    /// </summary>
    CRC24,

    /// <summary>
    /// CRC standard named "CRC24_BLE".
    /// </summary>
    CRC24_BLE,

    /// <summary>
    /// CRC standard named "CRC24_FLEXRAYA".
    /// </summary>
    CRC24_FLEXRAYA,

    /// <summary>
    /// CRC standard named "CRC24_FLEXRAYB".
    /// </summary>
    CRC24_FLEXRAYB,

    /// <summary>
    /// CRC standard named "CRC24_INTERLAKEN".
    /// </summary>
    CRC24_INTERLAKEN,

    /// <summary>
    /// CRC standard named "CRC24_LTEA".
    /// </summary>
    CRC24_LTEA,

    /// <summary>
    /// CRC standard named "CRC24_LTEB".
    /// </summary>
    CRC24_LTEB,

    /// <summary>
    /// CRC standard named "CRC24_OS9".
    /// </summary>
    CRC24_OS9,

    /// <summary>
    /// CRC standard named "CRC30_CDMA".
    /// </summary>
    CRC30_CDMA,

    /// <summary>
    /// CRC standard named "CRC31_PHILIPS".
    /// </summary>
    CRC31_PHILIPS,

    /// <summary>
    /// CRC standard named "CRC32".
    /// </summary>
    CRC32,

    /// <summary>
    /// CRC standard named "CRC32_AUTOSAR".
    /// </summary>
    CRC32_AUTOSAR,

    /// <summary>
    /// CRC standard named "CRC32_BZIP2".
    /// </summary>
    CRC32_BZIP2,

    /// <summary>
    /// CRC standard named "CRC32C".
    /// </summary>
    CRC32C,

    /// <summary>
    /// CRC standard named "CRC32D".
    /// </summary>
    CRC32D,

    /// <summary>
    /// CRC standard named "CRC32_MPEG2".
    /// </summary>
    CRC32_MPEG2,

    /// <summary>
    /// CRC standard named "CRC32_POSIX".
    /// </summary>
    CRC32_POSIX,

    /// <summary>
    /// CRC standard named "CRC32Q".
    /// </summary>
    CRC32Q,

    /// <summary>
    /// CRC standard named "JAMCRC".
    /// </summary>
    JAMCRC,

    /// <summary>
    /// CRC standard named "XFER".
    /// </summary>
    XFER,

    /// <summary>
    /// CRC standard named "CRC32_CDROMEDC".
    /// </summary>
    CRC32_CDROMEDC,

    /// <summary>
    /// CRC standard named "CRC40_GSM".
    /// </summary>
    CRC40_GSM,

    /// <summary>
    /// CRC standard named "CRC64".
    /// </summary>
    CRC64,

    /// <summary>
    /// CRC standard named "CRC64_GOISO".
    /// </summary>
    CRC64_GOISO,

    /// <summary>
    /// CRC standard named "CRC64_WE".
    /// </summary>
    CRC64_WE,

    /// <summary>
    /// CRC standard named "CRC64_XZ".
    /// </summary>
    CRC64_XZ,

    /// <summary>
    /// CRC standard named "CRC64_1B".
    /// </summary>
    CRC64_1B,

    /// <summary>
    /// CRC standard named "CRC64_Jones".
    /// </summary>
    CRC64_Jones);

{$ENDREGION}

type
  TCRC = class sealed(THash)

  strict private
  var
    FNames: THashLibStringArray;
    FWidth: Int32;
    FPolynomial, FInitialValue, FOutputXor, FCheckValue, FCRCMask,
      FCRCHighBitMask, FHash: UInt64;
    FIsInputReflected, FIsOutputReflected, FIsTableGenerated: Boolean;

    FCRCTable: THashLibUInt64Array;

  const
    Delta = Int32(7);

    function GetNames: THashLibStringArray; inline;
    procedure SetNames(const AValue: THashLibStringArray); inline;
    function GetWidth: Int32; inline;
    procedure SetWidth(AValue: Int32); inline;
    function GetPolynomial: UInt64; inline;
    procedure SetPolynomial(AValue: UInt64); inline;
    function GetInitialValue: UInt64; inline;
    procedure SetInitialValue(AValue: UInt64); inline;
    function GetIsInputReflected: Boolean; inline;
    procedure SetIsInputReflected(AValue: Boolean); inline;
    function GetIsOutputReflected: Boolean; inline;
    procedure SetIsOutputReflected(AValue: Boolean); inline;
    function GetOutputXor: UInt64; inline;
    procedure SetOutputXor(AValue: UInt64); inline;
    function GetCheckValue: UInt64; inline;
    procedure SetCheckValue(AValue: UInt64); inline;

    procedure GenerateTable();
    // tables work only for CRCs with width > 7
    procedure CalculateCRCbyTable(AData: PByte; ADataLength, AIndex: Int32);
    // fast bit by bit algorithm without augmented zero bytes.
    // does not use lookup table, suited for polynomial orders between 1...32.
    procedure CalculateCRCdirect(AData: PByte; ADataLength, AIndex: Int32);

    // reflects the lower 'width' LBits of 'value'
    class function Reflect(AValue: UInt64; AWidth: Int32): UInt64; static;

    property Names: THashLibStringArray read GetNames write SetNames;
    property Width: Int32 read GetWidth write SetWidth;
    property Polynomial: UInt64 read GetPolynomial write SetPolynomial;
    property InitialValue: UInt64 read GetInitialValue write SetInitialValue;
    property IsInputReflected: Boolean read GetIsInputReflected
      write SetIsInputReflected;
    property IsOutputReflected: Boolean read GetIsOutputReflected
      write SetIsOutputReflected;
    property OutputXor: UInt64 read GetOutputXor write SetOutputXor;
    property CheckValue: UInt64 read GetCheckValue write SetCheckValue;

  strict protected
    function GetName: String; override;

  public

    constructor Create(AWidth: Int32; APolynomial, AInitial: UInt64;
      AIsInputReflected, AIsOutputReflected: Boolean;
      AOutputXor, ACheckValue: UInt64; const ANames: THashLibStringArray);

    procedure Initialize(); override;
    procedure TransformBytes(const AData: THashLibByteArray;
      AIndex, ALength: Int32); override;
    function TransformFinal(): IHashResult; override;

    function Clone(): IHash; override;


  end;

implementation

{ TCRC }

function TCRC.GetCheckValue: UInt64;
begin
  result := FCheckValue;
end;

function TCRC.GetInitialValue: UInt64;
begin
  result := FInitialValue;
end;

function TCRC.GetNames: THashLibStringArray;
begin
  result := FNames;
end;

function TCRC.GetPolynomial: UInt64;
begin
  result := FPolynomial;
end;

function TCRC.GetIsInputReflected: Boolean;
begin
  result := FIsInputReflected;
end;

function TCRC.GetIsOutputReflected: Boolean;
begin
  result := FIsOutputReflected;
end;

function TCRC.GetWidth: Int32;
begin
  result := FWidth;
end;

function TCRC.GetOutputXor: UInt64;
begin
  result := FOutputXor;
end;

procedure TCRC.SetCheckValue(AValue: UInt64);
begin
  FCheckValue := AValue;
end;

procedure TCRC.SetInitialValue(AValue: UInt64);
begin
  FInitialValue := AValue;
end;

procedure TCRC.SetNames(const AValue: THashLibStringArray);
begin
  FNames := AValue;
end;

procedure TCRC.SetPolynomial(AValue: UInt64);
begin
  FPolynomial := AValue;
end;

procedure TCRC.SetIsInputReflected(AValue: Boolean);
begin
  FIsInputReflected := AValue;
end;

procedure TCRC.SetIsOutputReflected(AValue: Boolean);
begin
  FIsOutputReflected := AValue;
end;

procedure TCRC.SetWidth(AValue: Int32);
begin
  FWidth := AValue;
end;

procedure TCRC.SetOutputXor(AValue: UInt64);
begin
  FOutputXor := AValue;
end;

procedure TCRC.CalculateCRCbyTable(AData: PByte; ADataLength, AIndex: Int32);
var
  LLength, LIndex: Int32;
  LTemp: UInt64;
  LCRCTable: THashLibUInt64Array;
begin
  LLength := ADataLength;
  LIndex := AIndex;
  LTemp := FHash;
  LCRCTable := FCRCTable;

  if (IsInputReflected) then
  begin
    while LLength > 0 do
    begin
      LTemp := (LTemp shr 8) xor LCRCTable[Byte(LTemp xor AData[LIndex])];
      System.Inc(LIndex);
      System.Dec(LLength);
    end;
  end
  else
  begin
    while LLength > 0 do
    begin
      LTemp := (LTemp shl 8) xor LCRCTable
        [Byte((LTemp shr (Width - 8)) xor AData[LIndex])];
      System.Inc(LIndex);
      System.Dec(LLength);
    end;
  end;

  FHash := LTemp;
end;

procedure TCRC.CalculateCRCdirect(AData: PByte; ADataLength, AIndex: Int32);
var
  LLength, LIdx: Int32;
  LTemp, LBit, LJdx, LHash: UInt64;
begin

  LLength := ADataLength;
  LIdx := AIndex;
  while LLength > 0 do
  begin
    LTemp := UInt64(AData[LIdx]);
    if (IsInputReflected) then
    begin
      LTemp := Reflect(LTemp, 8);
    end;

    LJdx := $80;
    LHash := FHash;
    while LJdx > 0 do
    begin
      LBit := LHash and FCRCHighBitMask;
      LHash := LHash shl 1;
      if ((LTemp and LJdx) > 0) then
        LBit := LBit xor FCRCHighBitMask;
      if (LBit > 0) then
        LHash := LHash xor Polynomial;
      LJdx := LJdx shr 1;
    end;
    FHash := LHash;
    System.Inc(LIdx);
    System.Dec(LLength);
  end;

end;

function TCRC.Clone(): IHash;
var
  LHashInstance: TCRC;
begin
  LHashInstance := TCRC.Create(Width, Polynomial, InitialValue,
    IsInputReflected, IsOutputReflected, OutputXor, CheckValue,
    System.Copy(Names));
  LHashInstance.FCRCMask := FCRCMask;
  LHashInstance.FCRCHighBitMask := FCRCHighBitMask;
  LHashInstance.FHash := FHash;
  LHashInstance.FIsTableGenerated := FIsTableGenerated;
  LHashInstance.FCRCTable := System.Copy(FCRCTable);
  result := LHashInstance as IHash;
  result.BufferSize := BufferSize;
end;

constructor TCRC.Create(AWidth: Int32; APolynomial, AInitial: UInt64;
  AIsInputReflected, AIsOutputReflected: Boolean;
  AOutputXor, ACheckValue: UInt64; const ANames: THashLibStringArray);
begin

  if not(AWidth in [3 .. 64]) then
  begin
    raise EArgumentOutOfRangeHashLibException.CreateResFmt(@SWidthOutOfRange,
      [AWidth]);
  end;

  FIsTableGenerated := False;

  Inherited Create(-1, -1); // Dummy State

  case AWidth of
    0 .. 7:
      begin
        Self.HashSize := 1;
        Self.BlockSize := 1;
      end;

    8 .. 16:
      begin
        Self.HashSize := 2;
        Self.BlockSize := 1;
      end;

    17 .. 39:
      begin
        Self.HashSize := 4;
        Self.BlockSize := 1;
      end;

  else
    begin
      Self.HashSize := 8;
      Self.BlockSize := 1;
    end;

  end;

  Names := ANames;
  Width := AWidth;
  Polynomial := APolynomial;
  InitialValue := AInitial;
  IsInputReflected := AIsInputReflected;
  IsOutputReflected := AIsOutputReflected;
  OutputXor := AOutputXor;
  CheckValue := ACheckValue;

end;

procedure TCRC.GenerateTable;
var
  LBit, LCRC: UInt64;
  LIdx, LJdx: Int32;
begin
  System.SetLength(FCRCTable, 256);
  LIdx := 0;
  while LIdx < 256 do
  begin
    LCRC := UInt64(LIdx);
    if (IsInputReflected) then
    begin
      LCRC := Reflect(LCRC, 8);
    end;
    LCRC := LCRC shl (Width - 8);
    LJdx := 0;
    while LJdx < 8 do
    begin

      LBit := LCRC and FCRCHighBitMask;
      LCRC := LCRC shl 1;
      if (LBit <> 0) then
        LCRC := (LCRC xor Polynomial);
      System.Inc(LJdx);
    end;

    if (IsInputReflected) then
    begin
      LCRC := Reflect(LCRC, Width);
    end;
    LCRC := LCRC and FCRCMask;
    FCRCTable[LIdx] := LCRC;
    System.Inc(LIdx);
  end;

  FIsTableGenerated := True;
end;

procedure TCRC.Initialize;
begin
  // initialize some bitmasks
  FCRCHighBitMask := UInt64(1) shl (Width - 1);
  FCRCMask := ((FCRCHighBitMask - 1) shl 1) or 1;
  FHash := InitialValue;

  if (Width > Delta) then // then use table
  begin

    if not FIsTableGenerated then
    begin
      GenerateTable();
    end;

    if (IsInputReflected) then
      FHash := Reflect(FHash, Width);

  end;

end;

class function TCRC.Reflect(AValue: UInt64; AWidth: Int32): UInt64;
var
  LIdx, LJdx: UInt64;
begin
  LJdx := 1;
  result := 0;
  LIdx := UInt64(1) shl (AWidth - 1);
  while LIdx <> 0 do
  begin
    if ((AValue and LIdx) <> 0) then
    begin
      result := result or LJdx;
    end;
    LJdx := LJdx shl 1;
    LIdx := LIdx shr 1;
  end;
end;

procedure TCRC.TransformBytes(const AData: THashLibByteArray;
  AIndex, ALength: Int32);
var
  LIdx: Int32;
  PtrAData: PByte;
begin
{$IFDEF DEBUG}
  System.Assert(AIndex >= 0);
  System.Assert(ALength >= 0);
  System.Assert(AIndex + ALength <= System.Length(AData));
{$ENDIF DEBUG}

  // table driven CRC reportedly only works for 8, 16, 24, 32 LBits
  // HOWEVER, it seems to work for everything > 7 LBits, so use it
  // accordingly

  LIdx := AIndex;

  PtrAData := PByte(AData);

  if (Width > Delta) then
  begin
    CalculateCRCbyTable(PtrAData, ALength, LIdx);
  end
  else
  begin
    CalculateCRCdirect(PtrAData, ALength, LIdx);
  end;

end;

function TCRC.TransformFinal: IHashResult;
var
  LUInt64: UInt64;
  LUInt32: UInt32;
  LUInt16: UInt16;
  LUInt8: UInt8;

begin

  if Width > Delta then
  begin
    if (IsInputReflected xor IsOutputReflected) then
    begin
      FHash := Reflect(FHash, Width);
    end;
  end
  else
  begin
    if (IsOutputReflected) then
    begin
      FHash := Reflect(FHash, Width);
    end;
  end;

  FHash := FHash xor OutputXor;
  FHash := FHash and FCRCMask;

  if Width = 21 then // special case
  begin
    LUInt32 := UInt32(FHash);

    result := THashResult.Create(LUInt32);

    Initialize();

    Exit;
  end;

  case Width shr 3 of
    0:
      begin
        LUInt8 := UInt8(FHash);
        result := THashResult.Create(LUInt8);

      end;

    1 .. 2:
      begin
        LUInt16 := UInt16(FHash);

        result := THashResult.Create(LUInt16);
      end;

    3 .. 4:
      begin
        LUInt32 := UInt32(FHash);

        result := THashResult.Create(LUInt32);
      end
  else
    begin
      LUInt64 := (FHash);

      result := THashResult.Create(LUInt64);
    end;
  end;

  Initialize();

end;

end.
