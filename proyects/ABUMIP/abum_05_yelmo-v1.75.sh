# ABUM_05 tests with Yelmo v1.75
# Aim: study the effect of  ytopo.bmb_gl_method = ['fcmp','fmp','pmp','nmp'] and ytopo.fmb_scale=[0, 10]
file_restart=/home/sergio/entra/ice_data/restart/alexr-yelmo_ismip6/spinup_32km_68/0/yelmo_restart.nc
fldr=output/ismip6/abum_05_yelmo-v1.75/

runopt='-r'
paropt="ytopo.kt=1.0e-3"

methods=$(echo "fcmp" "fmp" "pmp" "nmp")
scales=$(echo 0.0 1.0 10.0)

for i in $methods; do
    for j in $scales; do
    
        ./runylmox ${runopt} -e ismip6 -n par/yelmo_ismip6_Antarctica.nml -o ${fldr}/${i}_fmb${j} -p abumip.scenario="abum" ctrl.run_step="abumip_proj" yelmo.restart=${file_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ${paropt} ytopo.bmb_gl_method=${i} ytopo.fmb_scale=${j}
	
done
done
