function [] = calc_srf(t_gm,Tef,yoff,ab,srfname,width_mult);
% 
% calc_srf: Generate AIRS SRF look-up tables
%
% This script started with do_calc_srftables_fringes_mar08.m
%
% Sept. 2018:  L. Strow updated to use gmodel.m instead of gmodelall2.m

addpath ~/Work/Airs/l1c_freq_adjust/calc_airs_freq

driver.t_gm = t_gm;
driver.Tef = Tef;
driver.yoff = yoff;
driver.ab = ab;
driver.srfname = srfname;
driver.width_mult = width_mult;

% Module names
modules={'12', '11', '10', '9', '8',  '7',  '6',  '5', '4d', '4c',  '3',  '4b', '4a', '2b', '1b', '2a', '1a'};

% Define x-axis grid points (in FWHM)
fwgrid=[ (-10:0.1:-1.6), (-1.5:0.01:1.5), (1.6:0.1:10)]'; %'

% Use the grating model to calc the chan center freqs & widths
[fc_lm, freq, modid_lm, modid, width] = gmodel(t_gm,yoff,ab);
clear fc_lm modid_lm 

chanid = 1:2378;
% Add  fake channels
[chanid, freq, width, mindex] = add_fake(chanid, freq, width);
nchan = length(chanid);

% Declare SRF array
npts=length(fwgrid);
srfval=zeros(npts,nchan);

% Convert cell array to string
modid=char(modid);

% Load fringe data
load fringe_data_nov02.txt;
fringe_data=fringe_data_nov02; clear fringe_data_nov02
amp  = fringe_data(:,6);
pha  = fringe_data(:,7);
dch  = fringe_data(:,8);
beta = fringe_data(:,9);
clear fringe_data

% fringe_data_nov02 is frequency calibrated; thus gamma, the frequency
% adjustment factor, should be set to unity
gamma=1.0;

% Loop over the modules
ichan=0;
nmod=length(modules);

for imod=1:nmod
   module=char(modules(imod));

   disp(['Working on module ' module]);

   ind = find(mindex == imod);
   nchanmod=length(ind);

% Load SRF shape parameters for this module
   [gfrac, gexp, gslope, lexp, xresid, yresid]=get_srf_params(module);

% Loop over channels and fill up srfval
   for ic=1:nchanmod
      ichan = ind(ic);
      v0=freq(ichan);
      f=fwgrid*width(ichan) + v0;
      yout=zx_srf_resid(f, v0, width(ichan), gfrac, gexp, gslope, lexp, xresid, yresid);
      if (chanid(ichan) > 2378)
         srfval(:,ichan)=yout/max(yout);
      else
         fringes=calc_fringes(Tef, amp(ichan), pha(ichan), dch(ichan), beta(ichan), f', gamma);
         yf=yout.*fringes';
         srfval(:,ichan)=yf/max(yf);
      end
   end
end % End of loop over modules

% Need to keep old hdf file vector type
chanid = chanid';
freq = freq';
width = width';
fwgrid = fwgrid';
srfval = srfval';

% Comments (256 char max)
% version number, brief description, and date
% version='Version 5.0 AIRS SRFs; yoffset=-13.5um; M5offset=3.0; M12offset=-1.5; Tgrat=155.1325; Tfilt=156.339';
version = 'Version x.0 AIRS SRFs; yoffset=2016mean'; 

% author name, address, and email  256 max length
author = 'L. Strow; Dept. of Physics, University of Maryland Baltimore County (UMBC), 1000 Hilltop Circle, Baltimore MD 21250; strow@umbc.edu';

% Any extra comments, 256 max length
comment = 'freqgrid = fwgrid*width + freq; Do a linear interpolation of srfval andfreqgrid to calculate the SRF on your desired frequency grid; Do not extrapolate the SRF beyond the endpoints of fwgrid; Channels with ID>2378 are fake';

% Units (80 char max)
width_units  ='cm^-1; Full Width at Half Maximum (FWHM)';
fwgrid_units ='FWHM; grid points for all SRF lookup tables';
srfval_units ='none; peak=1 normalized SRF values on the fwgrid grid';
chanid_units ='integer 1 to 2378 or fake channel if >2378; channel ID number';
freq_units   ='cm^-1; channel center frequency';

eval(['save ' srfname ' chanid freq width fwgrid srfval comment author version chanid_units freq_units width_units fwgrid_units srfval_units']);

% Statements below used to be in this file, now passed to this function

% % Grating temperature
% t_gm = 155.1325; 
% % Entrance filter temperature, post Nov 03.  Pre Nov 03 was 155.770
% Tef= 156.339; 

% % Get mean yoff
% load ~/Work/Combined_sensors/Final_analysis/yoff_desc_area_weighted_2016
% yoff = yoff_desc_area_weighted_2016;

% Use ab state at beginning of 2016
% ab = get_ab_state(datetime(2016,1,1));

% % SRF output file name
% % srfname='srftables_m135f_155K_nov05';
% srfname = 'test';

% % Debugging info: Compare to mar08 AIRS SRFs at -14 um
% 
% sfile = 'srftables_m140f_withfake_mar08.hdf';
% xchanid = hdfread(sfile,'chanid');
% xfreq   = hdfread(sfile,'freq');
% xwidth  = hdfread(sfile,'width');
% xfwgrid = hdfread(sfile,'fwgrid');
% xsrfval = hdfread(sfile,'srfval');


