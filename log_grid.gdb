define log_grid
  set $vm = $r14

  printf "\n=== ds_grid_set ===\n"
  printf "grid ptr: %p\n", $rbx
  printf "col (x): %d\n", $esi
  printf "row (y): %d\n", $ebp

  set $type = *(unsigned int*)($vm + 0x3c)
  set $payload = *(unsigned long long*)($vm + 0x30)

  printf "type: 0x%x\n", $type

  if ($type == 0)
    printf "value (double): %g\n", *(double*)($vm + 0x30)
  else
    printf "payload raw: 0x%llx\n", $payload
  end

  printf "=================================\n"
end