import argparse
import h5py
import numpy as np
from numba import njit
from tqdm import tqdm
from tensorflow.keras.models import load_model
from qkeras.utils import _add_supported_quantized_objects
co = {}; _add_supported_quantized_objects(co)
import anomaly_detection_emulation as ade        # keeping this for the moment, as I've added my objects to this

def packed_to_hex(in_int, bits):
    in_hex = f'{in_int:x}'.rjust(bits,'0')
    return in_hex

def fill_obj_string(objs, nGT, bits, offset=0):
    n_blanks = nGT - len(objs)
    prefix = ' '.join([packed_to_hex(0, bits) for _ in range(offset)])
    objects = ' '.join([packed_to_hex(obj, bits) for obj in objs])
    postfix = ' '.join([packed_to_hex(0, bits) for _ in range(n_blanks-offset)])
    return  ' '.join([prefix, objects, postfix])

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Generate Test Vectors for μGT')
    parser.add_argument('-m', '--model', type=str, default='trimmed_encoder.h5', help='.h5 encoder model file')
    parser.add_argument('-i', '--input', type=str, required=True, help='.h5 input data file')
    parser.add_argument('-s', '--sample', type=str, default='full_data_cyl', help='data sample in input file [NOTE: Use "full_data_cyl" for sample with ZeroBias input]')
    parser.add_argument('-o', '--output', type=str, default='test_vectors.txt', help='.txt output filename')
    parser.add_argument('-n', '--nevt', type=int, default='10000', help='number of events to encode to .txt file')
    parser.add_argument('-t', '--thresholds', type=float, nargs='+', required=True, help='decision threshold(s) of trigger output')
    args = parser.parse_args()

    h5f = h5py.File(args.input, 'r')
    evts = np.array(h5f[args.sample])[:args.nevt]
    model = load_model(args.model, custom_objects=co)

    with open(args.output, 'w+') as f:
        for i, evt in enumerate(tqdm(evts)):
            event = evt.astype('int')

            # Get the GT ETMiss, EGammas, Muon, and Jet objects from h5
            met = ade.ETMiss.initFromHWInt(event[0][0], event[0][2]) # this is MET eta and MET phi
            jets = [ade.Jet.initFromHWInt(*event[1+i]) for i in range(ade.TPT_NJETS)]
            muons = [ade.Muon.initFromHWInt(*event[1+ade.TPT_NJETS+i]) for i in range(ade.TPT_NMUONS)]
            egammas = [ade.Jet.initFromHWInt(*event[1+ade.TPT_NJETS+ade.TPT_NMUONS+i]) for i in range(ade.TPT_NJETS)]

            s_evt = f'{i:04}'
            s_muons = fill_obj_string([muon.pack() for muon in muons], 8, 16)
            s_egammas = fill_obj_string([egamma.pack() for egamma in egammas], 12, 8)
            s_taus = fill_obj_string([0], 12, 8)
            s_jets = fill_obj_string([jet.pack() for jet in jets], 12, 8)
            s_met = fill_obj_string([met.pack()], 6, 8, offset=2)
            s_free = fill_obj_string([0], 6,8)
            s_extcond = '00000000000000000000000000000000000000000000000000000000000000f0' # Example external conditions from https://https://raw.githubusercontent.com/herbberg/l1menus/master/2022/L1Menu_Collisions2022_v1_3_0-d99/testvectors/TestVector_L1Menu_Collisions2022_v1_3_0.txt

            pxpypz = np.array(ade.objects_to_pxpypz(met, egammas, muons, jets))
            nn_in = np.array(ade.scale_nn_inputs(pxpypz))

            # Qkeras w/ HLS pxpypz (Not used for test vectors)
            # y_qkeras = model.predict(np.expand_dims(nn_in, 0))
            # loss_qk = np.sum(y_qkeras**2)

            # All HLS
            loss_hls = np.array(ade.hwint_to_topo_trigger_score(event.flatten()))

            passes = [int(loss_hls >= threshold) for threshold in args.thresholds]
            s_algos = fill_obj_string([int(''.join([str(thr) for thr in passes]),2)], 1, 128)
            s_finor = str(int(np.logical_or.reduce(passes)))

            output_blocks = [s_evt, s_muons, s_egammas, s_taus, s_jets, s_met, s_free, s_extcond, s_algos, s_finor]
            output_line = ' '.join([i.strip() for i in output_blocks])

            f.write(output_line)
            f.write('\n')
