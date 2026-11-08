MODULE NoExtend;
  TYPE R = RECORD a: INTEGER END;
       R1 = RECORD (R) b: INTEGER END;
       R2 = RECORD (R) c: INTEGER END;
       P = POINTER TO R;
       P1 = POINTER TO R1;
       P2 = POINTER TO R2;
  VAR b: R; e: R1;
BEGIN
  e := b
END NoExtend.
