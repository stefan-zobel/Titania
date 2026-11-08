# Titania design

Titania is an AST-walking interpreter for Oberon-07, written in Algol 68 and
compiled with a68j. It loads one source file, together with the modules that
file imports, and runs it. There is no REPL.

The program is a showcase for Algol 68: the syntax tree is a `union` handled
with conformity clauses, `VAR` parameters are references, and storage
management is left to the garbage collector. It uses only the standard prelude
and the POSIX module, so it needs neither `-fnest-java` nor any Java code.

Speed is secondary.

## Language

Titania implements the Oberon-07 report of 3 May 2016, without the module
`SYSTEM`.

### Accepted for Oberon-2 programs

Titania is not an Oberon-2 interpreter. It accepts exactly the additions below,
which are the ones needed by the simplest 44 of the 134 Oberon-2 programs on
Rosetta Code.

| Addition | Meaning |
|---|---|
| `SHORTINT`, `LONGINT` | predeclared synonyms of `INTEGER` |
| `SHORTREAL`, `LONGREAL` | predeclared synonyms of `REAL` |
| `ENTIER(x)` | same as `FLOOR(x)` |
| `LONG(x)`, `SHORT(x)` | identity |
| `MIN(T)`, `MAX(T)` | limits of `INTEGER`, `REAL`, `CHAR`, `BYTE` and `SET` |
| `CAP(c)` | upper-case letter |
| `ASH(x, n)` | arithmetic shift, left if `n` is positive |
| `COPY(src, dst)` | string copy, truncating to the length of `dst` |
| `HALT(n)` | ends the program with exit status `n` |
| `RETURN x;` | a semicolon can follow the expression of the final `RETURN` |
| Mixed numeric operands | an `INTEGER` operand of an arithmetic operator next to a `REAL` is converted, and `/` of two integers yields a `REAL` |
| Numeric assignment | an `INTEGER` can be assigned or passed as a value to a `REAL` |
| Declaration order | `CONST`, `TYPE`, `VAR` and procedure declarations can repeat and come in any order |
| `Out.Real(x)`, `Out.LongReal(x)` | the width can be omitted |

The synonyms are ordinary predeclared identifiers bound to the same type object,
so a program can still redeclare them.

Like Wirth's compiler, and unlike the grammar in the report, Titania accepts a
procedure type as the type of a formal parameter.

Not accepted: `RETURN` in the middle of a body, `LOOP`, `EXIT`, `WITH`,
`CASE ... ELSE`, single-quoted strings, type-bound procedures,
`POINTER TO ARRAY`, `NEW(p, n)`, `LEN(a, n)` and `SIZE`.

### Basic types

| Oberon | Algol 68 | Notes |
|---|---|---|
| `INTEGER` | `int` | 32 bits |
| `BYTE` | `int` | reduced to 0..255 on store |
| `REAL` | `long real` | 64 bits, the report leaves the size open |
| `BOOLEAN` | `bool` | |
| `CHAR` | `char` | `CHR` reduces its operand to 0..65535, as `oberonc` does |
| `SET` | `bits` | elements 0..31; element `e` is `ELEM` position `32 - e` |

`MOD` yields a remainder in `0 .. ABS(y) - 1`, like the Algol 68 `%*`, and `DIV`
is the matching quotient. For a positive divisor this is the floored division of
the report; for a negative divisor it matches `oberonc`. A zero divisor is a
runtime error.

## Structure

The source is split into files with one-way dependencies, in this order:

| File | Contents |
|---|---|
| `src/scanner.a68` | symbols, positions, diagnostics |
| `src/syntax.a68` | modes of types, objects, tree nodes and runtime values; operations on values |
| `src/library.a68` | native `Out`, `In`, `Math` and `Strings` |
| `src/parser.a68` | single-pass parser with type checking; builds the tree and resolves names |
| `src/interp.a68` | `eval`, `exec`, `locate`, module initialization |
| `src/titania.a68` | command line; includes the other files |

The files are not Algol 68 modules: `titania.a68` includes them with
`[[ include "file" ]]`, and `build.sh` compiles the result into `titania.jar`.
With modules, a68j 0.6.0 cannot compile Titania. The key of a public identifier
spells out its mode to a depth of 12, and for the mutually recursive modes `Expr`
and `Value` a key exceeds the 65535 bytes of a class file constant.

### Front end

As in Wirth's compilers, one pass over the source parses, checks types and
builds the tree. Oberon-07 requires declaration before use, except for the base
type of a pointer, which is resolved at the end of the enclosing scope. Scopes
are linear lists of objects, as in Wirth's compilers.

The parser resolves every name. A node holds a frame slot, a global slot, a
field index or a reference to a procedure definition, so the interpreter never
looks up an identifier.

`IMPORT` is handled by the parser. A module `M` is read from the file `M.Mod`, in
the directory of the importing file or else in a directory given with `-I`, and
the file must contain the module `M`. If there is no such file, `M` can be a
built-in module, so a file takes precedence over a built-in module of the same
name. Every module is parsed once, in the scope of the predeclared identifiers,
and importing a module that is still being parsed is an error. A module body runs
after the bodies of the modules it imports.

Exported objects are looked up in the scope of the module, which keeps its
private objects too; a lookup from outside accepts only those marked with `*`. A
field remembers the source that declares it, for the same check on field
selection. An imported variable, including its elements and fields, is read-only.

## Runtime values

```
mode Value = union (int, long real, bool, char, bits,
                    ref Array_obj, ref Record_obj, ref Proc_def, Var_ref);
mode Var_ref = struct (ref Value target);
mode Array_obj = struct (ref [] Value elems);
mode Record_obj = struct (ref Type dyn_type, ref [] Value fields);
```

A `ref` row or `ref Value` cannot be a direct alternative of the union, since
the mode would not be well formed; the wrapper structures are needed for that
reason.

- **Aggregates** are always `ref Array_obj` or `ref Record_obj`. A slot of array
  or record type owns its object, which is created when the frame is set up.
  Assignment copies deeply, guided by the static type. Assigning an extended
  record copies only the fields of the destination type, which come first in
  `fields`. A source array can be shorter than the destination, as a string or
  an open array can; a longer one is a runtime error.
- **Pointers** are `ref Record_obj` or `nil`, and share the object. `NEW`
  allocates it and records its dynamic type.
- **Procedure values** are `ref Proc_def` or `nil`.
- **`VAR` parameters** of scalar, pointer or procedure type hold a `Var_ref` to
  the actual variable, which can be a frame slot, a global, an array element or
  a record field. `VAR` parameters of aggregate type share the object, which
  also carries the length and the dynamic type.
- **Structured value parameters** are read-only in Oberon-07 and are shared
  without copying. Open arrays need no extra handling, since the object knows
  its length.

## Execution

Three mutually recursive procedures walk the tree:

- `eval (Expr, base) Value` computes an expression;
- `exec (Stmt, base) void` executes a statement;
- `locate (Expr, base) ref Value` yields the variable of a designator.

`Expr` and `Stmt` are unions of references to structures. Two structures with the
same field names and modes are the same mode and would collapse into one
alternative, so every node has a distinct set of field names.

Oberon-07 allows `RETURN` only at the end of a function, so a call runs the body
and then evaluates the result expression. Statements need no status result, and
no jumps are used.

Local variables live in one shared stack `ref [] Value`, and `base` is the
position of the current frame. Inner procedures can reach only their own locals
and globals, so no static links are needed. The global variables of all modules
occupy the bottom of the stack.

Prototype measurements on a68j 0.6.0 and JDK 25, including JVM startup:

| Variant | 30 million loop iterations | `fib(35)` |
|---|---|---|
| Typed evaluator, new row per call | 3.2 s | 9.4 s |
| Generic evaluator, new row per call | 3.9 s | 9.2 s |
| Typed evaluator, shared stack | not measured | 3.6 s |
| Generic evaluator, shared stack | 4.7 s | 4.1 s |
| Titania at milestone 1 | 5.8 s | 6.1 s |

Titania therefore uses one generic evaluator and the shared stack. A stack of
4 million slots adds 0.5 s to startup, so the stack has 1 million slots, with a
runtime error on overflow.

The JVM thread that runs an a68j program has a 128 MiB stack, and exhausting it
ends the program with exit status 139. Titania therefore limits calls to a depth
of 50000, which leaves room for deeply nested statements in each call: a
procedure with five nested statements and expressions survived 50000 calls and
failed at 100000.

## Library

The Oberon-07 report defines no input or output, so these modules are built in. A
table gives the module, the Oberon heading and the Algol 68 routine of each entry; the
parser reads the headings when the module is imported. An entry can also be a
constant (`CONST pi = ...`) or a variable (`VAR Done: BOOLEAN`), which is read by
calling its routine.

| Module | Contents |
|---|---|
| `Out` | `Open`, `Char`, `String`, `Int`, `LongInt`, `Real`, `LongReal`, `Fixed`, `Ln`, `Hex`, `Flush` |
| `In` | `Open`, `Int`, `LongInt`, `Real`, `LongReal`, `Char`, `String`, `Done` |
| `Math`, `MathL` | `pi`, `e`, and `sqrt`, `power`, `exp`, `ln`, `log`, `round`, `sin`, `cos`, `tan`, `arcsin`, `arccos`, `arctan`, `arctan2`, `sinh`, `cosh`, `tanh`, `arcsinh`, `arccosh`, `arctanh`, each also with the Oakwood spelling (`Sqrt`, `ArcSinH`, ...) |
| `Strings` | `Length`, `Append`, `Insert`, `Delete`, `Replace`, `Extract`, `Pos`, `Cap`, `Copy`, `Write`, `WriteChar`, `AppendChar`, `WriteInt`, `AppendInt` |

The formats of `Out` follow `oberonc`. `In.String` reads the rest of the line, and
the numeric procedures read one word of the input.

With the option `-oberonc`, the universe also has the names that the test programs
of `oberonc` use: `WriteInt`, `WriteChar`, `WriteLn`, `WriteReal`, `ReadInt`,
`eot`, `AND`, `BOR` and `NOT`. The option also accepts a local procedure as a value,
which needs no support in the interpreter since a procedure can reach only its
own frame and the globals, and a `BYTE` variable as the control variable of a `FOR`
statement.

## Diagnostics

| Situation | Output | Exit status |
|---|---|---|
| Error in the source | `FILE:LINE:COLUMN: error: MESSAGE` | 1 |
| Runtime error | `FILE:LINE: runtime error: MESSAGE` | 2 |
| `HALT(n)` | none | `n` |

The command line is `titania [-I DIRECTORY]... [-oberonc] FILE`.

A source error is reported at the last symbol of the construct that was parsed,
or, if a symbol was expected, at the symbol found instead.

Runtime errors are array bounds, array copy overflow, `NIL` dereference, failed
type guards, failed `ASSERT`, a `CASE` on numbers or characters without a matching
label, a zero divisor and stack overflow.

The report leaves some cases open, and Titania then behaves like `oberonc`:
`NIL IS T` is false, a type guard lets `NIL` pass, and a `CASE` on types without a
matching arm does nothing.

## Testing

- `oberonc` (<https://github.com/lboasso/oberonc>, MIT license) is the reference
  compiler. It runs on the JVM and is used to compare outputs.
- Its test suite is copied to `tests/oberonc`, with its license and a list of what
  was left out or changed. All remaining programs pass.
- `oberonc` has a 32-bit `REAL`, so the last digits of printed reals can differ.
- `oberonc` deviates from the report in places. It treats `{m .. n}` with `m > n`
  as non-empty, rejects unused local variables and empty `CASE` arms, lacks
  `PACK` and `UNPK`, and rejects a procedure constant as an actual parameter or
  in a comparison. Titania follows the report.
- `tools/run_tests.py` runs `tests/`. The expected output in `tests/core` is
  recorded from `oberonc`; `tests/spec`, `tests/import`, `tests/errors` and
  `tests/runtime` are written by hand and cover behavior the reference does not
  share.
- Rosetta Code: the 106 Oberon-07 programs and the selected 44 Oberon-2 programs
  were run with Titania and, where it accepts them, with `oberonc`. The outputs
  are the same, except that five programs print real numbers that differ in the
  last digits or, in one case, an iteration count that depends on the size of
  `REAL`. The programs that fail need another module from Rosetta Code or a system
  module such as `Files` (31 of them) or `SYSTEM` (2), contain an error
  (`Averages/Arithmetic mean` calls a procedure with too few parameters,
  `Case-sensitivity of identifiers` uses an undeclared type `STRING`, and `D1` in
  `Scope modifiers` lacks a semicolon), or stop on purpose (`Assertions`). Four
  programs need more than five minutes.
