#!/bin/bash


masses=(650 750 850 1000 1150 1300 1450 1600 1750 2050 2450 2850 3250 3650 4050)
#masses=(600 700 800 900 1200 1400 1600 1800 2000 2200 2400 2600 2800 3000 3500 4000)
model="narrow"
folder="/afs/cern.ch/work/s/sgelli/public/CMSSW_7_4_15/src/DiBosonAnalysis/myPlot_test/"
suffix=${1}
fileName="ak08_photon_mass"
for mass in ${masses[*]}
do
  echo "Launching for mass: "${mass}
  ./launcher.sh ${folder} ${fileName} ${model} ${mass} ${suffix}
done
