function [f,X_m,X_phi] = DFT(xn,ts,N,drawflag)
% [f,X_m,X_phi] = DFT(xn,ts,N,drawflag) ��ɢ���еĿ��ٸ���Ҷ�任��ʱ��ת��ΪƵ��
% ����  xnΪ��ɢ���� Ϊ����  
%       tsΪ���еĲ���ʱ��/s
%       NΪFFT�任�ĵ�����Ĭ��Ϊxn�ĳ���  
%       drawflagΪ��ͼ��ʶλ��ȡ0ʱ����ͼ�������0ֵʱ��ͼ��Ĭ��Ϊ��ͼ
% ��� fΪƵ������
%      X_mΪ��ֵ����
%      X_phiΪ��λ��������λΪ��
% ע����������0Ƶ����(ֱ������Ӧ�ó���2)  ֱ�������ķ���Ӧ�����λͼ��ȷ��
% By ZFS@wust  2020
% ��ȡ����Matlab/Simulinkԭ�����Ϻͳ������ע΢�Ź��ںţ�Matlab Fans

if nargin == 2
    N = length(xn);
    drawflag = 1;
elseif  nargin == 3
    drawflag = 1;
end

if  isempty(N)
    N = length(xn);
end


Xk = fft(xn,N);         % FFT�任
fs = 1/ts;              % ����Ƶ�� HZ
X_m = abs(Xk)*2/N;      % ��ֵ�����任
X_phi = angle(Xk);      % ��λ
Nn = floor((N-1)/2);    % �任�����õĵ���-1
%f = (0:Nn)*fs/N ;       % ������ Ƶ��HZ
f = (0:Nn)*fs/N ;       % ����ֱ������
%X_m = X_m(1:Nn+1);      % ��ֵ(��ȡ���õ�Nn����)
X_m = X_m(2:Nn+1);      % ����ֱ������
X_phi = X_phi(1:Nn+1);  % ��λ(��ȡ���õ�Nn����)
% X_phi = unwrap(X_phi);  % ȥ����λ�ļ�ϵ�(���ڳ�ͼʱ����)
X_phi = X_phi*180/pi;   % ���ɡ㵥λ

% ֱ����������
X_m(1) = X_m(1)/2;      % ע����������0Ƶ����(ֱ������Ӧ�ó���2)

if drawflag ~= 0        
    figure
    %subplot(211)
    plot(f,X_m)
    title('Ƶ��-��ֵͼ');
    xlabel('Ƶ��/HZ');ylabel('��ֵ');
    grid on

    %subplot(212)
    %plot(f,X_phi)
    %title('DFT��Ƶ��-��λͼ');
    %xlabel('Ƶ��/HZ');ylabel('��λ/��');
    %grid on
end
