clear;
%%
Nt = 64; % tx antenna elements number
d_to_lambda = 1/4; % tx antenna distance
alpha = -3.1; % path loss parameter
beta = 5.75e-5; % path loss parameter
bandwidth = 800e6; % bandwidth of channel
M = 3; % parameter of Nakagami-M model
r = 30; % range of interference
R = 150; % range of interference

Pt = 631; % tx transmit power 28dBm
TxRxGain = 16; % 16 dB for tx rx antenna gain
sigma = 10; % noise figure

txHeight = 5;
rxHeight = 1.6;

%% read map
%viewer = siteviewer("Buildings","measuredArea.osm","Basemap","openstreetmap");

%% define tx
%clearMap(viewer);
% t-mobile LTE sites location

%-----------
txLats = [40.73524475, 40.73524500, 40.73524475, 40.73524475, 40.73730500, 40.73661804, 40.73772700, 40.73524475, 40.73524475, 40.73524500, 40.73524500, 40.73661800, 40.73570300, 40.73531900, 40.73528800, 40.73661800, 40.73524500, 40.73661800, 40.73580700, 40.73524475, 40.73661804, 40.73524475, 40.73524475, 40.73524475, 40.73524475, 40.73661804, 40.73730500, 40.73645100, 40.73661800, 40.73655300, 40.73654900, 40.73528800, 40.73577300, 40.73524475, 40.73524500, 40.73472500, 40.73723400, 40.73506300, 40.73645800, 40.73510700, 40.73659300, 40.73551900, 40.73602900, 40.73490100, 40.73524475, 40.73524475, 40.73777900, 40.73707600, 40.73661800, 40.73656500, 40.73548400, 40.73654800, 40.73524500, 40.73661804, 40.73524475, 40.73524475, 40.73524475, 40.73524475, 40.73661804, 40.73661804, 40.73585500, 40.73524475, 40.73524475, 40.73524475, 40.73524475, 40.73661804, 40.73661800, 40.73761700, 40.73524475, 40.73661804, 40.73524475, 40.73524475, 40.73661804, 40.73661800, 40.73524475, 40.73579500, 40.73658200, 40.73593200, 40.73544200, 40.73537100, 40.73664900, 40.73591600, 40.73546400, 40.73774000, 40.73658000, 40.73534800, ];
txLons = [-73.97712708, -73.98372200, -73.98811340, -73.98536682, -73.99154700, -73.98262024, -73.98814000, -73.97575378, -73.98811340, -73.98588200, -73.98631400, -73.98969800, -73.98811300, -73.97916800, -73.98961500, -73.99044200, -73.98763300, -73.98199600, -73.99137200, -73.98674011, -73.98811340, -73.98811340, -73.97438049, -73.98536682, -73.98124695, -73.99085999, -73.98948700, -73.98241900, -73.97575400, -73.97510000, -73.97596000, -73.97438000, -73.98758500, -73.97850037, -73.98605300, -73.98912300, -73.98879500, -73.99021500, -73.98252400, -73.99155400, -73.98229600, -73.98948700, -73.98556300, -73.99086000, -73.99223328, -73.99085999, -73.99102200, -73.98170500, -73.98237100, -73.97438000, -73.99114900, -73.97857100, -73.99116500, -73.98124695, -73.98811340, -73.98948669, -73.97987366, -73.97850037, -73.98124695, -73.98536682, -73.97872900, -73.98811340, -73.98948669, -73.98536682, -73.97438049, -73.97850037, -73.97781400, -73.98249500, -73.98399353, -73.97712708, -73.97987366, -73.97987366, -73.99085999, -73.98330700, -73.98536682, -73.99052400, -73.98757200, -73.98797900, -73.98833300, -73.98985600, -73.99056800, -73.99116700, -73.99021100, -73.99227100, -73.99095200, -73.99096700, ];
%-----------

txSites = txsite(...
    "Latitude", txLats, ...
    "Longitude", txLons, ...
    "AntennaHeight", txHeight, ...
    "TransmitterPower", 5, ...
    "TransmitterFrequency", 28e9);
%show(txSites)

%% define prop model
rtpm = propagationModel("raytracing", ...
    "Method", "image", ...
    "MaxNumReflections", 0, ... % only LOS works
    "BuildingsMaterial","concrete", ...
    "TerrainMaterial","concrete");

%% define rx

%-----------
lineNbr =  65 ;
rxNbr =  [30, 16, 26, 8, 9, 0, 18, 13, 0, 0, 15, 0, 31, 15, 12, 1, 15, 15, 14, 16, 15, 22, 15, 15, 22, 15, 22, 23, 22, 23, 23, 0, 21, 12, 5, 8, 7, 0, 8, 0, 8, 8, 0, 8, 8, 8, 8, 7, 7, 8, 0, 0, 8, 8, 8, 7, 8, 8, 7, 7, 9, 13, 0, 0, 0] ;
rxSpanDis =  [297, 161, 259, 81, 92, 0, 185, 133, 0, 0, 152, 0, 314, 152, 123, 11, 150, 154, 145, 163, 154, 217, 152, 153, 219, 151, 218, 229, 218, 227, 228, 0, 214, 116, 50, 81, 74, 0, 81, 0, 75, 79, 0, 85, 84, 82, 75, 74, 73, 76, 0, 0, 75, 75, 75, 73, 75, 79, 74, 74, 89, 133, 0, 0, 0] ;
%-----------

rxRange = table2array(readtable('data.txt'));

rxLocation = 0 : sum(rxSpanDis(1:lineNbr))/(sum(rxNbr(1:lineNbr)) - 1) : sum(rxSpanDis(1:lineNbr));
rxLats = [];
rxLons = [];
for cnt = 1 : lineNbr
    rxLats = [rxLats, rxRange(cnt, 1) : (rxRange(cnt, 3) - rxRange(cnt, 1)) / (rxNbr(cnt)-1): rxRange(cnt, 3)];
    rxLons = [rxLons, rxRange(cnt, 2) : (rxRange(cnt, 4) - rxRange(cnt, 2)) / (rxNbr(cnt)-1): rxRange(cnt, 4)];
end


% rxLats = (rxLatR(1) : (rxLatR(2) - rxLatR(1)) / (rxNbr - 1) : rxLatR(2));
% rxLons = (rxLonR(1) : (rxLonR(2) - rxLonR(1)) / (rxNbr - 1) : rxLonR(2));

rxSites = rxsite("Name","User locations", ...
    "Latitude", rxLats, ...
    "Longitude", rxLons, ...
    "AntennaHeight", rxHeight);
%show(rxSites);

%% run raytracing
rtpm.MaxNumReflections = 0;
rays = raytrace(txSites, rxSites, rtpm);
connectedRay = cell(1, sum(rxNbr(1:lineNbr)));
connectedSNR = zeros(1, sum(rxNbr(1:lineNbr)));
connectedSINR = zeros(1, sum(rxNbr(1:lineNbr)));

connectedSitesLoc = zeros(sum(rxNbr(1:lineNbr)), 2);

sPower = zeros(1, sum(rxNbr(1:lineNbr)));
iPower = zeros(1, sum(rxNbr(1:lineNbr)));
nPower = GaussianNoisePower(sigma, bandwidth);
iCount = zeros(1, sum(rxNbr(1:lineNbr)));

iPower0 = zeros(1, sum(rxNbr(1:lineNbr)));
iPower15 = zeros(1, sum(rxNbr(1:lineNbr)));
connectedSINR0 = zeros(1, sum(rxNbr(1:lineNbr)));
connectedSINR15 = zeros(1, sum(rxNbr(1:lineNbr)));

%% find nearest BS and calculate SNR
for cnt1 = 1 : sum(rxNbr(1:lineNbr))
    minDis = 9e9;
    
    for cnt2 = 1 : length(txLats)
        tempRay = rays(cnt2, cnt1);
        tempRay = tempRay{1};
        if (length(tempRay) == 1) && (tempRay.PropagationDistance < minDis)
            minDis = tempRay.PropagationDistance;
            connectedRay{cnt1} = tempRay;
        end
    end
    for cnt2 = 1 : length(txLats)
        tempRay = rays(cnt2, cnt1);
        tempRay = tempRay{1};
        if (length(tempRay) == 1) && (tempRay.PropagationDistance ~= minDis) && (tempRay.PropagationDistance < R) && (tempRay.PropagationDistance > r)
            iCount(cnt1) = iCount(cnt1) + 1;
            iPower(cnt1) = iPower(cnt1) + InterferencePower(tempRay.PropagationDistance, Nt, d_to_lambda, alpha, beta, M, Pt);
        end

        if (length(tempRay) == 1) && (tempRay.PropagationDistance ~= minDis) && (tempRay.PropagationDistance < R) && (tempRay.PropagationDistance > 0)
            iPower0(cnt1) = iPower0(cnt1) + InterferencePower(tempRay.PropagationDistance, Nt, d_to_lambda, alpha, beta, M, Pt);
        end
        if (length(tempRay) == 1) && (tempRay.PropagationDistance ~= minDis) && (tempRay.PropagationDistance < R) && (tempRay.PropagationDistance > 15)
            iPower15(cnt1) = iPower15(cnt1) + InterferencePower(tempRay.PropagationDistance, Nt, d_to_lambda, alpha, beta, M, Pt);
        end
    end
    connectedSNR(cnt1) = SNR(minDis, alpha, beta);
    sPower(cnt1) = SignalPower(minDis, Nt, alpha, beta, M, Pt);
    connectedSINR(cnt1) = 10 * log10(sPower(cnt1)/(nPower + iPower(cnt1))) + TxRxGain;
    
    connectedSINR0(cnt1) = 10 * log10(sPower(cnt1)/(nPower + iPower0(cnt1))) + TxRxGain;
    connectedSINR15(cnt1) = 10 * log10(sPower(cnt1)/(nPower + iPower15(cnt1))) + TxRxGain;
end

for cnt1 = 1 : sum(rxNbr(1:lineNbr))
    connectedSitesLoc(cnt1, 1) = connectedRay{cnt1}.TransmitterLocation(1);
    connectedSitesLoc(cnt1, 2) = connectedRay{cnt1}.TransmitterLocation(2);
    %plot(connectedRay{cnt1})
end

connectedSitesCnt = length(unique(connectedSitesLoc, 'row'));

%% plot SNR curve
%figure(1)
%hold on
%plot(rxLocation, connectedSNR, 'LineWidth', 2);
%plot(rxLocation, connectedSINR, '-.', 'LineWidth', 1.5);
%plot(rxLocation, connectedSINR15, '--', 'LineWidth', 1.5);
%plot(rxLocation, connectedSINR0, '--', 'LineWidth', 1.5);
%for cnt = 1:lineNbr
%    xline(sum(rxSpanDis(1:cnt)))
%end
%hold off
%ylabel('SNR');
%xlabel('Distance/m');
%legend('No Interference', 'With Interference, r=30', 'With Interference, r=15', 'With Interference, r=0');
% legend('Measured model', "Theoretical model");

%%
b = sum(rxNbr(1:lineNbr));
latitude = zeros(b,1);
longitude = zeros(b,1);
connectedSNR2 = zeros(b,1);

%-----------
fileID = fopen('test11.txt','w');
%-----------

for cnt = 1 : sum(rxNbr(1:lineNbr))
    fprintf(fileID,'%f %f %f %f %f %f\n', rxLats(cnt), rxLons(cnt), connectedSNR(cnt), connectedSINR(cnt), connectedSINR0(cnt), connectedSINR15(cnt));
    latitude(cnt) = rxLats(cnt);
    longitude(cnt) = rxLons(cnt);
    connectedSNR2(cnt) = connectedSNR(cnt);
end

fclose(fileID);

%% color streets

%tbl = table(latitude, longitude, connectedSNR2);
%fprintf("start: %d, %d, %d %d \n", size(latitude), size(longitude), size(connectedSNR2), size(tbl));

%pd = propagationData(tbl);

%legendTitle = "Signal" + newline + "Strength" + newline + "(dB)";

%c = jet;
%c = flipud(c);
%plot(pd, "LegendTitle", legendTitle, "Colormap", c);

%% path model
% path gain value
function pg = PG(d, alpha, beta)
    % Int-LOS result
    n = alpha;
    b = 10 * log10(beta); %dB
    %theta = 4.5; %dB
    pg = 10*n*log10(d)+b;
end

% SNR
function snr = SNR(d, alpha, beta)
    Ptx = 28; % tx power
    Gtx = 23; % tx gain
    PGmed = PG(d, alpha, beta); % path gain
    Grx = 11; % rx gain
    Pnf = -174 + 10*log10(800e6)+10; % 800 MHz bandwidth
    snr = Ptx + Gtx + PGmed + Grx - Pnf;
end

function ip = InterferencePower(d, Nt, d_to_lambda, alpha, beta, M, Pt)
    [m, v] = gamstat(M, 1/M); % mean value of rho^2
    persistent x0; 
    persistent It0;
    if isempty(x0)
        x0 = pi * Nt * d_to_lambda;
        It0 = (2 * sinint(2 * x0) + cos(2 * x0) - 1) / (x0 * x0); % average value of sin^2(x)/x^2
    elseif x0 ~= pi * Nt * d_to_lambda
        x0 = pi * Nt * d_to_lambda;
        It0 = (2 * sinint(2 * x0) + cos(2 * x0) - 1) / (x0 * x0);
    end
    ip = beta * Nt * Pt * It0 * (d^alpha) * m;
end

function np = GaussianNoisePower(sigma, bandwidth)
    np = 10^(-17.4 + log10(bandwidth) + sigma / 10);
end

function sp = SignalPower(d, Nt, alpha, beta, M, Pt)
    [m, v] = gamstat(M, 1/M); % mean value of rho^2
    sp = beta * Nt * Pt * (d^alpha) * m;
end

