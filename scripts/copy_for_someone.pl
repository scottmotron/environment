#!/usr/local/bin/perl

$usage = "Usage: copy_for_someone [dir_to_copy] [dest dir name] <user>";

if($#ARGV < 1) { die $usage; }

$test_dir = $ARGV[0];
$dest_dir = $ARGV[1];

if($#ARGV > 1) { $user = $ARGV[2]; }
else           { $user = "kevin"; }

$dest_dir = "~/for_$user/$dest_dir";

print "Copying $test_dir to $dest_dir\n";

`cp -r $test_dir $dest_dir`;
`which vsim > $dest_dir/vsim_info`;
chdir "../../../..";
`svn info > $dest_dir/svn_info`;
`svn stat > $dest_dir/svn_stat`;
`cp -r hi/rtl/sec $dest_dir/hi_rtl_sec`;
