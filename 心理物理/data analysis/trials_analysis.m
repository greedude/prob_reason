function trials_analysis(subName,subNo)

datafilename = strcat('..\data\',subName,'_',num2str(subNo),'.dat'); % name of data file to read
DATA = dlmread(datafilename,' ');

% size_data = size(DATA);

for i=5:8
    a =find(DATA(:,2) == i);
    if ~isempty(a)
    
    b = find(DATA(:,3)==1);
    c = find(DATA(:,3)==5);
    d = find(DATA(:,3)==-1);
    e = find(DATA(:,3)==-5);
    
    f = intersect(a,b);
    g = intersect(a,c);
    h = intersect(a,d);
    j = intersect(a,e);
    
    percen_one = fetch(f,DATA,a);
    percen_five = fetch(g,DATA,a);
    percen_neg_one = fetch(h,DATA,a);
    percen_neg_five = fetch(j,DATA,a);
    
    percentage_total = [percen_one percen_neg_one percen_five percen_neg_five];
    
    subplot(3,2,i-4);
    bar(percentage_total);
    axis([0 5 0 1])
    
    
     
    end
    
end

for i=5:8
    a =find(DATA(:,2) == i);
    
    
    if ~isempty(a)
        b = find(abs(DATA(:,3))==1);    % 找到所有选1分的trial    
        c = intersect(a,b);             % 找到图i里选1分的trial
        one_percentage = [0 0 0 0 0 0 0 0 0 0]; %初始化10个点的平均数
        
        for k=1:10    %外循环表示向前前进的trials数
            count = 0;  %初始化含义为1分的trials
            total = 0;  %初始化前面k个trials的数量
            for h=1:length(c)  %内循环表示该图形每一个选1分的trial。
                
                index = find(a==c(h));
                if index>k
                    total = total +1;
                    trial_num = a(index-k);
                    if DATA(trial_num,6) ==1
                        count=count+1;
                    end
                    
                end
            end
            one_percentage(11-k) = count/total;
        
        end
        
        subplot(3,2,5);
        hold on;
        color = 'rgbk';
        plot([-10 -9 -8 -7 -6 -5 -4 -3 -2 -1],one_percentage,color(i-4));
        xlabel('1分');
       
        
    end

end
hold off;

for i=5:8
    a =find(DATA(:,2) == i);   
    if ~isempty(a)
        b = find(abs(DATA(:,3))==5);        
        c = intersect(a,b);
        one_percentage = [0 0 0 0 0 0 0 0 0 0];
        
        for k=1:10
            count = 0;
            total = 0;
            for h=1:length(c)
                index = find(a==c(h));
                if index>k
                    total = total +1;
                    trial_num = a(index-k);
                    if DATA(trial_num,6) ==0
                        count=count+1;
                    end
                end
            end
            one_percentage(11-k) = count/total;
        
        end
        
        subplot(3,2,6);
        hold on;
        color = 'rgbk';
        plot([-10 -9 -8 -7 -6 -5 -4 -3 -2 -1],one_percentage,color(i-4));
        xlabel('5分');
       
        
    end

end
hold off;
end






function percentage = fetch(trials,DATA,a)
    count = 0;
    percentage = 0;
    for i=1:length(trials)
        
        k = find(a==trials(i));
        
        if k ~= length(a)
            y= DATA(a(k+1),7); 
            if y==1
                count = count + 1;
            end
            percentage = count/length(trials);

            
        end
    end
    

end

    



