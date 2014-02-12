function [right_count,right_percentage,err]=get_data(DATA,a,k,total,right_count,start,stop)
right_count = [];
if length(k) >1
    for id =1:length(k) 
        x = find(total == k(id));
        if id >1
            for ie = start:stop
                change_index = k(id)-ie; 
                index_safe = length(a)>change_index && change_index>0;
                if  index_safe && -1<x && x<=length(total)-1
                    is_smaller = a(change_index)<a(total(x+1));
                else is_smaller =true;
                end
                
                if index_safe && 1<x && x<= length(total)+1 
                    is_bigger = a(change_index)>=a(total(x-1)) ;
                else is_bigger = true;
                end
                if   index_safe && x>1 && is_bigger && is_smaller
                    right_count(end+1) = 1-DATA(a(change_index),7);
               end
            end
        else
            for ih =start :stop
                change_index=k(1)-ih;
                 index_safe = length(a)>=change_index && change_index>0;
                if  index_safe && -1<x && x<=length(total)-1 
                    is_smaller = a(change_index)<a(total(x+1));
                else is_smaller =true;
                end
                
                if index_safe && 1<x && x<= length(total)+1
                    is_bigger = a(change_index)>=a(total(x-1)) ;
                else is_bigger = true;
                end
                if   index_safe && x>1 && is_bigger && is_smaller
                right_count(end+1) = 1-DATA(a(change_index),7);
                elseif x == 1 && index_safe && is_smaller 
                    right_count(end+1) = 1-DATA(a(change_index),7);
                
                
                end
            end
        end
    end
else
    x = find(total == k);
     for ih =start :stop
                change_index=k-ih;
                index_safe = length(a)>change_index && change_index>0;
                if  index_safe && -1<x && x<=length(total)-1
                    is_smaller = a(change_index)<a(total(x+1));
                else is_smaller =true;
                end
                
                if index_safe && 1<x && x<= length(total)+1 
                    is_bigger = a(change_index)>=a(total(x-1)) ;
                else is_bigger = true;
                end
                if   index_safe && x>1 && is_bigger && is_smaller
                right_count(end+1) =1- DATA(a(change_index),7);
                elseif index_safe && x==1 && is_smaller
                    right_count(end+1) = 1-DATA(a(change_index),7);
                end
     end
    
end


    right_percentage =mean(right_count);
    l = length(right_count);
    root = sqrt(l);
    std_val = std(right_count);
    err = std_val/root;
    
     
    