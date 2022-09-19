# MARINE Present Day
# Aim: Build an Antarctic PD using marine bc

yelmox_path=/home/sergio/entra/models/yelmo_vers/v1.75/yelmox/
yelmo_path=/home/sergio/entra/models/yelmo_vers/v1.75/yelmox/yelmo/src/physics/
exp_name="MARINE_PD"

dtt_values=$(echo "1.0" "0.5" "0.1")
namelist=yelmo_ismip6_Antarctica-AR-restart.nml
fldr=output/ismip6/d03_LateralBC/${exp_name}/
runopt='-r'

v10=1 # v1.0

#### SCRIPT ####
cd ${yelmox_path}

# v1.0
if [ ${v10} -eq 1 ]; then
for i in ${dtt_values}; do
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/v1.0/spinup_${exp_name}_d${i} -p ctrl.run_step="spinup_ismip6" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 ytopo.kt=1.0e-3 ymat.enh_shear=1 ydyn.ssa_lat_bc="marine" yelmo.dt_method=0 yelmo.pc_n_redo=1 yelmo.log_timestep=.true. abumip_proj.dtt=${i}
done
fi



