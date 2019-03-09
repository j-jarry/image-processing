clear all;
close all;
clc;

%Img=imread('brain.bmp');
Img=imread('test.jpg');
Img=double(rgb2gray(Img));
Img=imresize(Img,0.2); % Ϊ�˼��ٳ�������ʱ�䣬��ͼ���СΪԭ����С�� 1/2

figure(1);
imshow(uint8(Img));

[ny,nx]=size(Img);%��ȡͼ���С

%%����ʼ������ΪԲ
%��ʼԲ��Բ��
c_i=floor(ny/2);
c_j=floor(nx/2);
%��ʼԲ�İ뾶
r=c_i/3;


%%��ʼ��uΪ���뺯��
u=zeros([ny,nx]);
for i=1:ny
    for j=1:nx
        u(i,j)=r-sqrt((i-c_i).^2+(j-c_j).^2);
    end
end

%%����ʼԲ�����ߵ�����ԭʼͼƬ��
figure(2);
imshow(uint8(Img));
hold on;
[c,h]=contour(u,[0 0],'r');

%%��ʼ������
epsilon=1.0;%��eaviside������������
mu=250;%������Ȩ��
dt=0.1;%ʱ�䲽��
nn=0;%���ͼ�������ʼ��

%%�������㿪ʼ
for n=1:1000
    %%�������򻯵�Heaviside����
    H_u=0.5+1/pi.*atan(u/epsilon);
    %%�ɵ�ǰu���������c1,c2
    c1=sum(sum((1-H_u).*Img))/sum(sum(1-H_u));
    c2=sum(sum(H_u.*Img))/sum(sum(H_u));
    %%�õ�ǰc1,c2����u
    delta_epsilon=1/pi*epsilon/(pi^2+epsilon^2);%delta����������
    m=dt*delta_epsilon;%��ʱ����m�洢ʱ�䲽����delta�����ĳ˻�
    %%�������ڵ��Ȩ��
    C1=1./sqrt(eps+(u(:,[2:nx,nx])-u).^2+0.25*(u([2:ny,ny],:)-u([1,1:ny-1],:)).^2);
    C2=1./sqrt(eps+(u-u(:,[1,1:nx-1])).^2+0.25*(u([2:ny,ny],[1,1:nx-1])-u([1,1:ny-1],[1,1:nx-1])).^2);
    C3=1./sqrt(eps+(u([2:ny,ny],:)-u).^2+0.25*(u([2:ny,ny],[2:nx,nx])-u([2:ny,ny],[1,1:nx-1])).^2);
    C4=1./sqrt(eps+(u-u([1,1:ny-1],:)).^2+0.25*(u([1,1:ny-1],[2:nx,nx])-u([1,1:ny-1],[1,1:nx-1])).^2);
    C=1+mu*m.*(C1+C2+C3+C4);
    u=(u+m*(mu*(C1.*u(:,[2:nx,nx])+C2.*u(:,[1,1:nx-1])+C3.*u([2:ny,ny],:)+C4.*u([1,1:ny-1],:))+(Img-c1).^2-(Img-c2).^2))./C;
    %%ÿ�������ٴ���ʾ���ߺͷ�Ƭ��������
    if mod(n,200)==0
        nn=nn+1;
        f=Img;
        f(u>0)=c1;
        f(u<0)=c2;
        figure(nn+2);
        subplot(1,2,1);imshow(uint8(f));
        subplot(1,2,2);imshow(uint8(Img));
        hold on;
        [c,h]=contour(u,[0,0],'r');
        hold off;
    end
end
