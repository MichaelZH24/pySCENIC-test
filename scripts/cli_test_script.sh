#!/usr/bin/env bash

DATA_FOLDER="./cli_test_data/"
CORES=6
DB_FOLDER="/Users/bramvandesande/Projects/lcb/databases/"
RESOURCES_FOLDER="/Users/bramvandesande/Projects/lcb/resources"

#################
# TEST GRNBOOST #
#################

pyscenic grnboost --num_workers ${CORES} "${DATA_FOLDER}/GSE60361.em.mgi.sample.cxg.csv" "${DATA_FOLDER}/mm_tfs.txt"

##############
# TEST PRUNE #
##############

pyscenic ctx "${DATA_FOLDER}/GSE103322.modules.sample.dat" \
       "${DB_FOLDER}/hg19-500bp-upstream-10species.mc9nr.feather" \
       "${DB_FOLDER}/hg19-500bp-upstream-7species.mc9nr.feather" \
       --annotations_fname "${RESOURCES_FOLDER}/motifs-v9-nr.hgnc-m0.001-o0.0.tbl" \
       --mode "dask_multiprocessing" \
       --chunk_size 1 \
       --output "${DATA_FOLDER}/motifs.csv" \
       --num_workers ${CORES}

pyscenic ctx "${DATA_FOLDER}/GSE103322.modules.sample.dat" \
       "${DB_FOLDER}/hg19-500bp-upstream-10species.mc9nr.feather" \
       "${DB_FOLDER}/hg19-500bp-upstream-7species.mc9nr.feather" \
       --annotations_fname "${RESOURCES_FOLDER}/motifs-v9-nr.hgnc-m0.001-o0.0.tbl" \
       --mode "custom_multiprocessing" \
       --output "${DATA_FOLDER}/motifs.csv" \
       --num_workers ${CORES}

###############
# TEST AUCELL #
###############

pyscenic aucell --num_workers=1 "${DATA_FOLDER}/GSE103322.em.hgnc.sample.cxg.csv" "${DATA_FOLDER}/motifs.csv"
pyscenic aucell --num_workers=1 "${DATA_FOLDER}/GSE103322.em.hgnc.sample.cxg.csv" "${DATA_FOLDER}/signatures.hgnc.gmt"
pyscenic aucell --transpose --num_workers=${CORES} "${DATA_FOLDER}/GSE103322.em.hgnc.sample.gxc.csv" "${DATA_FOLDER}/signatures.hgnc.gmt"
pyscenic aucell --transpose --num_workers=${CORES} "${DATA_FOLDER}/GSE103322.em.hgnc.sample.gxc.tsv" "${DATA_FOLDER}/signatures.hgnc.gmt"
pyscenic aucell --transpose --num_workers=${CORES} "${DATA_FOLDER}/GSE103322.em.hgnc.sample.gxc.tsv" "${DATA_FOLDER}/GSE103322.modules.sample.dat"
