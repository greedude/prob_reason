
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