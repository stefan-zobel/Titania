#!/usr/bin/env python3
"""Runs Titania on Oberon programs and compares the results.

Every NAME.Mod with a NAME.txt in the given directories (default: all of
tests/) is a test; a NAME.Mod without one is a module that tests import.
NAME.txt holds the expected standard output, and NAME.in, if present, the
standard input, and NAME.args, if present, more options for Titania, in which
{dir} stands for the directory of the test. For a test in a directory named errors or runtime, NAME.txt
holds the expected first line of the standard error stream, with the path of
the source reduced to its file name, and the exit status must be 1 or 2.
Programs in a directory named oberonc run with the option -oberonc.

With --record, the expected output of a program is taken from the reference
compiler oberonc instead of being compared (directory core only).

Environment:
  JAVA        the java launcher of JDK 25 or later (default: java)
  A68J_HOME   directory with a68j-runtime.jar (default: ../a68j/backend)
  OBERON_BIN  the bin directory of oberonc (for --record only)
"""
import argparse
import os
import shutil
import subprocess
import sys
import tempfile

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
JAVA = os.environ.get('JAVA', 'java')
A68J_HOME = os.environ.get('A68J_HOME', os.path.join(ROOT, '..', 'a68j', 'backend'))
SEP = os.pathsep
TIMEOUT = 120


def titania(source):
    cp = SEP.join([os.path.join(ROOT, 'titania.jar'),
                   os.path.join(A68J_HOME, 'a68j-runtime.jar')])
    command = [JAVA, '-cp', cp, 'Titania']
    args_file = os.path.splitext(source)[0] + '.args'
    if os.path.exists(args_file):
        with open(args_file, encoding='utf-8') as f:
            command += f.read().replace('{dir}', os.path.dirname(source)).split()
    if os.path.basename(os.path.dirname(source)) == 'oberonc':
        command.append('-oberonc')
    input_file = os.path.splitext(source)[0] + '.in'
    stdin = b''
    if os.path.exists(input_file):
        with open(input_file, 'rb') as f:
            stdin = f.read()
    return subprocess.run(command + [source], input=stdin, capture_output=True,
                          timeout=TIMEOUT)


def oberonc(source):
    """Compiles and runs source with the reference compiler; returns stdout."""
    bin_dir = os.environ['OBERON_BIN']
    env = dict(os.environ, OBERON_BIN=bin_dir)
    locale = ['-Duser.language=en', '-Duser.country=US']
    name = os.path.splitext(os.path.basename(source))[0]
    with tempfile.TemporaryDirectory() as out:
        copy = os.path.join(out, os.path.basename(source))
        shutil.copy(source, copy)
        subprocess.run([JAVA] + locale + ['-cp', bin_dir, 'oberonc', '.', copy],
                       cwd=out, env=env, check=True, capture_output=True,
                       timeout=TIMEOUT)
        run = subprocess.run([JAVA] + locale + ['-cp', bin_dir + SEP + '.', name],
                             cwd=out, env=env, capture_output=True,
                             stdin=subprocess.DEVNULL, timeout=TIMEOUT)
        return run.stdout


def normalize(data):
    return data.decode('utf-8', 'replace').replace('\r\n', '\n')


def tests_in(paths):
    for path in paths:
        if os.path.isfile(path):
            yield path
            continue
        for directory, _, files in sorted(os.walk(path)):
            for f in sorted(files):
                if f.endswith('.Mod') and f[:-4] + '.txt' in files:
                    yield os.path.join(directory, f)


def check(source):
    """Returns None if the test passes, else a description of the failure."""
    expected_file = os.path.splitext(source)[0] + '.txt'
    with open(expected_file, encoding='utf-8', newline='') as f:
        expected = f.read().replace('\r\n', '\n')
    result = titania(source)
    kind = os.path.basename(os.path.dirname(source))
    if kind in ('errors', 'runtime'):
        status = 1 if kind == 'errors' else 2
        first = normalize(result.stderr).split('\n')[0]
        first = first.replace(os.path.dirname(source) + os.sep, '')
        if result.returncode != status:
            return 'exit status %d: %s' % (result.returncode, first)
        if first != expected.strip():
            return 'expected: %s\n     got: %s' % (expected.strip(), first)
        return None
    out = normalize(result.stdout)
    if result.returncode != 0:
        return 'exit status %d\n%s' % (result.returncode, normalize(result.stderr))
    if out != expected:
        return 'output differs\n--- expected\n%s--- got\n%s' % (expected, out)
    return None


def main():
    sys.stdout.reconfigure(errors='backslashreplace')
    ap = argparse.ArgumentParser()
    ap.add_argument('--record', action='store_true')
    ap.add_argument('paths', nargs='*')
    args = ap.parse_args()
    paths = args.paths or [os.path.join(ROOT, 'tests')]
    failed = total = 0
    for source in tests_in(paths):
        if args.record:
            if os.path.basename(os.path.dirname(source)) != 'core':
                continue
            with open(os.path.splitext(source)[0] + '.txt', 'w',
                      encoding='utf-8', newline='\n') as f:
                f.write(normalize(oberonc(source)))
            print('recorded', source)
            continue
        total += 1
        problem = check(source)
        if problem:
            failed += 1
            print('FAIL', source, problem, sep='\n  ')
    if not args.record:
        print('%d tests, %d failed' % (total, failed))
    sys.exit(1 if failed else 0)


if __name__ == '__main__':
    main()
