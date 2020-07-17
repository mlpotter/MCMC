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
%%
rho = sigma(1,2)/(sqrt(sigma(1,1))*sqrt(sigma(2,2)));
x1givenx2 = @(x2) normrnd(mu(1) + sigma(1,1)*rho*(x2-mu(2))/sigma(2,2),sqrt(sigma(1,1)^2 * (1-rho^2)));
x2givenx1 = @(x1) normrnd(mu(2) + sigma(2,2)*rho*(x1-mu(1))/sigma(1,1),sqrt(sigma(2,2)^2*(1-rho^2)));
%%
N = 80;
x = [0,0];
filename = 'Gibbs_Sampling.gif';

for i = 1:N
    for k = 1:length(mu)
        x_prev = x;
        x(1) = x1givenx2(x(2));
        plot([x_prev(1) x(1)],[x_prev(2) x_prev(2)],'r-')
        pointer = plot(x(1),x(2),'g*');
        
        drawnow
        frame = getframe(h);
        im = frame2im(frame);
        [imind,cm] = rgb2ind(im,256);
        if i == 1 
            imwrite(imind,cm,filename,'gif','DelayTime',0.5, 'Loopcount',inf); 
        else 
            imwrite(imind,cm,filename,'gif','DelayTime',0.5,'WriteMode','append'); 
        end 
        
        x(2) = x2givenx1(x(1));
        plot([x(1) x(1)],[x_prev(2) x(2)],'r-')
        delete(pointer)
        pointer = plot(x(1),x(2),'g*');
        
        drawnow
        frame = getframe(h);
        im = frame2im(frame);
        [imind,cm] = rgb2ind(im,256);
        if i == 1 
            imwrite(imind,cm,filename,'gif','DelayTime',0.5, 'Loopcount',inf); 
        else 
            imwrite(imind,cm,filename,'gif','DelayTime',0.5,'WriteMode','append'); 
        end 
        
        delete(pointer)
    end
end
