# BMB spin-ups maker with Yelmo v1.75
# Aim: generate yelmo_restart.nc for different bmb_gl_method values
yelmox_path=/home/sergio/entra/yelmo_vers/v1.75/yelmox/
bmbmeth=$(echo "fcmp" "pmp" "nmp") #  
namelist=yelmo_ismip6_Antarctica-AR-restart.nml
fldr=output/ismip6/bmb_restart_yelmo-v1.75/
path_restart=${yelmox_path}/${fldr}/
runopt='-r'
paropt="ytopo.kt=1.0e-3"

# First we create the restart file (spin-up) for each bmb method
echo "Generating bmb spin-ups"
cd ${yelmox_path}
for i in ${bmbmeth}; do
    FILE=${path_restart}/${i}/yelmo_restart.nc
    if [ -f "$FILE" ]; then
        echo "$FILE exists"
    else
        echo " ## $FILE does not exist"
        echo " ### Generating ${i} restart file"
        ./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${path_restart}/${i} -p ctrl.run_step="spinup_ismip6" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 ytopo.kt=1.0e-3 ymat.enh_shear=1 ytopo.bmb_gl_method=${i}

        #while pgrep -x "yelmox_ismip6.x" > /dev/null; do
        #    sleep 2
        #done
    fi
done
