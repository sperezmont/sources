# BMB-taud_lim tests with Yelmo v1.75
# Aim: study the dependency of bmb_gl_method with taud_lim on ABUM-floating
# How to run --> nohup bmb-taud_lim_yelmo-v1.75.sh &
yelmox_path=/home/sergio/entra/yelmo_vers/v1.75/yelmox/

exps=$(echo "abum")
bmbmeth=$(echo "fcmp") #"pmp" "nmp")
fmbscale=$(echo 0.0)
taudlim=$(echo 30e2 30e3 30e4 30e5) # [default = 200000.0 Pa]	300000.0 Pa

namelist=yelmo_ismip6_Antarctica-AR-restart.nml
fldr=output/ismip6/bmb-taud_lim_yelmo-v1.75/
path_restart=${yelmox_path}/output/ismip6/bmb_restart_yelmo-v1.75/
runopt='-r'
paropt="ytopo.kt=1.0e-3"

cd ${yelmox_path}
echo "###########################"
echo "Running bmb-taud_lim experiments"
echo "###########################"
# Now we will run the experiments ABUC and ABUM
for k in $exps; do
    for i in $bmbmeth; do
        for j in $fmbscale; do
        	for l in $taudlim; do
		    echo "#### ${k}_${i}_fmb${j}_taudl${l}"
		    file_restart=/${path_restart}/${i}/yelmo_restart.nc
		    echo "${file_restart}"
		    ./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/${k}_${i}_fmb${j}_taudl${l} -p abumip.scenario=${k} ctrl.run_step="abumip_proj" yelmo.restart=${file_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ${paropt} ydyn.ssa_lat_bc="floating" ytopo.bmb_gl_method=${i} ytopo.fmb_scale=${j} ydyn.taud_lim=${l}
		    
		    #while pgrep -x "yelmox_ismip6.x" > /dev/null; do
		    #    sleep 2
		    #done
done
done
done
done



