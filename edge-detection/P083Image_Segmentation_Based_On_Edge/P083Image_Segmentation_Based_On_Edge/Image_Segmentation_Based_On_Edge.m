I=imread('test.jpg');
I=rgb2gray(I);

[ny,nx]=size(I);


%% ���������Ե
J=zeros(ny+2,nx+2);
J([2:end-1],[2:end-1])=I;

J(1,[2:end-1])=I(2,[1:end]);
J(end,[2:end-1])=I(end-1,[1:end]);

J(:,1)=J(:,3);
J(:,end)=J(:,end-2);

%% Sobel ����
Ix=J([1:ny],[3:nx+2])-J([1:ny],[1:nx])...
    +2*(J([2:ny+1],[3:nx+2])-J([2:ny+1],[1:nx]))...
    +(J([3:ny+2],[3:nx+2])-J([3:ny+2],[1:nx]));
Iy=J([3:ny+2],[1:nx])-J([1:ny],[1:nx])...
    +2*(J([3:ny+2],[2:nx+1])-J([1:ny],[2:nx+1]))...
    +J([3:ny+2],[3:nx+2])-J([1:ny],[3:nx+2]);

%% ���ݶȵ�ƽ��
gradient=floor(sqrt(Ix.^2+Iy.^2));

%% ���ݶȽ�����ֵ����
figure(1);
subplot(2,2,1);imshow(I);title('ԭͼ��');
tmp=floor(gradient/8);
subplot(2,2,2);imshow(uint8(tmp));title('�ݶ�ģֵͼ');
tmp1=ones(ny,nx);
tmp1(tmp<5)=0;
subplot(2,2,3);imshow(tmp1);title('�� T = 20 Ϊ��ֵ');
tmp2=ones(ny,nx);
tmp2(tmp<20)=0;
subplot(2,2,4);imshow(tmp2);title('�� T = 50 Ϊ��ֵ');

