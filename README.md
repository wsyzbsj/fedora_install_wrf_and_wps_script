# fedora_install_wrf_and_wps_script  
Install WRF and WPS on Fedora **only after you installed all dependencies**  
**I won't check whether you have installed all dependencies correct or not!**  
**only tested on Fedora 33 and rawhide**  
仅在Fedora33(28Mar2021)与rawhide(29Mar2021)上测试过,其他发行版还请自行摸索。  

We use em_real in class
  
**需要的而网站上没写到的依赖:libtirpc-devel**  
*Notice：/rpc/types.h不再在/usr/include/rpc；现在跟着tirpc去了/usr/include/tirpc/rpc。*  
Fedora33 uses gcc/g++/gfortran-10.2.1；rawhide uses gcc/g++/gfortran-11.0.1-0。 

```
sudo dnf install gcc gcc-g++ gcc-gfortran libtirpc-devel
```
 
**另：WPS的configure由于指定的FFLAGS和FCFLAGS对其无效，在./configure之后要自己手动去configure.wps加-fallow-argument-mismatch**。。。

*若有错漏之处还请海涵并赐教*  
  
Mostly according to:  
https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compilation_tutorial.php  

![Image text](https://github.com/wsyzbsj/my_install_wrf_and_wps/blob/master/IMG_20210328_082858.jpg?raw=true)
