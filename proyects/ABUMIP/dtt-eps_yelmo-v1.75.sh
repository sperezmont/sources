# Tests with Yelmo v1.75
# Aim: study the effect of  yelmo.pc_eps and dtt
file_restart=/home/sergio/entra/ice_data/restart/alexr-yelmo_ismip6/spinup_32km_68/0/yelmo_restart.nc
yelmox_path=/home/sergio/entra/yelmo_vers/v1.75/yelmox/
fldr=output/ismip6/dtt-eps_yelmo-v1.75/

runopt='-r'
paropt="ytopo.kt=1.0e-3"
namelist=yelmo_ismip6_Antarctica-AR-restart.nml

exps=$(echo "abum" "abuk")
eps=$(echo 0.5 1.0 2.0 3.0)
timesteps=$(echo 0.5 1.0 2.0 3.0 4.0 5.0)

echo "###########################"
echo "Running dtt-eps experiments"
echo "###########################"

cd ${yelmox_path}
for k in $exps; do
    for i in $eps; do
        for j in $timesteps; do
            echo "### ${k}-marine_eps${i}_dtt${j}"
            ./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/${k}-marine_eps${i}_dtt${j} -p abumip.scenario=${k} ctrl.run_step="abumip_proj" yelmo.restart=${file_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ${paropt} ydyn.ssa_lat_bc="marine" yelmo.pc_eps=${i} abumip_proj.dtt=${j}
            while pgrep -x "yelmox_ismip6.x" > /dev/null; do
                sleep 2
            done
done
done
done
