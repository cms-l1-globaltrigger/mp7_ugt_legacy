#!/usr/bin/python

n_bits = 8
steps = 2**n_bits
scale_step = 1/steps
max_val = (scale_step*steps)-scale_step

print("    <scale>")
print("      <object>CICADAADDEC</object>")
print("      <type>COUNT</type>")
print("      <minimum>+0.0000000000000000E+00</minimum>")
print("      <maximum>+{:.16E}</maximum>".format(max_val))
print("      <step>+{:.16E}</step>".format(scale_step))
print("      <n_bits>{}</n_bits>".format(n_bits))

for i in range(0, steps):
    dec_val = scale_step * i
    print("      <bin>")
    print("        <number>{}</number>".format(i))
    print("        <minimum>+{:.16E}</minimum>".format(dec_val))
    print("        <maximum>+{:.16E}</maximum>".format(dec_val))
    print("      </bin>")
