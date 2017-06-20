function [ drought droughtclasses droughtA droughtMA droughtMAM droughtMAS droughtMAE droughtADD droughtADS droughtADI ] = STAND_LS_NCDA( indicator,mask,n,nondata,tini,tfin )
%STAND_LS_NCDA performs the Non-Contiguous Drought Analysis (NCDA) 
% proposed by Corzo et al. (2011 HESS), on a monthly basis.
% Furthermore, it computes drought characteristics 
% (i.e., Duration, Severity and Intensity=D/S) from one 
% arrangement (rows x cols x time) containing drought indicator values. 

% STAND-LS stands for Spatio-Temporal ANalysis of Large-Scale Drought

%[drought droughtclasses droughtA droughtMA droughtADD droughtADS droughtADI droughtDSI] = STAND_LSD_NCDA( indicator,mask,n,nondata,tini,tfin )
%INPUTS
%               indicator: matrix of indicator values Long x Lat x time(in months)
%                    mask: mask of zone to calculate droughts
%                 nondata: indicator of non value  
%                       n: number of time steps per year, for instance monthly n=12
%                          if no value is specified then n=12
%                    tini: initial month 
%                    tfin: final month
%OUTPUTS
%               drought: matrix of drought indicated by 1   (Indicator<=-1)
%        droughtclasses: matrix of drought classes:  
%                           1:moderate, 2:severe, 3:extreme
%              droughtA: vector of area (cells) of drought  
%             droughtMA: Matrix of drought area (Indicator<=-1) Year x Month
%            droughtMAM: Matrix of drought area (Moderate) Year x Month
%            droughtMAS: Matrix of drought area (Severe) Year x Month
%            droughtMAE: Matrix of drought area (Extreme) Year x Month
%            droughtADD: Matrix of (A)verage (D)rought (D)uration 
%            droughtADS: Matrix of (A)verage (D)rought (S)everity 
%            droughtADI: Matrix of (A)verage (D)rought (I)ntensity
%            
%by Vitali Diaz
%vitalidime@gmail.com
%IHE Delft
%
% have a look at https://github.com/hydroinfo4x!
%
%updated: 2017 Feb
%

%%
% nargin=2;
% indicator=spi;
% mask=mask;

%%Drought classes
class=[-1,-1.5,-2];  %SPI, SPEI

%%Drought <=classlim
classlim=-1;  %SPI, SPEI

%STARTING
if nargin<=3

    tini=1;
    %tfin=length(indicator(1,:,:));
    [aux aux tfin]=size(indicator);

    data=[];
    data=indicator(:,:,1);
    nondata=data(1,1); 

    if nargin==1
        mask=data;
        mask(mask(:)~=nondata)=1;
        mask(mask(:)==nondata)=0;

    elseif nargin<=2
        % time to cut per year
        %n=12: months
        n=12;
    end

end 
    

%Classifying droughts!!

%Non-data

for t=tini:tfin
    data=indicator(:,:,t);
       
    %Non data
    data(data(:)==nondata)=0;
    
    %Non drought
    data(data(:)>class(1))=0;
    
    %Drought classes
    data(and(data(:)<=class(1),data(:)>class(2)))=1;
    data(and(data(:)<=class(2),data(:)>class(3)))=2;
    data(data(:)<=class(3))=3;
  
    droughtclasses(:,:,t)=int8(data(:,:));
    %droughtclasses(:,:,t)=data(:,:);
    
    %Drought events
    events=indicator(:,:,t);
    Inan=find(isnan(events));
    Ine=find(events>classlim);
    Ie=find(events<=classlim);
    events(Inan)=0;
    events(Ine)=0;
    events(Ie)=1;
    
    drought(:,:,t)=int8(events(:,:));
    %drought(:,:,t)=data(:,:);
end

%Area (#Cell) land

%Land area
%land=sum(sum(mask));

for t=tini:tfin
    
    data=drought(:,:,t);
    %Only data in mask
    data=double(data).*mask;

    %Land area on drought
    %droughtA(t)=sum(data(:))/land;
    droughtA(t,1)=sum(data(:));
    
    %(1)Moderate, (2) Severe; (3) Extreme
    data=droughtclasses(:,:,t);
    %Only data in mask
    data=double(data).*mask;
    
    droughtA(t,2)=sum(data(data(:)==1))/1;
    droughtA(t,3)=sum(data(data(:)==2))/2;
    droughtA(t,4)=sum(data(data(:)==3))/3;
    
end

%%
%Matrix year x time-step
% time to cut per year
% n=12: months, indicated before (up)

opc=1;
i=1;
j=1;
while opc;
   datay=droughtA(i:i+(n-1),1);
   droughtMA(j,:)=datay(:);
   
   datay=droughtA(i:i+(n-1),2);
   droughtMAM(j,:)=datay(:);
   
   datay=droughtA(i:i+(n-1),3);
   droughtMAS(j,:)=datay(:);
   
   datay=droughtA(i:i+(n-1),4);
   droughtMAE(j,:)=datay(:);
   i=i+n;
   j=j+1;
   if i>=length(droughtA)
       opc=0;
   end
end

%Duration and severity

data=indicator(:,:,1);

indicatorXY=[];  %Indicator per cell
droughtDSI={}; %drought (D)uration, drought (S)everity and drought (I)ntensity
droughtADD=zeros(size(data)); %average drought duration
droughtADS=zeros(size(data)); %average drought severity
droughtADI=zeros(size(data)); %average drought intensity

for i=1:length(data(:,1))
    for j=1:length(data(1,:))
                
        if mask(i,j)==1
            
            indicatorXY(1,:)=indicator(i,j,:);  %Analysis in TIME
            
            %If some vector's value is nondata then takes 0 value, which is
            %bigger than classlim (i.e., 0>-1)
            indicatorXY(indicatorXY(:)==nondata)=0; 
            
            %Inizialization
            d=0;  %duration
            s=0;  %severity

            opc=0;
            k=1;
            vectorDS=[0,0];   %Vector (D)uration, (S)everity per (i,j)
                              %This is not initialization, it's when a cell
                              %has only nan data all the time
            
            for t=1: length(indicatorXY)   %Analysis in TIME
                
                if indicatorXY(t)<=classlim
                    d=d+1;
                    s=s+indicatorXY(t);
                    opc=1;
                else
                    if opc==1
                        vectorDS(k,:)=[d,s];  %duration and severity per event
                        d=0;
                        s=0;
                        opc=0;
                        k=k+1;
                    end
                end

            end
            if opc==1 %for the last event in the data
                vectorDS(k,:)=[d,s];  %duration and severity per event
            end
            
            droughtDSI{i,j,1}=vectorDS(:,1);  %duration
            droughtDSI{i,j,2}=vectorDS(:,2);  %severity(magnitude)
            if sum(vectorDS(:,1))==0
                aux=zeros(size(vectorDS(:,1)));
                droughtDSI{i,j,3}=aux(:,1);  %intensity
            else
                droughtDSI{i,j,3}=vectorDS(:,2)./vectorDS(:,1);  %intensity
            end
        else
            droughtDSI{i,j,1}=0;
            droughtDSI{i,j,2}=0;
            droughtDSI{i,j,3}=0;
        end
        droughtADD(i,j)=mean(droughtDSI{i,j,1});
        droughtADS(i,j)=mean(droughtDSI{i,j,2});
        droughtADI(i,j)=mean(droughtDSI{i,j,3});
    end
end

end

