# bmb-sliding-fmb tests with Yelmo v1.75
yelmox_path=/home/sergio/entra/yelmo_vers/v1.75/yelmox/

exps=$(echo "abuc" "abum")
bmbmeth=$(echo "fcmp" "pmp" "nmp")
slidingmethod=$(echo "2" "3")
betaq=$(echo "0.0" "0.2" "0.5" "1.0")
fmbscale=$(echo 0.0 0.5 1.0 10.0)

namelist=yelmo_ismip6_Antarctica-AR-restart.nml
fldr=output/ismip6/bmb-sliding-fmb_yelmo-v1.75/
runopt='-r'
paropt="ytopo.kt=1.0e-3"


#cd ${yelmox_path}
#echo "###########################"
#echo "Generating bmb-sliding-fmb spin-ups"
#echo "###########################"

#for i in ${bmbmeth}; do
#	for j in ${slidingmethod}; do
#		for k in ${betaq}; do
#			FILE=${fldr}/restart_${i}-m${j}q${k}/yelmo_restart.nc
#			if [ -f "$FILE" ]; then
#				echo "$FILE exists"
#			else
#				echo " ## restart_${i}-m${j}q${k} does not exist"
#				echo " ### Generating restart_${i}-m${j}q${k} file"
#				./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/restart_${i}-m${j}q${k} -p ctrl.run_step="spinup_ismip6" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 ytopo.kt=1.0e-3 ymat.enh_shear=1 ytopo.bmb_gl_method=${i} ydyn.beta_method=${j} ydyn.beta_q=${k}
#			fi
#		done
#	while pgrep -x "yelmox_ismip6.x" > /dev/null; do
#	    sleep 10
#	done
#	done
#done

#echo 'Spin-ups finished ------------------------------------------'

#while pgrep -x "yelmox_ismip6.x" > /dev/null; do
#    sleep 2
#done

cd ${yelmox_path}
echo "###########################"
echo "Running bmb-sliding-fmb experiments"
echo "###########################"

for e in ${exps}; do
	for i in ${bmbmeth}; do
		for j in ${slidingmethod}; do
			for k in ${betaq}; do
        			for n in ${fmbscale}; do
					echo "#### ${e}_${i}-m${j}q${k}f${n} using restart_${i}-m${j}q${k}"
					file_restart=${yelmox_path}/${fldr}/restart_${i}-m${j}q${k}/yelmo_restart.nc
					./runylmox ${runopt} -e ismip6 -n par/${namelist} -o ${fldr}/${e}_${i}-m${j}q${k}f${n} -p abumip.scenario=${e} ctrl.run_step="abumip_proj" yelmo.restart=${file_restart} abumip_proj.scenario="ctrl" tf_cor.name="dT_nl" marine_shelf.gamma_quad_nl=14500 isostasy.method=0 ${paropt} ydyn.ssa_lat_bc="floating" ytopo.bmb_gl_method=${i} ydyn.beta_method=${j} ydyn.beta_q=${k} ytopo.fmb_scale=${n}

				done
			while pgrep -x "yelmox_ismip6.x" > /dev/null; do
				sleep 10
			done
			done
		done
	done
done

echo 'Simulations are finished'


