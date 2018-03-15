%%Aplication of STAND-LS:
%It illustrates, step by step, the use of STAND_LS_NCDA.m 
% by using the Standardized Precipitation Evaporation Index (SPEI)
% as drought indicator (Vicente-Serrano et al. 2010 JC), 
% but it is possible to use another.

%References
% Corzo, G. A., Van Huijgevoort, M. H. J., Voﬂ, F., & Van Lanen, H. A. J. (2011). 
% On the spatio-temporal analysis of hydrological droughts from global hydrological models. 
% Hydrology and Earth System Sciences, 
% 15(9), 2963ñ2978. http://doi.org/10.5194/hess-15-2963-2011
%
% Vicente-Serrano, S. M., Begueria, S., & Lopez-Moreno, J. I. (2010). 
% A multiscalar drought index sensitive to global warming: 
% The standardized precipitation evapotranspiration index. 
% Journal of Climate, 23(7), 1696ñ1718. http://doi.org/10.1175/2009JCLI2909.1

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
%             droughtMA: Matrix of drought (Indicator<=-1) Year x Month
%            droughtMAM: Matrix of drought area (Moderate) Year x Month
%            droughtMAS: Matrix of drought area (Severe) Year x Month
%            droughtMAE: Matrix of drought area (Extreme) Year x Month
%            droughtADD: Matrix of (A)verage (D)rought (D)uration 
%            droughtADS: Matrix of (A)verage (D)rought (S)everity 
%            droughtADI: Matrix of (A)verage (D)rought (I)ntensity
%
%            
%by Vitali Diaz
%vitalidime@gmail.com
%IHE Delft
%
% have a look at https://github.com/hydroinfo4x
% and https://www.researchgate.net/project/STAND-Spatio-Temporal-ANalysis-of-Drought
%
%updated: March 2018 
%
%%
%COLOMBIA
%%%STARTING
%Please load mask.mat and spei06.mat 

%if mask has nan
%mask0and1=mask;
%mask0and1(isnan(mask0and1))=0;
% tic;
% [ drought droughtclasses droughtA droughtMA droughtMAM droughtMAS droughtMAE droughtADD droughtADS droughtADI droughtDSI ] = STAND_LS_NCDA( spei,mask0and1 );
% toc;
% disp('ending classification');

%Classifying droughts with function!!
tic;
[ drought droughtclasses droughtA droughtMA droughtMAM droughtMAS droughtMAE droughtADD droughtADS droughtADI droughtDSI ] = STAND_LS_NCDA( spei,mask );
toc;
disp('ending classification');

% %Saving matrices
% tic;
%save('spei.mat','spei','-v7.3');
% save('drought.mat','drought','-v7.3');
% save('droughtclasses.mat','droughtclasses','-v7.3');
% save('droughtA.mat','droughtA','-v7.3');
% save('droughtMA.mat','droughtMA','-v7.3');
% save('droughtMAM.mat','droughtMAM','-v7.3');
% save('droughtMAS.mat','droughtMAS','-v7.3');
% save('droughtMAE.mat','droughtMAE','-v7.3');
% save('droughtADD.mat','droughtADD','-v7.3');
% save('droughtADS.mat','droughtADS','-v7.3');
% save('droughtADI.mat','droughtADI','-v7.3');
% save('droughtDSI.mat','droughtDSI','-v7.3');
% toc;
% disp('ending saving classification');

%%
%How it looks: Indicator
%Please load mask.mat and spei06.mat

mask(mask==0)=nan;
colormap(flipud(jet(64)));

T=length(spei);
year_ini=1901;
date=[];
xLabels={};

yr=year_ini;
mm=0;
for tt=1:T
    
    mm=mm+1;

    date(tt,1)=yr;
    date(tt,2)=mm;
    xLabels{tt}=[num2str(yr),'/',num2str(mm)];

    if mm==12
        mm=0;
        yr=yr+1;
    end
    
end
for tt=1081:1116%length(spei)
    datat=[];
    datat(:,:)=spei(:,:,tt).*mask;
    datat=transpose(datat);
    
    pcolor(datat);
    shading flat; 
    colorbar
    set(gca, 'CLim', [-3, 3]);
    
    title(['Drought Indicator [-], ',xLabels(tt)]);
    pause(0.2)
end

%%
%How it looks: drought
%Please load mask.mat and drought.mat

mask(mask==0)=nan;
colormap(jet(2));
labels={'Non-drought','Drought'};
 
T=length(drought);
year_ini=1901;
date=[];
xLabels={};

yr=year_ini;
mm=0;
for tt=1:T
    
    mm=mm+1;

    date(tt,1)=yr;
    date(tt,2)=mm;
    xLabels{tt}=[num2str(yr),'/',num2str(mm)];

    if mm==12
        mm=0;
        yr=yr+1;
    end
    
end
for tt=1081:1116%length(drought)
    datat=[];
    datat(:,:)=double(drought(:,:,tt)).*mask;
    datat=transpose(datat);
    
    pcolor(datat);
    shading flat; 
    set(gca, 'CLim', [0, 1]);
   
    colorbar('Ticks',[0,1],'TickLabels',labels)
    
    title(['Drought (1), ',xLabels(tt)]);
    pause(0.2)
end

%%
%How it looks: drought classes
%Please load mask.mat and droughtclasses.mat

mask(mask==0)=nan;

colormap(jet(4));

T=length(droughtclasses);
year_ini=1901;
date=[];
xLabels={};

yr=year_ini;
mm=0;
for tt=1:T
    
    mm=mm+1;

    date(tt,1)=yr;
    date(tt,2)=mm;
    xLabels{tt}=[num2str(yr),'/',num2str(mm)];

    if mm==12
        mm=0;
        yr=yr+1;
    end
    
end
for tt=1083:1116%length(droughtclasses)
    datat=[];
    datat(:,:)=double(droughtclasses(:,:,tt)).*mask;
    datat=transpose(datat);
    
    pcolor(datat);
    shading flat; 
    colorbar
    set(gca, 'CLim', [0, 3]);
    labels={'Non-drought','Moderate','Severe','Extreme'};
    colorbar('Ticks',[0,1,2,3],'TickLabels',labels)
    
    title(['Drought classes, ',xLabels(tt)]);
    pause(0.2)
end

%%
%How it looks: percentage of drought areas (PADs)- Area chart
%Please load mask.mat and droughtA.mat

land=nansum(mask(:));
colormap(flipud(autumn(1)));

T=length(droughtA);
year_ini=1901;
date=[];
xLabels={};

yr=year_ini;
mm=0;
for tt=1:T
    
    mm=mm+1;

    date(tt,1)=yr;
    date(tt,2)=mm;
    xLabels{tt}=[num2str(yr),'/',num2str(mm)];

    if mm==12
        mm=0;
        yr=yr+1;
    end
    
end
delta=12*8;

legend_d=area(droughtA(:,1)/land*100);
title('Percentage of drought area (PDA) derived from SPEI06');
ylabel('PDA [%]')
set(gca,'XTick',1:delta:length(date));
set(gca,'XTickLabel', xLabels(1:delta:length(date)),'Fontsize', 8);

%%
%How it looks: percentage of drought areas (PADs) per classes- Area chart
%Please load mask.mat and droughtA.mat

land=nansum(mask(:));
colormap(flipud(autumn(3)));

T=length(droughtA);
year_ini=1901;
date=[];
xLabels={};

yr=year_ini;
mm=0;
for tt=1:T
    
    mm=mm+1;

    date(tt,1)=yr;
    date(tt,2)=mm;
    xLabels{tt}=[num2str(yr),'/',num2str(mm)];

    if mm==12
        mm=0;
        yr=yr+1;
    end
    
end
delta=12*8;

legend_d=area(droughtA(:,2:4)/land*100);
title('Percentage of drought area (PDA) derived from SPEI06');
ylabel('PDA [%]')
set(gca,'XTick',1:delta:length(date));
set(gca,'XTickLabel', xLabels(1:delta:length(date)),'Fontsize', 8);

legend(legend_d,'Moderate','Severe','Extreme','Location','southoutside','Orientation','horizontal');


%%
%How it looks: percentage of drought areas (PADs)- color-coded table,
%vertical
%Please load mask.mat and droughtMA.mat
land=nansum(mask(:));
colormap(flipud(hot(32)));

T=length(droughtMA);
year_ini=1901;
date=[];
xLabels={};

yr=year_ini;
for tt=1:T
 
   yLabels{tt}=num2str(yr);
   yr=yr+1;
end

delta=8;

pad=droughtMA/land*100;

figure(1)
imagesc(pad)
colorbar
set(gca, 'CLim', [0, 100]);
title('Percentage of drought area (PDA) derived from SPEI06');
xLabels = {'J', 'F', 'M', 'A','M','J','J','A','S','O','N','D'};
set(gca,'XTick',[1,2,3,4,5,6,7,8,9,10,11,12]);
set(gca,'XTickLabel', xLabels,'Fontsize', 10);
set(gca,'YTick',1:delta:length(yLabels));
set(gca,'YTickLabel', yLabels(1:delta:length(yLabels)),'Fontsize', 10);
%%
figure(2)
boxplot(pad)
title('Percentage of drought area (PDA) derived from SPEI06');
set(gca,'XTick',[1,2,3,4,5,6,7,8,9,10,11,12]);
set(gca,'XTickLabel', xLabels,'Fontsize', 10);
ylabel('PDA [%]')
ylim([1 100])

%%
%How it looks: percentage of drought areas (PADs)- color-coded table
%horizontal
%Please load mask.mat and droughtMA.mat
land=nansum(mask(:));
colormap(flipud(hot(32)));

T=length(droughtMA);
year_ini=1901;
date=[];
xLabels={};

yr=year_ini;
for tt=1:T
 
   yLabels{tt}=num2str(yr);
   yr=yr+1;
end

delta=8;
pad=droughtMA/land*100;

figure(3)
imagesc(transpose(pad))
colorbar
set(gca, 'CLim', [0, 100]);
title('Percentage of drought area (PDA) derived from SPEI06');
xLabels = {'J', 'F', 'M', 'A','M','J','J','A','S','O','N','D'};
set(gca,'YTick',[1,2,3,4,5,6,7,8,9,10,11,12]);
set(gca,'YTickLabel', xLabels,'Fontsize', 10);
set(gca,'XTick',1:delta:length(yLabels));
set(gca,'XTickLabel', yLabels(1:delta:length(yLabels)),'Fontsize', 10);

figure(4)
boxplot(transpose(pad))
title('Percentage of drought area (PDA) derived from SPEI06');
set(gca,'XTick',1:delta:length(yLabels));
set(gca,'XTickLabel', yLabels(1:delta:length(yLabels)),'Fontsize', 10);
ylabel('PDA [%]')
ylim([1 100])

%%
%How it looks: (A)verage (D)rought (D)uration/(S)everity/(I)ntensity
%Please load mask.mat and droughtADD.mat/droughtADS/droughtADI

mask(mask==0)=nan;
colormap(flipud(autumn(12)));

duration=droughtADD.*mask;
duration=transpose(duration);

severity=droughtADS.*mask;
severity=transpose(severity);

intensity=droughtADI.*mask;
intensity=transpose(intensity);

subplot(1,3,1)
pcolor(duration);
shading flat; 
colorbar
title('Average Drought (D)uration [month]');

subplot(1,3,2)
pcolor(severity);
shading flat; 
colorbar
title('Average Drought (S)everity');

subplot(1,3,3)
pcolor(intensity);
shading flat; 
colorbar
title('Average Drought Intensity (S/D)');

