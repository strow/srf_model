% function [f_lm, freq, m_lm, module, w_lm, width] = gmodelall2(temp, yoff);
%
% Calculate the AIRS channel center wavenumbers using the grating model
%
%     Based on the AIRS grating model dated May 5, 2000
%
%     V 1.0:        May 23, 2000    
%     Programmer:   L. Strow
%     V 2.0:        Scott Hannon
%     Organization: UMBC
%     
%     Inputs:
%        temp = (1 x 1) Grating spectrometer temperature, in K
%        yoff = (1 x 1) Focal plane offset, in um (usually 0)
%
%     Outputs:
%        f_lm   = freq, except Lockheed Martin ordering
%        freq   = (2378 x 1) channel center frequencies, in cm-1
%        m_lm   = module, except Lockheed Martin ordering
%        module = (2378 x 1) cell array of module names
%  	 w_lm   = width, except Lockheed Martin ordering
%  	 width  = (2378 x 1) channel width
%  
%     Required files:
%            finalgm.mat:             grating model parameters
%            sept99_fm_chanlist.txt:  defines jpl channel ordering
%	  
%     
%     UPDATES:
%
%     June 16, 2000: (L. Strow)
%        (1) Fixed 1 point in 2^16 error by UMBC in FFT routine to convert
%            interferograms into SRFs.
%        (2) Widths added for convenience.  They are not needed in
%	     the grating model since they are part of the SRF shape.
%	 (3) We no longer read the text file sept99_fm_chanlist.txt
%            in order to get the sort key for turning Lockheed Martin
%            channel ordering into JPL Level 2 channel ordering.  We
%            now read the file called lmtojplind.mat.
%        (4) Changed the definition of the Lockheed Martin ordering
%            to agree with what others are using, basically reversing
%            the channel numbering for M3 and M6.  We are still a
%            little worried about this since our original ordering
%            is how we read the channel from the ObjectStore files.
%        (5) The structure chan has been replaced with the array nu 
%            (see changes to gmfunc.m for reference)
%
%     Version 2:
%     30 August 2000, Scott Hannon:
%        (6) Add yoff to input; rename input and output variables
%        (7) Shift widths with temperature (nominal at T=155.1325 K)
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [f_lm, freq, m_lm, module, w_lm,width] = gmodelall2(temp, yoff);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Standard temperature 
t_std = 155.1325;
delta_t=temp - t_std;

% Temperature dependence of y_cuton's
yoffslope = 2.20813;  % microns/K

% Load grating model parameters for each array
load finalgm

% Load smoothed widths, in variable withavg
load widths

% Grating order and side
order  = [11 10 10 9 6 6 6 5 5 4 4 4 4 3 3 3 3];
side   = [1 2 1 2 2 2 1 2 2 2 2 1 1 2 2 1 1];

% Array channel ordering using Lockheed-Martin indexing
% Note: M3 and M6 are the revised LM ordering
a = { ...
    '1a'       0     117    2552    2677 ;
    '2a'     248     363    2432    2555 ;
    '1b'     118     247    2309    2434 ;
    '2b'     364     513    2169    2312 ;
    '4a'     706     809    1540    1614 ;
    '4b'     810     915    1460    1527 ;
    '3'      514     705    1337    1443 ;
    '4c'     916    1009    1283    1339 ;
    '4d'    1010    1115    1216    1273 ;
    '5'     1116    1274    1055    1136 ;
    '6'     1275    1441     973    1046 ;
    '7'     1442    1608     910     974 ;
    '8'     1609    1769     851     904 ;
    '9'     1770    1936     788     852 ;
    '10'    1937    2103     727     782 ;
    '11'    2104    2247     687     729 ;
    '12'    2248    2377     649     682 ;
    };
mod_list         = {a{:,1}};
first_chans      = [a{:,2}];
last_chans       = [a{:,3}];
approx_min_freqs = [a{:,4}];
approx_max_freqs = [a{:,5}];

nchans = 1 + abs(last_chans - first_chans)';

% Declare output arrays
f_lm=zeros(2378,1);
w_lm=zeros(2378,1);
freq=zeros(2378,1);
width=zeros(2378,1);

% Loop through modules
for m=1:17
   y        = yoff + y_cuton(m) + delta_t*yoffslope;
   nu       = gmfunc(y, focal_length(m),quadm(m),quadoff(m),...
		     side(m), order(m),nchans(m));
   newind        = first_chans(m)+1:last_chans(m)+1;

   % Adjust widths for temperature
   if (abs(delta_t) > 1E-6 | abs(yoff) > 1E-6)
      % Calc standard freqs & widths
      y_std  = y_cuton(m);
      nu_std = gmfunc(y_std, focal_length(m),quadm(m),quadoff(m),...
         side(m), order(m),nchans(m));
      w_std=widthavg(m).w;
      %
      % Polynomianl fit of standard witdhs
      warning off
      coef=polyfit(nu_std, w_std, 3);
      warning on
      %
      % Calc shifted widths
      w=polyval(coef,nu);
   else
      w=widthavg(m).w;
   end

   f_lm(newind)  = nu;
   m_lm(newind)  = mod_list(m);
   w_lm(newind)  = w;

end  

% Load sort key to go from LM ordering to JPL 
load lmtojplind

% Sort the Lockheed indexes
[junk,ind]  = sort(lmtojplind);

% load up frequencies in JPL order
freq(ind) = f_lm;

% load up widths in JPL order
width(ind) = w_lm;

% load up Module ID's (M1b, M4d, etc.) in JPL order
module(ind)= m_lm;
m_lm       = m_lm';
module     = module';

return
