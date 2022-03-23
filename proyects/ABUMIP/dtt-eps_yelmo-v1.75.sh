# Tests with Yelmo v1.75
# Aim: study the effect of  yelmo.pc_eps and dtt
file_restart=/home/sergio/entra/ice_data/restart/alexr-yelmo_ismip6/spinup_32km_68/0/yelmo_restart.nc

fldr=output/ismip6/dtt-eps_yelmo-v1.75/

runopt='-r'
paropt="ytopo.kt=1.0e-3"

exps=$(echo "abum" "abuk")
eps=$(echo 0.5 1.0 2.0 3.0)
timesteps=$(echo 0.5) # 1.0 2.0 3.0 4.0 5.0)

for k in $exps; do
    for i in $eps; do
        for j in $timesteps; do
            ./runylmox ${runopt} -e ismip6 -n par/yelmo_ismip6_Antarctica.nml -o ${fldr}/${k}-marine_eps${i}_dtt${j} -p abumip.scenario=${k} ctrl.run_step="abumip_proj" yelmo.restart=${file_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ${paropt} ydyn.ssa_lat_bc="marine" yelmo.pc_eps=${i} abumip_proj.dtt=${j}
done
done
done
