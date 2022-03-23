# ABUK 02
# Aim: study the effect off ydyn.ssa_lat_bc='marine' ytopo.fmb_scale ytopo.kt

file_restart=/home/sergio/entra/ice_data/restart/alexr-yelmo_ismip6/spinup_32km_68/0/yelmo_restart.nc 

genfldr=output/ismip6/abuk_02/

runopt='-r'
paropt="ytopo.kt=1.0e-3"

## fmb = 0.0
### abuk_02f0k3
fldr=${genfldr}/f0k3/
./runylmox ${runopt} -e ismip6 -n par/yelmo_ismip6_Antarctica.nml -o ${fldr} -p abumip.scenario="abuk" ctrl.run_step="abumip_proj" yelmo.restart=${file_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ${paropt} ydyn.ssa_lat_bc="marine" ytopo.fmb_scale=0.0 ytopo.kt=3e-3
### abuk_02f0k5
fldr=${genfldr}/f0k5/
./runylmox ${runopt} -e ismip6 -n par/yelmo_ismip6_Antarctica.nml -o ${fldr} -p abumip.scenario="abuk" ctrl.run_step="abumip_proj" yelmo.restart=${file_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ${paropt} ydyn.ssa_lat_bc="marine" ytopo.fmb_scale=0.0 ytopo.kt=5e-4

## fmb = 1.0
### abuk_02f1k3
fldr=${genfldr}/f1k3/
./runylmox ${runopt} -e ismip6 -n par/yelmo_ismip6_Antarctica.nml -o ${fldr} -p abumip.scenario="abuk" ctrl.run_step="abumip_proj" yelmo.restart=${file_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ${paropt} ydyn.ssa_lat_bc="marine" ytopo.fmb_scale=1.0 ytopo.kt=3e-3
### abuk_02f1k5
fldr=${genfldr}/f1k5/
./runylmox ${runopt} -e ismip6 -n par/yelmo_ismip6_Antarctica.nml -o ${fldr} -p abumip.scenario="abuk" ctrl.run_step="abumip_proj" yelmo.restart=${file_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ${paropt} ydyn.ssa_lat_bc="marine" ytopo.fmb_scale=1.0 ytopo.kt=5e-4

## fmb = 2.0
### abuk_02f2k3
fldr=${genfldr}/f2k3/
./runylmox ${runopt} -e ismip6 -n par/yelmo_ismip6_Antarctica.nml -o ${fldr} -p abumip.scenario="abuk" ctrl.run_step="abumip_proj" yelmo.restart=${file_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ${paropt} ydyn.ssa_lat_bc="marine" ytopo.fmb_scale=2.0 ytopo.kt=3e-3
### abuk_02f2k5
fldr=${genfldr}/f2k5/
./runylmox ${runopt} -e ismip6 -n par/yelmo_ismip6_Antarctica.nml -o ${fldr} -p abumip.scenario="abuk" ctrl.run_step="abumip_proj" yelmo.restart=${file_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ${paropt} ydyn.ssa_lat_bc="marine" ytopo.fmb_scale=2.0 ytopo.kt=5e-4

## fmb = 5.0
### abuk_02f5k3
fldr=${genfldr}/f5k3/
./runylmox ${runopt} -e ismip6 -n par/yelmo_ismip6_Antarctica.nml -o ${fldr} -p abumip.scenario="abuk" ctrl.run_step="abumip_proj" yelmo.restart=${file_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ${paropt} ydyn.ssa_lat_bc="marine" ytopo.fmb_scale=5.0 ytopo.kt=3e-3
### abuk_02f5k5
fldr=${genfldr}/f5k5/
./runylmox ${runopt} -e ismip6 -n par/yelmo_ismip6_Antarctica.nml -o ${fldr} -p abumip.scenario="abuk" ctrl.run_step="abumip_proj" yelmo.restart=${file_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ${paropt} ydyn.ssa_lat_bc="marine" ytopo.fmb_scale=5.0 ytopo.kt=5e-4

## fmb = 10.0
### abuk_02f10k3
fldr=${genfldr}/f10k3/
./runylmox ${runopt} -e ismip6 -n par/yelmo_ismip6_Antarctica.nml -o ${fldr} -p abumip.scenario="abuk" ctrl.run_step="abumip_proj" yelmo.restart=${file_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ${paropt} ydyn.ssa_lat_bc="marine" ytopo.fmb_scale=10.0 ytopo.kt=3e-3
### abuk_02f10k5
fldr=${genfldr}/f10k5/
./runylmox ${runopt} -e ismip6 -n par/yelmo_ismip6_Antarctica.nml -o ${fldr} -p abumip.scenario="abuk" ctrl.run_step="abumip_proj" yelmo.restart=${file_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ${paropt} ydyn.ssa_lat_bc="marine" ytopo.fmb_scale=10.0 ytopo.kt=5e-4
