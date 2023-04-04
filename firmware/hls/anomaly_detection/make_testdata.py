import h5py
import numpy as np

infile = "/eos/cms/store/cmst3/group/l1tr/jngadiub/L1TNtupleRun3-h5-extended-v2-120X_hw/BSM_preprocessed.h5"
nevents = 10
sample = "haa4b_ma15_powheg"


h5f = h5py.File(infile, 'r')
inval = np.array(h5f[sample])
inval = inval[:nevents]

with open("test_input.txt", "w") as f:
  for i,event in enumerate(inval):
    MET       = event[0,:]
    Electrons = event[1:5,:]
    Muons      = event[5:9,:]
    Jets      = event[9:20,:] 
    print (f"Event {i} with {event.shape[0]} objects, {Jets.shape[0]} jets, {Muons.shape[0]} muons, {Electrons.shape[0]} electrons and MET", file=f)
    for jet in Jets:
      print (f"   jet pt      {jet[0]} eta {jet[1]} phi {jet[2]}", file=f)
    for egamma in Electrons:
      print (f"   egamma pt      {egamma[0]} eta {egamma[1]} phi {egamma[2]}", file=f)  
    for muon in Muons:
      print (f"   muon pt      {muon[0]} eta {muon[1]} phi {muon[2]}", file=f)      
    print (f"   MET pt      {MET[0]} eta {MET[1]} phi {MET[2]}", file=f)        