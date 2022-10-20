# ismip6 dtt 01 (yelmo v1.753_sergio-test)
# Aim: study the effect of timestepping when performing a realistic scenario
yelmox_path=/home/sergio/entra/models/yelmo_vers/v1.753_sergio-test/yelmox/
yelmo_path=/home/sergio/entra/models/yelmo_vers/v1.753_sergio-test/yelmox/yelmo/src/physics/
exp_name="ismip6_dtt_01"

dtt_values=$(echo "0.1")
min_fixed_dtt=0.08

namelist=yelmo_ismip6_Antarctica-AR-restart.nml
fldr=output/ismip6/d03_LateralBC/${exp_name}/
runopt='-r'

# Switches
stored_spinup=1
spinup=0	 # set to 0 if stored_spinup=1
forced=1

adaptive=0
fixed=1

marine=1
floating=0

#### SCRIPT ####
cd ${yelmox_path}

if [ ${stored_spinup} -eq 1 ]; then
spinup=0
fi

if [ ${spinup} -eq 1 ]; then
# Spin-up
if [ ${adaptive} -eq 1 ]; then
if [ ${floating} -eq 1 ]; then
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/spinup_${exp_name}_f -p ctrl.run_step="spinup_ismip6" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 ytopo.kt=1.0e-3 ymat.enh_shear=1 ydyn.ssa_lat_bc="floating"
fi
if [ ${marine} -eq 1 ]; then
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/spinup_${exp_name}_m -p ctrl.run_step="spinup_ismip6" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 ytopo.kt=1.0e-3 ymat.enh_shear=1 ydyn.ssa_lat_bc="marine"
fi
fi
if [ ${fixed} -eq 1 ]; then
for i in ${dtt_values}; do
if [ ${floating} -eq 1 ]; then
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/spinup_${exp_name}_fd${i} -p ctrl.run_step="spinup_ismip6" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 ytopo.kt=1.0e-3 ymat.enh_shear=1 ydyn.ssa_lat_bc="floating" yelmo.dt_method=0 yelmo.pc_n_redo=1 spinup_ismip6.dtt=${i} yelmo.dt_min=${min_fixed_dtt}
fi
if [ ${marine} -eq 1 ]; then
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/spinup_${exp_name}_md${i} -p ctrl.run_step="spinup_ismip6" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 ytopo.kt=1.0e-3 ymat.enh_shear=1 ydyn.ssa_lat_bc="marine" yelmo.dt_method=0 yelmo.pc_n_redo=1 spinup_ismip6.dtt=${i} yelmo.dt_min=${min_fixed_dtt}
fi

#while pgrep -x "yelmox_ismip6.x" > /dev/null; do
#	    sleep 10
#done

done
fi
fi

if [ ${forced} -eq 1 ]; then

if [ ${stored_spinup} -eq 1 ]; then
floating_restart=${yelmox_path}/output/ismip6/d03_LateralBC/dtt_033/spinup_dtt_033_f/yelmo_restart.nc
marine_restart=${yelmox_path}/output/ismip6/d03_LateralBC/dtt_033/spinup_dtt_033_m/yelmo_restart.nc
else
floating_restart=${yelmox_path}/${fldr}/spinup_${exp_name}_f/yelmo_restart.nc
marine_restart=${yelmox_path}/${fldr}/spinup_${exp_name}_m/yelmo_restart.nc
fi

#while pgrep -x "yelmox_ismip6.x" > /dev/null; do
#	    sleep 10
#done


if [ ${adaptive} -eq 1 ]; then
# Adaptive time stepping experiments
if [ ${marine} -eq 1 ]; then
# MARINE
# ctrl
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/ctrl_m -p ctrl.run_step="transient_proj" yelmo.restart=${marine_restart} transient_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="marine"
# exp05
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/exp05_m -p ctrl.run_step="transient_proj" yelmo.restart=${marine_restart} transient_proj.scenario="rcp85" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="marine"
# exp09
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/exp09_m -p ctrl.run_step="transient_proj" yelmo.restart=${marine_restart} transient_proj.scenario="rcp85" tf_cor.name="dT_nl_95" marine_shelf.gamma_quad_nl=21000 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="marine"
# exp10
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/exp10_m -p ctrl.run_step="transient_proj" yelmo.restart=${marine_restart} transient_proj.scenario="rcp85" tf_cor.name="dT_nl_5" marine_shelf.gamma_quad_nl=9620 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="marine"
# exp13
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/exp13_m -p ctrl.run_step="transient_proj" yelmo.restart=${marine_restart} transient_proj.scenario="rcp85" tf_cor.name="dT_nl_pigl" marine_shelf.gamma_quad_nl=159000 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="marine"
fi

if [ ${floating} -eq 1 ]; then
# FLOATING
# ctrl
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/ctrl_f -p ctrl.run_step="transient_proj" yelmo.restart=${floating_restart} transient_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="floating"
# exp05
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/exp05_f -p ctrl.run_step="transient_proj" yelmo.restart=${floating_restart} transient_proj.scenario="rcp85" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="floating"
# exp09
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/exp09_f -p ctrl.run_step="transient_proj" yelmo.restart=${floating_restart} transient_proj.scenario="rcp85" tf_cor.name="dT_nl_95" marine_shelf.gamma_quad_nl=21000 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="floating"
# exp10
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/exp10_f -p ctrl.run_step="transient_proj" yelmo.restart=${floating_restart} transient_proj.scenario="rcp85" tf_cor.name="dT_nl_5" marine_shelf.gamma_quad_nl=9620 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="floating"
# exp13
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/exp13_f -p ctrl.run_step="transient_proj" yelmo.restart=${floating_restart} transient_proj.scenario="rcp85" tf_cor.name="dT_nl_pigl" marine_shelf.gamma_quad_nl=159000 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="floating"
fi
fi

if [ ${fixed} -eq 1 ]; then
# Fixed time steps experiments
for i in ${dtt_values}; do

if [ ${stored_spinup} -eq 1 ]; then
floating_restart=${yelmox_path}/output/ismip6/d03_LateralBC/dtt_033/spinup_dtt_033_fd${i}/yelmo_restart.nc
marine_restart=${yelmox_path}/output/ismip6/d03_LateralBC/dtt_033/spinup_dtt_033_md${i}/yelmo_restart.nc
else
floating_restart=${yelmox_path}/${fldr}/spinup_${exp_name}_fd${i}/yelmo_restart.nc
marine_restart=${yelmox_path}/${fldr}/spinup_${exp_name}_md${i}/yelmo_restart.nc
fi

if [ ${marine} -eq 1 ]; then
# MARINE
# ctrl
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/ctrl_md${i} -p ctrl.run_step="transient_proj" yelmo.restart=${marine_restart} transient_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="marine" yelmo.dt_method=0  yelmo.pc_n_redo=1 transient_proj.dtt=${i} yelmo.dt_min=${min_fixed_dtt}
# exp05
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/exp05_md${i} -p ctrl.run_step="transient_proj" yelmo.restart=${marine_restart} transient_proj.scenario="rcp85" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="marine" yelmo.dt_method=0  yelmo.pc_n_redo=1 transient_proj.dtt=${i} yelmo.dt_min=${min_fixed_dtt}
# exp09
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/exp09_md${i} -p ctrl.run_step="transient_proj" yelmo.restart=${marine_restart} transient_proj.scenario="rcp85" tf_cor.name="dT_nl_95" marine_shelf.gamma_quad_nl=21000 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="marine" yelmo.dt_method=0  yelmo.pc_n_redo=1 transient_proj.dtt=${i} yelmo.dt_min=${min_fixed_dtt}
# exp10
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/exp10_md${i} -p ctrl.run_step="transient_proj" yelmo.restart=${marine_restart} transient_proj.scenario="rcp85" tf_cor.name="dT_nl_5" marine_shelf.gamma_quad_nl=9620 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="marine" yelmo.dt_method=0  yelmo.pc_n_redo=1 transient_proj.dtt=${i} yelmo.dt_min=${min_fixed_dtt}
# exp13
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/exp13_md${i} -p ctrl.run_step="transient_proj" yelmo.restart=${marine_restart} transient_proj.scenario="rcp85" tf_cor.name="dT_nl_pigl" marine_shelf.gamma_quad_nl=159000 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="marine" yelmo.dt_method=0  yelmo.pc_n_redo=1 transient_proj.dtt=${i} yelmo.dt_min=${min_fixed_dtt}
fi

if [ ${floating} -eq 1 ]; then
# FLOATING
# ctrl
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/ctrl_fd${i} -p ctrl.run_step="transient_proj" yelmo.restart=${floating_restart} transient_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="floating" yelmo.dt_method=0  yelmo.pc_n_redo=1 transient_proj.dtt=${i} yelmo.dt_min=${min_fixed_dtt}
# exp05
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/exp05_fd${i} -p ctrl.run_step="transient_proj" yelmo.restart=${floating_restart} transient_proj.scenario="rcp85" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="floating" yelmo.dt_method=0  yelmo.pc_n_redo=1 transient_proj.dtt=${i} yelmo.dt_min=${min_fixed_dtt}
# exp09
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/exp09_fd${i} -p ctrl.run_step="transient_proj" yelmo.restart=${floating_restart} transient_proj.scenario="rcp85" tf_cor.name="dT_nl_95" marine_shelf.gamma_quad_nl=21000 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="floating" yelmo.dt_method=0  yelmo.pc_n_redo=1 transient_proj.dtt=${i} yelmo.dt_min=${min_fixed_dtt}
# exp10
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/exp10_fd${i} -p ctrl.run_step="transient_proj" yelmo.restart=${floating_restart} transient_proj.scenario="rcp85" tf_cor.name="dT_nl_5" marine_shelf.gamma_quad_nl=9620 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="floating" yelmo.dt_method=0  yelmo.pc_n_redo=1 transient_proj.dtt=${i} yelmo.dt_min=${min_fixed_dtt}
# exp13
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/exp13_fd${i} -p ctrl.run_step="transient_proj" yelmo.restart=${floating_restart} transient_proj.scenario="rcp85" tf_cor.name="dT_nl_pigl" marine_shelf.gamma_quad_nl=159000 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="floating" yelmo.dt_method=0  yelmo.pc_n_redo=1 transient_proj.dtt=${i} yelmo.dt_min=${min_fixed_dtt}
fi

while pgrep -x "yelmox_ismip6.x" > /dev/null; do
	    sleep 10
done

done
fi

fi



