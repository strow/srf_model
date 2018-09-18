%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% basic channel info %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Grating model data
t_gm = 155.1325;
%yoffset = -13.5;
yoffset = -14.0;
M12shift = -1.5;
M5shift = 3.0;

% Standard grating model
[j1,f,j2,m,j3,w] = gmodelall2(t_gm, yoffset);

% Determine numeric array number 1 to 17, in order of ascending freq
m_in_order={'12' '11' '10' '9' '8' '7' '6' '5' '4d' '4c' '3' '4b' '4a' '2b' '1b' '2a' '1a'};
a = zeros(2378,1);
for ii=1:17
ia = find(strcmp(m,m_in_order(ii)));
   a(ia) = ii;
end

% Do grating model for M12
[j1,fx,j2,mx,j3,wx] = gmodelall2(t_gm, yoffset+M12shift);
ia = find(a == 1); % m='12'
f(ia) = fx(ia);
w(ia) = wx(ia);

% Do grating model for M5
[j1,fx,j2,mx,j3,wx] = gmodelall2(t_gm, yoffset+M5shift);
ia = find(a == 8); % m='5'
f(ia) = fx(ia);
w(ia) = wx(ia);
clear j1 j2 j3 fx mx wx ii ia

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Note: requires grating info is ordered such that index = PGE ID

fake_id_offset = 2378;
nfake = 0;
nfakemax = 1000;
ffake = zeros(nfakemax,1);
wfake = zeros(nfakemax,1);
gfake = zeros(nfakemax,1);
idfake = fake_id_offset + (1:nfakemax)'; %'


% Fake channel at lo freq end of M12
ii = min( find(strcmp(m,'12')) );
ifake = nfake + 1;
ffake(ifake) = 2*f(ii) - f(ii+1);
wfake(ifake) = w(ii);
gfake(ifake) = -1;
nfake = nfake + 1;


% Fake channel info for M12--M11 gap
igap = 1;
ii = max( find(strcmp(m,'12')) );
flo = f(ii);
wlo = w(ii);
fhi = f(ii+1);
whi = w(ii+1);
dflo = f(ii) - f(ii-1);
dfhi = f(ii+2) - f(ii+1);
deltaf_gap = fhi - flo;
nfake_igap = round(0.5*(deltaf_gap/dflo + deltaf_gap/dfhi) + 0.1);
ifake = nfake + (1:nfake_igap);
nfake = nfake + nfake_igap;
gfake(ifake) = igap;
wfake(ifake) = 0.5*(wlo + whi);
df = deltaf_gap/(nfake_igap + 1);
ffake(ifake) = flo + df*(1:nfake_igap);


% Fake channel at hi freq end of M11
ii = max( find(strcmp(m,'11')) );
ifake = nfake + 1;
ffake(ifake) = 2*f(ii) - f(ii-1);
wfake(ifake) = w(ii);
gfake(ifake) = -1;
nfake = nfake + 1;


% Fake channel at lo freq end of M10
ii = min( find(strcmp(m,'10')) );
ifake = nfake + 1;
ffake(ifake) = 2*f(ii) - f(ii+1);
wfake(ifake) = w(ii);
gfake(ifake) = -1;
nfake = nfake + 1;


% Fake channel info for M10--M9 gap
igap = 2;
ii = max( find(strcmp(m,'10')) );
flo = f(ii);
wlo = w(ii);
fhi = f(ii+1);
whi = w(ii+1);
dflo = f(ii) - f(ii-1);
dfhi = f(ii+2) - f(ii+1);
deltaf_gap = fhi - flo;
nfake_igap = round(0.5*(deltaf_gap/dflo + deltaf_gap/dfhi) + 0.1);
ifake = nfake + (1:nfake_igap);
nfake = nfake + nfake_igap;
gfake(ifake) = igap;
wfake(ifake) = 0.5*(wlo + whi);
df = deltaf_gap/(nfake_igap + 1);
ffake(ifake) = flo + df*(1:nfake_igap);


% Fake channel at hi freq end of M9
ii = max( find(strcmp(m,'9')) );
ifake = nfake + 1;
ffake(ifake) = 2*f(ii) - f(ii-1);
wfake(ifake) = w(ii);
gfake(ifake) = -1;
nfake = nfake + 1;


% Fake channel at lo freq end of M8
ii = min( find(strcmp(m,'8')) );
ifake = nfake + 1;
ffake(ifake) = 2*f(ii) - f(ii+1);
wfake(ifake) = w(ii);
gfake(ifake) = -1;
nfake = nfake + 1;


% Fake channel info for M8--M7 gap
igap = 3;
ii = max( find(strcmp(m,'8')) );
flo = f(ii);
wlo = w(ii);
fhi = f(ii+1);
whi = w(ii+1);
dflo = f(ii) - f(ii-1);
dfhi = f(ii+2) - f(ii+1);
deltaf_gap = fhi - flo;
nfake_igap = round(0.5*(deltaf_gap/dflo + deltaf_gap/dfhi) + 0.1);
ifake = nfake + (1:nfake_igap);
nfake = nfake + nfake_igap;
gfake(ifake) = igap;
wfake(ifake) = 0.5*(wlo + whi);
df = deltaf_gap/(nfake_igap + 1);
ffake(ifake) = flo + df*(1:nfake_igap);


% Fake channel at hi freq end of M7
ii = max( find(strcmp(m,'7')) );
ifake = nfake + 1;
ffake(ifake) = 2*f(ii) - f(ii-1);
wfake(ifake) = w(ii);
gfake(ifake) = -1;
nfake = nfake + 1;


% Fake channel at lo freq end of M6
ii = min( find(strcmp(m,'6')) );
ifake = nfake + 1;
ffake(ifake) = 2*f(ii) - f(ii+1);
wfake(ifake) = w(ii);
gfake(ifake) = -1;
nfake = nfake + 1;


% Fake channel info for M6--M5 gap
igap = 4;
ii = max( find(strcmp(m,'6')) );
flo = f(ii);
wlo = w(ii);
fhi = f(ii+1);
whi = w(ii+1);
dflo = f(ii) - f(ii-1);
dfhi = f(ii+2) - f(ii+1);
deltaf_gap = fhi - flo;
nfake_igap = round(0.5*(deltaf_gap/dflo + deltaf_gap/dfhi) + 0.1);
ifake = nfake + (1:nfake_igap);
nfake = nfake + nfake_igap;
gfake(ifake) = igap;
wfake(ifake) = 0.5*(wlo + whi);
df = deltaf_gap/(nfake_igap + 1);
ffake(ifake) = flo + df*(1:nfake_igap);


% Fake channel info for M5--M4d gap
igap = 5;
ii = max( find(strcmp(m,'5')) );
flo = f(ii);
wlo = w(ii);
fhi = f(ii+1);
whi = w(ii+1);
dflo = f(ii) - f(ii-1);
dfhi = f(ii+2) - f(ii+1);
deltaf_gap = fhi - flo;
nfake_igap = round(0.5*(deltaf_gap/dflo + deltaf_gap/dfhi) + 0.1);
ifake = nfake + (1:nfake_igap);
nfake = nfake + nfake_igap;
gfake(ifake) = igap;
wfake(ifake) = 0.5*(wlo + whi);
df = deltaf_gap/(nfake_igap + 1);
ffake(ifake) = flo + df*(1:nfake_igap);


% Fake channel info for M4d--M4c gap
igap = 6;
ii = max( find(strcmp(m,'4d')) );
flo = f(ii);
wlo = w(ii);
fhi = f(ii+1);
whi = w(ii+1);
dflo = f(ii) - f(ii-1);
dfhi = f(ii+2) - f(ii+1);
deltaf_gap = fhi - flo;
nfake_igap = round(0.5*(deltaf_gap/dflo + deltaf_gap/dfhi) + 0.1);
ifake = nfake + (1:nfake_igap);
nfake = nfake + nfake_igap;
gfake(ifake) = igap;
wfake(ifake) = 0.5*(wlo + whi);
df = deltaf_gap/(nfake_igap + 1);
ffake(ifake) = flo + df*(1:nfake_igap);


% Fake channel at hi freq end of M4c
ii = max( find(strcmp(m,'4c')) );
ifake = nfake + 1;
ffake(ifake) = 2*f(ii) - f(ii-1);
wfake(ifake) = w(ii);
gfake(ifake) = -1;
nfake = nfake + 1;


% Fake channel at lo freq end of M3
ii = min( find(strcmp(m,'3')) );
ifake = nfake + 1;
ffake(ifake) = 2*f(ii) - f(ii+1);
wfake(ifake) = w(ii);
gfake(ifake) = -1;
nfake = nfake + 1;


% Fake channel info for M3--M4b gap
igap = 7;
ii = max( find(strcmp(m,'3')) );
flo = f(ii);
wlo = w(ii);
fhi = f(ii+1);
whi = w(ii+1);
dflo = f(ii) - f(ii-1);
dfhi = f(ii+2) - f(ii+1);
deltaf_gap = fhi - flo;
nfake_igap = round(0.5*(deltaf_gap/dflo + deltaf_gap/dfhi) + 0.1);
ifake = nfake + (1:nfake_igap);
nfake = nfake + nfake_igap;
gfake(ifake) = igap;
wfake(ifake) = 0.5*(wlo + whi);
df = deltaf_gap/(nfake_igap + 1);
ffake(ifake) = flo + df*(1:nfake_igap);


% Fake channel info for M4b--M4a gap
igap = 8;
ii = max( find(strcmp(m,'4b')) );
flo = f(ii);
wlo = w(ii);
fhi = f(ii+1);
whi = w(ii+1);
dflo = f(ii) - f(ii-1);
dfhi = f(ii+2) - f(ii+1);
deltaf_gap = fhi - flo;
nfake_igap = round(0.5*(deltaf_gap/dflo + deltaf_gap/dfhi) + 0.1);
ifake = nfake + (1:nfake_igap);
nfake = nfake + nfake_igap;
gfake(ifake) = igap;
wfake(ifake) = 0.5*(wlo + whi);
df = deltaf_gap/(nfake_igap + 1);
ffake(ifake) = flo + df*(1:nfake_igap);


% Fake channel at hi freq end of M4a
ii = max( find(strcmp(m,'4a')) );
ifake = nfake + 1;
ffake(ifake) = 2*f(ii) - f(ii-1);
wfake(ifake) = w(ii);
gfake(ifake) = -1;
nfake = nfake + 1;


% Fake channel info for lo extension to M2b
igap = 9;
ii = min( find(strcmp(m,'2b')) );
flo = 2165.0;
wlo = w(ii);
fhi = f(ii);
whi = w(ii);
dfhi = f(ii+1) - f(ii);
dflo = dfhi;
deltaf_gap = fhi - flo;
nfake_igap = round(0.5*(deltaf_gap/dflo + deltaf_gap/dfhi) + 0.1);
ifake = nfake + (1:nfake_igap);
nfake = nfake + nfake_igap;
gfake(ifake) = igap;
wfake(ifake) = 0.5*(wlo + whi);
df = deltaf_gap/(nfake_igap + 1);
ffake(ifake) = flo + df*(1:nfake_igap);


% Fake channel at hi freq end of M2b
ii = max( find(strcmp(m,'2b')) );
ifake = nfake + 1;
ffake(ifake) = 2*f(ii) - f(ii-1);
wfake(ifake) = w(ii);
gfake(ifake) = -1;
nfake = nfake + 1;


% Fake channel at lo freq end of M1b
ii = min( find(strcmp(m,'1b')) );
ifake = nfake + 1;
ffake(ifake) = 2*f(ii) - f(ii+1);
wfake(ifake) = w(ii);
gfake(ifake) = -1;
nfake = nfake + 1;


% Fake channel info for M1b--M2a gap
igap = 10;
ii = max( find(strcmp(m,'1b')) );
flo = f(ii);
wlo = w(ii);
fhi = f(ii+1);
whi = w(ii+1);
dflo = f(ii) - f(ii-1);
dfhi = f(ii+2) - f(ii+1);
deltaf_gap = fhi - flo;
nfake_igap = round(0.5*(deltaf_gap/dflo + deltaf_gap/dfhi) + 0.1);
ifake = nfake + (1:nfake_igap);
nfake = nfake + nfake_igap;
gfake(ifake) = igap;
wfake(ifake) = 0.5*(wlo + whi);
df = deltaf_gap/(nfake_igap + 1);
ffake(ifake) = flo + df*(1:nfake_igap);


% Fake channel at hi freq end of M2a
ii = max( find(strcmp(m,'2a')) );
ifake = nfake + 1;
ffake(ifake) = 2*f(ii) - f(ii-1);
wfake(ifake) = w(ii);
gfake(ifake) = -1;
nfake = nfake + 1;


% Fake channel at lo freq end of M1a
ii = min( find(strcmp(m,'1a')) );
ifake = nfake + 1;
ffake(ifake) = 2*f(ii) - f(ii+1);
wfake(ifake) = w(ii);
gfake(ifake) = -1;
nfake = nfake + 1;


% Fake channel info for hi extension to M1a
igap = 11;
ii = max( find(strcmp(m,'1a')) );
flo = f(ii);
wlo = w(ii);
fhi = 2768.0;
whi = w(ii);
dflo = f(ii) - f(ii-1);
dfhi = dflo;
deltaf_gap = fhi - flo;
nfake_igap = round(0.5*(deltaf_gap/dflo + deltaf_gap/dfhi) + 0.1);
ifake = nfake + (1:nfake_igap);
nfake = nfake + nfake_igap;
gfake(ifake) = igap;
wfake(ifake) = 0.5*(wlo + whi);
df = deltaf_gap/(nfake_igap + 1);
ffake(ifake) = flo + df*(1:nfake_igap);


%%%
clear nfakemax ifake df deltaf_gap nfake_igap igap fhi flo whi wlo dflo dfhi ii
ikeep = 1:nfake;
ffake=ffake(ikeep);
gfake=gfake(ikeep);
wfake=wfake(ikeep);
idfake=idfake(ikeep);
clear ikeep
