E6F40.R GISS ModelE Lat-Lon Atmosphere Model, 1850 atm./ocean

E6F40 is based on LLF40 with updated aerosol/ozone input files for CMIP6 simulations

Lat-lon: 2x2.5 degree horizontal resolution
F40: 40 vertical layers with standard hybrid coordinate, top at .1 mb
Atmospheric composition for year 1850
Ocean climatology prescribed from years 1876-1885, CMIP6
Uses turbulence scheme (no dry conv), grav.wave drag
Time steps: dynamics 3.75 min leap frog; physics 30 min.; radiation 2.5 hrs
Filters: U,V in E-W and N-S direction (after every physics time step)
         U,V in E-W direction near poles (after every dynamics time step)
         sea level pressure (after every physics time step)

Preprocessor Options
#define STDHYB                   ! standard hybrid vertical coordinate
#define ATM_LAYERING L40         ! 40 layers, top at .1 mb
#define NEW_IO                   ! new I/O (netcdf) on
#define IRRIGATION_ON
#define SWFIX_20151201
#define NO_HDIURN                ! exclude hdiurn diagnostics
#define MODIS_LAI
#define NEW_BCdalbsn
#define LIPLUGGABLE
#define USE_ICEBIN
End Preprocessor Options

Object modules:
     ! resolution-specific source codes
Atm144x90                           ! horizontal resolution is 144x90 -> 2x2.5deg
AtmLayering                         ! vertical resolution
DIAG_RES_F                          ! diagnostics
FFT144                              ! Fast Fourier Transform

IO_DRV                              ! new i/o

     ! GISS dynamics with gravity wave drag
ATMDYN MOMEN2ND                     ! atmospheric dynamics
QUS_DRV QUS3D                       ! advection of Q/tracers
STRATDYN STRAT_DIAG                 ! stratospheric dynamics (incl. gw drag)

! ---------- BEGIN #include b'/gpfsm/dnb53/laroach1/harn/twh/modelE/templates/latlon_source_files'
    ! lat-lon grid specific source codes
AtmRes
GEOM_B                              ! model geometry
DIAG_ZONAL GCDIAGb                  ! grid-dependent code for lat-circle diags
DIAG_PRT POUT                       ! diagn/post-processing output
! ---------- END #include b'/gpfsm/dnb53/laroach1/harn/twh/modelE/templates/latlon_source_files'
! ---------- BEGIN #include b'/gpfsm/dnb53/laroach1/harn/twh/modelE/templates/modelE4_source_files'
MODEL_COM                           ! calendar, timing variables
MODELE_DRV                          ! ModelE cap
MODELE                              ! initialization and main loop
ATM_COM                             ! main atmospheric variables
ATM_DRV                             ! driver for atmosphere-grid components
ATMDYN_COM                          ! atmospheric dynamics
ATM_UTILS                           ! utilities for some atmospheric quantities
QUS_COM QUSDEF                      ! T/Q moments, 1D QUS
CLOUDS2 CLOUDS2_DRV CLOUDS_COM      ! clouds modules
SURFACE SURFACE_LANDICE FLUXES FLUXESIO             ! surface calculation and fluxes
GHY_COM GHY_DRV    ! + giss_LSM     ! land surface and soils + snow model
VEG_DRV                             ! vegetation
! VEG_COM VEGETATION                ! old vegetation
ENT_DRV  ENT_COM   ! + Ent          ! new vegetation
PBL_COM PBL_DRV PBL                 ! atmospheric pbl
IRRIGMOD                            ! irrigation module
ATURB                               ! turbulence in whole atmosphere
LAKES_COM LAKES                     ! lake modules
SEAICE SEAICE_DRV                   ! seaice modules
LANDICE LANDICE_COM LANDICE_IO LANDICE_IO_SUBS LANDICE_DRV LANDICE_DIAG LISnow LISheetIceBin ! land ice modules
ICEDYN_DRV ICEDYN                   ! ice dynamics modules
RAD_COM RAD_DRV RADIATION           ! radiation modules
RAD_UTILS ALBEDO READ_AERO ocalbedo ! radiation and albedo
DIAG_COM DIAG DEFACC                ! diagnostics
OCN_DRV                             ! driver for ocean-grid components
! ---------- END #include b'/gpfsm/dnb53/laroach1/harn/twh/modelE/templates/modelE4_source_files'
! ---------- BEGIN #include b'/gpfsm/dnb53/laroach1/harn/twh/modelE/templates/static_ocn_source_files'
OCEAN OCNML                         ! ocean modules
! ---------- END #include b'/gpfsm/dnb53/laroach1/harn/twh/modelE/templates/static_ocn_source_files'

Components:
! ---------- BEGIN #include b'/gpfsm/dnb53/laroach1/harn/twh/modelE/templates/E4_components_nc'
shared MPI_Support solvers giss_LSM 
dd2d
! ---------- END #include b'/gpfsm/dnb53/laroach1/harn/twh/modelE/templates/E4_components_nc'
Ent
lipluggable

Component Options:
OPTS_Ent = ONLINE=YES PS_MODEL=FBB PFT_MODEL=ENT !/* needed for "Ent" only */
!OPTS_dd2d = NC_IO=PNETCDF

Data input files:
! ---------- BEGIN #include b'/gpfsm/dnb53/laroach1/harn/twh/modelE/templates/IC_144x90_input_files'
    ! start from the restart file of an earlier run ...                 ISTART=8
! AIC=1....rsfE... ! initial conditions, no GIC needed, use
!! AIC=1JAN1961.rsfE4F40.MXL65m   ! end of run with KOCEAN=0

    ! start from observed conditions AIC(,OIC), model ground data GIC   ISTART=2
! AIC=AIC.RES_F40.D771201.nc      ! observed initial conditions for F40 1977/12/01
! AIC=AIC_144x90_DEC01_L96.nc     ! observed initial conditions for F96 1977/12/01
AIC=NCARIC.144x90.D7712010_ext.nc ! AIC for automatic relayering to model vertical grid
GIC=inputs/GIC   ! initial ground conditions
! ---------- END #include b'/gpfsm/dnb53/laroach1/harn/twh/modelE/templates/IC_144x90_input_files'
! ---------- BEGIN #include b'/gpfsm/dnb53/laroach1/harn/twh/modelE/templates/static_ocn_1880_144x90_input_files'

OSST=OST_144x90.1876-1885avg.CMIP6.nc     ! climatological ocean temperature
SICE=SICE_144x90.1876-1885avg.CMIP6.nc    ! climatological sea ice cover
ZSIFAC=ZSIfac_144x90.1876-1885avg.CMIP6.nc  ! climatological sea ice thickness
TOPO=inputs/topoa.nc                      ! ocean fraction and surface topography
!! Q-flux ocean: use the next line instead, set KOCEAN=1
!! OHT=OTSPEC.E4F40.MXL65m.1956-1960         ! ocean horizontal heat transports
!! OCNML=Z1O.B144x90.nc                      ! mixed layer depth for Q-flux model
! ---------- END #include b'/gpfsm/dnb53/laroach1/harn/twh/modelE/templates/static_ocn_1880_144x90_input_files'
RVR=RD_Fb.nc             ! river direction file
NAMERVR=RD_Fb.names.txt  ! named river outlets

! ---------- BEGIN #include b'/gpfsm/dnb53/laroach1/harn/twh/modelE/templates/land144x90_input_files'
CDN=CD144X90.ext.nc
VEG=V144x90_EntMM16_lc_max_trimmed_scaled_nocrops.ext.nc
LAIMAX=V144x90_EntMM16_lai_max_trimmed_scaled_ext.nc
HITEent=V144x90_EntMM16_height_trimmed_scaled_ext.nc
LAI=V144x90_EntMM16_lai_trimmed_scaled_ext.nc
CROPS=CROPS_and_pastures_Pongratz_to_Hurtt_144X90N_nocasp.nc
IRRIG=Irrig144x90_1848to2100_FixedFuture_v3.nc
SOIL=S144X900098M.ext.nc
TOP_INDEX=top_index_144x90_a.ij.ext.nc
ZVAR=ZVAR2X25A.nc             ! topographic variation for gwdrag
! probably need these (should convert to 144x90)
soil_textures=soil_textures_top30cm_2x2.5
SOILCARB_global=soilcarb_top30cm_2x2.5.nc
GLMELT=GLMELT_144X90_gas.OCN.nc
! ---------- END #include b'/gpfsm/dnb53/laroach1/harn/twh/modelE/templates/land144x90_input_files'
! ---------- BEGIN #include b'/gpfsm/dnb53/laroach1/harn/twh/modelE/templates/rad_input_files'
RADN1=sgpgxg.table8                           ! rad.tables and history files
RADN2=LWTables33k_lowH2O_CO2_O3_planck_1-800  ! rad.tables and history files
RADN4=LWCorrTables33k                         ! rad.tables and history files
RADN5=H2Ocont_MT_CKD  ! Mlawer/Tobin_Clough/Kneizys/Davies H2O continuum table
! other available H2O continuum tables:
!    RADN5=H2Ocont_Ma_2000
!    RADN5=H2Ocont_Ma_2004
!    RADN5=H2Ocont_Roberts
!    RADN5=H2Ocont_MT_CKD  ! Mlawer/Tobin_Clough/Kneizys/Davies
RADN3=miescatpar.abcdv2

RH_QG_Mie=oct2003.relhum.nr.Q633G633.table
RADN7=STRATAER.VOL.1850-2014_CMIP6_hdr  ! needs MADVOL=2
RADN8=cloud.epsilon4.72x46
!RADN9=solar.lean2015.ann1610-2014.nc ! need KSOLAR=2
RADN9=solar.CMIP6official.ann1850-2299_with_E3_fastJ.nc ! need KSOLAR=2
RADNE=topcld.trscat8

ISCCP=ISCCP.tautables
GHG=GHG.CMIP6.1-2014.txt  !  GreenHouse Gases for CMIP6 runs up to 2014
CO2profile=CO2profile.Jul2017.txt ! scaling of CO2 in stratosphere
dH2O=dH2O_by_CH4_monthly

! ---------- END #include b'/gpfsm/dnb53/laroach1/harn/twh/modelE/templates/rad_input_files'
! ---------- BEGIN #include b'/gpfsm/dnb53/laroach1/harn/twh/modelE/templates/rad_144x90_input_files_CMIP6clim'
! Begin NINT E2.1 input files

BCdalbsn=cmip6_nint_inputs_E14TomaOCNf10_4av_decadal/BCdalbsn
DUSTaer=cmip6_nint_inputs_E14TomaOCNf10_4av_decadal/DUST
TAero_SUL=cmip6_nint_inputs_E14TomaOCNf10_4av_decadal/SUL
TAero_SSA=cmip6_nint_inputs_E14TomaOCNf10_4av_decadal/SSA
TAero_NIT=cmip6_nint_inputs_E14TomaOCNf10_4av_decadal/NIT
TAero_OCA=cmip6_nint_inputs_E14TomaOCNf10_4av_decadal/OCA
TAero_BCA=cmip6_nint_inputs_E14TomaOCNf10_4av_decadal/BCA
TAero_BCB=cmip6_nint_inputs_E14TomaOCNf10_4av_decadal/BCB

O3file=cmip6_nint_inputs_E14TomaOCNf10_4av_decadal/O3
Ox_ref=o3_2010_shindell_144x90x49_April1850.nc

! End NINT E2.1 input files
! ---------- END #include b'/gpfsm/dnb53/laroach1/harn/twh/modelE/templates/rad_144x90_input_files_CMIP6clim'

MSU_wts=MSU_SSU_RSS_weights.txt      ! MSU-diag
REG=REG2X2.5                      ! special regions-diag

Label and Namelist:  (next 2 lines)
E6F40 (LLF40 + updated aerosol/ozone input files for CMIP6 simulations, 1850 atm/ocean) 

&&PARAMETERS
! ---------- BEGIN #include b'/gpfsm/dnb53/laroach1/harn/twh/modelE/templates/static_ocn_params'
! parameters set for choice of ocean model:
KOCEAN=0        ! ocean is prescribed
!! KOCEAN=1        ! ocean is computed
Kvflxo=0        ! usually set to 1 only during a prescr.ocn run by editing "I"
!  Kvflxo=1     ! saves VFLXO files to prepare for q-flux runs (mkOTSPEC)

variable_lk=1   ! variable lakes
li_twoway = 1

! ---------- END #include b'/gpfsm/dnb53/laroach1/harn/twh/modelE/templates/static_ocn_params'
! ---------- BEGIN #include b'/gpfsm/dnb53/laroach1/harn/twh/modelE/templates/sdragF40_params'
! drag params if grav.wave drag is not used and top is at .01mb
X_SDRAG=.002,.0002  ! used above P(P)_sdrag mb (and in top layer)
C_SDRAG=.0002       ! constant SDRAG above PTOP=150mb
P_sdrag=1.          ! linear SDRAG only above 1mb (except near poles)
PP_sdrag=1.         ! linear SDRAG above PP_sdrag mb near poles
P_CSDRAG=1.         ! increase CSDRAG above P_CSDRAG to approach lin. drag
Wc_JDRAG=30.        ! crit.wind speed for J-drag (Judith/Jim)
ANG_sdrag=1     ! if 1: SDRAG conserves ang.momentum by adding loss below PTOP
! ---------- END #include b'/gpfsm/dnb53/laroach1/harn/twh/modelE/templates/sdragF40_params'
! ---------- BEGIN #include b'/gpfsm/dnb53/laroach1/harn/twh/modelE/templates/gwdragF40_params'
! vsdragl is a tuning coefficient for SDRAG starting at LS1
! layer:   24    25    26    27   28    29    30    31   32   33     34   35   36  37  38   39 40
vsdragl=0.000,0.000,0.000,0.000,0.00,0.000,0.000,0.000,0.00,0.00,  0.00,0.00,0.00,0.3,0.6,0.83,1.

! Gravity wave parameters
PBREAK = 200.  ! The level for GW breaking above.
DEFTHRESH=0.000055  ! threshold (1/s) for triggering deformation waves
PCONPEN=400.   ! penetrating convection defn for GWDRAG
CMC = 0.0000002 ! parameter for GW Moist Convective drag
CSHEAR=10.     ! Shear drag coefficient
CMTN=0.1       ! default is 0.5
CDEF=1.6       ! tuning factor for deformation -> momentum flux
XCDNST=400.,10000.   ! strat. gw drag parameters
QGWMTN=1 ! mountain waves ON
QGWDEF=1 ! deformation waves ON
QGWSHR=0 ! shear drag OFF
QGWCNV=0 ! convective drag OFF

! ---------- END #include b'/gpfsm/dnb53/laroach1/harn/twh/modelE/templates/gwdragF40_params'

! cond_scheme=2   ! newer conductance scheme (N. Kiang) ! not used with Ent

! The following two lines are only used when aerosol/radiation interactions are off
FS8OPX=1.,1.,1.,1.,1.5,1.5,1.,1.
FT8OPX=1.,1.,1.,1.,1.,1.,1.3,1.

! Increasing U00a decreases the high cloud cover; increasing U00b decreases net rad at TOA
U00a=0.655  ! above 850mb w/o MC region;  tune this first to get 30-35% high clouds
U00b=1.00   ! below 850mb and MC regions; tune this last  to get rad.balance
WMUI_multiplier = 2.
use_vmp=1
radius_multiplier=1.1

PTLISO=0.        ! pressure(mb) above which radiation assumes isothermal layers
H2ObyCH4=1.      ! if =1. activates stratospheric H2O generated by CH4 without interactive chemistry
KSOLAR=2         ! 2: use long annual mean file ; 1: use short monthly file

! ---------- BEGIN #include b'/gpfsm/dnb53/laroach1/harn/twh/modelE/templates/atmCompos_1850_params'
! parameters that control the atmospheric/boundary conditions
! if set to 0, the current (day/) year is used: transient run
master_yr=1850
!crops_yr=1850  ! if -1, crops in VEG-file is used
!s0_yr=1850
!s0_day=182
!ghg_yr=1850
!ghg_day=182
!irrig_yr=1850
volc_yr=-1
!volc_day=182
!aero_yr=1850
od_cdncx=0.        ! don't include 1st indirect effect
cc_cdncx=0.        ! don't include 2nd indirect effect (used 0.0036)
!albsn_yr=1850
dalbsnX=1.
!o3_yr=-1850
!aer_int_yr=1850    !select desired aerosol emissions year or 0 to use JYEAR
! atmCO2=368.6          !uatm for year 2000 - enable for CO2 tracer runs

!variable_orb_par=0
!orb_par_year_bp=100  !  BP i.e. 1950-orb_par_year_bp AD = 1850 AD
MADVOL=2
! ---------- END #include b'/gpfsm/dnb53/laroach1/harn/twh/modelE/templates/atmCompos_1850_params'

DTsrc=1800.      ! cannot be changed after a run has been started
DT=225.
! parameters that control the Shapiro filter
DT_XUfilter=225. ! Shapiro filter on U in E-W direction; usually same as DT
DT_XVfilter=225. ! Shapiro filter on V in E-W direction; usually same as DT
DT_YVfilter=0.   ! Shapiro filter on V in N-S direction
DT_YUfilter=0.   ! Shapiro filter on U in N-S direction

NIsurf=2         ! surface interaction computed NIsurf times per source time step
NRAD=5           ! radiation computed NRAD times per source time step
! ---------- BEGIN #include b'/gpfsm/dnb53/laroach1/harn/twh/modelE/templates/diag_params'
! parameters that affect at most diagn. output:  standard if DTsrc=1800. (sec)
aer_rad_forc=0   ! if set =1, radiation is called numerous times - slow !!
cloud_rad_forc=1 ! calls radiation twice; use =0 to save cpu time
SUBDD=' '        ! no sub-daily frequency diags
NSUBDD=0         ! saving sub-daily diags every NSUBDD-th physics time step (1/2 hr)
KCOPY=1          ! 0: no output; 1: save .acc; 2: unused; 3: include ocean data
KRSF=12          ! 0: no output; X: save rsf at the beginning of every X month
isccp_diags=1    ! use =0 to save cpu time, but you lose some key diagnostics
nda5d=13         ! use =1 to get more accurate energy cons. diag (increases CPU time)
nda5s=13         ! use =1 to get more accurate energy cons. diag (increases CPU time)
ndaa=13
nda5k=13
nda4=48          ! to get daily energy history use nda4=24*3600/DTsrc
! ---------- END #include b'/gpfsm/dnb53/laroach1/harn/twh/modelE/templates/diag_params'

Nssw=2           ! until diurnal diags are fixed, Nssw has to be even
Ndisk=960        ! write fort.1.nc or fort.2.nc every NDISK source time step
&&END_PARAMETERS

&INPUTZ
 YEARI=1949,MONTHI=12,DATEI=1,HOURI=0, ! pick IYEAR1=YEARI (default) or < YEARI
 YEARE=1949,MONTHE=12,DATEE=2,HOURE=0,     KDIAG=12*0,9,
 ISTART=2,IRANDI=0, YEARE=1949,MONTHE=12,DATEE=1,HOURE=1,
/
!! suggested settings for E6qsF40:
!! YEARI=1901,MONTHI=1,DATEI=1,HOURI=0,
!! YEARE=1931,MONTHE=1,DATEE=1,HOURE=0,   KDIAG=12*0,9,
!! ISTART=8,IRANDI=0, YEARE=1901,MONTHE=1,DATEE=1,HOURE=1,
