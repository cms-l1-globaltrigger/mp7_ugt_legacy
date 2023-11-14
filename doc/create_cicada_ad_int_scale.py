#!/usr/bin/python

n_bits = 8
steps = 2**n_bits
scale_step = 1

print("    <scale>")
print("      <object>CICADAADINT</object>")
print("      <type>COUNT</type>")
print("      <minimum>+0.0000000000000000E+00</minimum>")
print("      <maximum>+{:.16E}</maximum>".format(steps))
print("      <step>+{:.16E}</step>".format(scale_step))
print("      <n_bits>{}</n_bits>".format(n_bits))

for i in range(0, 256):
    int_val = scale_step * i
    print("      <bin>")
    print("        <number>{}</number>".format(i))
    print("        <minimum>+{:.16E}</minimum>".format(int_val))
    print("        <maximum>+{:.16E}</maximum>".format(int_val))
    print("      </bin>")


