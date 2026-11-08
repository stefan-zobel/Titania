MODULE Lib;
  IMPORT Out, Strings, Math, MathL;
  VAR s, t: ARRAY 16 OF CHAR; tiny: ARRAY 4 OF CHAR; n: INTEGER;

  PROCEDURE Show(x: ARRAY OF CHAR);
  BEGIN Out.Char("["); Out.String(x); Out.Char("]"); Out.Ln
  END Show;

  PROCEDURE R(x: REAL);
  BEGIN Out.Fixed(x, 0, 6); Out.Ln
  END R;

BEGIN
  Out.Open;
  s := "hello"; Out.Int(Strings.Length(s), 0); Out.Int(Strings.Length(""), 2); Out.Ln;
  Strings.Append(" world", s); Show(s);
  Strings.Insert("big ", 6, s); Show(s);
  Strings.Delete(s, 0, 6); Show(s);
  Strings.Replace("BIG", 0, s); Show(s);
  Strings.Extract(s, 4, 3, t); Show(t);
  Strings.Extract(s, 20, 3, t); Show(t);
  Out.Int(Strings.Pos("wor", s, 0), 0); Out.Int(Strings.Pos("wor", s, 5), 3); Out.Int(Strings.Pos("", s, 3), 2); Out.Ln;
  Strings.Cap(s); Show(s);
  Strings.Copy("abc", t); Show(t);
  tiny := "ab"; Strings.Append("cdefg", tiny); Show(tiny);
  tiny := "ab"; Strings.Insert("xyz", 1, tiny); Show(tiny);
  t := ""; Strings.AppendChar("x", t); Strings.AppendInt(-42, 5, t); Show(t);
  n := Strings.Write("ab", t, 0); Out.Int(n, 0); Show(t);
  n := Strings.WriteChar("z", t, n); Out.Int(n, 0); Show(t);
  n := Strings.WriteInt(7, 3, t, n); Out.Int(n, 0); Show(t);
  n := Strings.Write("abcdef", tiny, 0); Out.Int(n, 0); Show(tiny);
  R(Math.pi); R(MathL.e);
  R(Math.Sqrt(2.0)); R(MathL.sqrt(9.0));
  R(Math.Exp(1.0)); R(Math.Ln(Math.e)); R(Math.Log(8.0, 2.0));
  R(Math.Power(3.0, 2.0)); R(Math.Round(2.5)); R(Math.Round(-2.5));
  R(Math.Sin(0.0)); R(Math.Cos(0.0)); R(Math.Tan(0.0));
  R(Math.ArcSin(1.0)); R(Math.ArcCos(1.0)); R(Math.ArcTan(1.0));
  R(Math.ArcTan2(1.0, -1.0)); R(Math.ArcTan2(-1.0, 0.0));
  R(Math.SinH(1.0)); R(Math.CosH(1.0)); R(Math.TanH(100.0));
  R(Math.ArcSinH(1.0)); R(Math.ArcCosH(2.0)); R(Math.ArcTanH(0.5));
  Out.Fixed(1.0E19, 0, 2); Out.Ln;
  Out.Fixed(-5.97219E24, 28, 1); Out.Ln
END Lib.
