# dtt 04 (yelmo v1.753_sergio-test)
# Aim: study the effect of lateral bc and timestepping when using just 1 spinup run

yelmox_path=/home/sergio/entra/models/yelmo_vers/v1.753_sergio-test/yelmox/
yelmo_path=/home/sergio/entra/models/yelmo_vers/v1.753_sergio-test/yelmox/yelmo/src/physics/
exp_name="dtt_04"

dtt_values=$(echo "1.0" "0.5" "0.2" "0.1" "0.05" "0.02" "0.01")
spinup_dtt=0.1
min_fixed_dtt=0.00005

namelist=yelmo_ismip6_Antarctica-AR-restart.nml
fldr=output/ismip6/d03_LateralBC/${exp_name}/
runopt='-r'

# experiment switch
spinup=1	 # 

adaptive=1
fixed=1

marine=1
floating=1

#### SCRIPT ####
cd ${yelmox_path}

if [ ${spinup} -eq 1 ]; then
# Spin-up
if [ ${adaptive} -eq 1 ]; then
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/spinup_${exp_name}_f -p ctrl.run_step="spinup_ismip6" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 ytopo.kt=1.0e-3 ymat.enh_shear=1 ydyn.ssa_lat_bc="floating"
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/spinup_${exp_name}_m -p ctrl.run_step="spinup_ismip6" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 ytopo.kt=1.0e-3 ymat.enh_shear=1 ydyn.ssa_lat_bc="marine"
fi
if [ ${fixed} -eq 1 ]; then
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/spinup_${exp_name}_fd${spinup_dtt} -p ctrl.run_step="spinup_ismip6" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 ytopo.kt=1.0e-3 ymat.enh_shear=1 ydyn.ssa_lat_bc="floating" yelmo.dt_method=0 yelmo.pc_n_redo=1 yelmo.log_timestep=.true. spinup_ismip6.dtt=${spinup_dtt}
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/spinup_${exp_name}_md${spinup_dtt} -p ctrl.run_step="spinup_ismip6" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 ytopo.kt=1.0e-3 ymat.enh_shear=1 ydyn.ssa_lat_bc="marine" yelmo.dt_method=0 yelmo.pc_n_redo=1 yelmo.log_timestep=.true. spinup_ismip6.dtt=${spinup_dtt}

while pgrep -x "yelmox_ismip6.x" > /dev/null; do
	    sleep 10
done

fi
fi

floating_restart=${yelmox_path}/${fldr}/spinup_${exp_name}_f/yelmo_restart.nc
marine_restart=${yelmox_path}/${fldr}/spinup_${exp_name}_m/yelmo_restart.nc

while pgrep -x "yelmox_ismip6.x" > /dev/null; do
	    sleep 10
done

if [ ${adaptive} -eq 1 ]; then
# Adaptive time stepping experiments
if [ ${marine} -eq 1 ]; then
# MARINE
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/${exp_name}_cm -p abumip.scenario="abuc" ctrl.run_step="abumip_proj" yelmo.restart=${marine_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="marine" yelmo.log_timestep=.true. yelmo.dt_min=${min_fixed_dtt}
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/${exp_name}_km -p abumip.scenario="abuk" ctrl.run_step="abumip_proj" yelmo.restart=${marine_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="marine" yelmo.log_timestep=.true. yelmo.dt_min=${min_fixed_dtt}
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/${exp_name}_mm -p abumip.scenario="abum" ctrl.run_step="abumip_proj" yelmo.restart=${marine_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="marine" yelmo.log_timestep=.true. yelmo.dt_min=${min_fixed_dtt}
fi

if [ ${floating} -eq 1 ]; then
# FLOATING
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/${exp_name}_cf -p abumip.scenario="abuc" ctrl.run_step="abumip_proj" yelmo.restart=${floating_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="floating" yelmo.log_timestep=.true. yelmo.dt_min=${min_fixed_dtt}
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/${exp_name}_kf -p abumip.scenario="abuk" ctrl.run_step="abumip_proj" yelmo.restart=${floating_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="floating" yelmo.log_timestep=.true. yelmo.dt_min=${min_fixed_dtt}
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/${exp_name}_mf -p abumip.scenario="abum" ctrl.run_step="abumip_proj" yelmo.restart=${floating_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="floating" yelmo.log_timestep=.true. yelmo.dt_min=${min_fixed_dtt}
fi
fi

while pgrep -x "yelmox_ismip6.x" > /dev/null; do
	    sleep 10
done

if [ ${fixed} -eq 1 ]; then
# Fixed time steps experiments
floating_restart=${yelmox_path}/${fldr}/spinup_${exp_name}_fd${spinup_dtt}/yelmo_restart.nc
marine_restart=${yelmox_path}/${fldr}/spinup_${exp_name}_md${spinup_dtt}/yelmo_restart.nc

for i in ${dtt_values}; do

if [ ${marine} -eq 1 ]; then
# MARINE
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/${exp_name}_cmd${i} -p abumip.scenario="abuc" ctrl.run_step="abumip_proj" yelmo.restart=${marine_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="marine" yelmo.dt_method=0  yelmo.pc_n_redo=1 yelmo.log_timestep=.true. abumip_proj.dtt=${i} yelmo.dt_min=${min_fixed_dtt}
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/${exp_name}_kmd${i} -p abumip.scenario="abuk" ctrl.run_step="abumip_proj" yelmo.restart=${marine_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="marine" yelmo.dt_method=0 yelmo.pc_n_redo=1 yelmo.log_timestep=.true. abumip_proj.dtt=${i} yelmo.dt_min=${min_fixed_dtt}
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/${exp_name}_mmd${i} -p abumip.scenario="abum" ctrl.run_step="abumip_proj" yelmo.restart=${marine_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="marine" yelmo.dt_method=0 yelmo.pc_n_redo=1 yelmo.log_timestep=.true. abumip_proj.dtt=${i} yelmo.dt_min=${min_fixed_dtt}
fi

if [ ${floating} -eq 1 ]; then
# FLOATING
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/${exp_name}_cfd${i} -p abumip.scenario="abuc" ctrl.run_step="abumip_proj" yelmo.restart=${floating_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="floating" yelmo.dt_method=0 yelmo.pc_n_redo=1 yelmo.log_timestep=.true. abumip_proj.dtt=${i} yelmo.dt_min=${min_fixed_dtt}
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/${exp_name}_kfd${i} -p abumip.scenario="abuk" ctrl.run_step="abumip_proj" yelmo.restart=${floating_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="floating" yelmo.dt_method=0 yelmo.pc_n_redo=1 yelmo.log_timestep=.true. abumip_proj.dtt=${i} yelmo.dt_min=${min_fixed_dtt}
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/${exp_name}_mfd${i} -p abumip.scenario="abum" ctrl.run_step="abumip_proj" yelmo.restart=${floating_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="floating" yelmo.dt_method=0 yelmo.pc_n_redo=1 yelmo.log_timestep=.true. abumip_proj.dtt=${i} yelmo.dt_min=${min_fixed_dtt}
fi

while pgrep -x "yelmox_ismip6.x" > /dev/null; do
	    sleep 10
done

done
fi
