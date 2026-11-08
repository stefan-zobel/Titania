MODULE OuterLocal;
  PROCEDURE P;
    VAR v: INTEGER;
    PROCEDURE Q;
    BEGIN v := 1
    END Q;
  BEGIN Q
  END P;
END OuterLocal.
