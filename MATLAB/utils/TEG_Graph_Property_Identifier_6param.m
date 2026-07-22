%% Identifying Properties 
function [TEG_R, TEG_K, TEG_alpha, TEG_MA, TEG_MAtime, TEG_Ly30] = TEG_Graph_Property_Identifier_6param(T,Y_input,type)
% type = 1: this is used to find the experimental TEG parameters
% type = 2: this is TEG paramter estimations using simulated TEG profiles
Y_TEG=Y_input/2;

% R-time : Time to start forming clot, reach 2mm (5-10 minutes)
% data_id=find(abs(Y_TEG-2)<.2,1);
data_id = find(Y_TEG>=2, 1, 'first');
if isempty(data_id)==1
    data_id=find(abs(Y_TEG-2)<.5,1);
end
tegR_id=data_id;
TEG_R=T(data_id);

% K time : time to reach a certain strength, after R time, from 2 to 20 mm amplitude (1-3 minutes)
data_id=find(abs(Y_TEG-20)<1,1);
if isempty(data_id)==1
    data_id=find(abs(Y_TEG-20)<2,1);
end
time_20mm=T(data_id);
TEG_K=time_20mm-TEG_R;

% Alpha angle : speed of fibrin accumulation (53-72 degrees)
dydx = gradient(Y_TEG(:)) ./ gradient(T(:));
dydx2 = gradient(dydx(:)) ./ gradient(T(:)); 
smDyDx=smoothdata(smoothdata(dydx2));
aa=find(abs(smDyDx)<0.5);
[~,bb]=min(smDyDx);
data_id=aa(find(aa>bb,1));
TEG_alpha=abs(atand(dydx(data_id)));
% [~,data_id]=max(dydx);
% TEG_alpha= atand((Y_TEG(data_id)-Y_TEG(tegR_id))/(T(data_id)-TEG_R));

% Maximum amplitude : Highest vertical amplitude of TEG (50-70 mm) - clot
% strength 
if type==1
%Method 1
    [TEG_MA1,data_id]=max(Y_TEG);
    TEG_MAtime1= T(data_id) ;
    tegMA_id1=data_id;
    TEG_MA=TEG_MA1;
    TEG_MAtime=TEG_MAtime1;
    tegMA_id=tegMA_id1;

elseif type==2
%Method 2
    aa=find(abs(dydx)<0.02);
    [~,bb]=max(dydx);
    data_id=aa(find(aa>bb,1));
    TEG_MA2=Y_TEG(data_id);
    TEG_MAtime2=T(data_id);
    tegMA_id2=data_id;
    TEG_MA=TEG_MA2;
    TEG_MAtime=TEG_MAtime2;
    tegMA_id=tegMA_id2;
end

% TEG_MA=(TEG_MA1+TEG_MA2)/2;
% TEG_MAtime=(TEG_MAtime1+TEG_MAtime2)/2;
% tegMA_id=floor((tegMA_id1+tegMA_id2)/2);

% Ly30 : Lysis at 30 minute, percentage of amplitude reduction 30 min after
% MA (0-8%) - Clot stability 
% method 1 amplitude 
% A30=Y_TEG(data_id+360);
% Ly30_method1=(TEG_MA-A30)/TEG_MA*100;

%Method 2 Area Under the Curve : Valid 
if tegMA_id+360<=length(T)
    AUC30=trapz(T(tegMA_id:tegMA_id+360),Y_TEG(tegMA_id:tegMA_id+360));
else
    c1=polyfit(T(tegMA_id:end),Y_TEG(tegMA_id:end),1);
    y1 = polyval(c1,T(tegMA_id)+30);
    AUC30=trapz([T(tegMA_id:end);T(tegMA_id)+30],[Y_TEG(tegMA_id:end);y1]);
end
AUC_MA=30*TEG_MA;
Ly30_method2=(AUC_MA-AUC30)/AUC_MA*100;
TEG_Ly30=Ly30_method2;
if isempty(TEG_R)
    TEG_R = -1;
end
if isempty(TEG_K)
    TEG_K = -1;
end
if isempty(TEG_alpha)
    TEG_alpha = -1;
end
if isempty(TEG_MA)
    TEG_MA = -1;
end
if isempty(TEG_MAtime)
    TEG_MAtime = -1;
end
if isempty(TEG_Ly30)
    TEG_Ly30 = -1;
end

% All data
% TEG_Graph_parameters=[TEG_R, TEG_K, TEG_alpha, TEG_MA, TEG_MAtime, TEG_Ly30]; %TEG_MAtime1 TEG_MAtime2
return