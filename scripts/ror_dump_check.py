# Check the structure of read out record dumps (HLT crashes June 2023).

import argparse

blk_size = 30 # Block length for +/-2bx (and 6 frames with 32 bit data)
fed_marker = "FED#"
fed_nr_def = "1404" # FED number of production crate
line_nr_o = 2+6+3 # 2 AMC13 header lines, 6 lines for MP7s in AMC13 header and 3 AMC #1 header lines !!!!

idx = 0
valid_data = False
valid_data_idx = 0
length_o = 1
line_split_0_o = " "
line_split_1_o = " "

# fixed differences between blocks (in lines):
diff_0 = 0 # first difference
diff_1 = blk_size/2 # difference in data blocks
diff_2 = blk_size/2+1 # difference in data blocks
diff_3 = blk_size/2+1+4 # difference last data block and header of next MP7

def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Check read out record dump files")
    parser.add_argument('file_name', help="name of dump file")
    parser.add_argument('--blk_size', type=str, default=blk_size, help="block size (default is '{}')".format(blk_size))
    parser.add_argument('--fed_nr', type=str, default=fed_nr_def, help="FED number (default is '{}')".format(fed_nr_def))
    return parser.parse_args()

args = parse_args()

filename = args.file_name
blk_size = args.blk_size
fed_nr_c = args.fed_nr
block_marker = (str(hex(blk_size)) + "0").split("x")[1]

with open(filename) as file:
    for line in file:
        idx += 1
        fed_line = line.split(" ")[0]
        if fed_line == fed_marker:
            fed_nr = line.split(" ")[1]
            if fed_nr == fed_nr_c:
                valid_data = True
                valid_data_idx = idx
        if valid_data and idx >= valid_data_idx + 1:
            line_split = line.split("  ")
            line_nr = int(line_split[0], base=16)
            if block_marker in line_split[1]:
                length = line_nr-line_nr_o
                if length != diff_0 and length != diff_1 and length != diff_2 and length != diff_3:
                    print("length error:", length)
                    exit(1)
                if length == length_o:
                    print("ERROR - same length", length_o, "in consecutive blocks (before or after):")
                    print(line_split_0_o, line_nr_o, line_split_1_o)
                    exit(1)
                line_nr_o = line_nr
                length_o = length
                line_split_0_o = line_split[0].rstrip('\r\n')
                line_split_1_o = line_split[1].rstrip('\r\n')
    print("read out record structure ok !!")
