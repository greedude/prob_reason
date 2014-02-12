function volatile_analysis(subName,subNo)
datafilename = strcat('..\data\',subName,'_',num2str(subNo),'.dat'); % name of data file to read
DATA = dlmread(datafilename,' ');
size_data = size(DATA);


for i=5:8
    a =find(DATA(:,2) == i);
    
    l = length(a);
    change =[];
    
    %var change records the trial number when the volatile happens
    for x=1:l-1
        if DATA(a(x),13)*DATA(a(x+1),13)==5
        	change(x) = a(x+1);
        end
    end
    change=change(change~=0);
    if ~isempty(change)
    first_volatile = change(1);
    gap = 2;
    % var one2five stores the trials number when the state changes from 1 to 5
    % var five2one do the same, recording from 5 to 1 
    if DATA(first_volatile,5)==1        
        one2five = change(2:gap:end) ;
        five2one = change(1:gap:end);
    else        
        one2five = change(1:gap:end) ;
        five2one = change(2:gap:end);
    end
    
    % h is the index of one2five in a
    % j is the index of five2one in a
    [foo h] = intersect(a,one2five);
    [foo j] = intersect(a,five2one);
    [foo k] = intersect(a,change);
    
    
    length_change =change(1);
    for ic =1:length(change)-1
        length_change(end+1) = change(ic+1)-change(ic);
    end
   
    right_count = [];
     length_k = k(1);
     
     x = [-10 -5 5 10];
    
    if ~isempty(h) 
    subplot(4,2,2*(i-4)-1);
    
    % 前面5个的右键百分比 
     start = 1;
     stop = 5;
    %get_data is a function which get the wanted data near the changing state.
    [right_count,right_percentage,err2] = get_data(DATA,a,h,k,right_count,start,stop);
    
    start = 6;
     stop = 10;
    %get_data is a function which get the wanted data near the changing state.
    [right_count,right_percentage1,err1] = get_data(DATA,a,h,k,right_count,start,stop);
    
    %后面五个的右键百分比
     start = -4;
     stop = 0;
    [left_count,left_percentage,err3] = get_data(DATA,a,h,k,right_count,start,stop);
    
    start = -9;
     stop = -5;
    [left_count,left_percentage2,err4] = get_data(DATA,a,h,k,right_count,start,stop);
    
    
    y = [right_percentage1 right_percentage left_percentage  left_percentage2];
    err =[err1 err3 err2 err4];
    barwitherr(err,x,y);
    
 
    axis([-15 15 0 1]);
    vline(0);
    title(['graph  ',num2str(i),' state:1->5']);
    end
    
    if ~isempty(j)
    subplot(4,2,2*(i-4));
    % 前面5个的右键百分比 
     start = 1;
     stop = 5;
    %get_data is a function which get the wanted data near the changing state.
    [right_count,right_percentage,err1] = get_data(DATA,a,j,k,right_count,start,stop);
    
    start = 6;
     stop = 10;
    %get_data is a function which get the wanted data near the changing state.
    [right_count,right_percentage1,err2] = get_data(DATA,a,j,k,right_count,start,stop);
    
    %后面五个的右键百分比
     start = -4;
     stop = 0;
    [left_count,left_percentage,err3] = get_data(DATA,a,j,k,right_count,start,stop);
    
    start = -9;
     stop = -5;
    [left_count,left_percentage2,err4] = get_data(DATA,a,j,k,right_count,start,stop);
    
    
    y = [right_percentage left_percentage right_percentage1 left_percentage2];
    err =[err1 err2 err3 err4];
    barwitherr(err,x,y);
    axis([-15 15 0 1]);
    vline(0);
    title(['graph  ',num2str(i),' state: 5->1']);
    
    end
    end
    
end



