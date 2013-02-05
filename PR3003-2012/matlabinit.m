function matlabinit

%----------------------------------------------------------
%- 1 - Calcul du portrait de phase sans frottements
%----------------------------------------------------------
%Methode 1 (A partir de l'Intégrale Première)
figure(1)
[X,Y]=meshgrid([-4:0.01:4],[-4:0.01:4]);
Z=integprem(X,Y);
contour(X,Y,Z,[-5:0.05:5] )
xlabel('position')
ylabel('vitesse')
title(['Portrait de phase'])

%----------------------------------------------------------
%- 1 - Calcul du portrait de phase avec frottements
%----------------------------------------------------------
%Methode 2 (local)
figure(2)
[XX,YY]=meshgrid([-3:1.5:9],[-4:1:4]);
Z=[XX(:) YY(:)];
portloc(Z,30,0.2,1)
axis([-3 9 -4 4])


%-------------------------------------------------------------
%- 3 - Diagramme de bifurcation
%-------------------------------------------------------------
figure(3)
a=[2*sqrt(2):0.01:sqrt(15)]; %l_0
b=[1:1:3]; %Gamma
Peq=sqrt( -1+sqrt(1+a.^2)-sqrt(-2-2*sqrt(1+a.^2)+a.^2) );
df2dx=-(Peq.^2+1)/((1+Peq.^2).*(1+(Peq.^4)/4));
[X,Y]=meshgrid(a,b);
X=X(:);
Y=Y(:);
D=b.*b+4.*df2dx;
S=b;
P=0;
plot(X(D<0 & S>0),Y(D<0 & S>0),'.c')
hold on
plot(X(D<0 & S<0),Y(D<0 & S<0),'.b')
plot(X(D>0 & P>0 & S>0),Y(D>0 & P>0 & S>0),'.m')
plot(X(D>0 & P>0 & S<0),Y(D>0 & P>0 & S<0),'.r')
plot(X(D>0 & P<0 ),Y(D>0 & P<0 ),'.g')
hold off
title('Diagramme de bifurcation')
xlabel('a')
ylabel('b')



%----------------------------------------------------------
%- 4 - Calcul de la periode (a=0;b=1)
%----------------------------------------------------------
figure(4)
X0=[0:0.01:10];
T=[2*pi];
for i=2:length(X0)
x0=X0(i);
[T]=[T quad(@periode,10^-6,x0-10^-6,[],[],x0)];
end
plot(X0,T,'b')
xlabel('x0')
ylabel('T')
title(['Periode/Amplitude'])


%-------------------------------------------------------------
%Equation du pendule
%-------------------------------------------------------------
function dxdt=pend(t,x,a,b)
dxdt=[x(2);-a*x(2)-b*sin(x(1))];


%-----------------------------------------------------------
%Representation du portrait de phase local
%-----------------------------------------------------------
function portloc(Z,tf,a,b)
for i=1:size(Z,1)
[t,x]=ode45(@pend,[0 tf],Z(i,:),[],a,b);
plot(x(:,1),x(:,2))
hold on
xlabel('position')
ylabel('vitesse')
title(['Portrait de phase'])
end
hold off

%-----------------------------------------------------------
%Integrale premiere
%-----------------------------------------------------------
function z=integprem(x,y)
z=0.5*y.^2 + (1/8)*x.^4 + 0.5*x.^2 - sqrt(15)*sqrt(0.25*x.^4 + 1);

%----------------------------------------------------------
%Fonction a integrer pour la periode 
%----------------------------------------------------------
function y=periode(x,x0)
y=(sqrt(2)*sqrt(1+x.^2))./sqrt( (x0.^4)/8 +(x0.^2)/2 -sqrt(3)*sqrt((x0.^4)/4 + 1) - (x.^4)/8 - (x.^2)/2 + sqrt(3)*sqrt((x.^4)/4 + 1) );


