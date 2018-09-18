function mkhdfsrf(fname)

% function mkhdfsrf(fname);
%
% Reads in a matlab SRF table and creates an HDF file.
%
% Input:
%    fname = {string} name of SRF *.mat file without the ".mat"
%       extension.  The HDF file created by this function will
%       use the same file name except with a ".hdf" extension.
%
% Output: none
%
% Note: the *.mat SRF table file should be created with a program
% such as "do_calc_srf_tables.m".
%

% mkhdfsrf is a variant of Howard Mottelers "srfdemo.m" program.
% Update: 9 May 2002 - work-around for version (var vs function) bug
% Update: 14 March 2008, S.Hannon - add nchan to replace hardcoded "2378"
% Update: 19 Jan 2010, S.Hannon - revise path to hdp
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Path for HDF tools
addpath /asl/matlab/h4tools

hfile = [fname '.hdf'];
mfile = [fname '.mat'];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Folowing code is copied from Howards "h4tools/srfdemo.m"
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Assign dummy version string variable
% Note: without this, program will assume "version" refers to the function
version='dummy version string';

% get the data
load(mfile)
nchan = length(chanid);


% convert to more compact data types; only the channel centers
% (i.e., freq) need to be saved in the default double precision
chanid = int16(chanid);
fwgrid = single(fwgrid);
srfval = single(srfval);
width = single(width);

% set file attributes
fattr = { ...
  {'author',  author}, ...
  {'version', version}, ...
  {'comment', comment} };

% set array names, values, attributes, and dimension info
slist = { ...
  { 'chanid', chanid, {{'units', chanid_units}}, {'one', 'nchan'}}, ...
  { 'freq',   freq,   {{'units', freq_units}},   {'one', 'nchan'}}, ...
  { 'fwgrid', fwgrid, {{'units', fwgrid_units}}, {'npts', 'one'}}, ...
  { 'srfval', srfval, {{'units', srfval_units}}, {'npts', 'nchan'}},...
  { 'width',  width,  {{'units', width_units}},  {'one', 'nchan'}} };

% call h4sdwrite to write the HDF file
h4sdwrite(hfile, slist, fattr);

% call h4sdread to read the data back, for a check
[slist1, fattr1] = h4sdread(hfile);

% compare original and re-read data
%%% modified by Scott
%[isequal(slist, slist1), isequal(fattr, fattr1)]
ans=[isequal(slist, slist1), isequal(fattr, fattr1)];
for ii=1:length(ans)
   if (ans(ii) ~= 1)
      error('original data and HDF data disagree');
   end
end
%%%

% dump HDF SRF as binary data and check results again
%cmd = sprintf('!hdp dumpsds -b -n srfval %s > srfval.bin', hfile);
%cmd = sprintf('!/usr/local/hdf/bin/hdp dumpsds -b -n srfval %s > srfval.bin', hfile);
cmd = sprintf('!/asl/opt/hdf/4.2r4/bin/hdp dumpsds -b -n srfval %s > srfval.bin', hfile);
eval(cmd);
fid = fopen('srfval.bin', 'r');
% [srf1, count] = fread(fid, inf, 'double');
[srf1, count] = fread(fid, inf, 'single');

%%% removed 13 May 2010
%srf1 = reshape(srf1, 471, nchan);
%%%% modified by Scott
%%isequal(srfval, srf1)
%ans=isequal(srfval, srf1);
%for ii=1:length(ans)
%   if (ans(ii) ~= 1)
%      error('original data and HDF data disagree');
%   end
%end
%%%

% clean up
! rm srfval.bin 2> /dev/null

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% End of Howards "srfemo.m" code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp(['finished creating HDF SRF table ' hfile])

%%% end of function %%%
