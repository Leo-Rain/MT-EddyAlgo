%%%%%%%%%
% Created: 08-Apr-2014 19:50:46
% Computer:  GLNX86
% Matlab:  7.9
% Author:  NK
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function S07_getMeanU
    %% init
        DD = initialise([],mfilename);
%           save DD
%     load DD
    %     if ~DD.switchs.netUstuff,return;end
    %% find files
    [file] = findVelFiles(DD);
    %% get dims
    [d,pos,dim] = getDims(file,DD);
    %% means
    means = getMeans(d,pos,dim,file,DD); %#ok<NASGU>
    %%
    means.d = d;
    means.pos = pos;
    means.dim = dim;
    %% save
    save([DD.path.meanU.file], 'means')
 
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [means] = gMsConstCase(file,DD,dim,d,pos)
    for kk = 1:numel(file)
        disp(['found ' file(kk).U ' and ' file(kk).V])
        %%
        traforead = @(f,fac,key)  permute(squeeze(ncread(f,key,dim.start,dim.length))/fac,[2,1]);
        
        
        
        U(:,:,kk) = traforead(file(kk).U,DD.parameters.meanUunit,DD.map.in.keys.U);
        V(:,:,kk) = traforead(file(kk).V,DD.parameters.meanUunit,DD.map.in.keys.V);
        
        
        %%
%         x = DD.map.window.dim.x;
%         y = DD.map.window.dim.y;
%         if x ~= size(U,2) || y ~= size(U,1)
%             warning('trivially resizing U/V data!!! ')
%             U = downsize(U,x,y);
%             V = downsize(V,x,y);
%         end
    end
    disp(['creating means'])
    U(U<-1e33) = nan; % missing values
    V(V<-1e33) = nan; % missing values
    means.zonal = nanmean(U,3);
    means.merid = nanmean(V,3);
    means.total = hypot(means.zonal,means.merid);
    %     means.direc = azimuth(zeros(size(means.zonal)),zeros(size(means.zonal)),means.merid,means.zonal);
    means.depth = d(pos.z.start);
    %%
  
    
    
    disp(['resizing to output size'])
    proto = load(DD.path.protoMaps.file);
    lin = proto.idx(1:numel(U(:,:,1))); % ignore overlap    
    means.small.zonal = proto.proto.nan;
    %%
    
    indextrafo = cell(size(proto.proto.nan));
    parfor cc = 1:numel(indextrafo)
        indextrafo{cc} = find((lin == cc));
    end
    means.small.indextrafo = indextrafo;
    %%
    for cc = 1:numel(indextrafo)
        if numel(indextrafo{cc}) > 0
            means.small.zonal(cc) = nanmean(means.zonal(indextrafo{cc}));
        end
    end
  
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function means = getMeans(d,pos,dim,file,DD)
    [means] = gMsConstCase(file,DD,dim,d,pos);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [d,pos,dim] = getDims(file,DD)
    dWanted = DD.parameters.meanU;
    %%
    % TODO swap
    d =  ncread(file(1).U,'w_dep');
    %      A = ncinfo(file(1).U);
    %  for
    %  d =  ncread(file(1).U,DD.map.in.keys.z);
    %
    %%
    [~,pos.z.start] = min(abs(d-dWanted));
    pos.z.start = pos.z.start; % starts at 0
    pos.z.length = 1;
    pos.x.start  = DD.map.window.limits.west;
    pos.x.length = DD.map.window.dim.x;
    pos.y.start  = DD.map.window.limits.south;
    pos.y.length = DD.map.window.dim.y;
    dim.start    = [ pos.x.start pos.y.start pos.z.start 1];
    dim.length   = [pos.x.length pos.y.length pos.z.length inf];
    
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [file] = findVelFiles(DD)
    %% find the U and V files
    ucc = 0; vcc = 0;
    file = struct;
    uvFiles = DD.path.UV.files;
    for kk = 1:numel(uvFiles)
        if ~isempty(strfind(uvFiles(kk).name,'UVEL_'))
            ucc = ucc+1;
            file(ucc).U = [DD.path.UV.name uvFiles(kk).name]; %#ok<AGROW>
        end
        if ~isempty(strfind(uvFiles(kk).name,'VVEL_'))
            vcc = vcc+1;
            file(vcc).V = [DD.path.UV.name uvFiles(kk).name]; %#ok<AGROW>
        end
    end
    if isempty(fieldnames(file))
        disp(['put U/V files into ' DD.path.UV.name])
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% function [means] = gMsFromOWcase(file,DD,dim)
%     minOWz = reshape(extractdeepfield(load([DD.path.root 'minOW.mat']),'minOW.ziIntrl'),[dim.length(3:4)]);
%     means.u = nan(size(minOWz));
%     means.v = nan(size(minOWz));
%     uniDepths = unique(minOWz(:))';
%     spmd(numel(file))
%         my.u = nan(size(minOWz));
%         my.v = nan(size(minOWz));
%         kk = labindex;
%         T = disp_progress('init','determinig mean uvs from z(min(ow(z,y,x)))');
%         for zz = uniDepths
%             T = disp_progress('ojoih',T,numel(uniDepths),10);
%             dim.start(2) = zz;
%             dim.length(2) = 1;
%             uvtmp = nc_varget(file(kk).U,DD.map.in.keys.U,dim.start,dim.length)/DD.parameters.meanUunit;
%             my.u(minOWz == zz)  =  uvtmp(minOWz == zz);
%             uvtmp = nc_varget(file(kk).V,DD.map.in.keys.V,dim.start,dim.length)/DD.parameters.meanUunit;
%             my.v(minOWz == zz)  =  uvtmp(minOWz == zz);
%         end
%         my.u = gop(@vertcat,permute(my.u,[3,1,2]),1);
%         my.v = gop(@vertcat,permute(my.v,[3,1,2]),1);
%     end
%     my = my{1};
%     dim = dim{1}; %#ok<NASGU>
%     means.u = squeeze(nanmean(my.u,1));
%     means.v = squeeze(nanmean(my.v,1));
%     %     %%
%     %     cm1 = bone;cm2 = autumn;cm3 = flipud(jet);cm4 = bone;
%     %     lat = nc_varget(file(1).U,DD.map.in.keys.lat,dim.start(3:4),dim.length(3:4));
%     %     lon = nc_varget(file(1).U,DD.map.in.keys.lon,dim.start(3:4),dim.length(3:4));
%     %     depth = nc_varget(file(1).V,'depth_t');
%     %     uvtmp = (nc_varget(file(1).U,DD.map.in.keys.U,[0 0 dim.start(3:4)],[1 inf dim.length(3:4)]) =  = 0);
%     %     [~,bath] = min(flipud(uvtmp(:,:)),[],1);
%     %     bath = reshape(flipud(bath),size(uvtmp,2),[]);
%     %     w = zeros(size(lat));  figure(3)
%     %     contour(lon,lat,minOWz,uniDepths(1:2:end));colormap(cm3);shading flat;cb = colorbar;
%     %     yt = get(cb,'ytick')
%     %     set(cb,'yticklabel',round(depth(yt)))
%     %     hold on
%     %     quiver(lon(1:20:end),lat(1:20:end),means.u(1:20:end),means.v(1:20:end),2,'color','black','linewidth',1)
%     %     dim.start(2) = 10;
%     %     utmp = nc_varget(file(1).U,DD.map.in.keys.U,dim.start,dim.length)/DD.parameters.meanUunit;
%     %     vtmp = nc_varget(file(1).V,DD.map.in.keys.V,dim.start,dim.length)/DD.parameters.meanUunit;
%     %     figure(13)
%     %     contour(lon,lat,bath,uniDepths(1:2:end));colormap(cm3);shading flat;cb = colorbar;
%     %     yt = get(cb,'ytick')
%     %     set(cb,'yticklabel',round(depth(yt)))
%     %     hold on
%     %     quiver(lon(1:20:end),lat(1:20:end),utmp(1:20:end),vtmp(1:20:end),2,'color','black')
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%