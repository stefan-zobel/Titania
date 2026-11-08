MODULE Recursion;
  VAR r: INTEGER;
  PROCEDURE P(n: INTEGER): INTEGER;
    RETURN P(n + 1)
  END P;
BEGIN
  r := P(0)
END Recursion.
