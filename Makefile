# apt-get install libtext-csv-perl
XTABLE_ADDONS_version := 2.10
XTABLE_ADDONS_src_url := http://downloads.sourceforge.net/project/xtables-addons/Xtables-addons
XTABLE_ADDONS_build_dir := .build_dir

build: 
	@./build_geoip.sh "XTABLE_ADDONS_version=$(XTABLE_ADDONS_version);XTABLE_ADDONS_src_url=$(XTABLE_ADDONS_src_url);XTABLE_ADDONS_build_dir=$(XTABLE_ADDONS_build_dir);"
all:
	build
