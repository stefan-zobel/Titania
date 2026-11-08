# Tests of the compiler oberonc

The programs and expected outputs in this directory are from the test suite of
[oberonc](https://github.com/lboasso/oberonc), copyright Luca Boasso, under the
MIT license in `LICENSE.txt`. They run with the option `-oberonc` of Titania.

## Differences from the original suite

Left out:

| Program | Reason |
|---|---|
| `TestCmdLineArgs` | needs `ARGS`, and writes to a value parameter |
| `TestConstFunc` | needs `AND`, `BOR` and `NOT` in constant expressions |
| `TestImport100`, `TestSystemVal` | need the module `SYSTEM` |
| `TestImport110` to `TestImport112` | need a `DEFINITION` module |
| `TestCyclicImport*` | test the handling of symbol files |
| `RecordParam` | relies on copy-in, copy-out for a `VAR` parameter that is a record field; with the aliasing of the report, the program dereferences `NIL` |
| `ArrayConstantSize`, `TestReadOnlyPar`, `TestExprVarPar` | expect several error messages; Titania stops at the first error |

Changed:

- `Pattern1`, `Pattern2b`, `Pattern2c`, `SetTest` and `VarInit` use `ORD(s)`
  instead of `SYSTEM.VAL(INTEGER, s)`.
- In `SetTest.txt`, the line for `{x..3}` with `x = 30` is empty, since the set is
  empty according to the report, and the membership test of `-100` is false.
- In `TestOOP.txt`, a value printed with six decimals differs, since `REAL` has 64
  bits in Titania and 32 bits in `oberonc`.
- `NAME.in` holds the input that the original test runner passes to the program.
