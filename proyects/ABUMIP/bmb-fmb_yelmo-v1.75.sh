# BMB-fmb tests with Yelmo v1.75
# Aim: study the effect of bmb_gl_method and fmb on ABUC and ABUM-floating
yelmox_path=/home/sergio/entra/yelmo_vers/v1.75/yelmox/

exps=$(echo "abuc" "abum")
bmbmeth=$(echo "fcmp" "pmp" "nmp")
fmbscale=$(echo 0.0 1.0 10.0)

fldr=output/ismip6/bmb-fmb_yelmo-v1.75/
path_restart=${yelmox_path}/bmb-dtt_yelmo-v1.75/restart/
runopt='-r'
paropt="ytopo.kt=1.0e-3"

cd ${yelmox_path}
echo "Running bmb-fmb experiments"

# Now we will run the experiments ABUC and ABUM
for k in $exps; do
    for i in $bmbmeth; do
        for j in $fmbscale; do
            echo "#### ${k}_${i}_fmb${j}"
            file_restart=/${path_restart}/${i}/yelmo_restart.nc
            ./runylmox ${runopt} -e ismip6 -n par/yelmo_ismip6_Antarctica.nml -o ${fldr}/${k}_${i}_fmb${j} -p abumip.scenario=${k} ctrl.run_step="abumip_proj" yelmo.restart=${file_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ${paropt} ydyn.ssa_lat_bc="floating" ytopo.bmb_gl_method=${i} ytopo.fmb_scale=${j}
            
            while pgrep -x "yelmox_ismip6.x" > /dev/null; do
                sleep 2
            done
done
done
done
