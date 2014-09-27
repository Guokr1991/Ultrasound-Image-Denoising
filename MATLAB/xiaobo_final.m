clear;
%I=imread('lady.bmp');
I=dicomread('dicomfile.dcm'); 
X=double(I);
%A=25*I;
%imshow(A);
%[]���Զ�ѡ��һ���������й�һ����������ʾһ��ͼ��
%imshow(I,[]); title('ֱ�Ӵ�dicom');
info=dicominfo('dicomfile.dcm');
wincenter=info.WindowCenter;
winwidth=info.WindowWidth;
width=info.Width;
height=info.Height;
D=zeros(height,width);
for i=1:height
    for j=1:width
        if X(i,j)>(wincenter+winwidth/2)
            D(i,j)=255;
        elseif X(i,j)<(wincenter-winwidth/2)
            D(i,j)=0;
        else
            D(i,j)=(X(i,j)-(wincenter-winwidth /2))*256/winwidth;
        end;
    end;
end;
%A=(I-(wincenter-width /2))*(255 /winwidth );
%imshow(A);
disp('wincenter=');disp(wincenter);
disp('winwidth=');disp(winwidth);
disp('width=');disp(width);
disp('height=');disp(height);
figure;
imshow(uint8(D));title('ԭʼͼ��');

%load lena_mat;
%load  woman;
%colormap(pink(255)),sm=size(map,1);
%image(I);
%colormap(map);
init = 2055615866; randn('seed',init);
A = D + 20*randn(size(D));
%A=imnoise(I,'gaussian',0,0.005);
%A = imnoise(I,'localvar',V);
figure;
imshow(uint8(A));
%image(uint8(A));
%colormap(map);
title(' ����ͼ�� ');

[thr,sorh,keepapp]=ddencmp('den','wv',A);
disp('thr=');disp(thr);
xd=wdencmp('gbl',A,'sym4',2,thr,sorh,keepapp);
figure;
imshow(uint8(xd));
%image(uint8(xd));
%colormap(map);
title('HaarС�������ͼ��');

%��ͼ�����3���άС���ֽ�
[c,s]=wavedec2(A,3,'sym8');
[thr3,nkeep3]=wdcbm2(c,s,1.5,2.7*prod(s(1,:)));
disp('thr3=');disp(thr3);
disp('nkeep3=');disp(nkeep3);
[xd3,cxd,sxd,perf0,perf12]=wdencmp('lvd',c,s,'sym8',3,thr3,'s');
figure;
imshow(uint8(xd3));
title('Sym8С��ʹ�÷ֲ�����ֵ����ͼ��');

%���齵��ͼ��ͬԭͼ������
err1=norm(xd-D);
err2=norm(xd3-D);
%�����������ɷ�
per1=norm(xd)/norm(A);
per2=norm(xd3)/norm(A);
%�����ͼ��ͽ���ǰͼ�������
temp1=0;temp2=0;
for i=1:height
    for j=1:width
        temp1=temp1+A(i,j)*A(i,j);
        temp2=temp2+(A(i,j)-D(i,j))*(A(i,j)-D(i,j));
    end;
end;
SNR1=10*log10(temp1/temp2);
P1=10*log10(temp2);
PSNR1=10*log10(255*255)+10*log10(double(height*width))-P1;
temp3=0;temp4=0;
for i=1:height
    for j=1:width
        temp3=temp3+xd3(i,j)*xd3(i,j);
        temp4=temp4+(xd3(i,j)-D(i,j))*(xd3(i,j)-D(i,j));
    end;
end;
SNR2=10*log10(temp3/temp4);
P2=10*log10(temp4);
PSNR2=10*log10(255*255)+10*log10(double(height*width))-P2;

temp3=0;temp4=0;
for i=1:height
    for j=1:width
        temp3=temp3+xd(i,j)*xd(i,j);
        temp4=temp4+(xd(i,j)-D(i,j))*(xd(i,j)-D(i,j));
    end;
end;
SNR3=10*log10(temp3/temp4);
P3=10*log10(temp4);
PSNR3=10*log10(255*255)+10*log10(double(height*width))-P3;

disp('������ͼ�������');disp(SNR1);
disp('������ͼ���ֵ�����');disp(PSNR1);
disp('HaarС��ȥ���ͼ�������');disp(SNR3);
disp('HaarС��ȥ���ͼ���ֵ�����');disp(PSNR3);
disp('sym8С��ȥ���ͼ�������');disp(SNR2);
disp('sym8С��ȥ���ͼ���ֵ�����');disp(PSNR2);
disp('HaarС������ͼ��ͬԭͼ������');disp(err1);
disp('sym8С������ͼ��ͬԭͼ������');disp(err2);
disp('HaarС�������������ɷ�');disp(per1);
disp('sym8С�������������ɷ�');disp(per2);