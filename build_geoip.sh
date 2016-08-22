#!/bin/sh
# sudo apt-get install libtext-csv-xs-perl libdevel-trace-perl
eval $@
src_file=xtables-addons-${XTABLE_ADDONS_version}.tar.xz
work_root=${PWD}
mkdir ${work_root}/.src -p
cd ${work_root}/.src
if [ ! -f ${work_root}/.src/${src_file} ]; then
	wget ${XTABLE_ADDONS_src_url}/xtables-addons-${XTABLE_ADDONS_version}.tar.xz
fi

mkdir -p ${work_root}/$XTABLE_ADDONS_build_dir
cd ${work_root}/$XTABLE_ADDONS_build_dir
cp -r ${work_root}/.src/${src_file} .
rm -rf xtables-addons-${XTABLE_ADDONS_version}/
tar xvf ${src_file}
cd xtables-addons-${XTABLE_ADDONS_version}/geoip
./xt_geoip_dl
csv_md5=$(md5sum GeoIPCountryWhois.csv | cut -d ' ' -f1)

touch $work_root/last_version

if grep -q ${csv_md5} $work_root/last_version;then
	echo "No need update"
	exit
fi

./xt_geoip_build GeoIPCountryWhois.csv


7za a ${work_root}/BE.7z BE
7za a ${work_root}/LE.7z LE

BE_md5=$(md5sum ${work_root}/BE.7z | cut -d ' ' -f1)
LE_md5=$(md5sum ${work_root}/LE.7z | cut -d ' ' -f1)

current_version=$(grep -Eo '"ver":[ ]*[0-9]*' $work_root/last_version | grep -Eo '[0-9]*')

last_version=$((${current_version:-0} + 1))
echo ${last_version}

timestamp=$(date +%s)
cat <<EOF > $work_root/last_version
{"ver":1,"csv_md5":"${csv_md5}","timestamp":${timestamp},"BE.7z":"${BE_md5}","LE.7z":"${LE_md5}"}
EOF
cat <<EOF
updated,Please upstream to github

git add BE.7z LE.7z last_version
git commit -m "${timestamp}"
git push
EOF
