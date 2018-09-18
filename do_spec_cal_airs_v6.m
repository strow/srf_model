% Program "do_spec_cal_txt2.m"
%
% Create a spec cal txt file for use with SARTA.  Use the July 2009
% AIRS grating models for A/B detectors to calculate the channel
% freqs at Tnominal for A and B detectors at yoffset_nominal.
% Convert this to an effective delta yoffset for yoffset_nominal.
% Read in a L1B.cal_prop*anc file to determine A/B weights for
% each channel and the corresponding delta yoffset.
%

% Created: 04 August 2009, Scott Hannon
% Update: 05 Aug 2009, S.Hannon - switch gmodelall3 to gmodelall3_avg;
%    use new grating model for M12 & M11
% Update: 21 Aug 2009, S.Hannon - create A/B variant
% Update: 05 Oct 2011, S.Hannon - "x" variant created; output more info;
%    apply usual shifts for M12 & M5
% Update: 10 Oct 2011, S.Hannon - change module name to array number 1-17,
%    remove all freqs except SRF freq
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Edit this section as needed

clear

t_nom = 155.1325;
yoff_nom = -14;
sfile = 'srftables_m140f_withfake_mar08.hdf';

ind_m12 = 1:130;
ind_m5 = 1104:1262;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Calculate the freqs using the grating model
% WARNING! Old OPT grating model is not compatible with A/B grating models
% Unperturbed
% M12 is yoff_nom-1.5
[f_lm,freqo12,m_lm,module,w_lm,widtho] = gmodelall3_avg(t_nom,yoff_nom-1.5);
[f_lm,freqa12,m_lm,module,w_lm,widtha] = gmodelall3_avg(t_nom,yoff_nom-1.5,'A');
[f_lm,freqb12,m_lm,module,w_lm,widthb] = gmodelall3_avg(t_nom,yoff_nom-1.5,'B');
% M5 is yoff_nom+3.0
[f_lm,freqo5,m_lm,module,w_lm,widtho] = gmodelall3_avg(t_nom,yoff_nom+3.0);
[f_lm,freqa5,m_lm,module,w_lm,widtha] = gmodelall3_avg(t_nom,yoff_nom+3.0,'A');
[f_lm,freqb5,m_lm,module,w_lm,widthb] = gmodelall3_avg(t_nom,yoff_nom+3.0,'B');
% Nominal
[f_lm,freqo,m_lm,module,w_lm,widtho] = gmodelall3_avg(t_nom,yoff_nom);
[f_lm,freqa,m_lm,module,w_lm,widtha] = gmodelall3_avg(t_nom,yoff_nom,'A');
[f_lm,freqb,m_lm,module,w_lm,widthb] = gmodelall3_avg(t_nom,yoff_nom,'B');
%
freqo = freqo; freqo(ind_m12) = freqo12(ind_m12); freqo(ind_m5)=freqo5(ind_m5);
freqa = freqa; freqa(ind_m12) = freqa12(ind_m12); freqa(ind_m5)=freqa5(ind_m5);
freqb = freqb; freqb(ind_m12) = freqb12(ind_m12); freqb(ind_m5)=freqb5(ind_m5);
clear freqo5 freqa5 freqb5 freqo12 freqa12 freqb12
%
% Minus perturbation
% M12
[f_lm,freqom12 m_lm,module,w_lm,widthom]=gmodelall3_avg(t_nom,yoff_nom-0.5-1.5);
[f_lm,freqam12,m_lm,module,w_lm,widtham]=gmodelall3_avg(t_nom,yoff_nom-0.5-1.5,'A');
[f_lm,freqbm12,m_lm,module,w_lm,widthbm]=gmodelall3_avg(t_nom,yoff_nom-0.5-1.5,'B');
% M5
[f_lm,freqom5 m_lm,module,w_lm,widthom]=gmodelall3_avg(t_nom,yoff_nom-0.5+3.0);
[f_lm,freqam5,m_lm,module,w_lm,widtham]=gmodelall3_avg(t_nom,yoff_nom-0.5+3.0,'A');
[f_lm,freqbm5,m_lm,module,w_lm,widthbm]=gmodelall3_avg(t_nom,yoff_nom-0.5+3.0,'B');
% Nominal
[f_lm,freqom m_lm,module,w_lm,widthom]=gmodelall3_avg(t_nom,yoff_nom-0.5);
[f_lm,freqam,m_lm,module,w_lm,widtham]=gmodelall3_avg(t_nom,yoff_nom-0.5,'A');
[f_lm,freqbm,m_lm,module,w_lm,widthbm]=gmodelall3_avg(t_nom,yoff_nom-0.5,'B');
%
freqom = freqom; freqom(ind_m12) = freqom12(ind_m12); freqom(ind_m5)=freqom5(ind_m5);
freqam = freqam; freqam(ind_m12) = freqam12(ind_m12); freqam(ind_m5)=freqam5(ind_m5);
freqbm = freqbm; freqbm(ind_m12) = freqbm12(ind_m12); freqbm(ind_m5)=freqbm5(ind_m5);
clear freqom5 freqam5 freqbm5 freqom12 freqam12 freqbm12
%
% Plus perturbation
% M12
[f_lm,freqop12 m_lm,module,w_lm,widthop]=gmodelall3_avg(t_nom,yoff_nom+0.5+3.0);
[f_lm,freqap12,m_lm,module,w_lm,widthap]=gmodelall3_avg(t_nom,yoff_nom+0.5+3.0,'A');
[f_lm,freqbp12,m_lm,module,w_lm,widthbp]=gmodelall3_avg(t_nom,yoff_nom+0.5+3.0,'B');
% M5
[f_lm,freqop5 m_lm,module,w_lm,widthop]=gmodelall3_avg(t_nom,yoff_nom+0.5-1.5);
[f_lm,freqap5,m_lm,module,w_lm,widthap]=gmodelall3_avg(t_nom,yoff_nom+0.5-1.5,'A');
[f_lm,freqbp5,m_lm,module,w_lm,widthbp]=gmodelall3_avg(t_nom,yoff_nom+0.5-1.5,'B');
% Nominal
[f_lm,freqop m_lm,module,w_lm,widthop]=gmodelall3_avg(t_nom,yoff_nom+0.5);
[f_lm,freqap,m_lm,module,w_lm,widthap]=gmodelall3_avg(t_nom,yoff_nom+0.5,'A');
[f_lm,freqbp,m_lm,module,w_lm,widthbp]=gmodelall3_avg(t_nom,yoff_nom+0.5,'B');
%
freqop = freqop; freqop(ind_m12) = freqop12(ind_m12); freqop(ind_m5)=freqop5(ind_m5);
freqap = freqap; freqap(ind_m12) = freqap12(ind_m12); freqap(ind_m5)=freqap5(ind_m5);
freqbp = freqbp; freqbp(ind_m12) = freqbp12(ind_m12); freqbp(ind_m5)=freqbp5(ind_m5);
clear freqop5 freqap5 freqbp5 freqop12 freqap12 freqbp12


%keyboard


% Define A+B freqs as the mean of A and B freqs
freqab = (freqa + freqb)/2;

% Compute dy/df conversion factor
dydf_o = (0.5 - -0.5)./(freqop - freqom);
dydf_a = (0.5 - -0.5)./(freqap - freqam);
dydf_b = (0.5 - -0.5)./(freqbp - freqbm);

% Translate delta freq into delta yoffset
delta_yoff_a = (freqa - freqo).*dydf_a;
delta_yoff_b = (freqb - freqo).*dydf_b;
delta_yoff_ab= (freqab - freqo).*((dydf_a + dydf_b)/2);
%
% Indices for M12 & M11 (they do not have A/B detectors)
ind0 = 1:274;
%%% use old grating model for M12 & M11
%delta_yoff_a(ind0)=0;
%delta_yoff_b(ind0)=0;
%delta_yoff_ab(ind0)=0;
%%% use new grating model for M121 and M11
delta_yoff_a(ind0) = delta_yoff_ab(ind0);
delta_yoff_b(ind0) = delta_yoff_ab(ind0);


% Read SRF data
%[chanid, freq, width, fwgrid, srfval, fattr] = rdhdfsrf(sfile);

chanid = hdfread(sfile,'chanid');
freq   = hdfread(sfile,'freq');
width  = hdfread(sfile,'width');
fwgrid = hdfread(sfile,'fwgrid');
srfval = hdfread(sfile,'srfval');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Write out a more data
fname = input('Enter name of airs_abopt_m140f file to create: ','s');
%
widthab = (widtha + widthb)/2;
%
data_out = zeros(2378,5);
% SRF data
ind = 1:2378;
data_out(:,1) = freq(ind);
data_out(:,2) = width(ind);
% A-only data
data_out(:,3) = delta_yoff_a;
% B-only data
data_out(:,4) = delta_yoff_b;
% A+B data
data_out(:,5) = delta_yoff_ab;
%
fid = fopen(fname,'wt');
fprintf(fid,'%% SRF & grating model data for yoffset=-14.0 um\n');
fprintf(fid,'%% Note: SRF & grating model include yoffset adjustments for M12(-1.5 um) & M5(+3.0 um)\n');
fprintf(fid,'%% ID mi SRF freq  width  dY_A   dY_B   dY_AB  A/B weight A+B=0,A=1,B=2\n');
fprintf(fid,'%%--- -- --------- ------ ------ ------ ------ -------------------------\n');
for ii=1:2378
   junk = data_out(ii,:);
   if (length(module{ii}) == 1)
      modstr = [module{ii} ' '];
   else
      modstr = module{ii};
   end
   if (strcmp(modstr,'12')); mi =  1; end;
   if (strcmp(modstr,'11')); mi =  2; end;
   if (strcmp(modstr,'10')); mi =  3; end;
   if (strcmp(modstr,'9 ')); mi =  4; end;
   if (strcmp(modstr,'8 ')); mi =  5; end;
   if (strcmp(modstr,'7 ')); mi =  6; end;
   if (strcmp(modstr,'6 ')); mi =  7; end;
   if (strcmp(modstr,'5 ')); mi =  8; end;
   if (strcmp(modstr,'4d')); mi =  9; end;
   if (strcmp(modstr,'4c')); mi = 10; end;
   if (strcmp(modstr,'3 ')); mi = 11; end;
   if (strcmp(modstr,'4b')); mi = 12; end;
   if (strcmp(modstr,'4a')); mi = 13; end;
   if (strcmp(modstr,'2b')); mi = 14; end;
   if (strcmp(modstr,'1b')); mi = 15; end;
   if (strcmp(modstr,'2a')); mi = 16; end;
   if (strcmp(modstr,'1a')); mi = 17; end;
   fprintf(fid,'%4u %2i %9.4f %6.4f %6.3f %6.3f %6.3f\n',ii,mi,junk);
end
fclose(fid);
%%%
%keyboard
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%% end of program %%%
