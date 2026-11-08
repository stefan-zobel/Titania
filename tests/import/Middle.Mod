MODULE Middle;
  IMPORT B := Base, Out;
  TYPE Point3* = RECORD (B.Point) z*: INTEGER END;
  VAR p*: Point3;

  PROCEDURE Sum*(q: B.Point): INTEGER;
    RETURN q.x + q.y
  END Sum;

BEGIN
  p.x := 3; p.y := 4; p.z := 5;
  B.Bump(1);
  Out.String("init Middle"); Out.Ln
END Middle.
