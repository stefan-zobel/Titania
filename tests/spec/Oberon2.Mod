MODULE Oberon2;
  IMPORT Out;
  CONST top = MAX(INTEGER); letter = CAP("q"); shifted = ASH(3, 4); down = ASH(-16, -2);
  VAR i: LONGINT; s: SHORTINT; r: LONGREAL; t: SHORTREAL; c: CHAR;
      short: ARRAY 4 OF CHAR; long: ARRAY 12 OF CHAR;

  PROCEDURE Half(x: LONGREAL): SHORTREAL;
    RETURN x / 2.0
  END Half;

BEGIN
  i := 7; s := i; r := i; t := Half(r);
  Out.LongInt(i + s, 0); Out.Ln;
  Out.LongReal(r, 8); Out.Ln;
  Out.Fixed(t, 7, 3); Out.Ln;
  Out.Fixed(-0.5, 0, 2); Out.Ln;
  Out.Int(ENTIER(2.75), 0); Out.Int(ENTIER(-2.25), 3); Out.Ln;
  Out.Int(LONG(i), 0); Out.Int(SHORT(i), 2); Out.Ln;
  Out.Int(top, 0); Out.Int(MIN(LONGINT), 12); Out.Ln;
  Out.Int(MAX(BYTE), 0); Out.Int(MIN(BYTE), 2); Out.Int(MAX(SET), 3); Out.Int(MIN(SET), 2); Out.Ln;
  Out.Int(ORD(MAX(CHAR)), 0); Out.Int(ORD(MIN(CHAR)), 2); Out.Ln;
  IF MAX(REAL) > 1.0E300 THEN Out.String("big") END;
  IF MIN(LONGREAL) < -1.0E300 THEN Out.String(" negative") END;
  Out.Ln;
  Out.Char(letter); c := "z"; Out.Char(CAP(c)); c := "7"; Out.Char(CAP(c)); Out.Ln;
  Out.Int(shifted, 0); Out.Int(down, 3); Out.Ln;
  i := 5; Out.Int(ASH(i, 2), 0); Out.Int(ASH(i, -1), 2); Out.Int(ASH(i, 40), 2); Out.Int(ASH(-i, -40), 3); Out.Ln;
  COPY("hello", short); Out.String(short); Out.Ln;
  COPY("hello", long); Out.String(long); Out.Ln;
  COPY(short, long); Out.String(long); Out.Int(ORD(long[3]), 2); Out.Ln;
  r := 1 / 4; Out.Real(r, 6); Out.Ln;
  r := 3 + 0.5; Out.Real(r, 6); Out.Ln;
  Out.Flush;
  HALT(0);
  Out.String("not reached")
END Oberon2.
