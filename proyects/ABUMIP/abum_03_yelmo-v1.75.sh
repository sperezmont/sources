# ABUM_03 tests with Yelmo v1.75 -> FLOATING LBC
# Aim: study the effect of  ytopo.bmb_gl_method = ['fcmp','fmp','pmp','nmp']
file_restart=/home/sergio/entra/ice_data/restart/alexr-yelmo_ismip6/spinup_32km_68/0/yelmo_restart.nc

fldr=output/ismip6/abum_03_yelmo-v1.75/

runopt='-r'
paropt="ytopo.kt=1.0e-3"

# fcmp, flotation condition melt parameterization 
#./runylmox ${runopt} -e ismip6 -n par/yelmo_ismip6_Antarctica.nml -o ${fldr}/fcmp -p abumip.scenario="abum" ctrl.run_step="abumip_proj" yelmo.restart=${file_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ${paropt} ytopo.bmb_gl_method="fcmp"

# fcmp-marine
./runylmox ${runopt} -e ismip6 -n par/yelmo_ismip6_Antarctica.nml -o ${fldr}/fcmp-marine -p abumip.scenario="abum" ctrl.run_step="abumip_proj" yelmo.restart=${file_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ${paropt} ytopo.bmb_gl_method="fcmp" ydyn.ssa_lat_bc="marine"

# fmp, full melt parameterization
#./runylmox ${runopt} -e ismip6 -n par/yelmo_ismip6_Antarctica.nml -o ${fldr}/fmp -p abumip.scenario="abum" ctrl.run_step="abumip_proj" yelmo.restart=${file_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ${paropt} ytopo.bmb_gl_method="fmp"

# pmp (default), partial-melt parameterization 
#./runylmox ${runopt} -e ismip6 -n par/yelmo_ismip6_Antarctica.nml -o ${fldr}/pmp -p abumip.scenario="abum" ctrl.run_step="abumip_proj" yelmo.restart=${file_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ${paropt} ytopo.bmb_gl_method="pmp"

# nmp, no-melt parameterization
#./runylmox ${runopt} -e ismip6 -n par/yelmo_ismip6_Antarctica.nml -o ${fldr}/nmp -p abumip.scenario="abum" ctrl.run_step="abumip_proj" yelmo.restart=${file_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ${paropt} ytopo.bmb_gl_method="nmp"

# nmp-marine
./runylmox ${runopt} -e ismip6 -n par/yelmo_ismip6_Antarctica.nml -o ${fldr}/nmp-marine -p abumip.scenario="abum" ctrl.run_step="abumip_proj" yelmo.restart=${file_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ${paropt} ytopo.bmb_gl_method="nmp" ydyn.ssa_lat_bc="marine"
