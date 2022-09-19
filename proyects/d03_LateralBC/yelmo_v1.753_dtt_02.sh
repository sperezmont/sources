# dtt 02
# Aim: study the effect of lateral bc and timestepping
#      we want to see ABUK and ABUM with:
#                                        dt_method=0
#                                        yelmo.pc_n_redo=1
#                                        log_timestep=.true.
#                                        dtt = [0.1, 0.5, 0.8, 1.0]
#       and see if adaptive timestepping is doing right

yelmox_path=/home/sergio/entra/models/yelmo_vers/v1.75/yelmox/
yelmo_path=/home/sergio/entra/models/yelmo_vers/v1.75/yelmox/yelmo/src/physics/
exp_name="dtt_02"

dtt_values=$(echo "1.0" "0.8" "0.5" "0.1")

namelist=yelmo_ismip6_Antarctica-AR-restart.nml
fldr=output/ismip6/d03_LateralBC/${exp_name}/
runopt='-r'

# experiment switch
spinup=0	 # already done in taubc_02, set 0!!

marine=1
floating=1
all=1

#### SCRIPT ####
cd ${yelmox_path}

if [ ${spinup} -eq 1 ]; then

# Spin-up
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/spinup_${exp_name}_floating -p ctrl.run_step="spinup_ismip6" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 ytopo.kt=1.0e-3 ymat.enh_shear=1 ydyn.ssa_lat_bc="floating"
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/spinup_${exp_name}_marine -p ctrl.run_step="spinup_ismip6" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 ytopo.kt=1.0e-3 ymat.enh_shear=1 ydyn.ssa_lat_bc="marine"
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/spinup_${exp_name}_all -p ctrl.run_step="spinup_ismip6" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 ytopo.kt=1.0e-3 ymat.enh_shear=1 ydyn.ssa_lat_bc="all"
floating_restart=${yelmox_path}/${fldr}/spinup_${exp_name}_floating/yelmo_restart.nc
marine_restart=${yelmox_path}/${fldr}/spinup_${exp_name}_marine/yelmo_restart.nc
all_restart=${yelmox_path}/${fldr}/spinup_${exp_name}_all/yelmo_restart.nc

else
# taubc_02 restart files
floating_restart=${yelmox_path}/output/ismip6/d03_LateralBC/taubc_02/spinup_taubc_02_floating/yelmo_restart.nc
marine_restart=${yelmox_path}/output/ismip6/d03_LateralBC/taubc_02/spinup_taubc_02_marine/yelmo_restart.nc
all_restart=${yelmox_path}/output/ismip6/d03_LateralBC/taubc_02/spinup_taubc_02_all/yelmo_restart.nc

fi

while pgrep -x "yelmox_ismip6.x" > /dev/null; do
	    sleep 10
done

for i in ${dtt_values}; do
if [ ${marine} -eq 1 ]; then
# MARINE
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/${exp_name}_akmd${i} -p abumip.scenario="abuk" ctrl.run_step="abumip_proj" yelmo.restart=${marine_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="marine" yelmo.dt_method=0 yelmo.pc_n_redo=1 yelmo.log_timestep=.true. abumip_proj.dtt=${i}
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/${exp_name}_ammd${i} -p abumip.scenario="abum" ctrl.run_step="abumip_proj" yelmo.restart=${marine_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="marine" yelmo.dt_method=0 yelmo.pc_n_redo=1 yelmo.log_timestep=.true. abumip_proj.dtt=${i}
fi

if [ ${floating} -eq 1 ]; then
# FLOATING
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/${exp_name}_akfd${i} -p abumip.scenario="abuk" ctrl.run_step="abumip_proj" yelmo.restart=${floating_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="floating" yelmo.dt_method=0 yelmo.pc_n_redo=1 yelmo.log_timestep=.true. abumip_proj.dtt=${i}
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/${exp_name}_amfd${i} -p abumip.scenario="abum" ctrl.run_step="abumip_proj" yelmo.restart=${floating_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="floating" yelmo.dt_method=0 yelmo.pc_n_redo=1 yelmo.log_timestep=.true. abumip_proj.dtt=${i}
fi

if [ ${all} -eq 1 ]; then
# ALL
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/${exp_name}_akad${i} -p abumip.scenario="abuk" ctrl.run_step="abumip_proj" yelmo.restart=${all_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="all" yelmo.dt_method=0 yelmo.pc_n_redo=1 yelmo.log_timestep=.true. abumip_proj.dtt=${i}
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/${exp_name}_amad${i} -p abumip.scenario="abum" ctrl.run_step="abumip_proj" yelmo.restart=${all_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="all" yelmo.dt_method=0 yelmo.pc_n_redo=1 yelmo.log_timestep=.true. abumip_proj.dtt=${i}
fi

while pgrep -x "yelmox_ismip6.x" > /dev/null; do
	    sleep 10
done

done