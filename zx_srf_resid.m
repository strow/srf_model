function [yout]=zx_srf_resid(v, v0, fwhm, gfrac, gexp, gslope, lexp, ...
   xresid, yresid);

% function [yout]=zx_srf_resid(v, v0, fwhm, gfrac, gexp, gslope, lexp, ...
%    xresid, yresid);
%
% Calculate a SRF using a modified version of George Aumann's
% Gauss+Lorentz SRF.  This "zx" version does the gaussian portion
% with a variable power (as per x_srf) as well as a slope on the
% power (as per z_srf) that changes linearly with dv.
%
% Input:
%    v     = (1 x npts) frequency array
%    v0    = (1 x 1) channel center freq
%    fwhm  = (1 x 1) channel FWHM
%    gfrac = (1 x 1) Gauss fraction (Lorentz fraction is 1-gfrac)
%    gexp  = (1 x 1) Gauss initial exponent
%    gslope= (1 x 1) Gauss exponent slope
%    lexp  = (1 x 1) Lorentz exponent
%    xresid= (1 x nresid) residual x-axis points, in FWHM
%    yresid= (1 x nresid) residual(=obs-zxsrf)
%
% Output:
%    yout = SRF
%
% Nominal shape values:
%    gfrac = 0.975;
%    gexp  = 3.0;
%    gslope= 0.0;
%    lexp  = 1.8;
%
% Note:
%    1) When gslope=0, zx_srf is the same as x_srf
%    2) When gexp=2, zx_srf is the same as z_srf (except as per note 3)
%    3) Min Gauss exponent=(gexp +x*gslope) is 2, max is 4
%

% Last updated by Scott Hannon, 31 January 2000
% resid version created 18 May 2000 by scott
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x=abs(v - v0)/(0.5*fwhm);
% Note that x is twice the distance from chan center in units of FWHM
a=log(2);

gexponent=gexp + gslope*x;
ind=find(gexponent > 4);
gexponent(ind)=4;
ind=find(gexponent < 2);
gexponent(ind)=2;

yout=gfrac*exp(-a*x.^gexponent) + (1-gfrac)./(1 + x.^lexp);

% Tack on the residual
if (length(xresid) > 1)
   hx=(v - v0)/fwhm;
   ind=find( hx >= min(xresid) & hx <= max(xresid) );
   yy=interp1(xresid,yresid,hx(ind),'pchip');
   yout(ind)=yout(ind) + yy;

   % Renormalize to peak=1
   yout=yout/max(yout);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% end of function %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
