MODULE ReadOnlyPar;
  PROCEDURE P(a: ARRAY OF INTEGER);
  BEGIN
    a[0] := 1
  END P;
END ReadOnlyPar.
