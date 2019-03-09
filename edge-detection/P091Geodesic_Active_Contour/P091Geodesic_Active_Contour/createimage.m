function I_out=createimage(I_in,U)

%%���� createimage() ʵ�ֵ�ǰˮƽ����ԭͼ���ϵ���ʾ
%%����˵��
%%I_in   --- ԭʼͼ��
%%U      --- ��ǰ��ˮƽ������
%%I_out  --- ���ص�ǰ��ˮƽ�� (��ɫ����) ������ԭͼ���ϵ�ͼ��

[ny,nx]=size(I_in);
curvindex=zeros(5*ny*nx,2); % �洢 U ����ˮƽ�����ߵ�����
curvImg=zeros([ny,nx]);  % �洢 U ��������ϵ���ɫ��ǣ���ɫΪ (255��0��0)
num=0; % U ����ˮƽ�����ߵĵ�ĸ�����ʼ��
for i=2:ny-1
    for j=2:nx-1
        if (U(i,j)<0) & (U(i+1,j)>0 | U(i-1,j)>0 | U(i,j+1)>0 | U(i,j-1)>0) 
            % ������Կ��� �洢 U ����ˮƽ�����ߵ��������
            % ���Ϊ 5*ny*nx                    
            num=num+1;
            curvindex(num,1)=i;
            curvindex(num,2)=j;
            curvImg(i,j)=255;
        end
    end
end
            
%% ��ԭͼ����ʾ��ǰˮƽ��
tmp=I_in;
tmp(curvImg>0)=255;
I_tmp(:,:,1)=tmp;
tmp(curvImg>0)=0;
I_tmp(:,:,2)=tmp;
I_tmp(:,:,3)=tmp;
I_out=uint8(I_tmp);
    
%% �� U �������³�ʼ��Ϊ���뺯��
U_new=zeros([ny,nx]);
dist=zeros([1,num]);
for i=1:ny
    for j=1:nx
        for k=1:num
            dist(k)=sqrt((i-curvindex(k,1)).^2+(j-curvindex(k,2)).^2);
        end
        U_new(i,j)=min(dist); %% ���³�ʼ�� U Ϊ���뺯��
        if U(i,j)<0
            U_new(i,j)=-U_new(i,j); %% ��Ȼ������ľ��뺯��
        end
    end
end
U=U_new;