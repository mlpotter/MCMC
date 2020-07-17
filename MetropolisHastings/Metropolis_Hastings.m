close all; clear all; clc;
%%
sigma = [2 .5; .5 1];
mu = [2 3];

[X1,X2] = meshgrid(linspace(-2,6,50),linspace(0,6,50));
X = [X1(:) X2(:)];
p = mvnpdf(X, mu, sigma);

h = figure('units','normalized','outerposition',[0 0 1 1]);
contour(X1,X2,reshape(p,50,50));
hold on
%% proposal distribution and critic distribution
proposal = @(xi) mvnrnd(xi,eye(2),1);
critic = @(x_current,x_new) min([1 , mvnpdf(x_new,mu,sigma)/mvnpdf(x_current,mu,sigma)]);
%%
N = 100;
x_current = [0,0];
colors = ['r','g'];
filename = 'Metropolis_Hastings.gif';
hold on
for i = 1:N
    x_new = proposal(x_current);
    accept = rand(1) < critic(x_current,x_new);
    
    plot([x_current(1) x_new(1)],[x_current(2) x_new(2)],colors(accept+1))
    if ~accept
        x_new = x_current;
    end
    
    x_current = x_new;
    
    
    drawnow
    frame = getframe(h);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    if i == 1 
        imwrite(imind,cm,filename,'gif','DelayTime',0.5, 'Loopcount',inf); 
    else 
        imwrite(imind,cm,filename,'gif','DelayTime',0.5,'WriteMode','append'); 
    end 
end