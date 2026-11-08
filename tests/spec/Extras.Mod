MODULE Extras;
  (* Behavior defined by the report that the reference compiler lacks or rejects. *)
  IMPORT Out;
  TYPE F = PROCEDURE (a: INTEGER): INTEGER;
  VAR i, j, e: INTEGER; x: REAL; f: F;

  PROCEDURE Twice(a: INTEGER): INTEGER;
    RETURN 2 * a
  END Twice;

  PROCEDURE Apply(g: F; a: INTEGER): INTEGER;
    RETURN g(a)
  END Apply;

  PROCEDURE Defaults;
    VAR n: INTEGER; b: BOOLEAN; s: SET;
  BEGIN
    IF (n = 0) & ~b & (s = {}) THEN Out.String("zero") END; Out.Ln
  END Defaults;

  PROCEDURE Pick(v: INTEGER);
  BEGIN
    CASE v OF
      1: Out.String("one")
    |
    | 2: Out.String("two")
    END
  END Pick;

  PROCEDURE Nested(n: INTEGER): INTEGER;
    CONST k = 3;
    PROCEDURE Inner(m: INTEGER): INTEGER;
      RETURN m + k
    END Inner;
    RETURN Inner(n) * 2
  END Nested;

BEGIN
  i := 1; j := 3;
  Out.Int(ORD({j .. i}), 0); Out.Ln;
  x := 1.5; PACK(x, 3); Out.Int(FLOOR(x), 0); Out.Ln;
  x := 12.0; UNPK(x, e); Out.Int(FLOOR(x * 4.0), 0); Out.Int(e, 2); Out.Ln;
  Out.Int(Apply(Twice, 4), 0); Out.Ln;
  f := Twice;
  IF f = Twice THEN Out.String("same") END; Out.Ln;
  Defaults;
  Pick(2); Out.Ln;
  Out.Int(Nested(1), 0); Out.Ln;
  Out.Real(2.5E0, 0); Out.Char(" "); Out.Real(1.0E10, 0); Out.Char(" "); Out.Real(0.1, 0); Out.Ln
END Extras.
