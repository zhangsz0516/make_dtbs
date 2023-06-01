mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
cur_makefile_path := $(dir $(mkfile_path))

DIR_ROOT := $(cur_makefile_path)

suffix_dtb = .dtb
suffix_dts = .dts
dtb_d_pre_tmp = .dtb.d.pre.tmp
dtb_dts_tmp = .dtb.dts.tmp
dtb_d_dtc_tmp = .dtb.d.dtc.tmp

HOSTCC = gcc

HOST_DTC := $(DIR_ROOT)dtc

CFLAGS = -E -Wp,-MMD,

dtc_flags = 0 -Wno-interrupt_provider -Wno-unit_address_vs_reg -Wno-avoid_unnecessary_addr_size \
 -Wno-alias_paths -Wno-graph_child_address -Wno-simple_bus_reg -Wno-unique_unit_address

dtc_def = -undef -D__DTS__ -x assembler-with-cpp

dts_src_path = $(DIR_ROOT)
dts_folders := $(shell find $(dts_src_path) -maxdepth 1 -type d)
dts_file_string = $(foreach dir,$(dts_folders),$(wildcard $(dir)/*.dts))
dts_file_basename = $(basename $(dts_file_string))

all:
	for dts in ${dts_file_basename} ; do \
		$(HOSTCC) -E $(CFLAGS)$$dts$(dtb_d_pre_tmp) -nostdinc -I$(DIR_ROOT)include $(dtc_def) -o $$dts$(dtb_dts_tmp) $$dts$(suffix_dts); \
		$(HOST_DTC) -o $$dts$(suffix_dtb) -b $(dtc_flags) -d $$dts$(dtb_d_dtc_tmp) $$dts$(dtb_dts_tmp); \
	done


clean:
	for dts in ${dts_file_basename} ; do \
		rm -f $$dts$(dtb_d_pre_tmp); \
		rm -f $$dts$(dtb_dts_tmp); \
		rm -f $$dts$(dtb_dts_tmp); \
		rm -f $$dts$(dtb_d_dtc_tmp); \
	done


distclean:
	for dts in ${dts_file_basename}; do \
		rm -f $$dts$(dtb_d_pre_tmp); \
		rm -f $$dts$(dtb_dts_tmp); \
		rm -f $$dts$(dtb_dts_tmp); \
		rm -f $$dts$(dtb_d_dtc_tmp); \
		rm -f $$dts$(suffix_dtb); \
	done

