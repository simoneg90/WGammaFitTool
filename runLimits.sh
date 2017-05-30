#!/bin/bash

postfix=(
    `cat inputs_to_process.txt`
)

debug=${1}
mass=${2}
model=${3}
suffix=${4}
categories=(btag tau21 antitau21)

for category in ${categories[*]}  #${postfix[@]}
do
    echo running asymptotic limits for $category
    dirName="info_${mass}_${category}_${model}${suffix}"    
    dcardName="datacard_${mass}_${category}_${model}"
    logName="asymp_${mass}_${category}_${model}.log"

    pushd $dirName > /dev/null
    text2workspace.py ${dcardName}.txt -o ${dcardName}.root >& /dev/null
    #combine -M Asymptotic -m ${mass} ${dcardName}.txt -t -1 --rMax 2.0 -L libdiphotonsUtils | tee ${logName}
    combine -M Asymptotic -m ${mass} ${dcardName}.txt -L libdiphotonsUtils | tee ${logName}
    #combine -M HybridNew -H ProfileLikelihood -m ${mass} -t -1 --rMax=0.05 --frequentist --fork 8 ${dcardName}.txt -L libdiphotonsUtils | tee ${logName}
    if [ $debug -eq 1 ]; then
        mkdir -p sig
        #combine -M MaxLikelihoodFit -m ${mass} --robustFit=1 --rMin=-5 --rMax=5 -t -1 --plots --out sig ${dcardName}.txt -L libdiphotonsUtils | tee debug_${logName}
        combine -M MaxLikelihoodFit -m ${mass} --robustFit=1 --rMin=-5 --rMax=5 --plots --out sig ${dcardName}.txt -L libdiphotonsUtils | tee debug_${logName}
    fi
    popd > /dev/null
done

#combine -M Asymptotic -m ${mass} -t -1 --rMax 2.0 -L libdiphotonsUtils datacard_qqg_${mass}_combined.txt | tee asymp_${mass}_combo.log
combine -M Asymptotic -m ${mass} -L libdiphotonsUtils datacard_qqg_${mass}_${model}${suffix}_combined.txt | tee asymp_${mass}_comb.log
#combine -M HybridNew -H ProfileLikelihood -m ${mass} -t -1 --rMax=0.05 --frequentist --fork 8 -L libdiphotonsUtils datacard_qqg_${mass}_combined.txt | tee asymp_${mass}_combo.log
