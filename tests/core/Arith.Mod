MODULE Arith;
  IMPORT Out;
  CONST n = 3 * 4 - 1; mask = {1, 3 .. 5}; big = 7FFFFFFFH; c = 41X;
  VAR i, j: INTEGER; x, y: REAL; b: BYTE; s, t: SET; ok: BOOLEAN; ch: CHAR;

  PROCEDURE Show(v: INTEGER);
  BEGIN Out.Int(v, 0); Out.Char(" ")
  END Show;

  PROCEDURE ShowDiv(a, m: INTEGER);
  BEGIN Show(a DIV m); Show(a MOD m); Out.Ln
  END ShowDiv;

  PROCEDURE ShowBool(v: BOOLEAN);
  BEGIN IF v THEN Out.String("T ") ELSE Out.String("F ") END
  END ShowBool;

BEGIN
  Show(n); Show(big); Show(ORD(c)); Out.Ln;
  ShowDiv(8, 3); ShowDiv(8, -3); ShowDiv(-8, 3); ShowDiv(-8, -3);
  ShowDiv(-1, 2); ShowDiv(1, -2);
  i := 17; j := 5;
  Show(i + j); Show(i - j); Show(i * j); Show(-i); Show(ABS(-i)); Out.Ln;
  Show(LSL(1, 4)); Show(ASR(-16, 2)); Show(ASR(16, 2)); Show(ROR(1, 1)); Out.Ln;
  ShowBool(ODD(3)); ShowBool(ODD(-3)); ShowBool(ODD(4)); Out.Ln;
  b := 200; b := b + 100; Show(b); INC(b, 250); Show(b); DEC(b, 50); Show(b); Out.Ln;
  i := big; INC(i); Show(i); Out.Ln;
  x := 2.5; y := 0.5;
  Show(FLOOR(x + y)); Show(FLOOR(-1.5)); Show(FLOOR(x * 4.0)); Show(FLOOR(x / y));
  Show(FLOOR(FLT(7) - 0.5)); Show(FLOOR(ABS(-x))); Show(FLOOR(-x)); Out.Ln;
  Out.Real(x, 10); Out.Ln; Out.Real(-1.25E2, 12); Out.Ln;
  s := {0, 2}; t := mask;
  Show(ORD(s + t)); Show(ORD(t - {3})); Show(ORD(s * {2, 9})); Show(ORD(s / {2, 3}));
  Show(ORD(-s * {0 .. 3})); Out.Ln;
  i := 1; j := 3;
  Show(ORD({i .. j})); Show(ORD({i, j + 1})); Out.Ln;
  ShowBool(3 IN t); ShowBool(2 IN t); ShowBool(i IN s); ShowBool(j - 1 IN s); Out.Ln;
  INCL(s, 7); EXCL(s, 0); Show(ORD(s)); Out.Ln;
  ok := (i < j) & ~(i = j) OR FALSE;
  ShowBool(ok); ShowBool(i # j); ShowBool(i >= j); ShowBool(x > y); ShowBool(x <= y); ShowBool(s = t); Out.Ln;
  ch := "A"; Out.Char(ch); Out.Char(CHR(ORD(ch) + 1)); Out.Char(c); Out.Char(42X); Out.Ln;
  ShowBool(ch = "A"); ShowBool(ch < "B"); ShowBool(c = ch); Show(ORD(TRUE)); Show(ORD("a")); Out.Ln;
  Out.Hex(255); Out.Char(" "); Out.Hex(-1); Out.Ln;
  ASSERT(i = 1)
END Arith.
