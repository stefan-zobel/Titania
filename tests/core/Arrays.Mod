MODULE Arrays;
  IMPORT Out;
  CONST N = 20;
  TYPE Row = ARRAY 3 OF INTEGER;
       Grid = ARRAY 2, 3 OF INTEGER;
  VAR sieve: ARRAY N OF BOOLEAN;
      i, j, count: INTEGER;
      a, b: Row;
      g, h: Grid;
      v: ARRAY 4 OF Row;
      bytes: ARRAY 4 OF BYTE;
      reals: ARRAY 2 OF REAL;
      sets: ARRAY 2 OF SET;

  PROCEDURE Sum(x: ARRAY OF INTEGER): INTEGER;
    VAR k, s: INTEGER;
  BEGIN s := 0;
    FOR k := 0 TO LEN(x) - 1 DO s := s + x[k] END
    RETURN s
  END Sum;

  PROCEDURE Fill(VAR x: ARRAY OF INTEGER; value: INTEGER);
    VAR k: INTEGER;
  BEGIN
    FOR k := 0 TO LEN(x) - 1 DO x[k] := value + k END
  END Fill;

  PROCEDURE Total(m: ARRAY OF Row): INTEGER;
    VAR k, s: INTEGER;
  BEGIN s := 0;
    FOR k := 0 TO LEN(m) - 1 DO s := s + Sum(m[k]) END
    RETURN s
  END Total;

  PROCEDURE Width(m: ARRAY OF ARRAY OF INTEGER): INTEGER;
    RETURN LEN(m[0])
  END Width;

  PROCEDURE Bump(VAR n: INTEGER);
  BEGIN INC(n, 100)
  END Bump;

  PROCEDURE LocalCopy(x: Row): INTEGER;
    VAR local: Row;
  BEGIN local := x; local[0] := 99
    RETURN local[0] + x[0]
  END LocalCopy;

BEGIN
  FOR i := 2 TO N - 1 DO sieve[i] := TRUE END;
  FOR i := 2 TO N - 1 DO
    IF sieve[i] THEN
      Out.Int(i, 0); Out.Char(" ");
      j := i * i;
      WHILE j < N DO sieve[j] := FALSE; j := j + i END
    END
  END;
  Out.Ln;
  count := LEN(sieve); Out.Int(count, 0); Out.Ln;
  Fill(a, 1); Out.Int(Sum(a), 0); Out.Ln;
  b := a; b[1] := 50; Out.Int(a[1], 0); Out.Int(b[1], 3); Out.Ln;
  FOR i := 0 TO 1 DO
    FOR j := 0 TO 2 DO g[i, j] := i * 10 + j END
  END;
  h := g; g[1][2] := 0;
  Out.Int(h[1, 2], 0); Out.Int(g[1, 2], 2); Out.Int(LEN(g), 2); Out.Int(LEN(g[0]), 2); Out.Int(Width(h), 2); Out.Ln;
  v[2] := a; v[3][0] := 4;
  Out.Int(Total(v), 0); Out.Ln;
  Bump(a[2]); Out.Int(a[2], 0); Out.Ln;
  Bump(v[2][0]); Out.Int(v[2, 0], 0); Out.Int(a[0], 2); Out.Ln;
  Out.Int(LocalCopy(a), 0); Out.Int(a[0], 2); Out.Ln;
  bytes[1] := 250; INC(bytes[1], 10); Out.Int(bytes[1], 0); Out.Ln;
  reals[1] := 1.5; reals[1] := reals[1] * 2.0; Out.Int(FLOOR(reals[1]), 0); Out.Ln;
  INCL(sets[1], 3); Out.Int(ORD(sets[1]), 0); Out.Int(ORD(sets[0]), 2); Out.Ln;
  i := 0; a[i] := 5; INC(i); a[i] := a[i - 1] + 1; Out.Int(a[1], 0); Out.Ln
END Arrays.
