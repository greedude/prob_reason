



cell = {d1 d2 d3 d4 d5 d6 d7 d8};
percen_cell = [0;0;0;0;0;0;0;0];
right_cell = percen_cell;

for i=5:8
     for p =1:8
        DATA = cell{1,p};
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
        percen_cell(p,1:4) = percentage_total;
        

    
     
        end
    
     end
     percentage_total =  mean(percen_cell,1);
     
    subplot(3,2,i-4);
        bar(percentage_total);
        axis([0 5 0 1])
end

for i=5:8
    for p =1:8
    DATA = cell{1,p};
    a =find(DATA(:,2) == i);
    
    
    if ~isempty(a)
        b = find(abs(DATA(:,3))==1);        
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
                    if DATA(trial_num,6) ==1
                        count=count+1;
                    end
                    
                end
            end
            one_percentage(11-k) = count/total;
            
        
        end
        
        right_cell(p,1:10) = one_percentage;
       
        
    end
        
        one_percentage = mean(right_cell,1);
        
    end
    subplot(3,2,5);
        hold on;
        color = 'rgbk';
        plot([-10 -9 -8 -7 -6 -5 -4 -3 -2 -1],one_percentage,color(i-4));
        xlabel('1·Ö');
end
hold off;

for i=5:8
     for p =1:8
    DATA = cell{1,p};
    a =find(DATA(:,2) == i);   
    if ~isempty(a)
        b = find(abs(DATA(:,3))==5);        
        c = intersect(a,b);
        one_percentage = [0 0 0 0 0 0 0 0 0 0];
        
        for k=1:10
            count = 0;
            
            for h=1:length(c)
                index = find(a==c(h));
                if index>k
                    trial_num = a(index-k);
                    if DATA(trial_num,7) ==0
                        count=count+1;
                    end
                end
            end
            one_percentage(11-k) = count/length(c);
        
        end
         right_cell(p,1:10) = one_percentage;
       
        
    end
        
        one_percentage = mean(right_cell,1);
        
       
       
        
     end
     subplot(3,2,6);
        hold on;
        color = 'rgbk';
        plot([-10 -9 -8 -7 -6 -5 -4 -3 -2 -1],one_percentage,color(i-4));
        xlabel('5·Ö');
        axis([-10 1 0 1]);
end
   hold off;









    



