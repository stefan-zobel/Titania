MODULE Procs;
  IMPORT O := Out;
  CONST ten = 10;
  TYPE Op = PROCEDURE (a, b: INTEGER): INTEGER;
       Action = PROCEDURE;
  VAR g, h: INTEGER; f: Op; act: Action; r: REAL;

  PROCEDURE Add(a, b: INTEGER): INTEGER;
    RETURN a + b
  END Add;

  PROCEDURE Mul(a, b: INTEGER): INTEGER;
    VAR p: INTEGER;
  BEGIN p := a * b
    RETURN p
  END Mul;

  PROCEDURE Fib(n: INTEGER): INTEGER;
    VAR res: INTEGER;
  BEGIN
    IF n < 2 THEN res := n ELSE res := Fib(n - 1) + Fib(n - 2) END
    RETURN res
  END Fib;

  PROCEDURE Swap(VAR a, b: INTEGER);
    VAR t: INTEGER;
  BEGIN t := a; a := b; b := t
  END Swap;

  PROCEDURE IncTwice(VAR v: INTEGER);
    PROCEDURE Once(VAR w: INTEGER);
    BEGIN INC(w)
    END Once;
  BEGIN Once(v); Once(v)
  END IncTwice;

  PROCEDURE Forward(VAR v: INTEGER);
  BEGIN IncTwice(v); v := v * 2
  END Forward;

  PROCEDURE Hello;
  BEGIN O.String("hello"); O.Ln
  END Hello;

  PROCEDURE Apply(op: Op; a, b: INTEGER): INTEGER;
    RETURN op(a, b)
  END Apply;

  PROCEDURE Locals(n: INTEGER): INTEGER;
    VAR a, b: INTEGER;
  BEGIN
    a := n; b := a + 1;
    IF n > 0 THEN a := a + Locals(n - 1) END
    RETURN a + b
  END Locals;

  PROCEDURE Parameterless(): INTEGER;
    RETURN 7
  END Parameterless;

  PROCEDURE Shadow(g: INTEGER): INTEGER;
    CONST ten = 20;
    RETURN g + ten
  END Shadow;

BEGIN
  O.Int(Add(1, 2), 0); O.Char(" "); O.Int(Mul(3, 4), 0); O.Ln;
  O.Int(Fib(15), 0); O.Ln;
  g := 1; h := 2; Swap(g, h); O.Int(g, 0); O.Int(h, 2); O.Ln;
  IncTwice(g); O.Int(g, 0); O.Ln;
  Forward(g); O.Int(g, 0); O.Ln;
  Hello;
  f := Add; O.Int(f(5, 6), 0); O.Ln;
  f := Mul; O.Int(Apply(f, 5, 6), 0); O.Ln;
  act := Hello; act;
  act := NIL;
  IF act = NIL THEN O.String("nil") END;
  IF f # NIL THEN O.String(" set") END;
  O.Ln;
  O.Int(Locals(3), 0); O.Ln;
  r := 1.5; O.Int(FLOOR(r * 8.0), 0); O.Ln;
  O.Int(Parameterless(), 0); O.Int(Shadow(1), 3); O.Int(ten, 3); O.Ln;
  O.Int(Add(Fib(5), Add(Fib(6), Mul(2, Fib(3)))), 0); O.Ln
END Procs.
