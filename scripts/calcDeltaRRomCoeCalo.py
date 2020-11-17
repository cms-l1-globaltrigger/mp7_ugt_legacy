import logging
import math
import sys

EXIT_SUCCESS = 0
EXIT_FAILURE = 1

def main():
    """Main routine."""

    deta_addr = 256 # 8 bits
    dphi_addr = 256 # 8 bits

    deta_len = 230 # number of calo delta eta bins
    deta_bin = 0.0435 # bin width calo delta eta
    dphi_len = 144 # number of calo delta phi bins
    dphi_bin = 2*math.pi/dphi_len # bin width calo delta phi
    dr_list = [0] * deta_addr * dphi_addr
    prec = 5 # precision of delta R values (digits after comma, rounded)
    line_len = 16

    print("writing to firmware/ngc/lut_inv_dr_sq_rom.coe")
    with open('firmware/ngc/lut_inv_dr_sq_rom.coe', 'w+') as fout:
        index = 1

        fout.write("memory_initialization_radix=16;\n")
        fout.write("memory_initialization_vector=\n")
        for i in range(0, deta_addr):
          for j in range(0, dphi_addr):
            if (i == 0 and j == 0) or (i >= deta_len) or (j >= dphi_len) :
                dr_list[i*j+j] = 0
            else:
                dr_list[i*j+j] = int(10**prec * round(1/(((i*deta_bin)**2)+((j*dphi_bin)**2)), prec))

            fout.write('%s,' % dr_list[i*j+j])

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
