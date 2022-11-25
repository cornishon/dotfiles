function swap_files
if test (count $argv) -eq 2
set -f tmp ".tmp$(random)"
mv $argv[1] $tmp
mv $argv[2] $argv[1]
mv $tmp $argv[2]
else
echo "usage: swap_files file1 file2" >&2
return 1
end
end
