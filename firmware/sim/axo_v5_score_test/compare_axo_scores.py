fw_file_name = "axo_v5_scores_fw.txt"
emu_file_name = "axo_v5_scores_emu.txt"

fw_scores = []
emu_scores = []
fw_bx = []
emu_bx = []

err = False
header = False

with open(fw_file_name) as fw_file:
    for line in fw_file:
        line = line.strip()
        score = line.split(" ")[-1]
        bx = line.split(" ")[0]
        fw_scores.append(score)
        fw_bx.append(bx)

with open(emu_file_name) as emu_file:
    for line in emu_file:
        line = line.strip()
        score = line.split(" ")[-1]
        bx = line.split(" ")[0]
        emu_scores.append(score)
        emu_bx.append(bx)

for i in range(0, 3558):
    if fw_bx[i] != emu_bx[i]:
        print("bx mismatches in line:", i, "fw_bx:", fw_bx[i], "emu_bx:", emu_bx[i])
        exit(1)

for i in range(0, 3558):
    if fw_scores[i] != emu_scores[i]:
        if not header:
            print("bx   fw    emu")
        print(fw_bx[i], fw_scores[i], emu_scores[i])
        err = True
        header = True

if err:
    print("score value mismatches!")
else:
    print("success!")

