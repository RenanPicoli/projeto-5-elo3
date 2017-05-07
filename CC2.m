% simula o CC de saída por tensões nodais para prj 5
clc; close all; clear

% syms vi f
Nf=80;% nr de frequencias
vi=0.1;
fL=60;
fH=4.2e6;
f=logspace(log10(fL),log10(1.2*fH),Nf);
w=2*pi*f;

% parâmetros para -VCE=10V e IC = 9.78mA
rx=50;Gx=1/rx;
Cu=4.5e-12;
Cp=8e-12%104.2e-12;
CL=15e-12;% capacitância de ponta de prova, etc
rp=650;Gp=1/rp;
RL=1e3;
RE=470;
hfe=220;% entretanto, se a fT for de 150MHz, em 4.2MHz, hfe aprox 35
gm=-hfe/rp;%-0.155;TODO: descobrir pq precisa mudar o sinal

Habs=zeros(1,Nf);
Zin=zeros(1,Nf);
Yin=zeros(1,Nf);
Cin=zeros(1,Nf);
for i=1:Nf
    yu=j*Cu*w(i);
    yp=Gp+j*w(i)*Cp;
    ye=1/(RL*RE/(RE+RL))+j*w(i)*CL;% análogo ao Re chapeu
    % I=Y*V; V = [VA VB]'
    Y=[Gx+yu+yp -yp; -yp+gm yp+ye-gm];
    I=[vi/rx;0];
    V=inv(Y)*I;
    Zin(i)=vi*rx/(vi-V(1));%i=(vi-VA)/rx
    Habs(i)=abs(V(2)/vi);
    Yin(i)=1/Zin(i);
    Cin(i)=imag(Yin(i)/w(i));
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
figure;
semilogx(f,(1e12)*Cin);
xlabel('frequency(Hz)');
ylabel('C_{in}(pF)');
grid on