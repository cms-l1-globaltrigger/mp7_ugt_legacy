#Philipp Wanggo
#Error Tester
#06.07.2017
import sys
import os
import argparse
import logging


whitered = "\033[37;41;1m"#collors
yellowwhite = "\033[43;37;1m"
reset = "\033[0m"
o, ts = os.popen('stty size', 'r').read().split()
ts = int(ts)
a = ""


def print_hepler(s, output):
    print (s)
    if output:#checks for -o in args
        global a
        if whitered in s or yellowwhite in s or reset in s:
            s = s[10:-4]
        a += (s + "\n")


def err_search(f, args): #gets path to a log file

    def _print(s):
        print_hepler(s, args.o)

    error = 0
    warning = 0
    crit_warning = 0
    violated_count = 0
    output = ""
    with open("%s/vivado.log"  % f, "r+") as ins:#opens file as .log
        for line in ins:
            line = line.lstrip()
            if line.startswith("ERROR"):#checks in current ine if error is at the beginning
                error += 1
                if args.a == True or args.e == True: #checks for args if -a or -e is an arg print error line
                    _print("-" * ts)
                    _print(line)
                    _print("-" * ts)
            elif line.startswith("WARNING"):#checks in current ine if warning is at the beginning
                warning += 1
                if args.a == True or args.w == True:#checks for args if -a or -w is an arg print warning line#checks for args if -a or -w is an arg print warning line
                    _print("-" * ts)
                    _print(line)
                    _print("-" * ts)
            elif line.startswith("CRITICAL WARNING"):#checks in current ine if critical warning is at the beginning
                crit_warning += 1
                if args.a == True or args.c == True:#checks for args if -a or -c is an arg print critical warning line
                    _print("-" * ts)
                    _print(line)
                    _print("-" * ts)

    # checks if file exists
    timing_summary = "%s/top/top.runs/impl_1/top_timing_summary_postroute_physopted.rpt" % f
    if not os.path.exists(timing_summary):
        # else takes this path
        timing_summary = "%s/top/top.runs/impl_1/top_timing_summary_routed.rpt" % f
    # opens timing log
    with open(timing_summary, "r+") as ins:
        while True:
            line = ins.readline()
            if line == "":#checks line if empty
                break
            if "VIOLATED" in line:#checks for VIOLATED
                violated_count += 1#adds 1 to counter if found
                if args.v == True or args.a == True:#checks args for -v and -a
                    _print( "-" * ts)
                    _print (line)#prints the line
                    _print (ins.readline())
                    _print (ins.readline())
                    _print (ins.readline())
                    _print (ins.readline())
                    _print ("-" * ts)

    #outputs sum of errors warnings and critical warnings if any accured it gets painted in color
    _print ("#" * ts)
    if error != 0:
        _print("%sERRORS: %d%s" % (whitered, error, reset))
    else: _print("ERRORS: %d" % error)

    if warning != 0:
        _print("%sWARNINGS: %d%s" % (yellowwhite, warning, reset))
    else: _print("WARNINGS: %d" % warnings)

    if crit_warning != 0:
        _print("%sCRITICAL WARNINGS: %d%s" % (yellowwhite, crit_warning, reset))
    else: _print("CRITICAL WARNINGS: %d" % crit_warning)

    if violated_count != 0:
        _print("%sVIOLATED: %d%s" % (whitered, violated_count, reset))
    else: _print("VIOLATED: %d" % violated_count)

    if not os.path.exists("%stop/top.runs/impl_1/top.bit" % f):
        _print("%sMISSING BIT FILE: %stop/top.runs/impl_1/top.bit%s" % (whitered, f, reset))
        _print("")
    _print ("#" * ts)


def cfg_info(f):#gets path to the cfg file
    cfg = {}

    with open("%s.cfg" % f, "r+") as ins:#opens file as .cfg
        for line in ins:
            if line.startswith("name"):#checks for sub folder name
                cfg["ordner"] = line[7:-1]#puts the folder name in cfg array
            elif line.startswith("modules"):#checks for module count
                cfg["ordneranz"] = line[10:-1]#puts the count in cfg array
    return cfg


def parse():
    parser = argparse.ArgumentParser(description='Output Log data info') #arguments and parameters
    parser.add_argument('path', help = 'synthesis base path (e.g. build_0x10af)', metavar = 'path')
    parser.add_argument('-a', action = 'store_true', help='outputs all errors, warnings, critical warnings and timing violations with line')
    parser.add_argument('-c', action = 'store_true', help='outputs critical warnings with line info')
    parser.add_argument('-e', action = 'store_true', help='outputs errors with line info')
    parser.add_argument('-w', action = 'store_true', help='outputs warnings with line info')
    parser.add_argument('-m', action = 'store',type = int, help = 'input a number refering to a module in the folder; outputs the log of one module', metavar = 'int')
    parser.add_argument('-v', action = 'store_true', help = 'outputs line that contains VIOLATED')
    parser.add_argument('-o', action = 'store', help = 'inputs path for the output', metavar = 'path')
    return parser.parse_args()


def main():
    """Main routine."""

    # Parse command line arguments.
    args = parse()

    def _print(s):
        print_hepler(s, args.o)

    # checks for path if no path is given (deprecated??)
    if args.path == None:
        f = os.path.basename(os.path.dirname(os.path.abspath(__file__)))#take the path of the skript
        cfg = cfg_info(f)

        if args.m == None:#checks if -m is none
            for x in range(int(cfg["ordneranz"])):#loop is from 0 to module count
                _print ("=" * ts)
                _print ("module_%d" % x)#prints current module number
                _print ("=" * ts)
                _print("")
                err_search("%s/module_%d/" % (cfg["ordner"], x), args)#uses err_search <13>
                _print("")
        elif args.m <= int(cfg["ordneranz"]) - 1 and args.m >= 0:#cheks if -m is positive and available
            _print ("=" * ts)
            _print ("module_%d" % args.m)#prints current module
            _print ("=" * ts)
            _print("")
            err_search("%s/module_%d/" % (cfg["ordner"], args.m), args)#uses err_search <13>
            _print("")
        else: _print ("module %d not available. There are only %s modules registed(0-%d)" % (args.m, cfg["ordneranz"], int(cfg["ordneranz"]) - 1))#else outputs error message
    else:#if path is given
        f = os.path.basename(os.path.abspath(args.path))#takes path given and strips the last folder name
        cfg = cfg_info(args.path + "/" + f)#gives cfg_info the folder name

        if args.m == None:# checks if -m is none
            for x in range(int(cfg["ordneranz"])):#loop is from 0 to module count
                _print ("=" * ts)
                _print ("module_%d" % x)#prints current module number
                _print ("=" * ts)
                _print("")
                err_search("%s/%s/module_%d/" % (args.path, cfg["ordner"], x), args)#uses err_search <13>
                _print
        elif args.m <= int(cfg["ordneranz"]) and args.m >= 0:#cheks if -m is positive and available
            _print ("=" * ts)
            _print ("module_%d" % args.m)#prints current module number
            _print ("=" * ts)
            _print("")
            err_search("%s/%s/module_%d/" % (args.path, cfg["ordner"], args.m), args)#uses err_search <13>
            _print("")
        else: _print ("module %d not available. There are only %s modules registed" % (args.m, cfg["ordneranz"]))#else outputs error message

    if args.o:
        with open(os.path.abspath(args.o), 'w+') as ins:#then outpus in a file with -o as path
            ins.write(a)
            ins.close()

# Run main function with passed arguments.
if __name__ == '__main__':
    sys.exit(main())

#eof
