#!/bin/bash

# usage ./launcher dirName fileName model mass suffix
# the fileName has to be without .root and the category

rebinData=20
rebinSignal=10

debug=0
dirName=${1}
fileName=${2}
model=${3}
mass=${4}
suffix=${5}
categories=(btag tau21 antitau21)
signalHistoName=${mass}"_"${model}

echo -e "\nProcessing command: ./launcher.sh "${1}" "${2}" "${3}" "${4}" "${5}"\n"
for category in ${categories[*]}
do
  echo -e "\n++++++++++++++++++++++++++++++++"
  echo -e "      Analyzing folder:         "
  echo -e "      "${dirName}
  echo -e "      File:                     "
  echo -e "      "${fileName}"_"${category}".root"
  echo -e "      Category:                 "
  echo -e "      "${category}
  echo -e "      Mass:                     "
  echo -e "      "${mass}" GeV"
  echo -e "      Model:                    "
  echo -e "      "${model}
  echo -e "++++++++++++++++++++++++++++++++\n"

  ./buildInputs.sh ${rebinData} ${rebinSignal} ${mass} 0 ${dirName} ${fileName}"_"${category}".root" ${category} ${model} ${suffix}
  #./buildDatacards.sh ${mass} ${category} ${models}
  #./runLimits.sh ${debug} ${mass}
done
#echo ${categories[*]}
echo "./"buildDatacards.sh ${mass} ${model} ${suffix}
./buildDatacards.sh ${mass} ${model} ${suffix}
echo "./"runLimits.sh ${debug} ${mass} ${model} ${suffix}
./runLimits.sh ${debug} ${mass} ${model} ${suffix}
