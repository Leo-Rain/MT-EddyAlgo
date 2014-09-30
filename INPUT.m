
function DD=INPUT
    DD.template='mad';
    %% threads / debug
    DD.threads.num=12;
    DD.debugmode=false;
%  DD.debugmode=true;
     DD.overwrite=false;
   DD.overwrite=true;      
    %% time
    threshlife=3*3;
    DD.time.from.str='19091231';
    DD.time.till.str='19160724';
   %% window on globe
    DD.map.in.west=0;
    DD.map.in.east= 28;
    DD.map.in.south= 10;
    DD.map.in.north= 47;
    %% output map res
    DD.map.out.X=28*1+1; % TODO
    DD.map.out.Y=37*1+1;
    %% thresholds
    DD.contour.step=0.01; % [SI]
    DD.thresh.radius=0; % [SI]
    DD.thresh.maxRadiusOverRossbyL=4; %!
    DD.thresh.amp=0.01; % [SI]
    DD.thresh.shape.iq=0.55; % isoperimetric quotient
    DD.thresh.shape.chelt=0.2; % (diameter of circle with equal area)/(maximum distance between nodes) (if ~switch.IQ)
    DD.thresh.corners.min=8; % min number of data points for the perimeter of an eddy
     %% DANGEROUS !
    DD.thresh.corners.max=1e42; % at dx ~1e-4 -> skip eddies(radius> ~1000km) , just for performance
    DD.thresh.life=threshlife; % min num of living days for saving
    DD.thresh.ampArea=[.25 2.5]; % allowable factor between old and new time step for amplitude and area (1/4 and 5/1 ??? chelton)
    DD.thresh.IdentityCheck=[2];
    %% switches
    DD.switchs.IQ=1;
    DD.switchs.chelt=0;
    DD.switchs.RossbyStuff=1;
    DD.switchs.distlimit=0;
    DD.switchs.AmpAreaCheck=0;
    DD.switchs.netUstuff=0;
    DD.switchs.meanUviaOW=0;
    DD.switchs.IdentityCheck=0;
    DD.switchs.maxRadiusOverRossbyL=0;
    DD.switchs.spaciallyFilterSSH=0;
    DD.switchs.filterSSHinTime=1;
end
