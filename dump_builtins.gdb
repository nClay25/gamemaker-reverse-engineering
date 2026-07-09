define dump_builtins

  set $tbl = *(long*)0x1408bfe10
  set $count = *(unsigned int*)0x1408bfe18

  printf "\nBuiltin table base: 0x%lx\n", $tbl
  printf "Total entries: %u\n", $count
  printf "\n--- Dumping all entries ---\n\n"

  set $i = 0

  while $i < $count
    set $entry = $tbl + ($i * 0x18)
    set $nameptr = *(long*)$entry
    set $funcptr = *(long*)($entry + 8)
    set $nargs = *(unsigned int*)($entry + 16)

    printf "[%4u] func=0x%016lx argc=%2u name=", $i, $funcptr, $nargs

    if $nameptr != 0
      x/s $nameptr
    else
      printf "<null>\n"
    end

    set $i = $i + 1
  end

  printf "\n--- Done ---\n\n"
end