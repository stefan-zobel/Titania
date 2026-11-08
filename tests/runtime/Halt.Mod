MODULE Halt;
  IMPORT Out;
BEGIN
  Out.String("before"); Out.Ln;
  HALT(2);
  Out.String("after")
END Halt.
