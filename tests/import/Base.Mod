MODULE Base;
  (* Imported by several modules; initialized once. *)
  IMPORT Out;
  CONST limit* = 3; hidden = 9;
  TYPE
    Point* = RECORD x*, y*: INTEGER; secret: INTEGER END;
    Node* = POINTER TO NodeDesc;
    NodeDesc* = RECORD value*: INTEGER; next*: Node END;
    Fn* = PROCEDURE (n: INTEGER): INTEGER;
  VAR count*: INTEGER; origin*: Point; table*: ARRAY 3 OF INTEGER; first*: Node;

  PROCEDURE Bump*(n: INTEGER);
  BEGIN count := count + n
  END Bump;

  PROCEDURE Twice*(n: INTEGER): INTEGER;
    RETURN 2 * n
  END Twice;

  PROCEDURE MakeNode*(v: INTEGER; next: Node): Node;
    VAR n: Node;
  BEGIN NEW(n); n.value := v; n.next := next
    RETURN n
  END MakeNode;

  PROCEDURE SetSecret*(VAR p: Point; v: INTEGER);
  BEGIN p.secret := v + hidden
  END SetSecret;

  PROCEDURE Secret*(p: Point): INTEGER;
    RETURN p.secret
  END Secret;

BEGIN
  count := 10; origin.x := 1; origin.y := 2; table[1] := 7;
  first := MakeNode(5, NIL);
  Out.String("init Base"); Out.Ln
END Base.
