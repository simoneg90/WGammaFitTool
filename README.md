# WGammaFitTool
Repository created from the ZGamma analysis tool: https://github.com/lovedeepkaursaini/ZgFull2016
Instruction will be shortly available

Command: ./launchAllMasses.sh folder_suffix
folder_suffix is just a string attached to the output folder.
In launchAllMasses.sh you will find the masses list, the model name,
the directory where the .root file with the histos.
- data histogram name: dataHisto
- signal histogram name: signal_%d_%s (mass value, model: narrow or large. e.g. signal_1300_narrow)
- histogram bin width: 1 GeV
- the filename name should be: ak08_photon_mass_category.root, where category can be: btag, antibtag, tau21, antitau21
