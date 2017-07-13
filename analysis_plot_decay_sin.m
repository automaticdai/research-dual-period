f = 10
A = 1
phi = 0
a = 10

f = f*2*pi;
t=0:.001:0.6;
y=A*sin(f*t + phi).*exp(-a*t);

plot(t,y,'Linewidth',1.5);
%axis([0 1 -2.2 2.2]);


set(gca,'position',[0 0 1 1],'units','normalized')
axis off