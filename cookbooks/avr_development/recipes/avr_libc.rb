%w{
build-essential
avr-libc
gcc-avr
binutils-avr
gdb-avr
avrdude
}.each do |name|
  package name
end
