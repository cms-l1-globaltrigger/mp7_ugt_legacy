# Toolbox

import datetime
import glob
import shutil
import stat
import pwd
import socket
import sys, os

def build_t(value):
    """Custom build type validator for argparse. Argument value must be of
    format 0x1234, else an exception of type ValueError is raised.
    >>> parser.add_argument('-b', type=built_t)
    """
    try: return "{0:04x}".format(int(value, 16))
    except ValueError: raise TypeError("Invalid build version: `{0}'".format(value))

def remove(filename):
    """Savely remove a directory, file or a symbolic link."""
    if os.path.isfile(filename):
        os.remove(filename)
    elif os.path.islink(filename):
        os.remove(filename)
    elif os.path.isdir(filename):
        shutil.rmtree(filename)

def clear_file(filename):
    """Create an empty file and clears its content if the file already exists."""
    with open(filename, 'w'): pass

def read_file(filename):
    """Returns contents of a file.
    >>> read_file('spanish_inquisition.txt')
    'NO-body expects the Spanish Inquisition!\n'
    """
    with open(filename, 'rb') as fp:
        return fp.read()

def make_executable(filename):
    """Set executable flag for file."""
    st = os.stat(filename)
    os.chmod(filename, st.st_mode | stat.S_IEXEC)

def template_replace(template, replace_map, result):
    """Load template by replacing keys from dictionary and writing to result
    file. The function ignores VHDL escaped lines.

    Example:
    >>> template_replace('sample.tpl.vhd', {'name': "title"}, 'sample.vhd')

    """
    # Read content of source file.
    with open(template, 'rb') as fp:
        lines = fp.readlines()
    # Replace placeholders.
    for key, value in replace_map.items():
        for i, line in enumerate(lines):
            # Ignore VHDL comments
            if not line.strip().startswith('--'):
                lines[i] = line.replace(key, value)
    # Write content to destination file.
    with open(result, 'wb') as fp:
        fp.write(''.join(lines))

def count_modules(menu):
    """Returns count of modules of menu. *menu* is the path to the menu directory."""
    pattern = os.path.join(menu, 'vhdl', 'module_*')
    return len(glob.glob(pattern))

def timestamp():
    """Returns ISO timestamp of curretn tiem and date."""
    return datetime.datetime.now().strftime("%Y-%m-%d-T%H-%M-%S")

def hostname():
    """Returns UNIX machine hostname."""
    return socket.gethostname()

def username():
    """Returns UNIX login name."""
    login = 0
    return pwd.getpwuid(os.getuid())[login]
