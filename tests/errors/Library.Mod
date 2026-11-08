MODULE Library;
  CONST open* = 1; closed = 2;
  TYPE R* = RECORD a*, b: INTEGER END;
  VAR v*: INTEGER; w: INTEGER; arr*: ARRAY 2 OF INTEGER; r*: R;
BEGIN w := closed
END Library.
