MODULE NilDeref;
  TYPE R = RECORD a: INTEGER END;
       R1 = RECORD (R) b: INTEGER END;
       R2 = RECORD (R) c: INTEGER END;
       P = POINTER TO R;
       P1 = POINTER TO R1;
       P2 = POINTER TO R2;
  VAR p: P;
BEGIN
  p.a := 1
END NilDeref.
