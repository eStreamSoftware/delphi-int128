unit uint128impl;

interface

uses System.SysUtils;

type
  UInt128 = packed record
  private
    class procedure DivModU128(a, b: UInt128; out DivResult: UInt128; out
        Remainder: UInt128); static;
    class procedure SetBit128(var Value: UInt128; numBit: integer); static;
  public
    class operator Implicit(a: UInt8): UInt128;
    class operator Implicit(a: UInt16): UInt128;
    class operator Implicit(a: UInt32): UInt128;
    class operator Implicit(a: UInt64): UInt128;
    class operator Implicit(a: string): UInt128;
    class operator Implicit(a: UInt128): string; inline;
    class operator Explicit(a: UInt128): UInt64;
    class operator LogicalNot(a: UInt128): UInt128;
    class operator Negative(a: UInt128): UInt128;
    class operator Equal(a, b: UInt128): Boolean;
    class operator NotEqual(a, b: UInt128): Boolean;
    class operator GreaterThanOrEqual(a, b: UInt128): Boolean;
    class operator GreaterThan(a, b: UInt128): Boolean;
    class operator LessThanOrEqual(a, b: UInt128): Boolean;
    class operator LessThan(a, b: UInt128): Boolean;
    class operator RightShift(a: UInt128; b: Int64): UInt128;
    class operator RightShift(a, b: UInt128): UInt128;
    class operator LeftShift(a: UInt128; b: Int64): UInt128;
    class operator LeftShift(a, b: UInt128): UInt128;
    class operator Add(a, b: UInt128): UInt128;
    class operator Subtract(a, b: UInt128): UInt128;
    class operator Multiply(a, b: UInt128): UInt128;
    class operator IntDivide(a, b: UInt128): UInt128;
    class operator Modulus(a, b: UInt128): UInt128;
    class operator Modulus(a: UInt128; b: Int64): UInt128;
    class operator BitWiseAnd(a, b: UInt128): UInt128;
    class operator BitWiseOr(a, b: UInt128): UInt128;
    class operator BitWiseXor(a, b: UInt128): UInt128;
  strict private
    case Byte of
      0: (b: packed array [0..15] of UInt8);
      1: (w: packed array [0..7] of UInt16);
      2: (c0, c1, c2, c3: UInt32);
      3: (c: packed array [0..3] of UInt32);
      4: (dc0, dc1: UInt64);
      5: (dc: packed array [0..1] of UInt64);
end;

implementation

{ UInt128 }

class procedure UInt128.SetBit128(var Value: UInt128; numBit: integer);
begin
  Value.c[numBit shr 5] := Value.c[numBit shr 5] or longword(1 shl (numBit and 31));
end;

class operator UInt128.BitWiseAnd(a, b: UInt128): UInt128;
begin
  Result.dc0 := a.dc0 and b.dc0;
  Result.dc1 := a.dc1 and b.dc1;
end;

class operator UInt128.BitWiseOr(a, b: UInt128): UInt128;
begin
  Result.dc0 := a.dc0 or b.dc0;
  Result.dc1 := a.dc1 or b.dc1;
end;

class operator UInt128.BitWiseXor(a, b: UInt128): UInt128;
begin
  Result.dc0 := a.dc0 xor b.dc0;
  Result.dc1 := a.dc1 xor b.dc1;
end;

class procedure UInt128.DivModU128(a, b: UInt128; out DivResult: UInt128; out
    Remainder: UInt128);
var Shift : Integer;
begin
  if b = 0 then raise EMathError.Create('Divide by Zero.');

  if a = 0 then begin
    DivResult := 0;
    Remainder := 0;
    Exit;
  end;

  if a < b then begin
    DivResult := 0;
    Remainder := a;
    Exit;
  end;

  DivResult := 0;
  Remainder := a;
  Shift := 0;

  while (b < Remainder) and (b.c3 and $80000000 = 0) do begin
    if Shift = 124 then break;
    b := b shl 1;
    Inc(Shift);
    if b > Remainder then begin
      b := b shr 1;
      Dec(Shift);
      break;
    end;
  end;

  while True do begin
    if b <= Remainder then
    begin
      Remainder := Remainder - b;
      SetBit128(DivResult, Shift);
    end;

    if Shift > 0 then begin
      b := b shr 1;
      Dec(Shift);
    end else break;

  end;
end;

class operator UInt128.Add(a, b: UInt128): UInt128;
var qw: UInt64;
    c0, c1, c2, c3: Boolean;
  procedure inc3;
  begin
    if Result.c3 = $FFFFFFFF then
    begin
      raise EIntOverflow.Create('Integer Overflow');
    end else
      Inc(Result.c3);
  end;

  procedure inc2;
  begin
    if Result.c2 = $ffffffff then
    begin
      Result.c2 := 0;
      inc3;
    end else
      Inc(Result.c2);
  end;

  procedure inc1;
  begin
    if Result.c1 = $ffffffff then
    begin
      Result.c1 := 0;
      inc2;
    end else
      Inc(Result.c1);
  end;

begin
  qw := UInt64(a.c0) + UInt64(b.c0);
  Result.c0 := qw and $ffffffff;
  c0 := (qw shr 32) = 1;
  qw := UInt64(a.c1) + UInt64(b.c1);
  Result.c1 := qw and $ffffffff;
  c1 := (qw shr 32) = 1;
  qw := UInt64(a.c2) + UInt64(b.c2);
  Result.c2 := qw and $ffffffff;
  c2 := (qw shr 32) = 1;
  qw := UInt64(a.c3) + UInt64(b.c3);
  Result.c3 := qw and $ffffffff;
  c3 := (qw shr 32) = 1;
  if c0 then inc1;
  if c1 then inc2;
  if c2 then inc3;
  if c3 then raise EIntOverflow.Create('Integer Overflow');
end;

{$OVERFLOWCHECKS OFF}
class operator UInt128.Subtract(a, b: UInt128): UInt128;
begin
  if b > a then raise EIntOverflow.Create('Integer overflow')
  else begin
    Result.dc0 := a.dc0 - b.dc0;
    Result.dc1 := a.dc1 - b.dc1;

    if Result.dc0 > a.dc0 then Dec(Result.dc1);

  end;
end;
{$OVERFLOWCHECKS ON}

class operator UInt128.Modulus(a, b: UInt128): UInt128;
var temp: UInt128;
begin
  DivModU128(a, b, temp, Result);
end;

class operator UInt128.Modulus(a: UInt128; b: Int64): UInt128;
var temp: UInt128;
begin
  if b < 0 then b := -b;
  DivModU128(a, b, temp, Result);
end;

class operator UInt128.Multiply(a: UInt128; b: UInt128): UInt128;
var
  qw: UInt64;
  v: UInt128;
begin
  qw := UInt64(a.c0) * UInt64(b.c0);
  Result.c0 := qw and $FFFFFFFF;
  Result.c1 := qw shr 32;
  Result.c2 := 0;
  Result.c3 := 0;

  qw := UInt64(a.c0) * UInt64(b.c1);
  v.c0 := 0;
  v.c1 := qw and $FFFFFFFF;
  v.c2 := qw shr 32;
  v.c3 := 0;
  Result := Result + v;

  qw := UInt64(a.c1) * UInt64(b.c0);
  v.c0 := 0;
  v.c1 := qw and $FFFFFFFF;
  v.c2 := qw shr 32;
  v.c3 := 0;
  Result := Result + v;

  qw := UInt64(a.c0) * UInt64(b.c2);
  v.c0 := 0;
  v.c1 := 0;
  v.c2 := qw and $FFFFFFFF;
  v.c3 := qw shr 32;
  Result := Result + v;

  qw := UInt64(a.c1) * UInt64(b.c1);
  v.c0 := 0;
  v.c1 := 0;
  v.c2 := qw and $FFFFFFFF;
  v.c3 := qw shr 32;
  Result := Result + v;

  qw := UInt64(a.c2) * UInt64(b.c0);
  v.c0 := 0;
  v.c1 := 0;
  v.c2 := qw and $FFFFFFFF;
  v.c3 := qw shr 32;
  Result := Result + v;

  qw := UInt64(a.c0) * UInt64(b.c3);
  v.c0 := 0;
  v.c1 := 0;
  v.c2 := 0;
  v.c3 := qw and $FFFFFFFF;
  Result := Result + v;

  qw := UInt64(a.c1) * UInt64(b.c2);
  v.c0 := 0;
  v.c1 := 0;
  v.c2 := 0;
  v.c3 := qw and $FFFFFFFF;
  Result := Result + v;

  qw := UInt64(a.c2) * UInt64(b.c1);
  v.c0 := 0;
  v.c1 := 0;
  v.c2 := 0;
  v.c3 := qw and $FFFFFFFF;
  Result := Result + v;

  qw := UInt64(a.c3) * UInt64(b.c0);
  v.c0 := 0;
  v.c1 := 0;
  v.c2 := 0;
  v.c3 := qw and $FFFFFFFF;
  Result := Result + v;

  if qw and $100000000 <> 0 then raise EIntOverflow.Create('Integer Overflow');

end;

class operator UInt128.IntDivide(a: UInt128; b: UInt128): UInt128;
var temp: UInt128;
begin
  DivModU128(a, b, Result, temp);
end;

class operator UInt128.Implicit(a: UInt8): UInt128;
begin
  Result.b[0] := a;
  FillChar(Result.b[1], SizeOf(Result) - SizeOf(Result.b[0]), 0);
end;

class operator UInt128.Implicit(a: UInt16): UInt128;
begin
  Result.w[0] := a;
  FillChar(Result.w[1], SizeOf(Result) - SizeOf(Result.w[0]), 0);
end;

class operator UInt128.Implicit(a: UInt32): UInt128;
begin
  Result.c[0] := a;
  FillChar(Result.c[1], SizeOf(Result) - SizeOf(Result.c[0]), 0);
end;

class operator UInt128.Implicit(a: UInt64): UInt128;
begin
  Result.dc0 := a;
  Result.dc1 := 0;
end;

class operator UInt128.Implicit(a: string): UInt128;
var
  i: Integer;
  ten: UInt128;
begin
  Result := 0;
  ten := 10;
  for i := 1 to length(a) do begin
    if a[i] in ['0'..'9'] then begin
      Result := Result * ten;
      Result := Result + UInt32(Ord(a[i]) - Ord('0'));
    end
    else
      raise EConvertError.Create(a + ' is not a valid Int128 value.');
  end;

  if (length(a) > 1) and (Result = 0) then
     raise EIntOverflow.Create('Integer Overflow.');
end;

class operator UInt128.Implicit(a: UInt128): string;
var Ten, digit: UInt128;
begin
  Result := '';
  Ten := 10;

  while a <> 0 do begin
    DivModU128(a, Ten, a, digit);
    Result := Chr(Ord('0') + digit.c0) + Result;
  end;

  if Result = '' then Result := '0';
end;

class operator UInt128.LessThan(a, b: UInt128): Boolean;
begin
  Result := false;
  if a.dc1 < b.dc1 then Result := true
  else if a.dc1 = b.dc1 then if a.dc0 < b.dc0 then Result := true;
end;

class operator UInt128.LessThanOrEqual(a, b: UInt128): Boolean;
begin
  Result := (a = b) or (a < b);
end;

class operator UInt128.LogicalNot(a: UInt128): UInt128;
begin
  Result.dc0 := not a.dc0;
  Result.dc1 := not a.dc1;
end;

class operator UInt128.Equal(a: UInt128; b: UInt128): Boolean;
begin
  Result := true;
  if a.dc0 <> b.dc0 then Result := false;
  if a.dc1 <> b.dc1 then Result := false;
end;

class operator UInt128.Explicit(a: UInt128): UInt64;
begin
  if a.dc1 > 0 then raise EConvertError.Create(string(a) + ' is not a valid UInt64 value.');
  Result := a.dc0;
end;

class operator UInt128.Negative(a: UInt128): UInt128;
begin
  raise EIntOverflow.Create('Integer Overflow');
end;

class operator UInt128.NotEqual(a: UInt128; b: UInt128): Boolean;
begin
  Result := true;
  if (a.dc0 = b.dc0) and (a.dc1 = b.dc1) then Result := false;
end;

class operator UInt128.GreaterThan(a, b: UInt128): Boolean;
begin
  Result := false;
  if a.dc1 > b.dc1 then Result := true;
  if a.dc1 = b.dc1 then if a.dc0 > b.dc0 then Result := true;
end;

class operator UInt128.GreaterThanOrEqual(a, b: UInt128): Boolean;
begin
  Result := (a = b) or (a > b);
end;

class operator UInt128.RightShift(a: UInt128; b: Int64): UInt128;
begin
  if b >= 128 then Result := a shr (b mod 128)  // follow compiler
  else if b >= 64 then begin
    Result.dc1 := 0;
    Result.dc0 := a.dc1 shr (b-64);
  end
  else if b > 0 then begin
    Result.dc0 := (a.dc0 shr b) or (a.dc1 shl (64-b));
    Result.dc1 := a.dc1 shr b;
  end
  else if b = 0 then Result := a
  else if b < 0 then Result := a shr (128 - (Abs(b) mod 128));  // follow compiler
end;

class operator UInt128.RightShift(a: UInt128; b: UInt128): UInt128;
begin
  Result := a shr Int32(b mod 128);
end;

class operator UInt128.LeftShift(a: UInt128; b: Int64): UInt128;
begin
  if b >= 128 then Result := a shl (b mod 128)  // follow compiler
  else if b >= 64 then begin
    Result.dc0 := 0;
    Result.dc1 := a.dc0 shl (b - 64);
  end
  else if b > 0 then begin
    Result.dc1 := (a.dc1 shl b) or (a.dc0 shr (64-b));
    Result.dc0 := a.dc0 shl b;
  end
  else if b = 0 then Result := a
  else if b < 0 then Result := a shl (128 - (Abs(b) mod 128));  // follow compiler
end;

class operator UInt128.LeftShift(a: UInt128; b: UInt128): UInt128;
begin
  Result := a shl Int32(b mod 128);
end;

end.
