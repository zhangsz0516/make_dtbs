#! /bin/bash

DIR_ROOT=$( cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
HOST_DTC=${DIR_ROOT}/dtc
HOSTCC=gcc
# ${HOSTCC} -v
# ${HOST_DTC} --version

suffix_dtb=".dtb"
suffix_dts=".dts"
dtb_d_pre_tmp=".dtb.d.pre.tmp"
dtb_dts_tmp=".dtb.dts.tmp"
dtb_d_dtc_tmp=".dtb.d.dtc.tmp"

dtc_cflags="-E -Wp,-MMD,"
dtc_flags="0 -Wno-interrupt_provider -Wno-unit_address_vs_reg -Wno-avoid_unnecessary_addr_size "
dtc_flags+="-Wno-alias_paths -Wno-graph_child_address -Wno-simple_bus_reg -Wno-unique_unit_address"
dtc_def="-undef -D__DTS__ -x assembler-with-cpp"

dts_src_path=${DIR_ROOT}
dts_file_string=`find ${dts_src_path} -maxdepth 2 -type f -name *.dts`

for dts in ${dts_file_string}
do
	# echo ${dts}
	echo ${dts%.*}
	${HOSTCC} -E ${dtc_cflags}${dts%.*}${dtb_d_pre_tmp} -nostdinc -I${DIR_ROOT}/include ${dtc_def} -o ${dts%.*}${dtb_dts_tmp} ${dts%.*}${suffix_dts}
	${HOST_DTC} -o ${dts%.*}${suffix_dtb} -b ${dtc_flags} -d ${dts%.*}${dtb_d_dtc_tmp} ${dts%.*}${dtb_dts_tmp}
done

dts_folders=`find ${dts_src_path} -maxdepth 1 -type d`
for dts in ${dts_folders}
do
	`rm -f ${dts}/*.d.dtc.tmp`
	`rm -f ${dts}/*.d.pre.tmp`
	`rm -f ${dts}/*.dtb.dts.tmp`
done

echo " --- build dtbs end --- "

