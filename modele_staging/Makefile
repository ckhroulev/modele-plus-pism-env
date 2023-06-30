DATA_DIR ?= ${HOME}/modele_data

all: inputs rundeck.R icebin.cdl.template

clean:
	rm -rf ./prod_input_files

INPUTS=pism_Greenland_5km_v1.1.nc g20km_10ka.nc global_ecO_ng.nc topoo_ng.nc gcmO.nc topoa.nc GIC

ARCHIVED=\
CD144X90.ext.nc \
CO2profile.Jul2017.txt \
CROPS_and_pastures_Pongratz_to_Hurtt_144X90N_nocasp.nc \
GHG.CMIP6.1-2014.txt \
GLMELT_144X90_gas.OCN.nc \
H2Ocont_MT_CKD \
ISCCP.tautables \
Irrig144x90_1848to2100_FixedFuture_v3.nc \
LWCorrTables33k \
LWTables33k_lowH2O_CO2_O3_planck_1-800 \
MSU_SSU_RSS_weights.txt \
NCARIC.144x90.D7712010_ext.nc \
OST_144x90.1876-1885avg.CMIP6.nc \
RD_Fb.names.txt \
RD_Fb.nc \
REG2X2.5 \
S144X900098M.ext.nc \
SICE_144x90.1876-1885avg.CMIP6.nc \
STRATAER.VOL.1850-2014_CMIP6_hdr \
V144x90_EntMM16_height_trimmed_scaled_ext.nc \
V144x90_EntMM16_lai_max_trimmed_scaled_ext.nc \
V144x90_EntMM16_lai_trimmed_scaled_ext.nc \
V144x90_EntMM16_lc_max_trimmed_scaled_nocrops.ext.nc \
ZSIfac_144x90.1876-1885avg.CMIP6.nc \
ZVAR2X25A.nc \
cloud.epsilon4.72x46 \
cmip6_nint_inputs_E14TomaOCNf10_4av_decadal/BCA/ \
cmip6_nint_inputs_E14TomaOCNf10_4av_decadal/BCB/ \
cmip6_nint_inputs_E14TomaOCNf10_4av_decadal/BCdalbsn/ \
cmip6_nint_inputs_E14TomaOCNf10_4av_decadal/DUST/ \
cmip6_nint_inputs_E14TomaOCNf10_4av_decadal/NIT/ \
cmip6_nint_inputs_E14TomaOCNf10_4av_decadal/O3/ \
cmip6_nint_inputs_E14TomaOCNf10_4av_decadal/OCA/ \
cmip6_nint_inputs_E14TomaOCNf10_4av_decadal/SSA/ \
cmip6_nint_inputs_E14TomaOCNf10_4av_decadal/SUL/ \
dH2O_by_CH4_monthly \
miescatpar.abcdv2 \
o3_2010_shindell_144x90x49_April1850.nc \
oct2003.relhum.nr.Q633G633.table \
sgpgxg.table8 \
soil_textures_top30cm_2x2.5 \
soilcarb_top30cm_2x2.5.nc \
solar.CMIP6official.ann1850-2299_with_E3_fastJ.nc \
top_index_144x90_a.ij.ext.nc \
topcld.trscat8

${INPUTS}:
	mkdir -p ./prod_input_files/inputs
	cp ${DATA_DIR}/inputs/$@ ./prod_input_files/inputs/$@

${ARCHIVED} : ${DATA_DIR}/prod_input_files.zip
	unzip -n $^ prod_input_files/$@

inputs: ${INPUTS} ${ARCHIVED}
