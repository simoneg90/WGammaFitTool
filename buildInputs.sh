#!/bin/bash

postfix=(
    `cat inputs_to_process.txt`
)

rebinData=${1}
rebinSignal=${2}
mass=${3}
fitModel=${4}
dirname=${5}
filename=${6}
file=${dirname}"/"${filename}
category=${7}
model=${8}
suffix=${9}

signalHistoName="signal_"${mass}"_"${model}

#echo -e "Complete file for Signal: "${file}
outDir=info_${mass}_${category}_${model}${suffix}

mkdir -p info_${mass}_${category}_${model}${suffix}
echo -e "\nAnalysing "${category}" category\n"
echo -e  "root -x -b -l -q Display_SignalFits.cc\(\"${category}\"\,\"${file}\",\"${signalHistoName}\",${mass},${rebinSignal},\"${model}\",\"${suffix}\"\) > ${outDir}/signal$_${mass}_${category}_${model}.log\n"
root -x -b -l -q Display_SignalFits.cc\(\"${category}\"\,\"${file}\",\"${signalHistoName}\",${mass},${rebinSignal},\"${model}\",\"${suffix}\"\) > ${outDir}/signal_${mass}_${category}_${model}.log
#root -x -b -l -q Display_SignalFits.cc\(\"${name}\"\,\"../${dirname}/\",\"histZg_minitree_mrgd_GluGluSpin0ToZGamma_ZToQQ_W_0-p-014_M_\",${mass},${rebin}\) > info_${mass}_${name}/signal${mass}_${name}_sig.log

#echo -e "root -x -b -l -q BackgroundPrediction.c\(\"${name}\",\"../histZg_minitree_mrgd_SP_Run2016BtoH.root\",${rebin},${fitModel},${mass}\) > info_${mass}_${name}/data_${name}_bkg.log\n"
###root -x -l -b -q BackgroundPrediction.c\(\"btag\",\"/afs/cern.ch/work/s/sgelli/public/CMSSW_7_4_15/src/DiBosonAnalysis/myPlot_test/ak08_photon_massprova.root\",30,0,900\)
echo -e "root -x -b -l -q BackgroundPrediction.c\(\"${category}\",\"${file}\",${rebinData},${fitModel},${mass},\"${model}\",\"${suffix}\"\) > ${outDir}/data_${category}_${model}_bkg.log\n"
root -x -b -l -q BackgroundPrediction.c\(\"${category}\",\"${file}\",${rebinData},${fitModel},${mass},\"${model}\",\"${suffix}\"\) > ${outDir}/data_${category}_${model}_bkg.log
##root -x -b -l -q BackgroundPrediction.c\(\"${name}\",\"../histZg_minitree_mrgd_SP_Run2016BtoH.root\",${rebin},${fitModel},${mass}\) > info_${mass}_${name}/data_${name}_bkg.log





#for name in ${postfix[@]}
#do
#    mkdir info_${mass}_${name}
#    echo $name
#    echo
#    echo "root -x -b -l -q Display_SignalFits.cc\(\"${name}\"\,\"../${dirname}/\",\"\",${mass},${rebin}\) > info_${mass}_${name}/signal${mass}_${name}_sig.log"
#    echo
#    root -x -b -l -q Display_SignalFits.cc\(\"${name}\"\,\"../${dirname}/\",\"histos_signal-\",${mass},${rebin}\) > info_${mass}_${name}/signal${mass}_${name}_sig.log
#    #root -x -b -l -q Display_SignalFits.cc\(\"${name}\"\,\"../${dirname}/\",\"histZg_minitree_mrgd_GluGluSpin0ToZGamma_ZToQQ_W_0-p-014_M_\",${mass},${rebin}\) > info_${mass}_${name}/signal${mass}_${name}_sig.log
#    echo
#    echo "root -x -b -l -q BackgroundPrediction.c\(\"${name}\",\"../histZg_minitree_mrgd_SP_Run2016BtoH.root\",${rebin},${fitModel},${mass}\) > info_${mass}_${name}/data_${name}_bkg.log"
#    #echo
#    #root -x -b -l -q BackgroundPrediction.c\(\"${name}\",\"../${dirname}/\",\"../histos_bkg.root\",${rebin},${fitModel},${mass}\) > info_${mass}_${name}/data_${name}_bkg.log
#    root -x -b -l -q BackgroundPrediction.c\(\"${name}\",\"../histZg_minitree_mrgd_SP_Run2016BtoH.root\",${rebin},${fitModel},${mass}\) > info_${mass}_${name}/data_${name}_bkg.log
#    
#done

