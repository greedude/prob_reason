function [curScore,graph_num,count_actual_accuracy]=do_computation(left,graph_type,awardScore1,awardScore2,prob,state,count_actual_accuracy,mode)
% graph1        
    if graph_type < 0.05
       graph_num = 1;
        if left==1
            curScore=awardScore1;
        else
            curScore=-awardScore2;
        end
    
%  graph2       
    elseif graph_type >= 0.05 && graph_type < 0.1
        graph_num =2;
        if left==0
            curScore=awardScore2;
        else
            curScore=-awardScore1;
        end

%  graph3       
    elseif graph_type >=0.1 && graph_type < 0.25
       graph_num =3;
            if left==0
                if prob<0.33
                    curScore=awardScore2;
                else
                    curScore=-awardScore2;
                end
            
            else
                count_actual_accuracy(3) = count_actual_accuracy(3)+1;
                if prob>=0.33
                    curScore=awardScore1;
                else
                    curScore=-awardScore1;
                end
            end
        
            
   
% graph4        
    elseif graph_type>=0.25 && graph_type < 0.4 %graph_type = 4
      graph_num =4 ;
            if left==1
                if prob<0.33
                    curScore=awardScore1;
                else
                    curScore=-awardScore1;
                end
            
            else
                count_actual_accuracy(4) = count_actual_accuracy(4)+1;
                if prob>=0.33
                    curScore=awardScore2;
                else
                    curScore=-awardScore2;
                end
            end
            
    
% graph5        
    elseif  graph_type>=0.4 && graph_type < 0.55 %graph_type==5
       graph_num =5;
        if state(1)==1
            if left==1
                curScore=awardScore1;
            else
                curScore=-awardScore2;
            end
        else
            if left==0
                curScore=awardScore2;
            else
                curScore=-awardScore1;
            end
        end

% graph6        
%     elseif graph_type>=0.5 && graph_type < 0.6 %graph_type==6
%           graph_num =6;            
%         if   state(2)==5
%             if left==0
%                 curScore=awardScore2;
%             else
%                 curScore=-awardScore1;
%             end
%         else
%             if left==1
%                 curScore=awardScore1;
%             else
%                 curScore=-awardScore2;
%             end
%         end
    
% graph7        
    elseif mode==0 && graph_type >= 0.55 && graph_type < 1 %graph_type==7
       graph_num = 7;
        if state(3)==5
            if left==1
                if prob<0.33
                    curScore=awardScore1;
                else
                    curScore=-awardScore1;
                end
            
            else
                count_actual_accuracy(7) = count_actual_accuracy(7)+1;
                if prob>=0.33
                    curScore=awardScore2;
                else
                    curScore=-awardScore2;
                end
            end
        else
            if left==0
                if prob<0.33
                    curScore=awardScore2;
                else
                    curScore=-awardScore2;
                end
            
            else
                count_actual_accuracy(7) = count_actual_accuracy(7)+1;
                if prob>=0.33
                    curScore=awardScore1;
                else
                    curScore=-awardScore1;
                end
            end
        end

% graph8
    elseif mode ==1 && graph_type >= 0.55 && graph_type < 1 
        graph_num =8;
        if state(4)==1
            if left==0
                if prob<0.33
                    curScore=awardScore2;
                else
                    curScore=-awardScore2;
                end
            
            else
                count_actual_accuracy(8) = count_actual_accuracy(8)+1;
                if prob>=0.33
                    curScore=awardScore1;
                else
                    curScore=-awardScore1;
                end
            end
            
        else
            if left==1
                if prob<0.33
                    curScore=awardScore1;
                else
                    curScore=-awardScore1;
                end
            
            else
                count_actual_accuracy(8) = count_actual_accuracy(8)+1;
                if prob>=0.33
                    curScore=awardScore2;
                else
                    curScore=-awardScore2;
                end
            end
            
        end
    end

end