function [totalScore]=simulation(subNo,totalTrial,mode,status)


if nargin < 1
    error('ÇëÊäÈë±»ÊÔ±àºÅsubNo');
end

if nargin < 2
    error('ÇëÊäÈëtrialÊý');
end


count_graph = [0,0,0,0,0,0,0,0];
count_image_right = [0,0,0,0,0,0,0,0];
count_actual_accuracy = [0,0,0,0,0,0,0,0];


state=[1,1,1,1];
totalScore=0;
awardScore1=1;
awardScore2=5;

graph_num = 0;

datafilename = strcat('computer_',num2str(subNo),'.dat'); % name of data file to write to

datafilepointer = fopen(datafilename,'wt'); % open ASCII file for writing



trials = 1;
total_trial = totalTrial;

while trials <= total_trial  
    startTime = GetSecs;
% get a new graph only if user made clicks in last trial     
    graph_type = rand;
    left=round(rand);
% prob is the probability of click changes
    v1 = rand;
    v2 = rand;
    v3 = rand;
    v4 = rand;
    prob = rand;
    
    if graph_type>=0.4 && graph_type < 0.55 && v1<0.1667
        state(1)=6-state(1);     
    end
    
    if graph_type >= 0.55 && graph_type < 1 && v2<0.0556  
        state(3)=6-state(3);  
    end
    
    if v3<0.0133
        state(2)=6-state(2);        
    end
    
    if graph_type >= 0.55 && graph_type < 1 && v4<0.0278 
        state(4)=6-state(4);
    end
    
  

[curScore,graph_num,count_actual_accuracy]=do_computation(left,graph_type,awardScore1,awardScore2,prob,state,count_actual_accuracy,mode);
    

    
     if curScore>0
        rightans = curScore;
        count_image_right(graph_num) = count_image_right(graph_num) + 1;
    else rightans = 6+curScore;
    end
    
    if curScore>0
        
        rightclick=left;
    else
        rightclick=1-left;
    end    
    
    count_graph(graph_num) = count_graph(graph_num) + 1;
    
   
    totalScore=totalScore+curScore;
    responsetime=rand+1;
    right_rate = (count_image_right(graph_num))/(count_graph(graph_num));
    actual_accuracy = (count_actual_accuracy(graph_num))/(count_graph(graph_num));
    
    if graph_num ==1 || graph_num ==2 || graph_num ==3 || graph_num ==4
        state_now = 0;
    else
        state_now = state(graph_num-4);
    end
     endTime = GetSecs;
    total_time = endTime - startTime;
    
  fprintf(datafilepointer,'%g %g %g %g %g %g %g %g %g %g %.3f %.3f %i %.3f %g\n', ...
            trials, ...
            graph_num, ...
            curScore, ...
            totalScore,...
            rightans,...
            rightclick,...
            left,...
            responsetime,...
            count_image_right(graph_num),...
            count_graph(graph_num),...
            right_rate,...
            actual_accuracy,...
            state_now,...
            total_time,...
            status);


       trials= trials+1;

end

fclose('all');
 