#!/bin/bash

#postfix=(
#    `cat inputs_to_process.txt`
#)

mass=${1}
model=${2}
suffix=${3}
categories=(btag tau21 antitau21)

echo "Categories: "${categories[*]}

extratau21=`python -c "import math; print ('%.4f'% (1+0.01*4.1*math.log(0.5*${mass}/200.)))"`
echo $extratau21


extraantitau21=`python -c "import math; print ('%.4f'% (1+0.01*5.4*math.log(0.5*${mass}/200.)))"`
echo $extraantitau21

pessys=`python -c "import math; print('%.4f'% (0.22/(5.11+math.exp(-0.0033*${mass}+5.44))))"`
echo $pessys

pdfsys=`python -c "print ('%.4f'% (0.00101+(0.000000281)*${mass}+(-0.00000000259)*${mass}*${mass}+(0.0000000000020006)*${mass}*${mass}*${mass}+(-0.000000000000000211)*${mass}*${mass}*${mass}*${mass}))"`
pdfsysm=`python -c "print 1+max(0.01,$pdfsys)"`
echo $pdfsys $pdfsysm


echo "0.12+${mass}*0.07*0.001" | bc -l
btagSys=$(bc <<< "scale=3;1+0.12+${mass}*0.07*0.001")
echo $btagSys
antibtagSys=$(bc <<< "scale=3;1/${btagSys}")
echo $antibtagSys
cards=""
for category in ${categories[*]}   #${postfix[@]}
do

    dirName="info_${mass}_${category}_${model}${suffix}"
    echo building datacard for ${category} and ${model} in ${dirName}
    dcardName="datacard_${mass}_${category}_${model}.txt"
    bgLogName="data_${category}_${model}_bkg.log"
    sig_norm=`grep 'norm =' ${dirName}/index.html | awk '{print $3}'`    
    bkg_norm=`grep ' Background number of events = ' ${dirName}/${bgLogName} | awk '{print $6}'`
    
    #let's build a datacard!
    cat > ${dirName}/${dcardName} <<EOF
imax 1 number of channels
jmax * number of backgrounds
kmax * number of systematic uncertainty sources
----------
shapes signal     Vg w_signal_${mass}.root      Vg:signal_fixed_${category}
shapes background Vg w_background_GaussExp.root Vg:bg_${category}
shapes data_obs   Vg w_data.root                Vg:data_obs
----------
## Observation
bin                     Vg
observation             -1
----------
bin                   Vg          Vg
process               signal      background
process               0           1
rate                  ${sig_norm} 1
cms_lumi_13TeV          lnN              1.026       -    
cms_tau21_sf_13TeV      lnN              1.113/0.898       -
cms_tau21_sf_13TeV      lnN              0.902/1.109       -
cms_extra_tau21_sf_13TeV      lnN        $extratau21        -
cms_extra_tau21_sf_13TeV      lnN        $extraantitau21        -
cms_btag_sf_13TeV       lnN              1.32       -         
cms_btag_sf_13TeV       lnN              0.76        -
cms_JES_13TeV           lnN              1.04        -         
cms_phoHLT_13TeV        lnN              1.02        -         
cms_pho_sf_13TeV        lnN              1.015        -         
cms_pileup_13TeV        lnN              1.01        -         
cms_xzg_pdf_13TeV       lnN              $pdfsysm        -         
ggH_hzg_mShift_el_8TeV_cat0 param 0 $pessys
cms_swidth_JER_13TeV  param 0 0.025
EOF

    
    #now add the systematics to the card
    #grep 'signal_' ${dirName}/index.html | awk '{print $1 " " $2 " " $3 " " $4}' >>  ${dirName}/${dcardName}
    #grep 'bias_term_' ${dirName}/${bgLogName} | grep ' param ' >> ${dirName}/${dcardName}
    #grep 'bg_' ${dirName}/${bgLogName} | grep 'param' >> ${dirName}/${dcardName}
    if [[ $dcardName == *"tau"* ]]
    then
	sed -i '/cms_btag_sf_13TeV.*1\.32.*/d' ${dirName}/${dcardName}
        sed -i '/cms_extra_tau21_sf_13TeV.*'${extraantitau21}'.*/d' ${dirName}/${dcardName}
        sed -i '/cms_tau21_sf_13TeV.*0\.902\/1\.109.*/d' ${dirName}/${dcardName}
    elif [[ $dcardName == *"anti"* ]]
      then
        sed -i '/cms_btag_sf_13TeV.*1\.32.*/d' ${dirName}/${dcardName}
        sed -i '/cms_extra_tau21_sf_13TeV.*'${extratau21}'.*/d' ${dirName}/${dcardName}
        sed -i '/cms_tau21_sf_13TeV.*1\.113\/0\.898.*/d' ${dirName}/${dcardName}
    elif [[ $dcardName == *"btag"* ]]
      then
        sed -i '/cms_extra_tau21_sf_13TeV.*'${extraantitau21}'.*/d' ${dirName}/${dcardName}
        sed -i '/cms_extra_tau21_sf_13TeV.*'${extratau21}'.*/d' ${dirName}/${dcardName}
        sed -i '/cms_tau21_sf_13TeV.*0\.902\/1\.109.*/d' ${dirName}/${dcardName}
        sed -i '/cms_tau21_sf_13TeV.*1\.113\/0\.898.*/d' ${dirName}/${dcardName}
        sed -i '/cms_btag_sf_13TeV.*0.76.*/d' ${dirName}/${dcardName}
    fi

    cards+="${dirName}/${dcardName} "
done
echo ${cards}
combineCards.py -S $cards > datacard_qqg_${mass}_${model}${suffix}_combined.txt

