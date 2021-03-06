% simula o CC por tens�es nodais
clc; close all; clear

% syms vi f
Nf=40;% nr de frequencias
vi=0.1;
fL=60;
fH=4.2e6;
f=logspace(log10(fL),log10(fH),Nf);
w=2*pi*f;

% par�metros para VCE=5V e IC = 4mA
rx=50;Gx=1/rx;
Cu=3.2e-12;
Cp=104.2e-12;
CL=15e-12;% capacit�ncia de ponta de prova, etc
rp=1.45e3;Gp=1/rp;
RL=150*15e3/(150+15e3);
RE=82;
gm=-0.155;

Habs=zeros(1,Nf);
Zin=zeros(1,Nf);
for i=1:Nf
    yu=j*Cu*w(i);
    yp=Gp+j*w(i)*Cp;
    ye=1/(RL*RE/(RE+RL))+j*w(i)*CL;% an�logo ao Re chapeu
    % I=Y*V; V = [VA VB]'
    Y=[Gx+yu+yp -yp; -yp+gm yp+ye-gm];
    I=[vi/rx;0];
    V=inv(Y)*I;
    Zin(i)=vi*rx/(vi-V(1));%i=(vi-VA)/rx
    Habs(i)=abs(V(2)/vi);
end

figure;
semilogx(f,real(Zin));
xlabel('frequency(Hz)');
ylabel('R_{in}(\Omega)');
grid on
figure;
semilogx(f,20*log10(Habs));
xlabel('frequency(Hz)');
ylabel('|H|(dB)');
grid on