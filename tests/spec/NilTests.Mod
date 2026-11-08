MODULE NilTests;
  (* NIL in type tests, and a type case without a matching arm. *)
  IMPORT Out;
  TYPE R = RECORD a: INTEGER END;
       R1 = RECORD (R) b: INTEGER END;
       R2 = RECORD (R) c: INTEGER END;
       P = POINTER TO R;
       P1 = POINTER TO R1;
       P2 = POINTER TO R2;
  VAR p: P; q: P1; s: P2;
BEGIN
  IF p IS P1 THEN Out.String("yes") ELSE Out.String("no") END; Out.Ln;
  q := p(P1); IF q = NIL THEN Out.String("nil passes") END; Out.Ln;
  CASE p OF P1: Out.String("one") END; Out.String("after nil"); Out.Ln;
  NEW(s); p := s;
  CASE p OF P1: Out.String("one") END; Out.String("after no match"); Out.Ln
END NilTests.
