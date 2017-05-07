%% -*- texinfo -*-
%% @deftypefn{Function File} {@var{C} =} pid (@var{Kp})
%% @deftypefnx{Function File} {@var{C} =} pid (@var{Kp}, @var{Ki})
%% @deftypefnx{Function File} {@var{C} =} pid (@var{Kp}, @var{Ki}, @var{Kd})
%% @deftypefnx{Function File} {@var{C} =} pid (@var{Kp}, @var{Ki}, @var{Kd}, @var{Tf})
%% Return the transfer function @var{C} of the @acronym{PID} controller
%% in parallel form with first-order roll-off.
%%
%% @example
%% @group
%%              Ki      Kd s
%% C(s) = Kp + ---- + --------
%%              s     Tf s + 1
%% @end group
%% @end example
%% @end deftypefn

%% Author: Renan Picoli <renanps123@gmail.com>
%% Created: April 2017
%% Version: 0.1
%% Script para simular a resposta em frequencia de um emissor comum com BC548A

Cp=104.2e-12;
Cu=3.2e-12;
rp=1.45e3;% para VCE=5V e Ic=4mA
hfe=180
gm=hfe/rp

RE=1.5e3
re=82
Re=RE*re/(RE+re) % Re: Re chapeu; re: resistor de ajuste de ganho

RC=1.5e3
Rin3=10e3 % resistência de entrada do estágio seguinte
Rc=RC*Rin3/(RC+Rin3)
CL=15e-12 % capacitancia de entrada do estagio seguinte, ponta de prova, trilhas

Nf=60;
fL=60
fH=4.2e6
w=logspace(log10(fL),log10(100*fH),Nf);

Av=zeros(1,Nf);
for i=1:Nf
	% ganho de tensão aproximado
	Av(i)=(-gm*Rc)/(1+Re*gm)/(1+j*w(i)*Rc*(Cu+CL));
end

subplot(2,1,1);
semilogx(w,20*log10(abs(Av)));
grid on
legend('Ganho de tensao (dB)')
xlabel('frequencia (Hz)')
ylabel('|A_v|(dB)')
subplot(2,1,2);
semilogx(w,180*angle(Av)/pi);
grid on
legend('Fase do ganho de tensao')
xlabel('frequencia(Hz)')
ylabel('angulo de A_v (�)')