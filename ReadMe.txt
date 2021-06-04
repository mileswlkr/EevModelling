Automotive R1234yf reversible heat pump system expansion valve dataset & mass flow modelling
---
AFFILIATIONS
Loughborough University Department of Aeronautical and Automotive Engineering
HORIBA MIRA
---
INTRODUCTION
This data and accompanying analysis are made available to aid the reproducibility of a research paper that references it (pending approval) – and to provide open data for electronic expansion valve modelling with refrigerant R1234yf in an automotive reversible heat pump system.
Experimentation was undertaken in the Thermal Systems Laboratory at HORIBA MIRA in Nuneaton, UK.
---
CITATION INFORMATION
(pending approval)
---
DESCRIPTION OF DATA AND SCRIPTS
This repository contains both raw data and scripts used to fit expansion valve mass flow models. The data was collected over a 2-day period: continuously between 07:54 to 17:34 on 28/01/2021 and 07:24 to 17:44 on 29/01/2021 with a sample rate of 1Hz. The two sets of data are concatenated for the purposes of model fitting and validation.
The main purpose of the scripts is to fit 4 types of mass flow model to the data – constant-coefficient, polynomial-coefficient, power-law coefficient and neuro-fuzzy models.
---
SUMMARY OF DATA COLLECTION
The expansion valve used was a Carel E2V18 driven using a Carel EVD evolution driver. The system used to generate the expansion valve data included Nissan Leaf heat exchangers (HVAC evaporator and external heat exchanger (EHX) operating as a condenser) and accumulator (with modified outer shell) and a Gallay PVH6797-T clutched mechanical compressor (with a capacity of 154.8 cm3) – see “ExperimentalSetup.png” in the “Supporting” folder. The system was charged with 1.2 kg of R1234yf refrigerant and used PAG 46 YF oil. 
A space-filling design approach was taken to the selection of system inputs – which were broad (see “SpaceFillingInputs.emf” in the “Supporting” folder for pairwise plots of the designed inputs).
---
USING THE DATA FILES
The raw data is available through the CSV files in the “Data” folder (TD_2021-01-28_07-54-16.CSV and TD_2021-01-29_07-24-54.CSV). This data has been processed into a table data type in MATLAB which can be loaded through the *.mat files with the same name.
MATLAB R2019b was used and the file “EevModelFitting.mlx” contains all the model fitting results and residual plots. The MATLAB project file (“EEVanalysis.prj”) should be loaded be loaded first so that dependent files in repository subfolders are able to be referenced by “EevModelFitting.mlx”.
Additional programs are required for the scripts to run without errors:
-	REFPROP:
	o	Release 10.0 was used.
	o	Required by “fInitR1234yf” to load R1234yf fluid properties into MATLAB.
-	Python:
	o	Version 3.7 was used.
	o	Required for access to CoolProp database. CoolProp is used for additional fluid property calculations (such as surface tension).
-	LMN toolbox [1]:
	o	Version 1.5.2 was used.
	o	Required for neuro-fuzzy modelling section.
---
FURTHER INFORMATION
For additional information, please contact Miles Walker through miles.walker@horiba-mira.com.
---
ACKNOWLEDGEMENTS
This work was carried out as part of a PhD project funded by HORIBA MIRA.


[1]	B. Hartmann, T. Ebert, T. Fischer, J. Belz, G. Kampmann, and O. Nelles, “LMNTOOL-Toolbox zum automatischen Trainieren lokaler Modellnetze,” Proc. 22. Work. Comput. Intell., no. December, pp. 341–355, 2012.