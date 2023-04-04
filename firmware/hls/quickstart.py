import anomaly_detection_emulation as ade
import h5py
import numpy as np
import tensorflow as tf
from qkeras.utils import _add_supported_quantized_objects
co = {}; _add_supported_quantized_objects(co)

# load an NN
model = tf.keras.models.load_model('encoder_trimmed.h5', custom_objects=co)

# load some data
infile = "BSM_preprocessed.h5"
sample = "haa4b_ma15_powheg"
h5f = h5py.File(infile, 'r')
inval = np.array(h5f[sample])

# just pick the first event
event = inval[0].astype('int')

# Get the GT ETMiss, EGammas, Muon, and Jet objects from h5
met = ade.ETMiss.initFromHWInt(event[0][0], event[0][2])
egammas = [ade.EGamma.initFromHWInt(*event[1+i]) for i in range(ade.AD_NEGAMMAS)]
muons = [ade.Muon.initFromHWInt(*event[1+ade.AD_NEGAMMAS+i]) for i in range(ade.AD_NMUONS)]
jets = [ade.Jet.initFromHWInt(*event[1+ade.AD_NEGAMMAS+ade.AD_NMUONS+i]) for i in range(ade.AD_NJETS)]
event_gt_objects = [met, *egammas, *muons, *jets]

# pack the GT objects to their interface integers
packed = np.array([o.pack() for o in event_gt_objects])
#packed = np.array(ade.hwint_to_packed(event.flatten()), dtype=np.uint64) # old way (still works)
unpacked = np.array(ade.packed_to_hwint(packed), dtype='int').reshape(event.shape) # new way
print(f'Unpacked matches original? {np.all(unpacked == event)}')

# compute the NN loss in steps (if you want to check intermediate results)
# pxpypz = np.array(ade.hwint_to_pxpypz(event.flatten())) # old way (still works)
pxpypz = np.array(ade.objects_to_pxpypz(met, egammas, muons, jets)) # new way
nn_in = np.array(ade.scale_nn_inputs(pxpypz))
y_hls = np.array(ade.nn(nn_in))
loss_hls_1 = ade.nn_loss(y_hls)

# compute the NN loss in one step from integers
loss_hls_2 = np.array(ade.hwint_to_anomaly_score(event.flatten()))

# compute the NN loss in one step from GT objects
loss_hls_3 = np.array(ade.objects_to_anomaly_score(met, egammas, muons, jets))

# compute the NN loss of the QKeras model on emulated pxpypz
#y_qkeras = model.predict(np.expand_dims(nn_in, 0))
#loss_qk = np.sum(y_qkeras**2)
