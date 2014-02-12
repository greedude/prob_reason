function total_analysis(subName,subNo)

datafilename = strcat(subName,'_',num2str(subNo),'.dat'); % name of data file to read
DATA = dlmread(datafilename,' ');
    
    
    
        b = find(abs(DATA(:,3))==1);    % �ҵ�����ѡ1�ֵ�trial    
        one_percentage = [0 0 0 0 0 0 0 0 0 0]; %��ʼ��10�����ƽ����
        
        for k=1:10    %��ѭ����ʾ��ǰǰ����trials��
            count = 0;  %��ʼ������Ϊ1�ֵ�trials
            total = 0;  %��ʼ��ǰ��k��trials������
            for h=1:length(b)  %��ѭ����ʾ��ͼ��ÿһ��ѡ1�ֵ�trial��
                
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
        xlabel('1��');
       
        
    


        b = find(abs(DATA(:,3))==5);    % �ҵ�����ѡ5�ֵ�trial    
        one_percentage = [0 0 0 0 0 0 0 0 0 0]; %��ʼ��10�����ƽ����
        
        for k=1:10    %��ѭ����ʾ��ǰǰ����trials��
            count = 0;  %��ʼ������Ϊ5�ֵ�trials
            total = 0;  %��ʼ��ǰ��k��trials������
            for h=1:length(b)  %��ѭ����ʾÿһ��ѡ1�ֵ�trial��
                
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
        xlabel('5��');
end



