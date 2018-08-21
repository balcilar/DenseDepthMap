function [out mD]=dense_depth_map(Pts,n, m,grid)
% Writtenby Muhammet Balcilar, France
% All rights reserved.

ng=2*grid+1;

linearindex = sub2ind([n m], round(Pts(:,2)), round(Pts(:,1)));

mX=inf([n m]);
mX(linearindex)=Pts(:,1)-round(Pts(:,1));
mY=inf([n m]);
mY(linearindex)=Pts(:,2)-round(Pts(:,2));
mD=zeros([n m]);
mD(linearindex)=Pts(:,3);

for i=1:ng
    for j=1:ng
        KmX{i,j}=mX(i:n-ng+i,j:m-ng+j)-grid-1+i;
        KmY{i,j}=mY(i:n-ng+i,j:m-ng+j)-grid-1+j;
        KmD{i,j}=mD(i:n-ng+i,j:m-ng+j);
    end
end

S=zeros(size(KmD{1,1}));
Y=zeros(size(KmD{1,1}));
for i=1:ng
    for j=1:ng
        s=1./sqrt(KmX{i,j}.*KmX{i,j}+KmY{i,j}.*KmY{i,j});
        Y=Y+s.*KmD{i,j};
        S=S+s;  
    end
end
S(S==0)=1;
out=zeros(n,m);
out(grid+1:end-grid,grid+1:end-grid)=Y./S;




