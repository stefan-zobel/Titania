MODULE Text;
  IMPORT Out;
  CONST greeting = "hello"; dash = "-"; bang = 21X;
  VAR s, t: ARRAY 16 OF CHAR; c: ARRAY 2 OF CHAR; i: INTEGER; ch: CHAR;

  PROCEDURE Length(x: ARRAY OF CHAR): INTEGER;
    VAR n: INTEGER;
  BEGIN n := 0;
    WHILE (n < LEN(x)) & (x[n] # 0X) DO INC(n) END
    RETURN n
  END Length;

  PROCEDURE Upper(VAR x: ARRAY OF CHAR);
    VAR n: INTEGER;
  BEGIN n := 0;
    WHILE x[n] # 0X DO
      IF (x[n] >= "a") & (x[n] <= "z") THEN x[n] := CHR(ORD(x[n]) - 32) END;
      INC(n)
    END
  END Upper;

  PROCEDURE Show(x: ARRAY OF CHAR);
  BEGIN Out.String(x); Out.Char("|"); Out.Int(LEN(x), 0); Out.Ln
  END Show;

  PROCEDURE Cmp(a, b: ARRAY OF CHAR);
  BEGIN
    IF a = b THEN Out.Char("=") END;
    IF a # b THEN Out.Char("#") END;
    IF a < b THEN Out.Char("<") END;
    IF a <= b THEN Out.Char("l") END;
    IF a > b THEN Out.Char(">") END;
    IF a >= b THEN Out.Char("g") END;
    Out.Ln
  END Cmp;

BEGIN
  s := greeting; Out.String(s); Out.Ln;
  Out.Int(Length(s), 0); Out.Int(Length("abc"), 2); Out.Int(Length(""), 2); Out.Ln;
  t := s; Upper(t); Out.String(t); Out.Char(" "); Out.String(s); Out.Ln;
  Show("lit"); Show(s); Show(greeting); Show(dash);
  Cmp("abc", "abd"); Cmp("abc", "abc"); Cmp("b", "abc"); Cmp("ab", "abc"); Cmp("", "");
  Cmp(s, t); Cmp(t, "HELLO");
  IF s = "hello" THEN Out.String("eq") END;
  IF "hellp" > s THEN Out.String(" gt") END;
  IF s[0] = "h" THEN Out.String(" first") END;
  Out.Ln;
  c := "x"; Out.String(c); Out.Int(ORD(c[1]), 2); Out.Ln;
  ch := dash; Out.Char(ch); ch := bang; Out.Char(ch); Out.Ln;
  s[2] := 0X; Out.String(s); Out.Ln;
  s := ""; Out.Int(Length(s), 0); Out.Ln;
  FOR i := 0 TO 2 DO t[i] := CHR(ORD("a") + i) END; t[3] := 0X; Out.String(t); Out.Ln;
  Out.String("tab"); Out.Char(9X); Out.String("x"); Out.Char(0AX)
END Text.
