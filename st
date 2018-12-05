#!/usr/bin/python3
import os
import sys
import subprocess


def get_dos_path(path):
    unix_path = os.path.realpath(path)
    dos_path = subprocess.Popen("wslpath -aw '{0}'".format(unix_path), shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE).stdout.read().strip().decode()
    if dos_path:
        dos_path = dos_path.replace("\\", "\\\\")
    else:
        dos_path = (os.environ["WSL_PATH"] + unix_path).replace("/", "\\\\")
    return dos_path


def main():
    if len(sys.argv) <= 1:
        shell_path = "D:\\\\Applications\\\\wsl-terminal\\\\open-wsl.exe"
        current_path = os.getcwd()
        os.system("/mnt/c/Windows/System32/cmd.exe /c start {0} -C {1}".format(shell_path, current_path))
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

    if os.path.exists(path):
        real_path = get_dos_path(path)
        if method == "-d":
            os.system("/mnt/c/Windows/System32/cmd.exe /c start '' '{0}'".format(real_path))
        elif method == "-c":
            os.system("/mnt/c/Windows/System32/cmd.exe /c rundll32.exe shell32,OpenAs_RunDLL {0}".format(real_path))
    else:
        print("{0}: no such file or directory: {1}".format(os.path.basename(sys.argv[0]), path))
    return


if __name__ == '__main__':
    main()
