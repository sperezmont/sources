# BMB-dtt tests with Yelmo v1.75
# Aim: study the effect of bmb_gl_method and dtt on ABUC and ABUM-floating
yelmox_path=/home/sergio/entra/yelmo_vers/v1.75/yelmox/

exps=$(echo "abuc" "abum") #
bmbmeth=$(echo "fcmp" "pmp" "nmp") #  
timesteps=$(echo 0.5 1.0 2.0 3.0 4.0 5.0)   #

namelist=yelmo_ismip6_Antarctica-AR-restart.nml
fldr=output/ismip6/bmb-dtt_yelmo-v1.75/
path_restart=${yelmox_path}/output/ismip6/bmb_restart_yelmo-v1.75/
runopt='-r'
paropt="ytopo.kt=1.0e-3"

echo "Running bmb-dtt experiments"
cd ${yelmox_path}
# First we create the restart file (spin-up) for each bmb method
#for i in ${bmbmeth}; do
#    FILE=${path_restart}/${i}/yelmo_restart.nc
#    if [ -f "$FILE" ]; then
#        echo "$FILE exists"
#    else
#        echo " ## $FILE does not exist"
#        echo " ### Generating ${i} restart file"
#        ./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${path_restart}/${i} -p ctrl.run_step="spinup_ismip6" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 ytopo.kt=1.0e-3 ymat.enh_shear=1 ytopo.bmb_gl_method=${i}
        
#        while pgrep -x "yelmox_ismip6.x" > /dev/null; do
#            sleep 2
#        done
#    fi
#done


# Now we will run the experiments ABUC and ABUM
for k in $exps; do
    for i in $bmbmeth; do
        for j in $timesteps; do
            echo "#### ${k}_${i}_dtt${j}"
            file_restart=/${path_restart}/${i}/yelmo_restart.nc
            ./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/${k}_${i}_dtt${j} -p abumip.scenario=${k} ctrl.run_step="abumip_proj" yelmo.restart=${file_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ${paropt} ydyn.ssa_lat_bc="floating" ytopo.bmb_gl_method=${i} abumip_proj.dtt=${j}
            
            while pgrep -x "yelmox_ismip6.x" > /dev/null; do
                sleep 2
            done
done
done
done

# cd "/home/sergio/entra/proyects/ABUMIP/scripts/sh"
# nohup ./bmb-fmb_yelmo-v1.75.sh &
