function Ig=gauss(I,window,sigma)

%%���� guass() ʵ�� guassian ƽ���˲�
%%����˵��
%%I         --- ��ƽ������
%%window    --- gaussian �˴�С(����)
%%simga     --- gaussian ����
%%Ig        --- ���� guassian ƽ�����ͼ��

[ny,nx]=size(I);

half_window=(window-1)/2;%����ȡ����

if ny<half_window
    x=(-half_window:half_window);
    filter=exp(-x.^2/(2*sigma));%һά guassian ����
    filter=filter/sum(filter);%��һ��
    %%ͼ����չ
    xL=mean(I(:,[1:half_window]));
    xR=mean(I(:,[nx-half_window+1,nx]));
    I=[xL*ones(ny,half_window) I xR*ones(ny,half_window)];
        %��չ�� nx + window -1 ��
    Ig=conv(I,filter);
        %�γ� (nx + window -1) + (window) -1 = nx + 2 (window-1) ��
    Ig=Ig(:,window+half_window+1:nx+window+half_window);
        %��һ�����Ҫȫ����ԭͼ�������, �Ӷ�
        %����е� l ���õ�ͼ��������Сֵ = l-windows
        % >=(windows-1)/2+1 = ԭͼ������չͼ���е�λ��
else
    %%��ά���
    x=ones(window,1)*(-half_window:half_window);%������
    y=x';%������
    
    filter=exp(-(x.^2+y.^2/(2*sigma)));%��ά guassian ����
    filter=filter/(sum(sum(filter)));%��һ��
    
    %%ͼ����չ
    if (half_window>1)
        xLeft=mean(I(:,[1:half_window])')';
        %matlab �Ƕ���ȡƽ���ģ�����������
        xRight=mean(I(:,[nx-half_window+1:nx])')';
    else
        xLeft=I(:,1);
        xRight=I(:,nx);
    end
    
    I=[xLeft*ones(1,half_window),I,xRight*ones(1,half_window)];
    
    if (half_window>1)
        xUp=mean(I([1:half_window],:));
        xDown=mean(I([ny-half_window+1,ny],:));
    else
        xUp=I(1,:);
        xDown=I(ny,:);
    end
    
    I=[ones(half_window,1)*xUp;I;ones(half_window,1)*xDown];
    
    Ig=conv2(I,filter,'valid');
    
end