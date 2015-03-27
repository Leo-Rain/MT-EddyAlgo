% templates :
% 'udef' - user defined in INPUTuserDef.m
% 'pop' - template for POP SSH data
% 'aviso' - template for AVISO SSH data
% 'mad' - template for Madeleine's data
% 'pop2avi' -
function DD=INPUT
    %DD.template='pop2avi';
   DD.template='aviso';
%     DD.template='pop';
    %% threads / debug
    DD.threads.num = 12;
    DD.debugmode   = false;
%     DD.debugmode = true;
    DD.overwrite   = false;
    DD.overwrite = true;
    %% time
    DD.time.from.str  = '20030101'; %first pop/avi
%     DD.time.till.str  = '19990105'; %first pop/avi
    DD.time.till.str  = '20040101'; % last pop/avi
    DD.time.delta_t   = 7; % [days]!
    threshlife        = 7*4;  %7*8; % TODO
    %% window on globe (0:360° system)
    DD.map.in.west  =  40;
    DD.map.in.east  =  90;
    DD.map.in.south = -50;
    DD.map.in.north = -30;
    %% thresholds
    DD.contour.step                = 0.01; % [SI]
    DD.thresh.radius               = 0; % [SI]
    DD.thresh.maxRadiusOverRossbyL = 4; %[ ]
    DD.thresh.minRossbyRadius      = 20e3; %[SI]
    DD.thresh.amp                  = DD.contour.step; % [SI]
    DD.thresh.shape.iq             = 0.55; % isoperimetric quotient [ ]
    DD.thresh.corners.min          = 10; % min number of data points for the perimeter of an eddy[ ]
    DD.thresh.corners.max          = 500; % dangerous.. [ ]
    DD.thresh.life                 = threshlife; % min num of living days for saving [days]
    DD.thresh.ampArea              = [.25 2.5]; % allowable factor between old and new time step for amplitude and area (1/4 and 5/2 ??? chelton)
    DD.thresh.IdentityCheck        = 2; % 1: perfect fit, 2: 100% change ie factor 2 in either sigma or amp
    DD.thresh.phase                = 0.2; % max(abs(rossby phase speed)) [SI]
     %% switches

    %% 1 for I    -    0 for II
    DD.switchs.chelt = 1;

    DD.switchs.AmpAreaCheck  =  DD.switchs.chelt;
    DD.switchs.IQ            = ~DD.switchs.chelt;
    DD.switchs.IdentityCheck = ~DD.switchs.chelt;

    %% TODO
    DD.switchs.netUstuff = 0;
    DD.switchs.meanUviaOW = 0;
    DD.switchs.RossbyStuff = 1;  % TODO no choice
    DD.switchs.distlimit = 1;      % TODO no choice
    DD.switchs.maxRadiusOverRossbyL = 1;  % TODO no choice
    DD.switchs.spaciallyFilterSSH = 0;  % TODO delete
    DD.switchs.filterSSHinTime = 1;
    %%
    DD.parameters.fourierOrder = 4;
end
