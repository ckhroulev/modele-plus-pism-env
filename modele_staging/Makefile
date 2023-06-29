export INPUT_DIR ?= ${PWD}
export OUTPUT_DIR ?= ${HOME}/modele_output
DATA_DIR ?= ~/modele_data

# files mentioned in icebin.cdl.template
INPUTS=pism_Greenland_5km_v1.1.nc g20km_10ka.nc global_ecO_ng.nc topoo_ng.nc gcmO.nc

local: inputs icebin.nc rundeck.R

container:
	${MAKE} -C . INPUT_DIR=/home/builder/modele_data OUTPUT_DIR=/home/builder/modele_output

icebin.nc: icebin.cdl.template
	cat $^  | envsubst | ncgen -o $@ -

rundeck.R: rundeck.R.template
	cat $^  | envsubst > $@

${INPUTS}:
	cp ${DATA_DIR}/inputs/$@ ./$@

inputs: ${INPUTS}

clean:
	rm -f *.nc rundeck.R

# if desperate, try to get a file from the massive archive:
%.nc : ${DATA_DIR}/prod_input_files.zip
	unzip -n -j $^ prod_input_files/$@
