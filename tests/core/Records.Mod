MODULE Records;
  IMPORT Out;
  TYPE Base = RECORD x: INTEGER END;
       Ext = RECORD (Base) y: INTEGER; tags: ARRAY 2 OF INTEGER END;
       Ext2 = RECORD (Ext) z: REAL END;
       Point = RECORD a, b: INTEGER END;
       Line = RECORD from, to: Point; name: ARRAY 8 OF CHAR END;
       Node = POINTER TO NodeDesc;
       NodeDesc = RECORD value: INTEGER; next: Node END;
       Tree = POINTER TO TreeDesc;
       TreeDesc = RECORD key: INTEGER; left, right: Tree END;
       Shape = POINTER TO ShapeDesc;
       ShapeDesc = RECORD id: INTEGER END;
       Circle = POINTER TO CircleDesc;
       CircleDesc = RECORD (ShapeDesc) r: INTEGER END;
       Square = POINTER TO SquareDesc;
       SquareDesc = RECORD (ShapeDesc) side: INTEGER END;
       Handler = RECORD run: PROCEDURE (n: INTEGER): INTEGER END;
  VAR b: Base; e: Ext; e2: Ext2; l, m: Line; list, n: Node; i, s: INTEGER;
      root: Tree; sh: Shape; c: Circle; q: Square; h: Handler;
      lines: ARRAY 2 OF Line;

  PROCEDURE SetX(VAR v: Base; value: INTEGER);
  BEGIN v.x := value
  END SetX;

  PROCEDURE Describe(VAR v: Base);
  BEGIN
    IF v IS Ext2 THEN Out.String("ext2") ELSIF v IS Ext THEN Out.String("ext") ELSE Out.String("base") END;
    Out.Ln
  END Describe;

  PROCEDURE GetY(VAR v: Base): INTEGER;
    RETURN v(Ext).y
  END GetY;

  PROCEDURE ReadA(p: Point): INTEGER;
    RETURN p.a
  END ReadA;

  PROCEDURE Insert(VAR t: Tree; key: INTEGER);
  BEGIN
    IF t = NIL THEN NEW(t); t.key := key; t.left := NIL; t.right := NIL
    ELSIF key < t.key THEN Insert(t.left, key)
    ELSE Insert(t.right, key)
    END
  END Insert;

  PROCEDURE Walk(t: Tree);
  BEGIN
    IF t # NIL THEN Walk(t.left); Out.Int(t.key, 3); Walk(t.right) END
  END Walk;

  PROCEDURE Area(p: Shape): INTEGER;
    VAR result: INTEGER;
  BEGIN result := 0;
    CASE p OF
      Circle: result := 3 * p.r * p.r
    | Square: result := p.side * p.side
    END
    RETURN result
  END Area;

  PROCEDURE Which(VAR v: Base);
  BEGIN
    CASE v OF
      Ext2: Out.String("case ext2 "); Out.Int(FLOOR(v.z), 0)
    | Ext: Out.String("case ext "); Out.Int(v.y, 0)
    | Base: Out.String("case base "); Out.Int(v.x, 0)
    END;
    Out.Ln
  END Which;

  PROCEDURE Double(n: INTEGER): INTEGER;
    RETURN 2 * n
  END Double;

BEGIN
  e.x := 1; e.y := 2; e.tags[1] := 3;
  b := e; Out.Int(b.x, 0); Out.Ln;
  SetX(b, 5); SetX(e, 6); SetX(e2, 7);
  Out.Int(b.x, 0); Out.Int(e.x, 2); Out.Int(e2.x, 2); Out.Ln;
  e2.y := 8; e2.z := 2.5;
  Describe(b); Describe(e); Describe(e2);
  Which(b); Which(e); Which(e2);
  Out.Int(GetY(e2), 0); Out.Ln;
  e2.tags[0] := 9;
  e := e2; e2.tags[0] := 0; Out.Int(e.tags[0], 0); Out.Int(e.y, 2); Out.Ln;
  l.from.a := 1; l.to.b := 2; l.name := "abc";
  m := l; l.from.a := 9; l.name[0] := "z";
  Out.Int(m.from.a, 0); Out.Int(m.to.b, 2); Out.Char(" "); Out.String(m.name); Out.Char(" "); Out.String(l.name); Out.Ln;
  Out.Int(ReadA(m.from), 0); Out.Ln;
  lines[1] := m; lines[0].to := lines[1].to; Out.Int(lines[0].to.b, 0); Out.Ln;
  list := NIL;
  FOR i := 1 TO 5 DO NEW(n); n.value := i * i; n.next := list; list := n END;
  s := 0; n := list;
  WHILE n # NIL DO s := s + n.value; n := n.next END;
  Out.Int(s, 0); Out.Int(list^.value, 3); Out.Ln;
  n := list; n.next.value := 0; Out.Int(list.next.value, 0); Out.Ln;
  root := NIL;
  Insert(root, 5); Insert(root, 2); Insert(root, 8); Insert(root, 1);
  Walk(root); Out.Ln;
  NEW(c); c.id := 1; c.r := 2; NEW(q); q.id := 2; q.side := 3;
  sh := c; Out.Int(Area(sh), 0); Out.Int(sh.id, 3); Out.Ln;
  sh := q; Out.Int(Area(sh), 0); Out.Ln;
  IF sh IS Square THEN Out.String("square") END;
  IF ~(sh IS Circle) THEN Out.String(" notcircle") END;
  Out.Ln;
  q := sh(Square); q.side := 4; Out.Int(sh(Square).side, 0); Out.Ln;
  h.run := Double; Out.Int(h.run(21), 0); Out.Ln
END Records.
