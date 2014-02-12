function data_analysis(subName,subNo)

datafilename = strcat('..\data\',subName,'_',num2str(subNo),'.dat'); % name of data file to read
DATA = dlmread(datafilename,' ');

size_data = size(DATA);

for i=1:8
    a =find(DATA(:,2) == i);
    if ~isempty(a)
    
    b = find(DATA(:,3)>0);
    c = find(DATA(:,3)<0);
    
    d = intersect(a,b);
    e = intersect(a,c);
    
    l = length(a);
    change =[];
    
    for x=1:l-1
        if DATA(a(x),13)*DATA(a(x+1),13)==5
        	change(x) = a(x+1);
        end
    end
    change=change(change~=0);

    
    subplot(8,1,i);
    percentage = DATA(a(l),9)/DATA(a(l),10);
    actual_accuracy = DATA(a(l),12);

    plot(DATA(d,1),DATA(d,3),'c.');
    
    hold on;
    plot(DATA(e,1),abs(DATA(e,3)),'r.');
    
    hold off;
   
    axis([ 1 size_data(1) 0 8 ]);
    if i==3 || i==4 ||i==7 || i==8
        title(['graph  ',num2str(i),' percentage:  ',num2str(percentage),' accuracy ',num2str(actual_accuracy)]);
    else 
        title(['graph  ',num2str(i),' percentage:  ',num2str(percentage)]);
    end

    if change ~=0 
        if i==5 || i==6 || i==7 || i==8
         vline(change);
        end
    end
    else 
        subplot(8,1,i);
        plot(0,0);
    
  
        title(['graph  ',num2str(i),' NO DATA']);
        axis([0 size_data(1) 0 8]);
    
    end
    
end



