close all;
clear all;
clc;

%I=imread('Jingse.jpg');
I=imread('test.jpg');

I=imresize(I,0.2);
I=rgb2gray(I);

figure(1);
subplot(1,2,1);imshow(I);title('ԭͼ��');
subplot(1,2,2);imhist(I);title('ֱ��ͼ');

J=ones(size(I));
J(I<150)=0;% ���ϳ�����ֵ
figure(2);imshow(J);title('��ˮ�� (watershed) �㷨');
