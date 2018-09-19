% run_calc_srf(t_gm);

addpath ../l1c_freq_adjust/calc_airs_freq

% % Grating temperature
% t_gm = 155.1325; 
% % Entrance filter temperature, post Nov 03.  Pre Nov 03 was 155.770
% Tef= 156.339; 

% Grating temperature
t_gm = 155.1325; 
% Entrance filter temperature, post Nov 03.  Pre Nov 03 was 155.770
Tef= 156.339; 

% Get mean yoff
load yoff_desc_area_weighted_2016
yoff = yoff_desc_area_weighted_2016;
% yoff = yoff + 0.3;
width_mul = 1.0;
%width_mul = 1.1=05;

% Use ab state at beginning of 2016
ab = get_ab_state(datetime(2016,1,1));

calc_srf(t_gm,Tef,yoff,ab,'test2',1.0);

% For testing, put proper path in for sfile
% sfile = 'srftables_m140f_withfake_mar08.hdf';
% chanid = hdfread(sfile,'chanid');
% freq   = hdfread(sfile,'freq');
% width  = hdfread(sfile,'width');
% fwgrid = hdfread(sfile,'fwgrid');
% srfval = hdfread(sfile,'srfval');


          