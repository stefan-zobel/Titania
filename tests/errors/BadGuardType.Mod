MODULE BadGuardType;
  TYPE R = RECORD a: INTEGER END;
       R1 = RECORD (R) b: INTEGER END;
       R2 = RECORD (R) c: INTEGER END;
       P = POINTER TO R;
       P1 = POINTER TO R1;
       P2 = POINTER TO R2;
  VAR p: P1; q: P2;
BEGIN
  q := p(P2)
END BadGuardType.
