function [totalScore]=prob_reason(subName,subNo,totalTrial,mode,status)
clc;

% check for Opengl compatibility, abort otherwise:
AssertOpenGL;


% Check if all needed parameters given:
if nargin < 2
    error('请输入被试名字和编号');  
end

if nargin < 3
    error('请输入trial数');
end

HideCursor;
KbName('UnifyKeyNames');
EscapeKey=KbName('ESCAPE');


left=0;
count_graph = [0,0,0,0,0,0,0,0];
count_image_right = [0,0,0,0,0,0,0,0];
count_actual_accuracy = [0,0,0,0,0,0,0,0];

% seeds the random number generator based on the current time 
rng('shuffle');


state=[1,1,1,1];
totalScore=0;
awardScore1=1;
awardScore2=5;
duration=0.8;
% count=[0,0,0,0];
graph_num = 0;
total_time = 0;

reward_sound = 'right_sound.wav';
punish_sound = 'wrong_sound.wav';



screens=Screen('Screens');
curScreen=max(screens);


[w, wRect] = Screen('OpenWindow', curScreen, 0,[],32, 2);
[width,height] = Screen('WindowSize',w);
l_progressbar = 100;
h_progressbar = 20;

datafilename = strcat(subName,'_',num2str(subNo),'.dat'); % name of data file to write to

datafilepointer = fopen(datafilename,'wt'); % open ASCII file for writing

KbCheck;
GetSecs;

% black = BlackIndex(curScreen);

trials = 1;

total_trial = totalTrial;
ignored = 0;




str1=double( sprintf('请做好准备'));
DrawFormattedText(w, str1, 'center','center', WhiteIndex(w));
Screen('Flip',w);
WaitSecs(2);

%  try
    while trials <= total_trial
    % 
      if trials==251
          Screen('Flip',w);          
            while 1
              [KeyIsDown, endrt, KeyCode]=KbCheck;
                if KeyIsDown
                    if KeyCode(EscapeKey)
                        break
                    end
                end
            end
          
      end
    % baseline
        if    mod(trials,5)==1 && ignored==0
         
                Screen('TextSize', w, 50);
                str1=double( sprintf('.'));
                DrawFormattedText(w, str1, 'center','center', WhiteIndex(w));
                Screen('Flip',w);
                WaitSecs(8);
            
        end
   
        startTime = GetSecs;

    % get a new graph only if user made clicks in last trial     
    if ~ignored
        graph_type = rand;
    else
        time = GetSecs;
        Screen('TextSize', w, 32);
        str1=double( sprintf('请选择'));
        DrawFormattedText(w, str1, 'center',  height/3, WhiteIndex(w));
        str2=double(sprintf('太慢了'));
        DrawFormattedText(w, str2, 'center', 'center', WhiteIndex(w));
        Screen('Flip', w);
    end
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


    % get new graph according to the probability assigned to each graph
        if status == 0
            if graph_type < 0.05
                imdata=imread('1.png');
            elseif graph_type >= 0.05 &&graph_type < 0.1
                imdata=imread('2.png');
            elseif graph_type >= 0.1 && graph_type < 0.25
                imdata=imread('3.png');
            elseif graph_type >= 0.25 && graph_type < 0.4
                imdata=imread('4.png');
            elseif graph_type >= 0.4 && graph_type < 0.55
                imdata=imread('5.png');
            elseif mode == 0 && graph_type >= 0.55 && graph_type < 1
                imdata=imread('7.png');
            elseif mode == 1 && graph_type >= 0.55 && graph_type < 1
                imdata=imread('8.png');
            end
        elseif status == 1
            if graph_type < 0.05
                imdata=imread('4.png');
            elseif graph_type >= 0.05 &&graph_type < 0.1
                imdata=imread('3.png');
            elseif graph_type >= 0.1 && graph_type < 0.25
                imdata=imread('2.png');
            elseif graph_type >= 0.25 && graph_type < 0.4
                imdata=imread('1.png');
            elseif graph_type >= 0.4 && graph_type < 0.55
                imdata=imread('8.png');
            elseif mode == 0 && graph_type >= 0.55 && graph_type < 1
                imdata=imread('6.png');
            elseif mode == 1 && graph_type >= 0.55 && graph_type < 1
                imdata=imread('5.png');
            end
        end

    % paint the graph for 0.8 secs   
        if ignored
            tex=Screen('MakeTexture', w, imdata);
            Screen('DrawTexture', w, tex);
            [StartTime1 UserTime1 endTime1]=Screen('Flip', w,time+duration);
        else tex=Screen('MakeTexture', w, imdata);
            Screen('DrawTexture', w, tex);
            [StartTime1 UserTime1 endTime1]=Screen('Flip', w);
        end
  
    % print the instruction     
          
        Screen('TextSize', w, 32); 
        
        str1=double( sprintf('请选择'));
        DrawFormattedText(w, str1, 'center',  height/3, WhiteIndex(w));
        [StartTime3 UserTime3 endTime3] = Screen('Flip', w, StartTime1+duration);


    % get clicks, if no clicks in 2 secs, repeat this trial.
       start = GetSecs;
       while 1
            [x,y,buttons] = GetMouse(w);
            if any(buttons)  %user made clicks
                break;
            else
                if GetSecs > start+duration
                    break;
                end
            end
        end
  


    % exit if user press 'ESC'
            [KeyIsDown, endrt, KeyCode]=KbCheck;
            if KeyIsDown
                if KeyCode(EscapeKey)
                    Screen('CloseAll');
                    ShowCursor;
                    fclose('all');                 
                    break
                end
            end

    % get the user's click
    
     if ~buttons
        ignored = 1;   
     else
        ignored = 0;
        
        time_click = GetSecs;
        if buttons(1)
            left=1;
        elseif length(buttons)>=3 &&buttons(3)
            left=0;
        end


    [curScore,graph_num,count_actual_accuracy]=do_computation(left,graph_type,awardScore1,awardScore2,prob,state,count_actual_accuracy,mode);

        
        if curScore>0
            rightans = curScore;
            count_image_right(graph_num) = count_image_right(graph_num) + 1;
        else rightans = 6+curScore;
        end

        if abs(curScore)==5
            volume = 2;
        else
            volume = 0.5;
        end

        if curScore>0

            rightclick=left;
        else
            rightclick=1-left;
        end   

        count_graph(graph_num) = count_graph(graph_num) + 1;

        % Draw a progress bar
        progress = (trials/total_trial);
        progress_bar = progress * l_progressbar;
        str_score=sprintf('%.2f',curScore);
        if curScore >0
            DrawFormattedText(w, str_score,'center', 'center',[0 255 0]);
            pahandle = play_sound(reward_sound,volume);
        elseif curScore<0
            DrawFormattedText(w, str_score, 'center', 'center',[255 0 0]);
            pahandle= play_sound(punish_sound,volume);
        end

        DrawFormattedText(w, str1, 'center', height/3, WhiteIndex(w));

        Screen('FrameRect',w,[255 255 255],[(width-l_progressbar)/2 height*1.7/3 (width+l_progressbar)/2 height*1.7/3+h_progressbar]);
        Screen('Fillrect',w,[255 255 255],[(width-l_progressbar)/2 height*1.7/3 (width-l_progressbar)/2+progress_bar height*1.7/3+h_progressbar]);

        %Print out the result for this trial
        totalScore=totalScore+curScore;
    %     str2=double(sprintf('\n\n\n本次得分为 \n\n 总分为%.2f \n',totalScore));

    %     DrawFormattedText(w, str2, 'center', 'center',WhiteIndex(curScreen));



        responsetime=time_click-endTime3;
          
%         [statebase,trigCnt]=isTrigger(statebase,trigCnt,s);  
        StartTime2=Screen('Flip', w,StartTime3+duration);
        Screen('Flip', w,StartTime2+duration);

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

         PsychPortAudio('Stop', pahandle,1);
    % 
    %     % Close the audio device:
        PsychPortAudio('Close', pahandle);
        
    end
    if  ~ignored
        trials= trials+1;
    end
    end
%     PsychPortAudio('Close', pahandle);
% catch
%     delete(s);
%     clear s;
%     Screen('CloseAll');
%     ShowCursor;
%     fclose('all');
%     return
% end


Screen('CloseAll');
ShowCursor;
fclose('all');
 