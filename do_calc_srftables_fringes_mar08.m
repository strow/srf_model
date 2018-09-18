% Program to make up the SRF look-up tables
% Version Mar08 (14 March 2008) with fake channels

% Version "with_fringes" created: 22 March 2002, Scott Hannon
% This version for the new fringe positions as of 16 November 2003.
% Note: besdes the updated Tfilter, module 5 has been offset by +3.0 um
% compared to all other modules.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Edit this section as needed
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Module names
modules={'12', '11', '10', '9', '8',  '7',  '6',  '5', '4d', '4c',  '3', ...
   '4b', '4a', '2b', '1b', '2a', '1a'};

% Assign temperature at which to calc grating model
%t_gm = 155.1325;
t_gm=input('Enter grating temperature : [155.1325] ');
Tef=input('Enter entrance filters temperature: [156.339] ');

% Assign amount to shift grating model
%yoff=-200/12; % -200/12 = -16.66667
%yoff=0; % nominal at-launch freqs
yoff=input('Enter grating model y-offset: [-13.5] ');

% M5 offset
M5offset=input('Enter M5 mystery offset: [3.0] ');

% M12 offset
M12offset=input('Enter M12 mystery offset: [-1.5] ');

% Define x-axis grid points (in FWHM)
fwgrid=[ (-10:0.1:-1.6), (-1.5:0.01:1.5), (1.6:0.1:10)]'; %'

% Channel ID
chanid=1:2378;

% SRF output file name
srfname='srftables_m135f_155K_nov05';
disp(['example srfname [' srfname ']'])
srfname=input('Enter name of output SRF table to create : ','s');

%%%%%%%%%%
% Comments (256 char max)

% version number, brief description, and date
version='Version 5.0 AIRS SRFs; yoffset=-13.5um; M5offset=3.0; M12offset=-1.5; Tgrat=155.1325; Tfilt=156.339';
disp('Example version info:')
disp(version)
version=input('Enter SRF table version info (256 char max) : ','s');

% author name, address, and email
author='Scott Hannon; Dept. of Physics, University of Maryland Baltimore County (UMBC), 1000 Hilltop Circle, Baltimore MD 21250; hannon@umbc.edu';

% Any extra comments
comment='freqgrid = fwgrid*width + freq; Do a linear interpolation of srfval andfreqgrid to calculate the SRF on your desired frequency grid; Do not extrapolate the SRF beyond the endpoints of fwgrid; Channels with ID>2378 are fake';

%%%%%%%
% Units (80 char max)
width_units='cm^-1; Full Width at Half Maximum (FWHM)';
fwgrid_units='FWHM; grid points for all SRF lookup tables';
srfval_units='none; peak=1 normalized SRF values on the fwgrid grid';
chanid_units='integer 1 to 2378 or fake channel if >2378; channel ID number';
freq_units='cm^-1; channel center frequency';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Pad strings with blanks to the correct length
%
%%%%%
% 256 characters
%
% comment
junk=comment;
comment=blanks(256);
nchar=length(junk);
if (nchar > 256)
   error(['comment is too long; length =' int2str(nchar) ' > 256 max'])
end
comment(1:nchar)=junk;
%
% author
junk=author;
author=blanks(256);
nchar=length(junk);
if (nchar > 256)
   error(['author is too long; length =' int2str(nchar) ' > 256 max'])
end
author(1:nchar)=junk;
%
% version
junk=version;
version=blanks(256);
nchar=length(junk);
if (nchar > 256)
   error(['version is too long; length =' int2str(nchar) ' > 256 max'])
end
version(1:nchar)=junk;
%
%%%%
% 80 characters
%
% freq_units
junk=freq_units;
freq_units=blanks(80);
nchar=length(junk);
if (nchar > 256)
   error(['freq_units is too long; length =' int2str(nchar) ' > 80 max'])
end
freq_units(1:nchar)=junk;
%
% width_units
junk=width_units;
width_units=blanks(80);
nchar=length(junk);
if (nchar > 256)
   error(['width_units is too long; length =' int2str(nchar) ' > 80 max'])
end
width_units(1:nchar)=junk;
%
% fwgrid_units
junk=fwgrid_units;
fwgrid_units=blanks(80);
nchar=length(junk);
if (nchar > 256)
   error(['fwgrid_units is too long; length =' int2str(nchar) ' > 80 max'])
end
fwgrid_units(1:nchar)=junk;
%
% chanid_units
junk=chanid_units;
chanid_units=blanks(80);
nchar=length(junk);
if (nchar > 256)
   error(['chanid_units is too long; length =' int2str(nchar) ' > 256 max'])
end
chanid_units(1:nchar)=junk;
%
% srfval_units
junk=srfval_units;
srfval_units=blanks(80);
nchar=length(junk);
if (nchar > 256)
   error(['srfval_units is too long; length =' int2str(nchar) ' > 80 max'])
end
srfval_units(1:nchar)=junk;
%
clear junk nchar


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Use the grating model to calc the chan center freqs & widths

% Do calc for M5
[fc_lm, freq, modid_lm, modid, width_lm, width] = ...
   gmodelall2(t_gm,yoff+M5offset);
i5=strmatch('5',modid,'exact');
freq5=freq(i5);
width5=width(i5);

% Do calc for M12
[fc_lm, freq, modid_lm, modid, width_lm, width] = ...
   gmodelall2(t_gm,yoff+M12offset);
i12=strmatch('12',modid,'exact');
freq12=freq(i12);
width12=width(i12);

% Do calc for all other modules
[fc_lm, freq, modid_lm, modid, width_lm, width] = ...
   gmodelall2(t_gm,yoff);

clear fc_lm modid_lm width_lm
freq=freq'; %'
width=width'; %'
nchan=length(freq);

freq(i5)=freq5;
width(i5)=width5;
clear freq5 width5 i5

freq(i12)=freq12;
width(i12)=width12;
clear freq12 width12 i12


%%%%%%%%%%%%%%%%%%%%
% Add  fake channels
[chanid, freq, width, mindex] = add_fake(chanid, freq, width);
nchan = length(chanid);

% Declare SRF array
npts=length(fwgrid);
srfval=zeros(npts,nchan);

% Convert cell array to string
modid=char(modid);


%%%%%%%%%%%%%%%%%%
% Load fringe data
load fringe_data_nov02.txt;
fringe_data=fringe_data_nov02; clear fringe_data_nov02
amp=fringe_data(:,6);
pha=fringe_data(:,7);
dch=fringe_data(:,8);
beta=fringe_data(:,9);
clear fringe_data

% fringe_data_nov02 is frequency calibrated; thus gamma, the frequency
% adjustment factor, should be set to unity
gamma=1.0;


%%%%%%%%%%%%%%%%%%%%%%%
% Loop over the modules
ichan=0;
nmod=length(modules);
for imod=1:nmod
   module=char(modules(imod));

   disp(['Working on module ' module]);

   % Find indices of channels for the current module
%%% old
%   if (length(module) == 2)
%      ind=find(modid(:,1) == module(1) & modid(:,2) == module(2));
%   else
%      ind=find(modid(:,1) == module(1));
%   end
%%% new
   ind = find(mindex == imod);
%%%
   nchanmod=length(ind);

   % Load SRF shape parameters for this module
   [gfrac, gexp, gslope, lexp, xresid, yresid]=get_srf_params(module);

   % Loop over channels and fill up srfval
   for ic=1:nchanmod

%%% old
%      ichan=ichan + 1; % increment channel index
%%% new
      ichan = ind(ic);
%%%
      v0=freq(ichan);
      f=fwgrid*width(ichan) + v0;
      yout=zx_srf_resid(f, v0, width(ichan), ...
         gfrac, gexp, gslope, lexp, xresid, yresid);
      %
%%% old
%      fringes=calc_fringes(Tef, amp(ichan), pha(ichan), dch(ichan), ...
%         beta(ichan), f', gamma); %'
%      %
%      yf=yout.*fringes'; %'
%      srfval(:,ichan)=yf/max(yf);
%%% new
     if (chanid(ichan) > 2378)
         srfval(:,ichan)=yout/max(yout);
     else
         fringes=calc_fringes(Tef, amp(ichan), pha(ichan), dch(ichan), ...
            beta(ichan), f', gamma); %'
         yf=yout.*fringes'; %'
         srfval(:,ichan)=yf/max(yf);
     end
%%%

   end

end % End of loop over modules


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Save data to file
eval(['save ' srfname ' chanid freq width fwgrid srfval comment author version chanid_units freq_units width_units fwgrid_units srfval_units']);

%%% end of program %%%
