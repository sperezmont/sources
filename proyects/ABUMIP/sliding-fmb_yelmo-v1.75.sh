# sliding-fmb tests with Yelmo v1.75

yelmox_path=/home/sergio/entra/yelmo_vers/v1.75/yelmox/

exps=$(echo "abuc" "abum")
slidingmethod=$(echo "2" "3")
betaq=$(echo "0.0" "0.2" "0.5" "1.0")
fmbscale=$(echo 0.0 0.5 1.0 10.0)

namelist=yelmo_ismip6_Antarctica-AR-restart.nml
fldr=output/ismip6/sliding-fmb_yelmo-v1.75/
path_restart=${yelmox_path}/output/ismip6/sliding_restart_yelmo-v1.75/
runopt='-r'
paropt="ytopo.kt=1.0e-3"

while pgrep -x "yelmox_ismip6.x" > /dev/null; do
    sleep 2
done

cd ${yelmox_path}
echo "###########################"
echo "Running sliding-fmb experiments"
echo "###########################"

for k in $exps; do
	for i in $slidingmethod; do
        	for j in $betaq; do
        		for n in $fmbscale; do
			    echo "#### ${k}_m${i}q${j}f${n}"
			    file_restart=/${path_restart}/meth${i}_beta_q${j}/yelmo_restart.nc
			    echo "${file_restart}"
			    ./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/${k}_m${i}q${j}f${n} -p abumip.scenario=${k} ctrl.run_step="abumip_proj" yelmo.restart=${file_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ${paropt} ydyn.ssa_lat_bc="floating" ydyn.beta_method=${i} ydyn.beta_q=${j} ytopo.fmb_scale=${n}

			done
		while pgrep -x "yelmox_ismip6.x" > /dev/null; do
			sleep 10
		done
		done
	done
done

echo 'Finished'


