# ABUK 01 16 KM
# Aim: study the effect off marine lateral bc

yelmox_path=/home/sergio/entra/models/yelmo_vers/v1.75/yelmox/
exp_name="abuk_01_16KM"
parameter=$(echo "floating" "marine")

namelist=yelmo_ismip6_Antarctica-16KM.nml
fldr=output/ismip6/${exp_name}/
runopt='-r'

#cd ${yelmox_path}
#echo "###########################"
#echo "Generating ${exp_name} spin-ups"
#echo "###########################"

#for i in ${parameter}; do
#    ./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/restart_${exp_name}_${i} -p ctrl.run_step="spinup_ismip6" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 ytopo.kt=1.0e-3 ymat.enh_shear=1 ydyn.ssa_lat_bc=${i}
#done

#while pgrep -x "yelmox_ismip6.x" > /dev/null; do
#    sleep 2
#done

#echo 'Spin-ups finished ------------------------------------------'

cd ${yelmox_path}
echo "###########################"
echo "Running ${exp_name} experiments"
echo "###########################"

for i in ${parameter}; do
    file_restart=${yelmox_path}/${fldr}/restart_${exp_name}_${i}/yelmo_restart.nc
    ./runylmox ${runopt} -e ismip6 -n par/yelmo_ismip6_Antarctica.nml -o ${fldr}/${exp_name}_${i} -p abumip.scenario="abuk" ctrl.run_step="abumip_proj" yelmo.restart=${file_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ytopo.kt=1.0e-3 ydyn.ssa_lat_bc=${i}
done

echo 'Experiments finished ------------------------------------------'
