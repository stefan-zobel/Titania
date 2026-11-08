MODULE Main;
  IMPORT Middle, Base, Out, M := Math;
  CONST twice = Base.limit * 2;
  VAR a: ARRAY twice OF INTEGER; q: Base.Point; n: Base.Node; f: Base.Fn;
      r: Middle.Point3;
BEGIN
  Out.String("init Main"); Out.Ln;
  Out.Int(LEN(a), 0); Out.Ln;
  Out.Int(Base.count, 0); Out.Ln;
  Base.Bump(5); Out.Int(Base.count, 0); Out.Ln;
  q := Base.origin; q.x := 8; Out.Int(q.x + Base.origin.x, 0); Out.Ln;
  Out.Int(Base.table[1], 0); Out.Ln;
  Out.Int(Middle.Sum(Middle.p), 0); Out.Ln;
  r := Middle.p; Out.Int(r.z, 0); Out.Ln;
  Base.SetSecret(q, 1); Out.Int(Base.Secret(q), 0); Out.Ln;
  n := Base.MakeNode(1, Base.first); Out.Int(n.next.value, 0); Out.Ln;
  Base.first.value := 6; Out.Int(n.next.value, 0); Out.Ln;
  f := Base.Twice; Out.Int(f(21), 0); Out.Ln;
  Out.Int(FLOOR(M.sqrt(16.0)), 0); Out.Ln
END Main.
