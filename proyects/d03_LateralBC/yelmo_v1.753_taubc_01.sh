# taubc 01 
# Aim: study the effect of lateral bc (ONE spin-up, deprecated)

yelmox_path=/home/sergio/entra/models/yelmo_vers/v1.75/yelmox/
yelmo_path=/home/sergio/entra/models/yelmo_vers/v1.75/yelmox/yelmo/src/physics/
exp_name="taubc_01"

namelist=yelmo_ismip6_Antarctica-AR-restart.nml
fldr=output/ismip6/d03_LateralBC/${exp_name}/
runopt='-r'

# experiment switch
spinup=0	 # already done in taubc_02, set 0!!
standard=0
zero=0
ice=0
ocean=1

marine=1
floating=1
all=1

#### SCRIPT ####
cd ${yelmox_path}

if [ ${spinup} -eq 1 ]; then

cp ${yelmo_path}solver_ssa_sico5_orig.F90 ${yelmo_path}solver_ssa_sico5.F90
make clean
make yelmox_ismip6

# Spin-up
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/spinup_${exp_name}_floating -p ctrl.run_step="spinup_ismip6" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 ytopo.kt=1.0e-3 ymat.enh_shear=1 ydyn.ssa_lat_bc="floating"
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/spinup_${exp_name}_marine -p ctrl.run_step="spinup_ismip6" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 ytopo.kt=1.0e-3 ymat.enh_shear=1 ydyn.ssa_lat_bc="marine"
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/spinup_${exp_name}_all -p ctrl.run_step="spinup_ismip6" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 ytopo.kt=1.0e-3 ymat.enh_shear=1 ydyn.ssa_lat_bc="all"
floating_restart=${yelmox_path}/${fldr}/spinup_${exp_name}_floating/yelmo_restart.nc

else
# taubc_02 restart files
floating_restart=${yelmox_path}/output/ismip6/d03_LateralBC/taubc_02/spinup_taubc_02_floating/yelmo_restart.nc

fi

if [ ${standard} -eq 1 ]; then
while pgrep -x "yelmox_ismip6.x" > /dev/null; do
	    sleep 10
done

#### STANDARD case
cp ${yelmo_path}solver_ssa_sico5_standard.F90 ${yelmo_path}solver_ssa_sico5.F90
make clean
make yelmox_ismip6

if [ ${marine} -eq 1 ]; then
# MARINE
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/abuc_mbcs -p abumip.scenario="abuc" ctrl.run_step="abumip_proj" yelmo.restart=${floating_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="marine" 
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/abuk_mbcs -p abumip.scenario="abuk" ctrl.run_step="abumip_proj" yelmo.restart=${floating_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="marine" 
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/abum_mbcs -p abumip.scenario="abum" ctrl.run_step="abumip_proj" yelmo.restart=${floating_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="marine" abumip.bmb=-400 
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/abum-mod_mbcs -p abumip.scenario="abum" ctrl.run_step="abumip_proj" yelmo.restart=${floating_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="marine" abumip.bmb=-10 
fi

if [ ${floating} -eq 1 ]; then
# FLOATING
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/abuc_fbcs -p abumip.scenario="abuc" ctrl.run_step="abumip_proj" yelmo.restart=${floating_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="floating" 
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/abuk_fbcs -p abumip.scenario="abuk" ctrl.run_step="abumip_proj" yelmo.restart=${floating_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="floating" 
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/abum_fbcs -p abumip.scenario="abum" ctrl.run_step="abumip_proj" yelmo.restart=${floating_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="floating" abumip.bmb=-400 
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/abum-mod_fbcs -p abumip.scenario="abum" ctrl.run_step="abumip_proj" yelmo.restart=${floating_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="floating" abumip.bmb=-10 
fi

if [ ${all} -eq 1 ]; then
# ALL
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/abuc_abcs -p abumip.scenario="abuc" ctrl.run_step="abumip_proj" yelmo.restart=${floating_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="all" 
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/abuk_abcs -p abumip.scenario="abuk" ctrl.run_step="abumip_proj" yelmo.restart=${floating_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="all" 
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/abum_abcs -p abumip.scenario="abum" ctrl.run_step="abumip_proj" yelmo.restart=${floating_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="all" abumip.bmb=-400 
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/abum-mod_abcs -p abumip.scenario="abum" ctrl.run_step="abumip_proj" yelmo.restart=${floating_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="all" abumip.bmb=-10 
fi
fi

if [ ${zero} -eq 1 ]; then
while pgrep -x "yelmox_ismip6.x" > /dev/null; do
	    sleep 10
done

#### CHANGES bc0 --> tau_bc_int = 0.0; abumip.bmb = [-10, -400] (for abum)
cp ${yelmo_path}solver_ssa_sico5_zero.F90 ${yelmo_path}solver_ssa_sico5.F90
make clean
make yelmox_ismip6

if [ ${marine} -eq 1 ]; then
# MARINE
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/abuc_mbc0 -p abumip.scenario="abuc" ctrl.run_step="abumip_proj" yelmo.restart=${floating_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="marine" 
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/abuk_mbc0 -p abumip.scenario="abuk" ctrl.run_step="abumip_proj" yelmo.restart=${floating_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="marine" 
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/abum_mbc0 -p abumip.scenario="abum" ctrl.run_step="abumip_proj" yelmo.restart=${floating_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="marine" abumip.bmb=-400 
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/abum-mod_mbc0 -p abumip.scenario="abum" ctrl.run_step="abumip_proj" yelmo.restart=${floating_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="marine" abumip.bmb=-10 
fi

if [ ${floating} -eq 1 ]; then
# FLOATING
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/abuc_fbc0 -p abumip.scenario="abuc" ctrl.run_step="abumip_proj" yelmo.restart=${floating_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="floating" 
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/abuk_fbc0 -p abumip.scenario="abuk" ctrl.run_step="abumip_proj" yelmo.restart=${floating_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="floating" 
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/abum_fbc0 -p abumip.scenario="abum" ctrl.run_step="abumip_proj" yelmo.restart=${floating_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="floating" abumip.bmb=-400 
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/abum-mod_fbc0 -p abumip.scenario="abum" ctrl.run_step="abumip_proj" yelmo.restart=${floating_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="floating" abumip.bmb=-10 
fi

if [ ${all} -eq 1 ]; then
# ALL
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/abuc_abc0 -p abumip.scenario="abuc" ctrl.run_step="abumip_proj" yelmo.restart=${floating_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="all" 
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/abuk_abc0 -p abumip.scenario="abuk" ctrl.run_step="abumip_proj" yelmo.restart=${floating_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="all" 
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/abum_abc0 -p abumip.scenario="abum" ctrl.run_step="abumip_proj" yelmo.restart=${floating_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="all" abumip.bmb=-400 
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/abum-mod_abc0 -p abumip.scenario="abum" ctrl.run_step="abumip_proj" yelmo.restart=${floating_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="all" abumip.bmb=-10 
fi
fi

if [ ${ice} -eq 1 ]; then
while pgrep -x "yelmox_ismip6.x" > /dev/null; do
	    sleep 10
done

#### bch --> tau_bc_int = 0.5d0*rho_ice*g*H_ice_now**; abumip.bmb = [-10, -400] (for abum)
cp ${yelmo_path}solver_ssa_sico5_ice.F90 ${yelmo_path}solver_ssa_sico5.F90
make clean
make yelmox_ismip6

if [ ${marine} -eq 1 ]; then
# MARINE
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/abuc_mbch -p abumip.scenario="abuc" ctrl.run_step="abumip_proj" yelmo.restart=${floating_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="marine" 
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/abuk_mbch -p abumip.scenario="abuk" ctrl.run_step="abumip_proj" yelmo.restart=${floating_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="marine" 
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/abum_mbch -p abumip.scenario="abum" ctrl.run_step="abumip_proj" yelmo.restart=${floating_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="marine" abumip.bmb=-400 
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/abum-mod_mbch -p abumip.scenario="abum" ctrl.run_step="abumip_proj" yelmo.restart=${floating_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="marine" abumip.bmb=-10 
fi

if [ ${floating} -eq 1 ]; then
# FLOATING
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/abuc_fbch -p abumip.scenario="abuc" ctrl.run_step="abumip_proj" yelmo.restart=${floating_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="floating" 
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/abuk_fbch -p abumip.scenario="abuk" ctrl.run_step="abumip_proj" yelmo.restart=${floating_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="floating" 
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/abum_fbch -p abumip.scenario="abum" ctrl.run_step="abumip_proj" yelmo.restart=${floating_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="floating" abumip.bmb=-400 
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/abum-mod_fbch -p abumip.scenario="abum" ctrl.run_step="abumip_proj" yelmo.restart=${floating_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="floating" abumip.bmb=-10 
fi

if [ ${all} -eq 1 ]; then
# ALL
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/abuc_abch -p abumip.scenario="abuc" ctrl.run_step="abumip_proj" yelmo.restart=${floating_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="all" 
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/abuk_abch -p abumip.scenario="abuk" ctrl.run_step="abumip_proj" yelmo.restart=${floating_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="all" 
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/abum_abch -p abumip.scenario="abum" ctrl.run_step="abumip_proj" yelmo.restart=${floating_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="all" abumip.bmb=-400 
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/abum-mod_abch -p abumip.scenario="abum" ctrl.run_step="abumip_proj" yelmo.restart=${floating_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="all" abumip.bmb=-10 
fi
fi

if [ ${ocean} -eq 1 ]; then
while pgrep -x "yelmox_ismip6.x" > /dev/null; do
	    sleep 10
done

#### bco --> tau_bc_int =-0.5d0*rho_sw *g*H_ocn_now**2; abumip.bmb = [-10, -400] (for abum)
cp ${yelmo_path}solver_ssa_sico5_ocean.F90 ${yelmo_path}solver_ssa_sico5.F90
make clean
make yelmox_ismip6

if [ ${marine} -eq 1 ]; then
# MARINE
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/abuc_mbco -p abumip.scenario="abuc" ctrl.run_step="abumip_proj" yelmo.restart=${floating_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="marine" 
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/abuk_mbco -p abumip.scenario="abuk" ctrl.run_step="abumip_proj" yelmo.restart=${floating_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="marine" 
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/abum_mbco -p abumip.scenario="abum" ctrl.run_step="abumip_proj" yelmo.restart=${floating_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="marine" abumip.bmb=-400 
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/abum-mod_mbco -p abumip.scenario="abum" ctrl.run_step="abumip_proj" yelmo.restart=${floating_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="marine" abumip.bmb=-10 
fi

if [ ${floating} -eq 1 ]; then
# FLOATING
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/abuc_fbco -p abumip.scenario="abuc" ctrl.run_step="abumip_proj" yelmo.restart=${floating_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="floating" 
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/abuk_fbco -p abumip.scenario="abuk" ctrl.run_step="abumip_proj" yelmo.restart=${floating_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="floating" 
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/abum_fbco -p abumip.scenario="abum" ctrl.run_step="abumip_proj" yelmo.restart=${floating_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="floating" abumip.bmb=-400 
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/abum-mod_fbco -p abumip.scenario="abum" ctrl.run_step="abumip_proj" yelmo.restart=${floating_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="floating" abumip.bmb=-10 
fi

if [ ${all} -eq 1 ]; then
# ALL
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/abuc_abco -p abumip.scenario="abuc" ctrl.run_step="abumip_proj" yelmo.restart=${floating_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="all" 
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/abuk_abco -p abumip.scenario="abuk" ctrl.run_step="abumip_proj" yelmo.restart=${floating_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="all" 
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/abum_abco -p abumip.scenario="abum" ctrl.run_step="abumip_proj" yelmo.restart=${floating_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="all" abumip.bmb=-400 
./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/abum-mod_abco -p abumip.scenario="abum" ctrl.run_step="abumip_proj" yelmo.restart=${floating_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc="all" abumip.bmb=-10 
fi
fi
