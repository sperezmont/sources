# ABUMIP 02 experiments with Yelmo v1.75
# Aim: 3 standard experiments plus abuk-marine & abum-marine, this uses yelmo_ismip6_Antarctica-AR-restart.nml
file_restart=/home/sergio/entra/ice_data/restart/ismip6/v1.753/yelmo_restart.nc  #/home/sergio/entra/ice_data/restart/alexr-yelmo_ismip6/spinup_32km_68/0/yelmo_restart.nc

fldr=output/ismip6/abumip_02_yelmo-v1.75/
yelmox_path=/home/sergio/entra/yelmo_vers/v1.75/yelmox/
namelist=yelmo_ismip6_Antarctica-AR-restart.nml
runopt='-r'
paropt="ytopo.kt=1.0e-3"

echo "###########################"
echo "Running abumip_02 experiments"
echo "###########################"
cd ${yelmox_path}

# ABUC - control experiment
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/abuc -p abumip.scenario="abuc" ctrl.run_step="abumip_proj" yelmo.restart=${file_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ${paropt} 

# ABUK - Ocean-kill experiment
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/abuk -p abumip.scenario="abuk" ctrl.run_step="abumip_proj" yelmo.restart=${file_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ${paropt}

# ABUM - High shelf melt (400 m/yr)
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/abum -p abumip.scenario="abum" ctrl.run_step="abumip_proj" yelmo.restart=${file_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ${paropt} 


# ABUK - Ocean-kill experiment (MARINE BOUNDARY CONDITIONS)
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/abuk-marine -p abumip.scenario="abuk" ctrl.run_step="abumip_proj" yelmo.restart=${file_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ${paropt} ydyn.ssa_lat_bc="marine"

# ABUM - High shelf melt (400 m/yr) (MARINE BOUNDARY CONDITIONS)
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/abum-marine -p abumip.scenario="abum" ctrl.run_step="abumip_proj" yelmo.restart=${file_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ${paropt} ydyn.ssa_lat_bc="marine"
