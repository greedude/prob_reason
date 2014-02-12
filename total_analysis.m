function total_analysis(subName,subNo)

datafilename = strcat(subName,'_',num2str(subNo),'.dat'); % name of data file to read
DATA = dlmread(datafilename,' ');
    
    
    
        b = find(abs(DATA(:,3))==1);    % 找到所有选1分的trial    
        one_percentage = [0 0 0 0 0 0 0 0 0 0]; %初始化10个点的平均数
        
        for k=1:10    %外循环表示向前前进的trials数
            count = 0;  %初始化含义为1分的trials
            total = 0;  %初始化前面k个trials的数量
            for h=1:length(b)  %内循环表示该图形每一个选1分的trial。
                
                index = b(h);
                if index>k
                    total = total +1;
                    trial_num = index-k;
                    if DATA(trial_num,6) ==1
                        count=count+1;
                    end
                    
                end
            end
            one_percentage(11-k) = count/total;
        
        end
        
        subplot(1,2,1);
        
        plot([-10 -9 -8 -7 -6 -5 -4 -3 -2 -1],one_percentage);
        xlabel('1分');
       
        
    


        b = find(abs(DATA(:,3))==5);    % 找到所有选5分的trial    
        one_percentage = [0 0 0 0 0 0 0 0 0 0]; %初始化10个点的平均数
        
        for k=1:10    %外循环表示向前前进的trials数
            count = 0;  %初始化含义为5分的trials
            total = 0;  %初始化前面k个trials的数量
            for h=1:length(b)  %内循环表示每一个选1分的trial。
                
                index = b(h);
                if index>k
                    total = total +1;
                    trial_num = index-k;
                    if DATA(trial_num,6) ==0
                        count=count+1;
                    end
                    
                end
            end
            one_percentage(11-k) = count/total;
        
        end
        
        subplot(1,2,2);
       
        plot([-10 -9 -8 -7 -6 -5 -4 -3 -2 -1],one_percentage);
        xlabel('5分');
end



