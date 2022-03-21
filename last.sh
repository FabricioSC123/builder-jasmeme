SVENDOR=/mnt/vendora2
SSYSTEM=/mnt/systema2
PVENDOR=/mnt/vendorport
PSYSTEM=/mnt/systemport
CURRENTUSER=$4
SOURCEROM=$3
SCRIPTDIR=$(readlink -f "$0")
CURRENTDIR=$(dirname "$SCRIPTDIR")
FILES=$CURRENTDIR/files
ROMVERSION=$1
STOCKTAR=$2
OUTP=$CURRENTDIR/out
TOOLS=$CURRENTDIR/tools

e2fsck -y -f $OUTP/systemport.img
resize2fs $OUTP/systemport.img 786432


img2simg $OUTP/systemport.img $OUTP/sparsesystem.img
rm $OUTP/systemport.img
$TOOLS/img2sdat/img2sdat.py -v 4 -o $OUTP/zips/system -p system $OUTP/sparsesystem.img
rm $OUTP/sparsesystem.img
img2simg $OUTP/vendorport.img $OUTP/sparsevendor.img
rm $OUTP/vendorport.img
$TOOLS/img2sdat/img2sdat.py -v 4 -o $OUTP/zips/vendor -p vendor $OUTP/sparsevendor.img
rm $OUTP/sparsevendor.img
brotli -j -v -q 6 $OUTP/zips/system/system.new.dat
brotli -j -v -q 6 $OUTP/zips/vendor/vendor.new.dat
mv $CURRENTDIR/boot.img $OUTP/zips/vendor
cd $OUTP/zips
zip -ry $OUTP/10_MIUI_12_wayne_system.zip system/*
zip -ry $OUTP/10_MIUI_12_wayne_vendor.zip vendor/*
cd $CURRENTDIR
rm -rf $OUTP/zips
mv $OUTP/10_MIUI_12_wayne_system.zip ../
mv $OUTP/10_MIUI_12_wayne_vendor.zip ../
chown -hR $CURRENTUSER:$CURRENTUSER $OUTP

rm $OUTP/systema2.img
rm $OUTP/vendora2.img
