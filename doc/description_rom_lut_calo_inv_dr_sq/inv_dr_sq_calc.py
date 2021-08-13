#!/usr/bin/python

import sys
import math

idx=0

print(f"{'idx':>6}", f"{'dphi_val':>22}", f"{'deta_val':>22}", f"{'inv_dr_sq':>25}", f"{'inv_dr_sq_rounded':>18}", f"{'inv_dr_sq_fw_lut':>17}")
for deta_idx in range(0,230):
    for dphi_idx in range(0,72):
        deta_val = deta_idx*0.0435
        dphi_val = dphi_idx*2*math.pi/144
        if deta_val == 0 and dphi_val == 0:
            inv_dr_sq = 0
        else:
            inv_dr_sq = 1/((deta_val**2)+(dphi_val**2))
        inv_dr_sq_rounded = round(inv_dr_sq,5)
        inv_dr_sq_fw_lut = int(round(inv_dr_sq_rounded*100000,0))
        print(f"{idx:>6}", f"{dphi_val:>22}", f"{deta_val:>22}", f"{inv_dr_sq:>25}", f"{inv_dr_sq_rounded:>18}", f"{inv_dr_sq_fw_lut:>17}")
        idx+=1
