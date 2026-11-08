MODULE Input;
  IMPORT In, Out;
  VAR i, j: INTEGER; r: REAL; c: CHAR; s: ARRAY 8 OF CHAR;
BEGIN
  In.Open;
  In.Int(i); In.LongInt(j); Out.Int(i + j, 0); Out.Ln;
  In.Real(r); Out.Fixed(r, 0, 3); Out.Ln;
  In.LongReal(r); Out.Fixed(r, 0, 3); Out.Ln;
  In.Int(i); IF In.Done THEN Out.String("number") ELSE Out.String("no number") END; Out.Ln;
  In.Char(c); Out.Int(ORD(c), 0); Out.Ln;
  In.Char(c); Out.Char(c); Out.Ln;
  In.String(s); Out.String(s); Out.Ln;
  In.String(s); Out.String(s); Out.Ln;
  In.String(s); IF ~In.Done THEN Out.String("end") END; Out.Ln;
  In.Char(c); IF ~In.Done THEN Out.String("end") END; Out.Ln
END Input.
