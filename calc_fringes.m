function [fringes]=calc_fringes(Tef, amp, pha, dch, beta, v, gamma)

% function [fringes]=calc_fringes(Tef, amp, pha, dch, beta, v, gamma);
%
% Calculate the model fringe signal (channeling spectra).
%
% Input:
%    Tef   = [1 x 1] entrance filter temperature {Kelvin}
%    amp   = [nchan x 1] amplitude
%    pha   = [nchan x 1] phase
%    dch   = [nchan x 1] period
%    beta  = [nchan x 1] phase temperature coefficient
%    v     = [nchan x nfreq] frequency points
%    gamma = [1 x 1] frequency adjustment factor
%
% Output:
%    fringes = [nchan x nfreq] fringe
%
% Note: ordinarily the fringe data (amp, pha, dch, beta) should be
%    taken from columns 6-9 of file "fringe_data.txt".
%

% Created: 22 March 2002, Scott Hannon, based on "compare_fringes_test.m"
% Updated: 19 August 2002; gamma changed to input variable
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fringe calibration data
%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Margie's reference entrance filter temperature
Tefref=154.8020;
%
% Freq scaling factor to convert GM freqs (at Tgmref=155.1325) into
% freqs close to the values in Margie W's "metrics_155K.txt" file.
%%%
% This value is now passed in
% gamma=1./(1 + 3.04E-5);  % eyeballed value
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[nrow, ncol]=size(Tef);
if (nrow ~= 1 | ncol ~= 1)
   error('Tef must be a single temperature')
end
%
[nchan, nfreq]=size(v);
%
[nrow, ncol]=size(amp);
if (nrow ~= nchan | ncol ~= 1)
   error('amp data is not dimensioned compatible with v data')
end
%
[nrow, ncol]=size(pha);
if (nrow ~= nchan | ncol ~= 1)
   error('pha data is not dimensioned compatible with v data')
end
%
[nrow, ncol]=size(dch);
if (nrow ~= nchan | ncol ~= 1)
   error('dch data is not dimensioned compatible with v data')
end
%
[nrow, ncol]=size(beta);
if (nrow ~= nchan | ncol ~= 1)
   error('beta data is not dimensioned compatible with v data')
end

% Assign full matrices
A=amp*ones(1,nfreq);
p=pha*ones(1,nfreq);
d=dch*ones(1,nfreq);
b=beta*ones(1,nfreq);

% Calc fringes
fringes = ones(nchan,nfreq) - A + A.*sin( 2*pi*d.*( v .* ...
      (1 + b*(Tef - Tefref)) - p/gamma ) );

%%% end of function %%%
