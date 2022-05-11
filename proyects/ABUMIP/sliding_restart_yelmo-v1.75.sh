# Sliding law (q) spin-ups maker with Yelmo v1.75
# Aim: generate yelmo_restart.nc for different ydyn.beta_q values
yelmox_path=/home/sergio/entra/yelmo_vers/v1.75/yelmox/

slidingmethod="3"
betaq=$(echo "0.0" "0.2" "0.5" "1.0") #  
namelist=yelmo_ismip6_Antarctica-AR-restart.nml
fldr=output/ismip6/sliding_restart_yelmo-v1.75/
path_restart=${yelmox_path}/${fldr}/
runopt='-r'
paropt="ytopo.kt=1.0e-3"

# First we create the restart file (spin-up) for each bmb method
echo "Generating sliding (q) spin-ups"
cd ${yelmox_path}
for i in ${betaq}; do
    FILE=${path_restart}/meth${slidingmethod}_beta_q${i}/yelmo_restart.nc
    if [ -f "$FILE" ]; then
        echo "$FILE exists"
    else
        echo " ## $FILE does not exist"
        echo " ### Generating meth${slidingmethod}_beta_q${i} restart file"
        ./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${path_restart}/meth${slidingmethod}_beta_q${i} -p ctrl.run_step="spinup_ismip6" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 ytopo.kt=1.0e-3 ymat.enh_shear=1 ydyn.beta_method=${slidingmethod} ydyn.beta_q=${i}

        #while pgrep -x "yelmox_ismip6.x" > /dev/null; do
        #    sleep 2
        #done
    fi
done
