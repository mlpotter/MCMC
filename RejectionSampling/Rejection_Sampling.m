close all; clear all; clc;
%%
x = linspace(-9,9,1000);
h = figure('units','normalized','outerposition',[0 0 1 1]);
%% px GMM
mu1 = -2.5; sigma1=1; mu2 = 1.5; sigma2=1.1;
alpha1 = .3; alpha2 = .7;
px = @(x)(alpha1*normpdf(x,mu1,sigma1) + alpha2*normpdf(x,mu2,sigma2));
plot(x,px(x),'linewidth',2)
%% qx Gaussian
muq = 0; sigmaq = 2;
qx = @(x) normpdf(x,muq,sigmaq);
hold on
plot(x,2*qx(x),'linewidth',2')
%% rejection sampling 
N = 1000;
colors = ['r','g'];
filename = 'Rejection_Sampling.gif';

for i = 1:N
    xi = normrnd(muq,sigmaq);
    yi = 2*qx(xi)*rand(1,1);
    accept = (yi<=px(xi))+1;
    plot(xi,yi,colors(accept)+".");
    
    drawnow
    frame = getframe(h);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    if i == 1 
        imwrite(imind,cm,filename,'gif','DelayTime',0.001, 'Loopcount',inf); 
    else 
        imwrite(imind,cm,filename,'gif','DelayTime',0.001,'WriteMode','append'); 
    end 
end