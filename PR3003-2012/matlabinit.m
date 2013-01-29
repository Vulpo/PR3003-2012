function matlabinit

% -----------------------------------------------------------
%- 1 - Calcul de la solution de l'equation differentielle de 
%conditions initiales x0 pour b=1
%-------------------------------------------------------------
%Cas 1: Oscillations: a=0
%figure(1)                               
%reptraj([0;1.5],30,0,1)

%Cas 2: Point en spiral attractif: a=0.2
%figure(2)                               
%reptraj([0;1.5],100,0.2,1)

%Cas 3: Noeud attractif: a=2.2
%figure(3)                               
%reptraj([0;1.5],50,2.2,1)

%Cas 4 Spiral r�pulsif: a=-0.5
%figure(4)                               
%reptraj([0;1.5],10,-0.5,1)

%----------------------------------------------------------
%- 2 - Calcul du portrait de phase (b=1)
%----------------------------------------------------------
%Methode 1

%Cas 1: a=0
%figure(5)
[X,Y]=meshgrid([-4:0.01:4],[-4:0.01:4]);
Z=integprem(X,Y);
%contour(X,Y,Z,[-5:0.05:5] )

%xlabel('position')
%ylabel('vitesse')
%title(['Portrait de phase'])

%Methode 2

%Cas 2: a=0.2
[XX,YY]=meshgrid([-3:1.5:9],[-4:1:4]);
Z=[XX(:) YY(:)];
figure(6)
portloc(Z,30,0.2,1)
axis([-3 9 -4 4])

%Cas 3: a=2.2
%figure(7)
%Choix des valeurs initiales dans le cercle de centre O et de rayon r=1
r=1;
t=[0:0.2*pi:2*pi]';
Z=[r*cos(t) r*sin(t)];
%portloc(Z,30,2.2,1)

%cas 4:a=-0.5
%figure(8)
[XX,YY]=meshgrid([-0.1:0.05:0.1],[-0.1:0.05:0.1]);
Z=[XX(:) YY(:)];
%portloc(Z,10,-0.5,1)

%-------------------------------------------------------------
%- 3 - Diagramme de bifurcation
%-------------------------------------------------------------
%figure(9)
a=[-3:0.01:3];
b=[-3:0.01:3];
[X,Y]=meshgrid(a,b);
X=X(:);
Y=Y(:);
D=X.^2-4*Y;
S=-X;
P=Y;
%plot(X(D<0 & S>0),Y(D<0 & S>0),'.c')
%hold on
%plot(X(D<0 & S<0),Y(D<0 & S<0),'.b')
%plot(X(D>0 & P>0 & S>0),Y(D>0 & P>0 & S>0),'.m')
%plot(X(D>0 & P>0 & S<0),Y(D>0 & P>0 & S<0),'.r')
%plot(X(D>0 & P<0 ),Y(D>0 & P<0 ),'.g')
%hold off
%title('Diagramme de bifurcation')
%xlabel('a')
%ylabel('b')

%----------------------------------------------------------
%- 4 - Calcul de la p�riode (a=0;b=1)
%----------------------------------------------------------
X0=[0:0.01:10];
T=[2*pi];
for i=2:length(X0)
x0=X0(i);
[T]=[T quad(@periode,10^-6,x0-10^-6,[],[],x0)];
end
%Tapp=2*pi*(1+(X0.^2)/16);

figure(10)
%plot(X0,T,'b',X0,Tapp,'r')
plot(X0,T,'b')
xlabel('x0')
ylabel('T')
%axis([0 3.2 0 25])
title(['Periode/Amplitude'])


%-------------------------------------------------------------
%Equation du pendule
%-------------------------------------------------------------
function dxdt=pend(t,x,a,b)
dxdt=[x(2);-a*x(2)-b*sin(x(1))];

%-------------------------------------------------------------
%Repr�sentation d'une trajectoire
%-------------------------------------------------------------
function reptraj(x0,tf,a,b)
[t,x]=ode45(@pend,[0 tf],x0,[],a,b);

subplot(2,1,1)
plot(t,x,'o')
title(['Param�tres: a=' num2str(a) 'b=' num2str(b) '; Conditions initiales: x0=' num2str(x0')])

subplot(2,1,2)
plot(x(:,1),x(:,2))
xlabel('position')
ylabel('vitesse')
title('Trajectoire de phase')

%-----------------------------------------------------------
%Repr�sentation du portrait de phase local
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
%Int�grale premi�re
%-----------------------------------------------------------
function z=integprem(x,y)
%z=0.5*y.^2-cos(x);
z=0.5*y.^2 + (1/8)*x.^4 + 0.5*x.^2 - sqrt(15)*sqrt(0.25*x.^4 + 1);

%----------------------------------------------------------
%Fonction a int�grer pour la periode 
%----------------------------------------------------------
function y=periode(x,x0)
%y=(sqrt(2)*sqrt(1+x.^2))/sqrt( (1/8)*x0.^4 + x0.^2*0.5 - sqrt(3)*sqrt(x0.^4/4 + 1) - (1/8)*x.^4 - 0.5*x.^2 + sqrt(3)*sqrt(x.^4/4 + 1) );
y=(sqrt(2)*sqrt(1+x.^2))./sqrt( (x0.^4)/8 +(x0.^2)/2 -sqrt(3)*sqrt((x0.^4)/4 + 1) - (x.^4)/8 - (x.^2)/2 + sqrt(3)*sqrt((x.^4)/4 + 1) );
