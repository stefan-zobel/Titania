MODULE Control;
  IMPORT Out;
  VAR i, k, m, n, last: INTEGER; ch: CHAR;

  PROCEDURE Classify(v: INTEGER);
  BEGIN
    CASE v OF
      0: Out.String("zero")
    | 1, 3 .. 5: Out.String("small")
    | 7: Out.String("seven")
    | 100 .. 200: Out.String("large")
    END;
    Out.Ln
  END Classify;

  PROCEDURE Letter(c: CHAR);
  BEGIN
    CASE c OF
      "a" .. "c": Out.String("abc")
    | "x", 79X: Out.String("xy")
    | 41X: Out.String("A")
    END;
    Out.Ln
  END Letter;

BEGIN
  i := 0;
  WHILE i < 3 DO Out.Int(i, 2); i := i + 1 END; Out.Ln;
  m := 12; n := 18;
  WHILE m > n DO m := m - n ELSIF n > m DO n := n - m END;
  Out.Int(m, 0); Out.Ln;
  i := 10;
  REPEAT DEC(i, 3); Out.Int(i, 3) UNTIL i < 0; Out.Ln;
  FOR k := 1 TO 3 DO Out.Int(k, 2) END; Out.Ln;
  FOR k := 10 TO 1 BY -4 DO Out.Int(k, 3) END; Out.Ln;
  FOR k := 5 TO 1 DO Out.Int(k, 3) END; Out.Int(k, 3); Out.Ln;
  last := 3;
  FOR k := 1 TO last DO IF k = 1 THEN last := 5 END; Out.Int(k, 2) END; Out.Ln;
  FOR i := 0 TO 8 DO
    IF i = 0 THEN Out.Char("a")
    ELSIF i < 3 THEN Out.Char("b")
    ELSIF ODD(i) THEN Out.Char("c")
    ELSE Out.Char("d")
    END
  END;
  Out.Ln;
  Classify(0); Classify(4); Classify(7); Classify(150);
  Letter("b"); Letter("y"); Letter("A");
  ch := "c"; Letter(ch);
  IF TRUE THEN END;
  ;;
  i := 1; IF i = 1 THEN ; END
END Control.
