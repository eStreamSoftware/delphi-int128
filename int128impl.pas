unit int128impl;

interface

uses System.SysUtils, uint128impl;

type
  // https://forum.lazarus.freepascal.org/index.php/topic,17273.15.html
  PInt128 = ^Int128;

  Int128 = packed record
  private
    class procedure DivMod128(const Value1: Int128; const Value2: Int128;
        out DivResult: Int128; out Remainder: Int128); static;
    class procedure Inc128(var Value: Int128); static;
    class procedure SetBit128(var Value: Int128; numBit: integer); static;
    class function StrToInt128(Value: String): Int128; static; inline;
    function Invert: Int128;
  public
    class operator Add(a, b: Int128): Int128;
    class operator Equal(a, b: Int128): Boolean;
    class operator GreaterThan(a, b: Int128): Boolean;
    class operator GreaterThanOrEqual(a, b: Int128): Boolean;
    class operator Implicit(Value: Int8): Int128;
    class operator Implicit(Value: UInt8): Int128;
    class operator Implicit(Value: Int16): Int128;
    class operator Implicit(Value: UInt16): Int128;
    class operator Implicit(Value: Int32): Int128;
    class operator Implicit(Value: UInt32): Int128;
    class operator Implicit(Value: Int64): Int128;
    class operator Implicit(Value: UInt64): Int128;
    class operator Implicit(Value: Int128): string;
    class operator Implicit(Value: string): Int128;
    class operator Implicit(Value: UInt128): Int128;
    class operator Implicit(Value: Int128): UInt128;
    class operator Explicit(Value: UInt128): Int128;
    class operator Explicit(Value: Int128): UInt128;
    class operator Explicit(Value: Int128): Int32;
    class operator LeftShift(Value: Int128; Shift: Int64): Int128;
    class operator LeftShift(Value, Shift: Int128): Int128;
    class operator LessThan(a, b: Int128): Boolean;
    class operator LessThanOrEqual(a, b: Int128): Boolean;
    class operator LogicalNot(Value: Int128): Int128;
    class operator Multiply(a, b: Int128): Int128;
    class operator NotEqual(a, b: Int128): Boolean;
    class operator RightShift(Value: Int128; Shift: Int64): Int128;
    class operator RightShift(Value, Shift: Int128): Int128;
    class operator Subtract(a, b: Int128): Int128;
    class operator IntDivide(a, b: Int128): Int128;
    class operator Modulus(a, b: Int128): Int128;
    class operator BitwiseOr(a, b: Int128): Int128;
    class operator BitwiseXor(a, b: Int128): Int128;
    class operator BitwiseAnd(a, b: Int128): Int128;
    class operator Negative(a: Int128): Int128;
  strict private
    case Byte of
      0: (b: packed array[0..15] of UInt8);
      1: (w: packed array[0..7] of UInt16);
      2: (c0, c1, c2, c3: UInt32);
      3: (c: packed array[0..3] of UInt32);
      4: (dc0, dc1: UInt64);
      5: (dc: packed array[0..1] of UInt64);
  end;

implementation

uses System.SysConst;

class operator Int128.Negative(a: Int128): Int128;
begin
  Result := not a + 1;
end;

class procedure Int128.DivMod128(const Value1: Int128; const Value2: Int128;
    out DivResult: Int128; out Remainder: Int128);
var curShift: integer;
    sub: Int128;
    neg: Boolean;
begin
  if Value2 = 0 then raise EDivByZero.Create(SDivByZero);

  sub := Value2;
  Remainder := Value1;
  DivResult := 0;
  neg := false;

  if (sub.c3 and $80000000 <> 0) xor (Remainder.c3 and $80000000 <> 0)
  then neg:= true;
  if (sub.c3 and $80000000 <> 0) then sub := -sub;
  if (Remainder.c3 and $80000000 <> 0) then Remainder := -Remainder;

  // if divisor = 1
  if sub = 1 then begin
    if (Value1 < 0) and neg then DivResult := Value1
    else if (Value1 > 0) and neg then DivResult := -Value1
    else if Value1 < 0 then DivResult := -Value1
    else DivResult := Value1;
    Remainder := 0;
    Exit;
  end;

  curShift := 0;
  while (sub.c3 and $80000000 = 0) and (sub < Remainder) do begin
    if curShift = 123 then break;
    sub := sub shl 1;
    inc(curShift);
    if (sub > Remainder) then begin
      sub := sub shr 1;
      dec(curShift);
      break;
    end;
  end;

  while True do begin
    if sub <= Remainder then
    begin
      Remainder := Remainder - sub;
      SetBit128(DivResult, curShift);
    end;
    if curShift > 0 then begin
      sub := sub shr 1;
      dec(curShift);
    end else
      break;
  end;

  if neg then DivResult := -DivResult;
  if (Value1 < 0) then Remainder := -Remainder;

end;

class procedure Int128.Inc128(var Value: Int128);
begin
  if Value.c0 <> $ffffffff then Inc(Value.c0) else begin
    Value.c0 := 0;
    if Value.c1 <> $ffffffff then Inc(Value.c1) else begin
      Value.c1 := 0;
      if Value.c2 <> $ffffffff then Inc(Value.c2) else begin
        Value.c2 := 0;
        if Value.c3 <> $ffffffff then Inc(Value.c3) else
          Value.c3 := 0;
      end;
    end;
  end;
end;

class procedure Int128.SetBit128(var Value: Int128; numBit: integer);
begin
  Value.c[numBit shr 5] := Value.c[numBit shr 5] or longword(1 shl (numBit and 31));
end;

class function Int128.StrToInt128(Value: string): Int128;
var
  i: Integer;
  ten: Int128;
  neg: Boolean;
begin

  if Value = '-170141183460469231731687303715884105728' then begin
     Result.dc1 := $8000000000000000;
     Result.dc0 := 0;
     exit;
  end;

  Result := 0;
  ten := 10;
  neg := False;

  for i := 1 to length(Value) do begin
    if CharInSet(Value[i], ['0'..'9']) then begin
      Result := Result * ten;
      Result := Result + Int32(Ord(Value[i]) - Ord('0'));
    end else if (i = 1) and (Value[i] = '-') then
      neg := True
    else
      raise EConvertError.Create(Value + ' is not a valid Int128 value.');
  end;
  if neg then Result := -Result;

  if (length(Value) > 1) and (Result = 0) then raise EIntOverflow.Create(SIntOverflow);


end;

function Int128.Invert: Int128;
begin
  Result.dc0 := Self.dc0 xor $FFFFFFFFFFFFFFFF;
  Result.dc1 := Self.dc1 xor $FFFFFFFFFFFFFFFF;
end;

class operator Int128.Equal(a, b: Int128): Boolean;
begin
  Result := (a.dc0 = b.dc0) and (a.dc1 = b.dc1);
end;

class operator Int128.GreaterThan(a, b: Int128): Boolean;
begin
  Result := False;
  if Int64(a.dc1) > Int64(b.dc1) then Result := True
  else if a.dc1 = b.dc1 then begin
    if a.dc0 > b.dc0 then Result := True;
  end;
end;

class operator Int128.Add(a, b: Int128): Int128;
var qw: UInt64;
    c0, c1, c2: Boolean;
  procedure inc3;
  begin
    if Result.c3 = $ffffffff then
    begin
      Result.c3 := 0;
    end
    else
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

  if c0 then inc1;
  if c1 then inc2;
  if c2 then inc3;

  if ((Result < 0) and (a > 0) and (b > 0)) then
     raise EIntOverflow.Create(SIntOverflow);

  if ((Result > 0) and (a < 0) and (b < 0)) then
     raise EIntOverflow.Create(SIntOverflow);

end;

class operator Int128.GreaterThanOrEqual(a, b: Int128): Boolean;
begin
  Result := (a = b) or (a > b);
end;

class operator Int128.Implicit(Value: Int8): Int128;
begin
  var Sign: Byte := 0;
  Result.b[0] := UInt8(Value);
  if Value < 0 then Sign := $FF;
  FillChar(Result.b[1], SizeOf(Result) - SizeOf(Result.b[0]), Sign);
end;

class operator Int128.Implicit(Value: UInt8): Int128;
begin
  Result.b[0] := Value;
  FillChar(Result.b[1], SizeOf(Result) - SizeOf(Result.b[0]), 0);
end;

class operator Int128.Implicit(Value: Int16): Int128;
begin
  var Sign: Byte := 0;
  Result.w[0] := UInt16(Value);
  if Value < 0 then Sign := $FF;
  FillChar(Result.w[1], SizeOf(Result) - SizeOf(Result.w[0]), Sign);
end;

class operator Int128.Implicit(Value: UInt16): Int128;
begin
  Result.w[0] := Value;
  FillChar(Result.w[1], SizeOf(Result) - SizeOf(Result.w[0]), 0);
end;

class operator Int128.Implicit(Value: Int32): Int128;
begin
  var Sign: Byte := 0;
  Result.c[0] := UInt32(Value);
  if Value < 0 then Sign := $FF;
  FillChar(Result.c[1], SizeOf(Result) - SizeOf(Result.c[0]), Sign);
end;

class operator Int128.Implicit(Value: UInt32): Int128;
begin
  Result.c[0] := Value;
  FillChar(Result.c[1], SizeOf(Result) - SizeOf(Result.c[0]), 0);
end;

class operator Int128.Implicit(Value: Int64): Int128;
begin
  var Sign: Byte := 0;
  Result.dc[0] := UInt64(Value);
  if Value < 0 then Sign := $FF;
  FillChar(Result.dc[1], SizeOf(Result) - SizeOf(Result.dc[0]), Sign);
end;

class operator Int128.Implicit(Value: UInt64): Int128;
begin
  Result.dc0 := Value;
  Result.dc1 := 0;
end;

class operator Int128.Implicit(Value: Int128): string;
var digit, curValue, nextValue, ten: Int128;
    Neg: Boolean;
begin
  if (Value.c3 = $80000000) and (Value.c2 = 0)
  and (Value.c1 = 0) and (Value.c0 = 0) then
  begin
    Result := '-170141183460469231731687303715884105728';
    Exit;
  end;

  Result := '';
  ten := 10;
  if Value.b[15] shr 7 = 1 then begin
    curValue := UInt128(Value.Invert()) + 1;
    Neg := True;
  end else begin
    curValue := Value;
    Neg := False;
  end;

  while CurValue <> 0 do begin
    DivMod128(CurValue, ten, nextValue, digit);
    Result := Chr(Ord('0') + digit.c0) + Result;
    curValue := NextValue;
  end;

  if Result = '' then Result := '0';
  if Neg then Result := '-' + Result;
end;

class operator Int128.Implicit(Value: string): Int128;
begin
  Result := StrToInt128(Value);
end;

class operator Int128.LeftShift(Value: Int128; Shift: Int64): Int128;
begin
  if Shift >= 128 then Result := Value shl (Shift mod 128)
  else if Shift >= 64 then begin
    Result.dc1 := Value.dc0;
    Result.dc0 := 0;
    Result := Result shl (Shift - 64);
  end else if Shift > 0 then begin
    Result.dc1 := (Value.dc1 shl Shift) or (Value.dc0 shr (64-Shift));
    Result.dc0 := Value.dc0 shl Shift;
  end else if Shift = 0 then Result := Value
  else if Shift < 0 then Result := Value shl (128 - (Abs(Shift) mod 128));

end;

class operator Int128.LeftShift(Value, Shift: Int128): Int128;
begin
  if Shift < 0 then Result := Value shl Int32(128 - ((-Shift) mod 128))
  else Result := Value shl Int32(Shift mod 128);
end;

class operator Int128.LessThan(a, b: Int128): Boolean;
begin
  Result := False;
  if Int64(a.dc1) < Int64(b.dc1) then Result := True
  else if a.dc1 = b.dc1 then begin
    if a.dc0 < b.dc0 then Result := True;
  end;
end;

class operator Int128.LessThanOrEqual(a, b: Int128): Boolean;
begin
  Result := (a = b) or (a < b);
end;

class operator Int128.LogicalNot(Value: Int128): Int128;
begin
  Result.dc0 := not Value.dc0;
  Result.dc1 := not Value.dc1;
end;

class operator Int128.Multiply(a, b: Int128): Int128;
var qw: UInt64;
    v: Int128;
    neg, over: Boolean;
begin
  neg := false;
  over := false;
  if (a < 0) xor (b < 0) then neg := true;

  if a < 0 then a := -a;
  if b < 0 then b := -b;

  qw := UInt64(a.c0) * UInt64(b.c0);
  Result.c0 := qw and $ffffffff;
  Result.c1 := qw shr 32;
  Result.c2 := 0;
  Result.c3 := 0;

  qw := UInt64(a.c0) * UInt64(b.c1);
  v.c0 := 0;
  v.c1 := qw and $ffffffff;
  v.c2 := qw shr 32;
  v.c3 := 0;
  Result := Result + v;

  qw := UInt64(a.c1) * UInt64(b.c0);
  v.c0 := 0;
  v.c1 := qw and $ffffffff;
  v.c2 := qw shr 32;
  v.c3 := 0;
  Result := Result + v;

  qw := UInt64(a.c0) * UInt64(b.c2);
  v.c0 := 0;
  v.c1 := 0;
  v.c2 := qw and $ffffffff;
  v.c3 := qw shr 32;
  Result := Result + v;

  qw := UInt64(a.c1) * UInt64(b.c1);
  v.c0 := 0;
  v.c1 := 0;
  v.c2 := qw and $ffffffff;
  v.c3 := qw shr 32;
  Result := Result + v;

  qw := UInt64(a.c2) * UInt64(b.c0);
  v.c0 := 0;
  v.c1 := 0;
  v.c2 := qw and $ffffffff;
  v.c3 := qw shr 32;
  Result := Result + v;

  qw := UInt64(a.c0) * UInt64(b.c3);
  v.c0 := 0;
  v.c1 := 0;
  v.c2 := 0;
  v.c3 := qw and $ffffffff;
  if qw shr 32 <> 0 then over := True;
  Result := Result + v;

  qw := UInt64(a.c1) * UInt64(b.c2);
  v.c0 := 0;
  v.c1 := 0;
  v.c2 := 0;
  v.c3 := qw and $ffffffff;
  if qw shr 32 <> 0 then over := True;
  Result := Result + v;

  qw := UInt64(a.c2) * UInt64(b.c1);
  v.c0 := 0;
  v.c1 := 0;
  v.c2 := 0;
  v.c3 := qw and $ffffffff;
  if qw shr 32 <> 0 then over := True;
  Result := Result + v;

  qw := UInt64(a.c3) * UInt64(b.c0);
  v.c0 := 0;
  v.c1 := 0;
  v.c2 := 0;
  v.c3 := qw and $ffffffff;
  if qw shr 32 <> 0 then over := True;
  Result := Result + v;

  if (Result < a) and (Result < b) then raise EIntOverflow.Create(SIntOverflow);
  if (Result = 0) and (a <> 0) and (b <> 0) then raise EIntOverflow.Create(SIntOverflow);
  if over then raise EIntOverflow.Create(SIntOverflow);
  if neg then Result := -Result;
end;

class operator Int128.NotEqual(a, b: Int128): Boolean;
begin
  Result := not (a = b);
end;

class operator Int128.RightShift(Value: Int128; Shift: Int64): Int128;
begin
  if Shift >= 128 then
    Result := Value shr (Shift mod 128)
  else if Shift >= 64 then begin
    Result.dc0 := Value.dc1;
    Result.dc1 := 0;
    Result := Result shr (Shift - 64);
  end else if Shift > 0 then begin
    Result.dc0 := (Value.dc0 shr Shift) or (Value.dc1 shl (64-Shift));
    Result.dc1 := Value.dc1 shr Shift;
  end else if Shift = 0 then Result := Value
  else if Shift < 0 then Result := Value shr (128 - (Abs(Shift) mod 128))
end;

class operator Int128.RightShift(Value, Shift: Int128): Int128;
begin
  if Shift < 0 then Result := Value shr Int32(128 - ((-Shift) mod 128))
  else Result := Value shr Int32(Shift mod 128);
end;

class operator Int128.Subtract(a, b: Int128): Int128;
var c: Int128;
begin
  c := not b;
  Inc128(c);
  Result := a + c;
end;

class operator Int128.IntDivide(a, b: Int128): Int128;
var temp: Int128;
begin
  DivMod128(a, b, Result, temp);
end;

class operator Int128.Modulus(a: Int128; b: Int128): Int128;
var temp: Int128;
begin
  DivMod128(a, b, temp, Result);
end;

class operator Int128.BitwiseOr(a, b: Int128): Int128;
begin
  Result.dc0 := a.dc0 or b.dc0;
  Result.dc1 := a.dc1 or b.dc1;
end;

class operator Int128.BitwiseXor(a, b: Int128): Int128;
begin
  Result.dc0 := a.dc0 xor b.dc0;
  Result.dc1 := a.dc1 xor b.dc1;
end;

class operator Int128.BitwiseAnd(a, b: Int128): Int128;
begin
  Result.dc0 := a.dc0 and b.dc0;
  Result.dc1 := a.dc1 and b.dc1;
end;

class operator Int128.Implicit(Value: UInt128): Int128;
var temp: UInt64;
    temp2: UInt128;
begin
  temp := UInt64(Value shr 64);
  Result.dc1 := temp;

  temp2 := $FFFFFFFFFFFFFFFF;
  temp := UInt64(Value and temp2);
  Result.dc0 := temp;
end;

class operator Int128.Implicit(Value: Int128): UInt128;
begin
  // if value is -ve, implicit not able to convert
  if (Value.c3 and $80000000) <> 0 then
  raise ERangeError.Create('Range Check Error');

  Result := string(Value);
end;

class operator Int128.Explicit(Value: Int128): UInt128;
begin
  Result := UInt128(Value.dc0);
  Result := Result or (UInt128(Value.dc1) shl 64);
end;

class operator Int128.Explicit(Value: UInt128): Int128;
begin
  Result := Value;
end;

class operator Int128.Explicit(Value: Int128): Int32;
begin
  if (Value.c3 <> 0) or (Value.c2 <> 0) or (Value.c1 <> 0) then
    raise EConvertError.Create('Invalid Int32 Integer');

  Result := Int32(Value.c0);
end;

end.
