#!/usr/bin/python3
import os
import sys
import subprocess


def get_dos_path(path):
    unix_path = os.path.realpath(path)
    dos_path = subprocess.Popen("wslpath -aw '{0}'".format(unix_path), shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE).stdout.read().strip().decode()
    return dos_path


def main():
    if len(sys.argv) <= 1:
        print("help: -c|-d")
        return
    elif len(sys.argv) == 3 and (sys.argv[1] == "-c" or sys.argv[2] == "-c"):
        method = "-c"
        path = sys.argv[1] if sys.argv[2] == "-c" else sys.argv[2]
    elif len(sys.argv) == 3 and (sys.argv[1] == "-d" or sys.argv[2] == "-d"):
        method = "-d"
        path = sys.argv[1] if sys.argv[2] == "-d" else sys.argv[2]
    else:
        method = "-d"
        path = sys.argv[1]

    shell_path = "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe"
    if os.path.exists(path):
        real_path = get_dos_path(path)
        print(real_path)
        if method == "-d":
            os.system("{0} /c start '' '{1}'".format(shell_path, real_path))
        elif method == "-c":
            os.system("{0} /c rundll32.exe shell32,OpenAs_RunDLL {1}".format(shell_path, real_path))
    else:
        print("{0}: no such file or directory: {1}".format(os.path.basename(sys.argv[0]), path))
    return


if __name__ == '__main__':
    main()
