MODULE BadGuard;
  TYPE R = RECORD a: INTEGER END;
       R1 = RECORD (R) b: INTEGER END;
       R2 = RECORD (R) c: INTEGER END;
       P = POINTER TO R;
       P1 = POINTER TO R1;
       P2 = POINTER TO R2;
  VAR p: P; q: P1; s: P2;
BEGIN
  NEW(s);
  p := s;
  q := p(P1)
END BadGuard.
