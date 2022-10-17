function [h] = otppb_effic_error(scale,N)

if(nargin<1)
    scale = 0.1;
end

if(nargin<2)
    N = 100;
end
    
r = [1.0, 0.5, 0.4, 0.1, 0.4, 0.0, 0.0, 0.0; ...
     0.5, 1.0, 0.9, 0.3, 0.1, 0.4, 0.0, 0.0; ...
     0.4, 0.9, 1.0, 0.3, 0.0, .45, 0.0, 0.3; ...
     0.1, 0.3, 0.3, 1.0, 0.0, 0.0, 0.2, 0.0; ...
     0.4, 0.1, 0.0, 0.0, 1.0, .25, .05, 0.0; ...
     0.0, 0.4, .45, 0.0, .25, 1.0, .45, .65; ...
     0.0, 0.0, 0.0, 0.2, .05, .45, 1.0, .25; ...
     0.0, 0.0, 0.3, 0.0, 0.0, .65, .25, 1.0];
 
m = [1.5, 3.5, 4.0, 3.2, 5.0, 6.5, 7.5, 8.3]/100;
s = [3.5, 9.0, 11.5, 10.0, 9.0, 18.5, 21.0, 30.0]/100;
c = (s'*s).*r;

errorradius=scale*norm(m);

randmu1=zeros(N,8);
for j=1:N
    
    uniform = scale*(2*rand(size(m)) - 1).*s;
    randmu1(j,:)=m+uniform;
end

effportrisk=zeros(20,N);
effportreturn=zeros(20,N);
AssetBounds=[0,0,0,0,0,0.2,0,0;
            1,1,1,0.15,0.1,1,0.2,0.2];
for i=1:N
    [effportrisk(:,i),effportreturn(:,i)]=frontcon(randmu1(i,:),c,20,[],AssetBounds);
end 

plotsig =effportrisk(:);
plotmu  =effportreturn(:);


[effrisk,effreturn]=frontcon(m,c,20,[],AssetBounds);

h = figure;
[cloud] = plot(plotsig,plotmu,'C.');
hold on;
[hline] = plot(effrisk,effreturn,'-');
hold off;

%% Adjust line styles
set(hline,'LineWidth',2);
set(hline,'Color',[0 0 0]);

%set(hline,'LineWidth',2);
set(cloud,'Color',2*[0.4 0.4 0.4]);


%% Title
title('Efficient Frontier Distribution','FontSize',14);


%% Axes Labels
xlabel('\sigma_V','FontSize',16);
ylabel('\mu_V','FontSize',16);


%% Fix Axes
ha = get(h,'CurrentAxes');
set(ha,'FontSize',16);
set(ha,'XMinorTick','on');
set(ha,'YMinorTick','on');
