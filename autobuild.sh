#Automated Build Script By: Stayn/Artx
#For Building kernels for the LG G3 All variants
#Execute this script in the main directory of your Kernel source
#Start ./autobuild.sh

#Export "arm" and Cross Compiler
export ARCH=arm;
export CROSS_COMPILE=~/arm-eabi-4.9/bin/arm-eabi-;
echo "Export of ARCH and CROSS_COMPILE Sucessfully";

#Make clean
make clean;
echo "Source cleaned";

#Pre-Build configs
DIR=~/Images; #Here's the path of your 1st folder for compiled kernels
DIR2=~/Stock; #Here's the path of your 2nd folder for compiled kernels

#Defconfigs
if [ -e ./G3STOCK ]; then
G3TMO=g3-tmo_us_defconfig;
G3ATT=g3-att_defconfig;
G3CANADA=g3-bell_defconfig;
G3INT=g3-global_com_defconfig;
G3SPR=g3-spr_us_defconfig;
G3VZW=g3-vzw_defconfig;
elif [ -e G3LOS ]; then
G3TMO=lineageos_d851_defconfig;
G3ATT=lineageos_d850_defconfig;
G3CANADA=lineageos_d852_defconfig;
G3INT=lineageos_d855_defconfig;
G3SPR=lineageos_ls990_defconfig;
G3VZW=lineageos_vs985_defconfig;
G3KOR=lineageos_f400_defconfig;
G3DS=lineageos_dualsim_defconfig;
fi

#This creates a kernel output folder if it doesn't exist
if [ -d $DIR ]; then
echo "$DIR Found";
else
echo "$DIR folder not found, creating...";
mkdir $DIR;
fi

#If the 2nd folder doesn't exist then prompt the creation
if [ -d $DIR2 ]; then
echo "$DIR2 Found";
else
read -p "Do you want a 2nd folder for Kernels? [Y/N]: " SFD;
if [ $SFD = Y ]; then
echo "Creating $DIR2 folder...";
mkdir $DIR2;
fi
fi

#Number of cores for building
read -p "Enter the number of your CPU cores: " CORES;

#Kernel output directory
read -p "Which folder do you want to save you compiled kernels? Number [1/2]: " NUM;
if [ $NUM = 1 ]; then
OUT=$DIR;
elif [ $NUM = 2 ]; then
OUT=$DIR2;
fi

#Start Kernels building
read -p "Start kernel building? Old Kernels will be replaced [Y/N]: " START;
if [ $START = N ]; then
echo "Alright, come back later!";
exit 0;
fi
echo "Starting kernel(s) Building";

#G3 AT&T
echo "Building for d850";
make $ATT; #Your kernel Defconfig defined above
make -j$CORES; #Remember that "-jX" X is equal to the number of cores of your PC or assigned cores to the VM"
mv arch/arm/boot/zImage $OUT/d850; #You can change the output file name, here's "d850"
make clean; #Make clean before compiling for other variant
echo "Image for d850 compiled sucessfully";

#G3 T-Mobile
echo "Building for d851";
make $G3TMO;
make -j$CORES;
mv arch/arm/boot/zImage $OUT/d851;
make clean;
echo "Image for d851 compiled sucessfully";

#G3 International
echo "Building for d855";
make $G3INT;
make -j6$CORES;
mv arch/arm/boot/zImage $OUT/d855;
make clean;
echo "Image for d855 compiled sucessfully";

#G3 Canadá
echo "Building for d852";
make $G3CANADA;
make -j$CORES;
mv arch/arm/boot/zImage $OUT/d852;
make clean;
echo "Image for D852 compiled sucessfully";

#G3 Sprint
echo "Building for ls990";
make $G3SPR;
make -j$CORES;
mv arch/arm/boot/zImage $OUT/ls990;
make clean;
echo "Image for ls990 compiled sucessfully";

#G3 Verizon
echo "Building for vs985";
make $G3VZW;
make -j$CORES;
mv arch/arm/boot/zImage $OUT/vs985;
make clean;
echo "Image for vs985 compiled sucessfully";

#Finish
echo "All kernel(s) compiled sucessfully, output directory -> $OUT";

