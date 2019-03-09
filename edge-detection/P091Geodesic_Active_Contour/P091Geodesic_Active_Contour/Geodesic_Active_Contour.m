clear all;
close all;
clc;

N=2000; % ������������
D=50; % ÿ D �����ͼ�񣬲����¶� U ��ʼ��
dt=0.01; % ʱ�䲽��
c=3; % �����˶���
K=5; % �����


%% ����ͼ��
%I=imread('BanShou.bmp');
I=imread('test.jpg');
I=double(rgb2gray(I));
I=imresize(I,0.2); % Ϊ�˼��ٳ�������ʱ�䣬��ͼ���СΪԭ����С�� 1/2
figure(1);imshow(uint8(I));title('ԭʼͼ��');
[ny,nx]=size(I);

%% ���ó�ʼ����ΪԲ�Σ�Բ��Ϊ ci,cj, �뾶Ϊ r
ci=ny/2;
cj=nx/2;
%r=ci-1;
r=cj-1;

%% ��ʼ�����뺯��
U=zeros([ny,nx]);
for i=1:ny
    for j=1:nx
        U(i,j)=sqrt((i-ci).^2+(j-cj).^2)-r;
    end
end

%% ����ʼԲ�����ߵ�����ԭʼͼ����
figure(2);imshow(uint8(I));
hold on;
[d,h]=contour(U,[0 0],'r');
hold off;

%% Ԥƽ������
J=gauss(I,3,2);
%% ͼ���ݶ�
Jx=(J(:,[2:end,end])-J(:,[1,1:end-1]))/2;
Jy=(J([2:end,end],:)-J([1,1:end-1],:))/2;
gradient=sqrt(Jx.^2+Jy.^2);
    
for n=1:N
    %% ��Ե����
    g=1./(1+(gradient/K).^2);
    
    %% ��ǰ�����
    Ux_back=U-U(:,[1,1:end-1]);
    Ux_forward=U(:,[2:end,end])-U;
    Uy_back=U-U([1,1:end-1],:);
    Uy_forward=U([2:end,end],:)-U;

    %% ���������˶���
    curv=c*g.*sqrt(min(Ux_back,0).^2+max(Ux_forward,0).^2+...
                    min(Uy_back,0).^2+max(Uy_forward,0).^2);
               
    %% ����ɢ����
    divg=...
        (g+g(:,[2:end,end]))/2.*...
        Ux_forward./sqrt(Ux_forward.^2+...
            ((U([2:end,end],[2:end,end])+U([2:end,end],:))-...
            (U([1,1:end-1],[2:end,end])+U([1,1:end-1],:))).^2/16+eps)-...
        (g+g(:,[1,1:end-1]))/2.*...
        Ux_back./sqrt(Ux_back.^2+...
            ((U([2:end,end],:)+U([2:end,end],[1,1:end-1]))-...
            (U([1,1:end-1],:)+U([1,1:end-1],[1,1:end-1]))).^2/16+eps)+...
        ((g+g([2:end,end],:))/2).*...
         Uy_forward./sqrt(Uy_forward.^2+...
         ((U([2:end,end],[2:end,end])+U(:,[2:end,end]))-...
         (U([2:end,end],[1,1:end-1])+U(:,[1,1:end-1]))).^2/16+eps)-...
        ((g+g([1,1:end-1],:))/2).*...
         Uy_back./sqrt(Uy_back.^2+...
         ((U(:,[2:end,end])+U([1,1:end-1],[2:end,end]))-...
        (U(:,[1,1:end-1])+U([1,1:end-1],[1,1:end-1]))).^2/16+eps);
    
    %% ӭ���ʽ
    upwind=max(divg,0).*sqrt(...
                    min(Ux_back,0).^2+max(Ux_forward,0).^2+...
                    min(Uy_back,0).^2+max(Uy_forward,0).^2)+...
           min(divg,0).*sqrt(...
                    max(Ux_back,0).^2+min(Ux_forward,0).^2+...
                    max(Uy_back,0).^2+min(Uy_forward,0).^2);
                  
     %% ���¾��뺯��
     U=U+dt*(curv+upwind);
     
     %% ��ʾ��ǰ���ߺ�ԭͼ��
     if mod(n,D)==0
        %% Ϊ�����ۼ����� U �������³�ʼ��
        I_new=createimage(J,U);
        figure(3);imshow(uint8(I_new));
        n % �����ǰ�������������㿴����ʱ��
     end
end

