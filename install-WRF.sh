#/bin/sh

#set software versions
export WRF_VERSION="4.2.2"
export WPS_VERSION="4.2"
export HDF5_VERSION="1.12"
export NETCDF_C_VERSION="4.8.0"
export NETCDF_FORTRAN_VERSION="4.5.3"
export MPICH_VERSION="3.3"
export ZLIB_VERSION="1.2.11"
export LIBPNG_VERSION="1.6.37"
export JASPER_VERSION="1.900.1"

#set environment variables
export DIR="/opt/WRF/LIBRARIES"
export CC="gcc"
export CXX="g++"
export FC="gfortran"
export F77="gfortran"
export FCFLAGS="-march=native -fallow-argument-mismatch -fno-f2c"
export FFLAGS="-march=native -fallow-argument-mismatch -fno-f2c"
export JASPERLIB="$DIR/grib2/lib"
export JASPERINC="$DIR/grib2/include"
export NCARG_ROOT="${DIR}/ncl"
export MAKEFLAGS="-j4"

#mkdir log directory
rm -rf /var/log/compile_wrf
mkdir -p /var/log/compile_wrf

#cd work directory
if [ ! -d "$DIR" ]; then
      mkdir -p $DIR
fi
cd $DIR

#build HDF-5
if [ $(pwd) != "$DIR" ]
then
      cd $DIR
fi
curl -o hdf5-${HDF5_VERSION}.0.tar.gz https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-${HDF5_VERSION}/hdf5-${HDF5_VERSION}.0/src/hdf5-${HDF5_VERSION}.0.tar.gz
tar xzvf hdf5-${HDF5_VERSION}.0.tar.gz
cd hdf5-${HDF5_VERSION}.0
env LIBS="-lgcc_s" ./configure -enable-fortran --prefix="${DIR}/hdf5" | tee /var/log/compile_wrf/hdf5.log
make ${MAKEFLAGS} | tee /var/log/compile_wrf/hdf5.log
make install ${MAKEFLAGS} | tee /var/log/compile_wrf/hdf5.log
export HDF5="${DIR}/hdf5"
export LDFLAGS="-L${DIR}/hdf5/lib"
export CPPFLAGS="-I${DIR}/hdf5/include"
cd ..
echo -e "\e[1;32m hdf-5 compile finnished \e[0m"
sleep 5

#build netCDF-c
if [ $(pwd) != "$DIR" ]
then
      cd $DIR
fi
curl -o netcdf-c-${NETCDF_C_VERSION}.tar.gz https://codeload.github.com/Unidata/netcdf-c/tar.gz/refs/tags/v${NETCDF_C_VERSION}
tar xzvf netcdf-c-${NETCDF_C_VERSION}.tar.gz
cd netcdf-c-${NETCDF_C_VERSION}
./configure --prefix=${DIR}/netcdf --disable-dap --disable-netcdf-4 --enable-hdf5 --disable-shared | tee /var/log/compile_wrf/netcdf-c.log
make ${MAKEFLAGS} | tee /var/log/compile_wrf/netcdf-c.log
make install ${MAKEFLAGS} | tee /var/log/compile_wrf/netcdf-c.log
export NETCDF="$DIR/netcdf"
export PATH="$DIR/netcdf/bin:$PATH"
export LDFLAGS="${LDFLAGS} -L${JASPERLIB} -L${DIR}/netcdf/lib"
export CPPFLAGS="${CPPFLAGS} -I${JASPERINC} -I${DIR}/netcdf/include -I/usr/include/tirpc"
export CXXFLAGS="${CPPFLAGS}"
cd ..
echo -e "\e[1;32m netCDF-c compile finnished \e[0m"
sleep 5

#build netCDF-fortran
if [ $(pwd) != "$DIR" ]
then
      cd $DIR
fi
curl -o netcdf-fortran-${NETCDF_FORTRAN_VERSION}.tar.gz https://codeload.github.com/Unidata/netcdf-fortran/tar.gz/refs/tags/v${NETCDF_FORTRAN_VERSION}
tar xzvf netcdf-fortran-${NETCDF_FORTRAN_VERSION}.tar.gz
cd netcdf-fortran-${NETCDF_FORTRAN_VERSION}
./configure --prefix=${DIR}/netcdf --disable-shared | tee /var/log/compile_wrf/netcdf-fortran.log
make ${MAKEFLAGS} | tee /var/log/compile_wrf/netcdf-fortran.log
make install ${MAKEFLAGS} | tee /var/log/compile_wrf/netcdf-fortran.log
cd ..
echo -e "\e[1;32m netCDF-fortran compile finnished \e[0m"
sleep 5

#build mpich
if [ $(pwd) != "$DIR" ]
then
      cd $DIR
fi
curl -o mpich-${MPICH_VERSION}.tar.gz https://www.mpich.org/static/downloads/${MPICH_VERSION}/mpich-${MPICH_VERSION}.tar.gz
tar xzvf mpich-${MPICH_VERSION}.tar.gz
cd mpich-${MPICH_VERSION}
./configure --prefix=$DIR/mpich | tee /var/log/compile_wrf/mpich.log
make ${MAKEFLAGS} | tee /var/log/compile_wrf/mpich.log
make install ${MAKEFLAGS} | tee /var/log/compile_wrf/mpich.log
export PATH="$DIR/mpich/bin:$PATH"
cd ..
echo -e "\e[1;32m mpich compile finnished \e[0m"
sleep 5

#build zlib
if [ $(pwd) != "$DIR" ]
then
      cd $DIR
fi
curl -o zlib-${ZLIB_VERSION}.tar.gz https://www.zlib.net/zlib-${ZLIB_VERSION}.tar.gz
tar xzvf zlib-${ZLIB_VERSION}.tar.gz
cd zlib-${ZLIB_VERSION}
./configure --prefix=$DIR/grib2/ | tee /var/log/compile_wrf/zlib.log
make ${MAKEFLAGS} | tee /var/log/compile_wrf/zlib.log
make install ${MAKEFLAGS} | tee /var/log/compile_wrf/zlib.log
cd ..
echo -e "\e[1;32m zlib compile finnished \e[0m"
sleep 5

#build libpng
if [ $(pwd) != "$DIR" ]
then
      cd $DIR
fi
curl -o libpng-${LIBPNG_VERSION}.tar.gz https://ixpeering.dl.sourceforge.net/project/libpng/libpng16/${LIBPNG_VERSION}/libpng-${LIBPNG_VERSION}.tar.gz
tar xzvf libpng-${LIBPNG_VERSION}.tar.gz
cd libpng-${LIBPNG_VERSION}
./configure --prefix=$DIR/grib2 | tee /var/log/compile_wrf/libpng.log
make ${MAKEFLAGS} | tee /var/log/compile_wrf/libpng.log
make install ${MAKEFLAGS} | tee /var/log/compile_wrf/libpng.log
cd ..
echo -e "\e[1;32m libpng compile finnished \e[0m"
sleep 5

#build jasper
if [ $(pwd) != "$DIR" ]
then
      cd $DIR
fi
curl -o jasper-${JASPER_VERSION}.tar.gz https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/jasper-${JASPER_VERSION}.tar.gz
tar xzvf jasper-${JASPER_VERSION}.tar.gz
cd jasper-${JASPER_VERSION}
./configure --prefix=$DIR/grib2 | tee /var/log/compile_wrf/jasper.log
make ${MAKEFLAGS} | tee /var/log/compile_wrf/jasper.log
make install ${MAKEFLAGS} | tee /var/log/compile_wrf/jasper.log
cd ..
echo -e "\e[1;32m jasper compile finnished \e[0m"
sleep 5

#build WRF
export MAKEFLAGS="-j1"
cd ..
if [ -d "/opt/WRF/WRF" ] || [ -d "/opt/WRF/WRF-${WRF_VERSION}" ];
then
      rm -rf /opt/WRF/WRF
      rm -rf /opt/WRF/WRF-${WRF_VERSION}
fi
if [ $(pwd) != "/opt/WRF" ]
then
      cd /opt/WRF
fi
curl -o WRF-${WRF_VERSION}.tar.gz https://codeload.github.com/wrf-model/WRF/tar.gz/refs/tags/v${WRF_VERSION}
tar xzvf WRF-${WRF_VERSION}.tar.gz
mv WRF-${WRF_VERSION} WRF
cd WRF
./clean -a
./configure
./compile em_real | tee /var/log/compile_wrf/wrf.log
cd ..

#check wrf install correct or not
if [ -f "/opt/WRF/WRF/main/wrf.exe" -a -f "/opt/WRF/WRF/main/real.exe" -a -f "/opt/WRF/WRF/main/ndown.exe" -a -f "/opt/WRF/WRF/main/tc.exe" ];
then
      #build WPS
      if [ -d "/opt/WRF/WPS" ] || [ -d "/opt/WRF/WPS-${WPS_VERSION}" ];
      then
            rm -rf /opt/WRF/WPS
            rm -rf /opt/WRF/WPS-${WPS_VERSION}
      fi
      if [ $(pwd) != "/opt/WRF" ]
      then
            cd /opt/WRF
      fi
      curl -o WPS-${WPS_VERSION}.tar.gz https://codeload.github.com/wrf-model/WPS/tar.gz/refs/tags/v${WPS_VERSION}
      tar xzvf WPS-${WPS_VERSION}.tar.gz
      mv WPS-${WPS_VERSION} WPS
      cd WPS
      ./clean -a
      ./configure
      sleep 60
      #这里去configure.wps加-fallow-argument-mismatch -fno-f2c
      ./compile | tee /var/log/compile_wrf/wps.log
      cd ..
else
      echo -e "\033[31;5m WRF compile failed! \033[0m"
      exit 1
fi

#echo "compile finished"
echo -e "\e[1;32m compile finnished and succeed! \e[0m"
