unit int128Impl.TestCase;

interface

uses TestFramework;

type
  TInt128_TestCase = class(TTestCase)
  published
    procedure Size;
    procedure Test_Int8;
    procedure Test_UInt8;
    procedure Test_Int16;
    procedure Test_UInt16;
    procedure Test_Int32;
    procedure Test_UInt32;
    procedure Test_Int64;
    procedure Test_UInt64;
    procedure Test_Int128;
    procedure Test_Addition;
    procedure Test_Subtraction;
    procedure Test_Multiplication;
    procedure Test_Division;
    procedure Test_Left_Shift;
    procedure Test_Right_Shift;
    procedure Test_Modulus;
    procedure Test_Less_Than;
    procedure Test_Less_Than_OrEqual;
    procedure Test_Greater_Than;
    procedure Test_Greater_Than_OrEqual;
    procedure Test_BitwiseAnd;
    procedure Test_BitwiseOr;
    procedure Test_BitwiseXor;
    procedure Test_Int128_To_UInt128;
    procedure Test_UInt128_To_Int128;
    procedure Test_Overflow_Add;
    procedure Test_Overflow_Subtract;
    procedure Test_Overflow_Multiply;
    procedure Test_Overflow128;
    procedure Test_ConvertError;
    procedure Test_ConvertError32;
    procedure Test_DivBy0;
  end;

  TUInt128_TestCase = class (TTestCase)
  published
    procedure Size;
    procedure Test_UInt8;
    procedure Test_UInt16;
    procedure Test_UInt32;
    procedure Test_UInt64;
    procedure Test_UInt128;
    procedure Test_Addition;
    procedure Test_Subtraction;
    procedure Test_Multiply;
    procedure Test_Divide;
    procedure Test_Modulus;
    procedure Test_LeftShift;
    procedure Test_RightShift;
    procedure Test_GreaterThanOrEqual;
    procedure Test_GreaterThan;
    procedure Test_LessThanOrEqual;
    procedure Test_Equal;
    procedure Test_NotEqual;
    procedure Test_LessThan;
    procedure Test_BitwiseAnd;
    procedure Test_BitwiseOr;
    procedure Test_BitwiseXor;
    procedure Test_Overflow_Add;
    procedure Test_Overflow_Multiply;
    procedure Test_RangeCheck_Sub;
    procedure Test_Divby0;
  end;

implementation

uses int128impl, uint128impl, System.SysUtils;

procedure TInt128_TestCase.Size;
begin
  CheckEquals(16, SizeOf(Int128));
end;

procedure TInt128_TestCase.Test_Int8;
begin
  var A: Int128;
  A := Low(Int8);
  CheckEquals('-128', A);

  A := -1;
  CheckEquals('-1', A);

  A := -127;
  CheckEquals('-127', A);

  A := 126;
  CheckEquals('126', A);

  A := High(Int8);
  CheckEquals('127', A);
end;

procedure TInt128_TestCase.Test_UInt8;
begin
  var A: Int128;
  A := Low(UInt8);
  CheckEquals('0', A);

  A := High(UInt8);
  CheckEquals('255', A);
end;

procedure TInt128_TestCase.Test_Int16;
begin
  var A: Int128;
  A := Low(Int16);
  CheckEquals('-32768', A);

  A := -32767;
  CheckEquals('-32767', A);

  A := 32766;
  CheckEquals('32766', A);

  A := High(Int16);
  CheckEquals('32767', A);
end;

procedure TInt128_TestCase.Test_UInt16;
begin
  var A: Int128;
  A := Low(UInt16);
  CheckEquals('0', A);

  A := 65534;
  CheckEquals('65534', A);

  A := High(UInt16);
  CheckEquals('65535', A);
end;

procedure TInt128_TestCase.Test_Int32;
begin
  var A: Int128;
  A := Low(Int32);
  CheckEquals('-2147483648', A);

  A := -2147483647;
  CheckEquals('-2147483647', A);

  A := 2147483646;
  CheckEquals('2147483646', A);

  A := High(Int32);
  CheckEquals('2147483647', A);
end;

procedure TInt128_TestCase.Test_UInt32;
begin
  var A: Int128;
  A := Low(UInt32);
  CheckEquals('0', A);

  A := 4294967294;
  CheckEquals('4294967294', A);

  A := High(UInt32);
  CheckEquals('4294967295', A);
end;

procedure TInt128_TestCase.Test_Int64;
begin
  var A: Int128;
  A := Low(Int64);
  CheckEquals('-9223372036854775808', A);

  A := -9223372036854775807;
  CheckEquals('-9223372036854775807', A);

  A := 9223372036854775807;
  CheckEquals('9223372036854775807', A);

  A := High(Int64);
  CheckEquals('9223372036854775807', A);
end;

procedure TInt128_TestCase.Test_UInt64;
begin
  var A: Int128;
  A := Low(UInt64);
  CheckEquals('0', A);

  A := 18446744073709551614;
  CheckEquals('18446744073709551614', A);

  A := High(UInt64);
  CheckEquals('18446744073709551615', A);
end;

procedure TInt128_TestCase.Test_Int128;
begin
  var A: Int128;
  A := High(UInt64);
  A := A + High(UInt64);
  CheckEquals('36893488147419103230', A);

  A := High(UInt64) shr 1;
  A := A * High(UInt64);
  A := '170141183460469231704017187605319778305';
  CheckEquals('170141183460469231704017187605319778305', A);

  A := '-170141183460469231731687303715884105728';
  CheckEquals('-170141183460469231731687303715884105728', A);

  A := '-170141183460469231731687303715884105726';
  CheckEquals('-170141183460469231731687303715884105726', A);
end;

procedure TInt128_TestCase.Test_Addition;
begin
  var A, B: Int128;
  A := Int128('2514468541324685313585343515684');
  B := Int128('5231458413545231584365135435132');
  A := A + B;
  CheckEquals('7745926954869916897950478950816', A);

  B := Int128('-546841354751434768845435113558');
  A := B + A;
  CheckEquals('7199085600118482129105043837258', A);
end;

procedure TInt128_TestCase.Test_BitwiseAnd;
var A, B: Int128;
begin
  A := '7199085600118482129105043837258';
  B := '269852145658412521456874524742';
  CheckEquals('179965533517852354494593208386', A and B);
end;

procedure TInt128_TestCase.Test_BitwiseOr;
var A, B: Int128;
begin
  A := '7199085600118482129105043837258';
  B := '269852145658412521456874524742';
  CheckEquals('7288972212259042296067325153614', A or B);
end;

procedure TInt128_TestCase.Test_BitwiseXor;
var A, B: Int128;
begin
  A := '7199085600118482129105043837258';
  B := '269852145658412521456874524742';
  CheckEquals('7109006678741189941572731945228', A xor B);
end;

procedure TInt128_TestCase.Test_Overflow128;
begin
  StartExpectingException(EIntOverflow);
  var A: Int128 := '64798548145465497148876842174687164674572';
end;

procedure TInt128_TestCase.Test_ConvertError;
begin
  StartExpectingException(EConvertError);
  var A: Int128 := '654846546846+48974654097854654874'; // illegal char
end;

procedure TInt128_TestCase.Test_ConvertError32;
begin
  StartExpectingException(EConvertError);
  var A: Int128 := '65465489746548768147891861780';
  Int32(A);
end;

procedure TInt128_TestCase.Test_Subtraction;
begin
  var A, B: Int128;
  A := Int128('5436854135856841354184345341532435123');
  B := Int128('5634468412534683453548654135154685433');
  A := A - B;
  CheckEquals('-197614276677842099364308793622250310', A);

  B := Int128('6546854355185413546841514354685431');
  A := B - A;
  CheckEquals('204161131033027512911150307976935741', A);
end;

procedure TInt128_TestCase.Test_Multiplication;
begin
  var A: Int128;
  A := Int128('3564643518354354134854163485');
  A := A * 398;
  CheckEquals('1418728120305032945671957067030', A);

  A := A * -9536;
  CheckEquals('-13528991355228794169927782591198080', A);

  A := A * -1;
  CheckEquals('13528991355228794169927782591198080', A);

  A := A * -1;
  CheckEquals('-13528991355228794169927782591198080', A);

  A := '5468541358478654135484354534356';
  A := A * -1;
  CheckEquals('-5468541358478654135484354534356', A);
  CheckEquals('5468541358478654135484354534356', -1 * A);

  CheckEquals('0', A * 0);

  var B: UInt128;
  A := '5468541358478654135484';
  B := '6789746541210647';
  CheckEquals('37130009774197814770277287418521298148', A * B);

  A := '709711949013741918793';
  B := '479465461154789840';
  CheckEquals('340282366920938463463035577984261463120', B * A); // UInt128
end;

procedure TInt128_TestCase.Test_DivBy0;
begin
  StartExpectingException(EDivByZero);
  var A: Int128 := '445646540198048648436376843210';
  A := A div 0;
end;

procedure TInt128_TestCase.Test_Overflow_Add;
begin
  StartExpectingException(EIntOverflow);
  var A: Int128 := '85070591730234615865843651857942052864';
  A := A + A;
end;

procedure TInt128_TestCase.Test_Overflow_Multiply;
begin
  StartExpectingException(EIntOverflow);
  var A: Int128 := '36893488147419103232';
  var B: Int128 := '36893488147419103232';
  A := A * B;
end;

procedure TInt128_TestCase.Test_Overflow_Subtract;
begin
  StartExpectingException(EIntOverflow);
  var A, B: Int128;
  A := '-170141183460469231731687303715884105727';
  B := '1147215874';
  A := A - B;
end;

procedure TInt128_TestCase.Test_Division;
begin
  var A, B: Int128;
  A := Int128('54168545353251854354351545464685485554');
  A := A div 5468945;
  CheckEquals('9904752260856866242822252822927', A);

  A := A div 5959;
  CheckEquals('1662150068947284148820649911', A);

  A := A div -100;
  CheckEquals('-16621500689472841488206499', A);

  A := 0 div A;
  CheckEquals('0', A);

  A := Int128('-54168545353251854354351545464685485554');
  B := 454564564785;
  CheckEquals('0', B div A);
  CheckEquals('-119165789746221197751718951', A div B);
  CheckEquals('54168545353251854354351545464685485554', A div -1);
  CheckEquals('-54168545353251854354351545464685485554', A div 1);

  A := '-897564785647845698745447415894';
  B := '-47869852478587458745248956847156';
  CheckEquals('0', A div B);
end;

procedure TInt128_TestCase.Test_Left_Shift;
var C: Int128;
begin
  C := Int128(123) shl 100;
  CheckEquals('155921023828072216384094494261248', C);

  C := Int128(-1234) shl 40;
  CheckEquals('-1356797348675584', C);

  C := Int128('534534684685') shl 3;
  CheckEquals('4276277477480', C);

  C := Int128(123) shl -1;
  CheckEquals('-170141183460469231731687303715884105728', C);

  C := Int128(123) shl -100;
  CheckEquals('33017561088', C);

  C := Int128(19632) shl 128;
  CheckEquals('19632', C);

  C := Int128('-123548689745632458638471127834758368') shl 144;
  CheckEquals('69889874932754313790146744583712669696', C);

  C := Int128('589747876465487641039871476847314') shl Int128('7984621013214');
  CheckEquals('-13924022151500367134690243951177236480', C);

  C := Int128('674654547467878413146548740324110') shl Int128('-878465411032147');
  CheckEquals('78101836498460880225089455892358758400', C);

  C := Int128('-56487654103147987784512311465475') shl Int128('98765451431447');
  CheckEquals('-133570420189961572049687644626007097344', C);

  C := Int128('-98758465031306377452752974501243') shl Int128('-9741013457410');
  CheckEquals('85070591730234615865843651857942052864', C);

  C := Int128('4968789765432110647896547684210') shl Int128('1221715784192');
  CheckEquals('4968789765432110647896547684210', C);

  C := Int128('4798749874987146414874603187') shl Int128('-12217157860608');
  CheckEquals('4798749874987146414874603187', C);

  C := Int128('-4968789765432110647896547684210') shl Int128('1221715784192');
  CheckEquals('-4968789765432110647896547684210', C);

  C := Int128('-4798749874987146414874603187') shl Int128('-12217157860608');
  CheckEquals('-4798749874987146414874603187', C);
end;

procedure TInt128_TestCase.Test_Right_Shift;
var C: Int128;
begin
  C := Int128('125794368745377835274623412345424') shr 100;
  CheckEquals('99', C);

  C := Int128('1257943687453778352746') shr 38;
  CheckEquals('4576372475', C);

  C := Int128('1257943687453778352746') shr 5;
  CheckEquals('39310740232930573523', C);

  C := Int128(-100) shr 1;
  CheckEquals('170141183460469231731687303715884105678', C);

  C := Int128('5546984483256412478512566475') shr -96;
  CheckEquals('1291507967574617936', C);

  C := Int128('89414782146581244744113') shr 128;
  CheckEquals('89414782146581244744113', C);

  C := Int128('-795879844478414116717142') shr -231;
  CheckEquals('10141204801825811492905918628503', C);

  C := Int128('87944785614879145638941256846547') shr Int128('-6514814861');
  CheckEquals('0', C);

  C := Int128('984347865156345687894185465478654') shr Int128('6478547848');
  CheckEquals('3845108848266975343336661974525', C);

  C := Int128('-54765478644846687032106434761047') shr Int128('9714874631654');
  CheckEquals('67108853', C);

  C := Int128('-98754651320146147674846131465491') shr Int128('-875411464786410');
  CheckEquals('81129614869663034276301129480752', C);

  C := '984347865156345687894185465478654';
  C := C shr Int128('20224');
  CheckEquals('984347865156345687894185465478654', C);
end;

procedure TInt128_TestCase.Test_Modulus;
var A, B: Int128;
begin
  A := Int128('356478543547684735413847686485341');
  A := A mod 54685466;
  CheckEquals('12345495', A);

  A := Int128('35846854351638685354684365');
  A := A mod 354654;
  CheckEquals('101013', A);

  A := Int128('874985215842324121951723552');
  B := 978464874;
  CheckEquals('236470048', A mod B);
  CheckEquals('-236470048', -A mod B);
  CheckEquals('236470048', A mod -B);
  CheckEquals('-236470048', -A mod -B);

  A := '654786589743487425844875547865478654';
  B := '9874556547658748965454';
  CheckEquals('2322040360585739301282', A mod B);
  CheckEquals('-2322040360585739301282', -A mod B);
  CheckEquals('2322040360585739301282', A mod -B);
  CheckEquals('-2322040360585739301282', -A mod -B);

  CheckEquals('0', 0 mod A);
  CheckEquals('1', 1 mod A);
  CheckEquals('0', A mod 1);
end;

procedure TInt128_TestCase.Test_Less_Than;
begin
  var A := Int128('523216854135135468461354685314');
  var B := Int128('-546854135847865413548435453435');
  CheckTrue(B < A);
  CheckFalse(A < B);

  B := Int128('534584135413543136541351');
  CheckTrue(B < A);
  CheckFalse(A < B);

  B := Int128('-546854135847865413548435453435');
  CheckFalse(A < 0);
  CheckTrue(B < 0);
  CheckFalse(0 < B);
end;

procedure TInt128_TestCase.Test_Less_Than_OrEqual;
begin
  var A := Int128('523216854135135468461354685314');
  var B := Int128('-546854135847865413548435453435');
  CheckTrue(B <= A);
  CheckFalse(A <= B);

  B := Int128('523216854135135468461354685314');
  CheckTrue(B <= A);
  CheckTrue(A <= B);
end;

procedure TInt128_TestCase.Test_Greater_Than;
begin
  var A := Int128('86415374685435153748614385455744441');
  var B := Int128('5343513218541513354468435135843658');
  CheckTrue(A > B);
  CheckFalse(B > A);

  B := Int128('86415374685435153748614385455744441');
  CheckFalse(A > B);
  CheckFalse(B > A);

  CheckTrue(A > 0);
  CheckTrue(B > 0);

  B := Int128('-86415374685435153748614385455744441');
  CheckFalse(B > 0);
  CheckTrue(0 > B);
end;

procedure TInt128_TestCase.Test_Greater_Than_OrEqual;
begin
  var A := Int128('86415374685435153748614385455744441');
  var B := Int128('5343513218541513354468435135843658');
  CheckTrue(A >= B);
  CheckFalse(B >= A);

  B := Int128('86415374685435153748614385455744441');
  CheckTrue(A >= B);
  CheckTrue(B >= A);
end;

procedure TInt128_TestCase.Test_Int128_To_UInt128;
var A : UInt128;
    B : Int128;
begin
  // Implicit
  B := '69874121489669423687412';
  A := B;
  CheckEquals('69874121489669423687412', A);

  B := '14863698423985234458746214752';
  A := B;
  CheckEquals('14863698423985234458746214752', A);

  B := '170141183460469231731687303715884105727';
  A := B;
  CheckEquals('170141183460469231731687303715884105727', A);

  B := '0';
  A := B;
  CheckEquals('0', A);

  B := Int128('31293981238021830899330912');
  A := B;
  CheckEquals('31293981238021830899330912', A);

  B := Int128('-9223372036854775808');
  A := UInt128(B);
  CheckEquals('340282366920938463454151235394913435648', A);

  // Explicit
  B := '23642147562698745214747456';
  A := UInt128(B);
  CheckEquals('23642147562698745214747456', A);

  B := '-6589547';
  A := UInt128(B);
  CheckEquals('340282366920938463463374607431761621909', A);

  B := -6589547;
  A := UInt128(B);
  CheckEquals('340282366920938463463374607431761621909', A);

  B := '-17856598721458746542146521485';
  A := UInt128(B);
  CheckEquals('340282366903081864741915860889621689971', A);

  B := '0';
  A := UInt128(B);
  CheckEquals('0', A);
end;

procedure TInt128_TestCase.Test_UInt128_To_Int128;
var A: UInt128;
    B: Int128;
begin
  A := '170141183460469231731687303715884105727';
  B := A;
  CheckEquals('170141183460469231731687303715884105727', B);

  // A := High(UInt128) --> -1 (Int128)
  A := '340282366920938463463374607431768211455';
  B := A;
  CheckEquals('-1', B);

  A := UInt128('340282366920938463463374607431768211454');
  B := A;
  CheckEquals('-2', B);

  // Explicit
  A := '340282366920938463463374607431768211455';
  B := Int128(A);
  CheckEquals('-1', B);

  A := '0';
  B := Int128(A);
  CheckEquals('0', B);

  A := '24786321456324896789';
  B := Int128(A);
  CheckEquals('24786321456324896789', B);

  A := '170141183460469231731687303715884105728';
  B := Int128(A);
  CheckEquals('-170141183460469231731687303715884105728', B);

  A := '170141184252982974763771660535307698176';
  B := Int128(A);
  CheckEquals('-170141182667955488699602946896460513280', B);

  B := Int128('-9223372036854775808');
  A := UInt128(B);
  B := A;
  CheckEquals('-9223372036854775808', B);
end;

{ TUInt128_TestCase }

procedure TUInt128_TestCase.Size;
begin
  CheckEquals(16, SizeOf(UInt128));
end;

procedure TUInt128_TestCase.Test_UInt8;
var A: UInt128;
begin
  A := 123;
  CheckEquals('123', A);

  A := High(UInt8);
  CheckEquals('255', A);

  A := Low(UInt8);
  CheckEquals('0', A);
end;

procedure TUInt128_TestCase.Test_UInt16;
var A: UInt128;
begin
  A := 19733;
  CheckEquals('19733', A);

  A := High(UInt16);
  CheckEquals('65535', A);

  A := Low(UInt16);
  CheckEquals('0', A);
end;

procedure TUInt128_TestCase.Test_UInt32;
var A: UInt128;
begin
  A := 2987002901;
  CheckEquals('2987002901', A);

  A := High(UInt32);
  CheckEquals('4294967295', A);

  A := Low(UInt32);
  CheckEquals('0', A);
end;

procedure TUInt128_TestCase.Test_UInt64;
var A: UInt128;
begin
  A := 8178536958009540629;
  CheckEquals('8178536958009540629', A);

  A := High(UInt64);
  CheckEquals('18446744073709551615', A);

  A := Low(UInt64);
  CheckEquals('0', A);
end;

procedure TUInt128_TestCase.Test_UInt128;
var A: UInt128;
begin
  A := '340282366920938463426481119284349108225';
  CheckEquals('340282366920938463426481119284349108225', A);

  A := '340282366920938463463374607431768211455';
  CheckEquals('340282366920938463463374607431768211455', A);

  A := '795143514568412356841841548125841';
  CheckEquals('795143514568412356841841548125841', A);

  A := '751431314654';
  CheckEquals('751431314654', A);

  A := '0';
  CheckEquals('0', A);

  A := High(UInt64);
  A := A * (High(UInt64) - 50);
  CheckEquals('340282366920938462504143915598871527475', A);
end;

procedure TUInt128_TestCase.Test_Addition;
var A: UInt128;
begin
  A := High(UInt64);
  CheckEquals('36893488147419103230', A+A);

  A := A + '587654789654178956';
  CheckEquals('19034398863363730571', A);

  A := A + 0;
  CheckEquals('19034398863363730571', A);

  A := A + 8967;
  CheckEquals('19034398863363739538', A);
end;

procedure TUInt128_TestCase.Test_BitwiseAnd;
var A, B: UInt128;
begin
  A := '489521464326624696123';
  B := 658932985214752;
  CheckEquals('19797794395936', A and B);

  A := '340282366920938463463374607431768211455';
  B := '2547896369541295147587429874147821234';
  CheckEquals('2547896369541295147587429874147821234', A and B);

  A := '4579145789461346589747587458458745647';
  B := '48725689414785847125854121459842964';
  CheckEquals('7145759219085997425758499410574084', A and B);

  CheckEquals('0', A and 0);
end;

procedure TUInt128_TestCase.Test_BitwiseOr;
var A, B: UInt128;
begin
  A := '489521464326624696123';
  B := 658932985214752;
  CheckEquals('489522103461815514939', A or B);

  A := '254789636954129514758742987414782';
  B := '587452149846514141841584544785254';
  CheckEquals('588186773945868464049560827707390', A or B);

  CheckEquals('254789636954129514758742987414782', A or 0);
end;

procedure TUInt128_TestCase.Test_BitwiseXor;
var A, B: UInt128;
begin
  A := '489521464326624696123';
  B := 658932985214752;
  CheckEquals('489522083664021119003', A xor B);

  A := '254789636954129514758742698741';
  B := '587452149846514141841584584';
  CheckEquals('254591171453434960310216465213', A xor B);

  CheckEquals('254789636954129514758742698741', A xor 0);
end;

procedure TUInt128_TestCase.Test_Subtraction;
var A, B: UInt128;
begin
  A := High(UInt64);
  B := 4987641847654;
  CheckEquals('18446739086067703961', A-B);

  A := '7894648648612984645658941256';
  B := 786463184647654;
  CheckEquals('7894648648612198182474293602', A-B);

  CheckEquals('7894648648612984645658941256', A-0);
end;

procedure TUInt128_TestCase.Test_Modulus;
var A, temp: UInt128;
begin
  A := High(UInt64);
  A := A * High(UInt64);
  CheckEquals('5', A mod 10);

  CheckEquals('230853', A mod 974654);

  temp := '8463426481119284349108225';
  CheckEquals('4193650789272930447413550', A mod temp);

  A := '457946876455489745489745489';
  CheckEquals('0', 0 mod A);
  CheckEquals('890', 890 mod A);

  A := '457946876455489745489745489';
  CheckEquals('3537', A mod -5963);
end;

procedure TUInt128_TestCase.Test_Multiply;
var A, B: UInt128;
begin
  A := High(UInt64);
  B := 4560;

  CheckEquals('84117152976115555364400', A*B);

  CheckEquals('340282366920938463426481119284349108225', A*A);

  B := 789456123;
  CheckEquals('14562895058403968846046288645', A*B);
end;

procedure TUInt128_TestCase.Test_NotEqual;
var A, B: UInt128;
begin
  A := '24869874521478987521478687624';
  B := '24869874521478987521478687624';
  CheckFalse(A <> B);

  B := '56984221464515';
  CheckTrue(A <> B);

  B := 0;
  CheckTrue(A <> B);
end;

procedure TUInt128_TestCase.Test_Overflow_Add;
begin
  StartExpectingException(EIntOverflow);
  var A : UInt128 := '340282366920938463463374607431768211455';
  A := A + 1;
end;

procedure TUInt128_TestCase.Test_Overflow_Multiply;
begin
  StartExpectingException(EIntOverflow);
  var A: UInt128 := '36893488147419103232';
  var B: UInt128 := '68484654574846548748';
  A := A * B;
end;

procedure TUInt128_TestCase.Test_RangeCheck_Sub;
begin
  StartExpectingException(EIntOverflow);
  var A: UInt128 := '37465154764';
  A := A - '67897465465456465104894';
end;

procedure TUInt128_TestCase.Test_RightShift;
var A, B: UInt128;
begin
  A := '24869874521478987521478687624';
  B := A shr 0;
  CheckEquals('24869874521478987521478687624', B);

  B := A shr 54;
  CheckEquals('1380555365664', B);

  A := '248698745214789875214786876244785148';
  B := A shr 103;
  CheckEquals('24523', B);

  B := A shr 136;
  CheckEquals('971479473495272950057761235331191', B);

  B := A shr UInt128('89746548746');
  CheckEquals('242869868373818237514440308832797', B);

  A := '489521464326624696';
  B := A shr -10;
  CheckEquals('0', B);

  B := A shr -75;
  CheckEquals('54', B);
end;

procedure TUInt128_TestCase.Test_Divby0;
begin
  StartExpectingException(EDivByZero);
  var A : UInt128 := '648456454';
  A := A div 0;
end;

procedure TUInt128_TestCase.Test_Divide;
var X, Y: UInt128;
begin
  X := High(UInt64);
  X := X * High(UInt64);
  Y := X div 10;
  CheckEquals('34028236692093846342648111928434910822', Y);

  Y := X div 79548347;
  CheckEquals('4277679923643648603112785225874', Y);

  Y := '764578478155784147987';
  X := X div Y;
  CheckEquals('445058782901819216', X);
end;

procedure TUInt128_TestCase.Test_Equal;
var A, B: UInt128;
begin
  A := '34028236692093846342648111928434910822';
  B := '34028236692093846342648111928434910822';
  CheckTrue(A = B);

  B := 5874145687452;
  CheckFalse(A = B);

  B := 0;
  CheckFalse(A = B);
end;

procedure TUInt128_TestCase.Test_GreaterThan;
var A, B: UInt128;
begin
  A := '34028236692093846342648111928434910822';
  B := '764578478155784147987';

  CheckTrue(A > B);
  CheckFalse(B > A);

  A := '34028236692093846342648111928434910822';
  B := 0;

  CheckTrue(A > B);
  CheckFalse(B > A);
end;

procedure TUInt128_TestCase.Test_GreaterThanOrEqual;
var A, B: UInt128;
begin
  A := '34028236692093846342648111928434910822';
  B := '764578478155784147987';

  CheckTrue(A >= B);
  CheckFalse(B >= A);

  B := '34028236692093846342648111928434910822';

  CheckTrue(A >= B);
  CheckTrue(B >= A);
end;

procedure TUInt128_TestCase.Test_LeftShift;
var A: UInt128;
begin
  A := 123;
  A := A shl 253;
  CheckEquals('127605887595351923798765477786913079296', A);

  A := 123;
  A := A shl 100;
  CheckEquals('155921023828072216384094494261248', A);

  A := 4765247852;
  A := A shl 47;
  CheckEquals('670649014081101764755456', A);

  A := '45984521478962145844612597';
  A := A shl -8;
  CheckEquals('325660858967304388861432729768684421120', A);

  A := '45984521478962145844612597';
  A := A shl -6938;
  CheckEquals('207793068353508124237882531992282595328', A);

  A := 0;
  A := A shl 98;
  CheckEquals('0', A);

  A := '16543876543632478964786478923';
  A := A shl 0;
  CheckEquals('16543876543632478964786478923', A);

  A := A shl UInt128('98724790647936474');
  CheckEquals('6970435202010218812273698145472348160', A);
end;

procedure TUInt128_TestCase.Test_LessThan;
var A, B: UInt128;
begin
  B := '34028236692093846342648111928434910822';
  A := '764578478155784147987';

  CheckTrue(A < B);
  CheckFalse(B < A);

  B := '34028236692093846342648111928434910822';
  A := 0;

  CheckTrue(A < B);
  CheckFalse(B < A);
end;

procedure TUInt128_TestCase.Test_LessThanOrEqual;
var A, B: UInt128;
begin
  B := '34028236692093846342648111928434910822';
  A := '764578478155784147987';

  CheckTrue(A <= B);
  CheckFalse(B <= A);

  B := '34028236692093846342648111928434910822';
  A := '34028236692093846342648111928434910822';

  CheckTrue(A <= B);
  CheckTrue(B <= A);

  var C: Int128;
  C := '1';
  A := '340282366920938463463374607431768211455';
  CheckTrue(UInt128(C) <= A);
  CheckFalse(A <= C);

end;

initialization
  RegisterTest(TInt128_TestCase.Suite);
  RegisterTest(TUInt128_TestCase.Suite);
end.
