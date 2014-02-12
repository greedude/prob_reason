function response_time(subName,subNo)

datafilename = strcat('..\data\',subName,'_',num2str(subNo),'.dat'); % name of data file to read
DATA = dlmread(datafilename,' ');


for i=1:4
    a =find(DATA(:,2) == i);
%     l = length(a);
    subplot(6,2,i);   
    hist(DATA(a,8));
    title(['graph ',num2str(i)]);
end

for i=5:8
    a = find(DATA(:,2) == i);    
    b =find(DATA(:,13) == 1);    
    c =find(DATA(:,13) == 5);
    
    d = intersect(a,b);
    e = intersect(a,c);
    
%     length_d = length(d);
%     length_e = length(e);
    
    subplot(6,2,2*i-5);
    hist(DATA(d,8));
    title(['graph ',num2str(i),' state: 1']);
    
    subplot(6,2,2*i-4);
    hist(DATA(e,8));
    title(['graph ',num2str(i),' state: 5']);
end
