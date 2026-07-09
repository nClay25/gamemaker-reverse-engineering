define log_ini_write
  printf "\n--- INI WRITE ---\n"
  printf "Section: "
  x/s $rdx
  printf "Key: "
  x/s $r8
  printf "Value: "
  x/s $r9
  printf "-----------------\n"
end
