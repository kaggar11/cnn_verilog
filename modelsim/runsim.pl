#!/usr/bin/perl
#
use strict;

my $opt_help;
my $sim_type;
my $top;
my %opts  = ();
my $compile_command;
my $sim_command;
my $compile_file;

# Script usage
sub usage {
  print <<usage
runsim.pl [-sim_type <type>] [-top <top_module_name>] [-lib_map_path <path>] [-reset_run] [-noclean_files] [-help]\n\n\
[-help] -- Print help information for this script\n\n\
[-sim_type <type>] -- Run either a RTL or GLS simulation (options: 'gls', 'rtl') (Default: rtl)
[-top <top_module_name>] -- Specify the top module name
[-lib_map_path <path>] -- Compiled simulation library directory path. The simulation library is compiled\n\
using the compile_simlib tcl command. Please see 'compile_simlib -help' for more information.\n\n\
[-reset_run] -- Recreate simulator setup files and library mappings for a clean run. The generated files\n\
from the previous run will be removed. If you don't want to remove the simulator generated files, use the\n\
-noclean_files switch.\n\n\
[-noclean_files] -- Reset previous run, but do not remove simulator generated files from the previous run.\n\n"
usage
}

# Parse options
GetOptions(
   "help"          => \my $opt_help,
   "sim_type=s"    => \my $sim_type,
   "top=s"         => \my $top,
   "opts=s"        => \my $opts{sim_opts}
);

if ($opt_help) {
   usage();
   exit;
}

if ($sim_type eq "rtl") {
   $compile_file = "compile.do"
} elsif ($sim_type == "gls") {
   $compile_file = "compile_gls.do"
}

$compile_command = "source".
                   "$compile_file".
                   "| tee -a compile.log";

$sim_command = "/usr/local/mentor/modelsim-2019.1/modeltech/bin/vsim"
               "-c".
               "-do {simulate.do}".
               "-l simulate.log".
               "-top $top".
               "-wlf tb.wlf".
               "-voptargs="+acc "".
               "-L xil_defaultlib".
               "-lib xil_defaultlib".
               "xil_defaultlib.tb_conv_layer".
               "xil_defaultlib.glbl";