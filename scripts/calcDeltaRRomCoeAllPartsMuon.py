import logging
import math
import sys

EXIT_SUCCESS = 0
EXIT_FAILURE = 1

def main():
    """Main routine."""

    deta_addr = 64 # 6 bits
    dphi_addr = 64 # 6 bits

    deta_len = 225 # number of muon delta eta bins [half bins of muon scale]
    deta_bin = 0.02175 # bin width muon delta eta [double width of muon scale]
    dphi_len = 144 # number of muon delta phi bins
    dphi_bin = 2*math.pi/dphi_len # bin width muon delta phi
    dr_list = [0] * deta_addr * 4 * dphi_addr * 2
    prec = 5 # precision of delta R values (digits after comma, rounded)
    line_len = 16

    for k in range(0,4):
        for l in range(0,2):
            print("writing to firmware/ngc/rom_lut_muon_inv_dr_sq_part{}.coe".format(k+1+l*4))
            coe_file_path = 'firmware/ngc/rom_lut_muon_inv_dr_sq_part%s.coe' % str(k+1+l*4)
            with open(coe_file_path, 'w+') as fout:
                index = 1
                fout.write("memory_initialization_radix=10;\n")
                fout.write("memory_initialization_vector=\n")
                for i in range(deta_addr*k, deta_addr*k+deta_addr):
                    for j in range(dphi_addr*l, dphi_addr*l+dphi_addr):
                        if (i == 0 and j == 0) or i >= deta_len:
                            dr_list[i*j+j] = 0
                            print(dr_list[i*j+j])
                        else:
                            dr_list[i*j+j] = int(10**prec * round(1/(((i*deta_bin)**2)+((j*dphi_bin)**2)), prec))
                            print(dr_list[i*j+j])
                        fout.write('%s,' % dr_list[i*j+j])
                        if not (index % line_len):
                            fout.write("\n")
                        index += 1
                    #fout.write("\n")
                fout.write(";")

    dr_list9 = [0] * 256 * 16
    print("writing to firmware/ngc/rom_lut_muon_inv_dr_sq_part9.coe")
    with open('firmware/ngc/rom_lut_muon_inv_dr_sq_part9.coe', 'w+') as fout:
        index = 1
        fout.write("memory_initialization_radix=10;\n")
        fout.write("memory_initialization_vector=\n")
        for i in range(0, 256):
            for j in range(0, 16):
                if i >= deta_len:
                    dr_list9[i*j+j] = 0
                else:
                    dr_list9[i*j+j] = int(10**prec * round(1/(((i*deta_bin)**2)+(((j+128)*dphi_bin)**2)), prec))
                fout.write('%s,' % dr_list9[i*j+j])
                if not (index % line_len):
                    fout.write("\n")
                index += 1
        fout.write(";")

if __name__ == '__main__':
    try:
        main()
    except RuntimeError as message:
        logging.error(message)
        sys.exit(EXIT_FAILURE)
    sys.exit(EXIT_SUCCESS)
