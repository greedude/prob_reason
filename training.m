function [totalScore]= training(status)
clc;

% check for Opengl compatibility, abort otherwise:
AssertOpenGL;

% Check if all needed parameters given:


HideCursor;
KbName(' UnifyKeyNames');
EscapeKey=KbName('ESCAPE');

left=0;

mode=1;


state=[1,1,1,1];
totalScore=0;
awardScore1=1;
awardScore2=5;
duration=2;
% count=[0,0,0,0];
graph_num = 0;
count_actual_accuracy = [0,0,0,0,0,0,0,0];
left=0;
count_graph = [0,0,0,0,0,0,0,0];
count_image_right = [0,0,0,0,0,0,0,0];
str_expl = {'1分' '1分概率较高' '较快变化' '较慢变化' '5分概率较高' '5分'};

reward_sound = 'right_sound.wav';
punish_sound = 'wrong_sound.wav';


screens=Screen('Screens');
curScreen=max(screens);


[w, wRect] = Screen('OpenWindow', curScreen, 0,[],32, 2);
[width,height] = Screen('WindowSize',w);
l_progressbar = 100;
h_progressbar = 20;


KbCheck;
GetSecs;


trials = 1;

total_trial = 46;
ignored = 0;
while trials <= total_trial
    
% get a new graph only if user made clicks in last trial     
    if ~ignored
        if 1<=trials && trials<=3
            graph_type = 0.01;
        elseif trials>=4 && trials<=6
            graph_type = 0.06;
        elseif trials>=7 && trials<=11
            graph_type = 0.2;
        elseif trials>=12 &&trials<=16
            graph_type = 0.3;
        elseif trials >= 17 && trials<=26
            graph_type = 0.45;
        elseif trials>=27 && trials<=36
            graph_type = 0.65;
            mode = 0;
        elseif trials>=37 && trials<=46
            graph_type = 0.9;
            mode = 1;
        end
    else
        time = GetSecs;
        Screen('TextSize', w, 32);
        str2=sprintf('太慢了，请在2秒内做出选择');
        DrawFormattedText(w, str2, 'center', 'center', WhiteIndex(w));
        Screen('Flip', w);
    end
    

    
% prob is the probability of click changes
   right_trials = [7 8 11 12  13 16 37 38 46 41 42 43 47 56 48 51 52 53];
   wrong_trials = [9 10 14 15 39 40 44 45 49 50 54 55];
   if ismember(trials,right_trials)
        prob = 0.9;
    elseif ismember(trials,wrong_trials)
        prob =0.1;
   else prob =rand;
    end
    
    if trials == 21
        state(1)=6-state(1);     
    end
    if trials == 31    
        state(2)=6-state(2);  
    end
    
    if trials == 41
        state(3)=6-state(3);        
    end
    
    if trials == 51
        state(4)=6-state(4);
    end
    
    
% get new graph according to the probability assigned to each graph   
    if status == 0
        if graph_type < 0.05
            imdata=imread('1.png');
            str_graph=sprintf('图1：%s',str_expl{1});        
        elseif graph_type >= 0.05 &&graph_type < 0.1
            imdata=imread('2.png');
            str_graph=sprintf('图2：%s',str_expl{6});  
        elseif graph_type >= 0.1 && graph_type < 0.25
            imdata=imread('3.png');
            str_graph=sprintf('图3：%s',str_expl{2});  
        elseif graph_type >= 0.25 && graph_type < 0.4
            imdata=imread('4.png');
            str_graph=sprintf('图4：%s',str_expl{5});  
        elseif graph_type >= 0.4 && graph_type < 0.5
            imdata=imread('5.png');
            str_graph=sprintf('图5：%s',str_expl{3});  
%         elseif graph_type >= 0.5 && graph_type < 0.6
%             imdata=imread('6.png');
%             str_graph=sprintf('图6：%s',str_expl{4});  
        elseif graph_type >= 0.5 && graph_type < 0.8
            imdata=imread('7.png');
            str_graph=sprintf('图6：%s\n ',str_expl{3});  
        elseif graph_type >= 0.8 && graph_type < 1
            imdata=imread('8.png');
            str_graph=sprintf('图7：%s\n',str_expl{4});  
        end
    elseif status ==1
        if graph_type < 0.05
            imdata=imread('4.png');
            str_graph=sprintf('图1：%s',str_expl{1});        
        elseif graph_type >= 0.05 &&graph_type < 0.1
            imdata=imread('3.png');
            str_graph=sprintf('图2：%s',str_expl{6});  
        elseif graph_type >= 0.1 && graph_type < 0.25
            imdata=imread('2.png');
            str_graph=sprintf('图3：%s',str_expl{2});  
        elseif graph_type >= 0.25 && graph_type < 0.4
            imdata=imread('1.png');
            str_graph=sprintf('图4：%s',str_expl{5});  
        elseif graph_type >= 0.4 && graph_type < 0.5
            imdata=imread('8.png');
            str_graph=sprintf('图5：%s',str_expl{3});  
%         elseif graph_type >= 0.5 && graph_type < 0.6
%             imdata=imread('7.png');
%             str_graph=sprintf('图6：%s',str_expl{4});  
        elseif graph_type >= 0.6 && graph_type < 0.8
            imdata=imread('6.png');
            str_graph=sprintf('图6：%s\n',str_expl{3});  
        elseif graph_type >= 0.8 && graph_type < 1
            imdata=imread('5.png');
            str_graph=sprintf('图7：%s\n',str_expl{4});  
        end
    end
  
    
    DrawFormattedText(w, str_graph, 'center', 50,WhiteIndex(curScreen));
    
% paint the graph for 2 secs    
   if ignored
        tex=Screen('MakeTexture', w, imdata);
        Screen('DrawTexture', w, tex);
        [StartTime1 UserTime1 endTime1]=Screen('Flip', w,time+duration);
     else tex=Screen('MakeTexture', w, imdata);
            Screen('DrawTexture', w, tex);
            [StartTime1 UserTime1 endTime1]=Screen('Flip', w);
    end
   
% flip a black screen for 2 secs    
    [StarTime2 UserTime2 endTime2] = Screen('Flip', w, StartTime1+duration);
    
% print the instruction     
    Screen('TextSize', w, 32); 
    str1=sprintf('请做出选择');
    DrawFormattedText(w, str1, 'center', 'center', WhiteIndex(w));
    [StartTime3 UserTime3 endTime3] = Screen('Flip', w, endTime2+duration);
    
        
% get the mouse clicks, if no clicks in 2 secs, repeat this trial. Using
% ignored as a flag
    start = GetSecs;
    while 1
        [x,y,buttons] = GetMouse(w);
        if any(buttons)  %user made clicks
            break;
        else
            if GetSecs > start+2
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
    
    if curScore>0
        
        rightclick=left;
    else
        rightclick=1-left;
    end    
    
    if abs(curScore)==5
        volume = 2;
    else
        volume = 0.5;
    end
    
    count_graph(graph_num) = count_graph(graph_num) + 1;
    
    %Draw a progress bar
    progress = (trials/total_trial);
    progress_bar = progress * l_progressbar;

    Screen('FrameRect',w,[255 255 255],[(width-l_progressbar)/2 height*2/3 (width+l_progressbar)/2 height*2/3+h_progressbar]);
    Screen('Fillrect',w,[255 255 255],[(width-l_progressbar)/2 height*2/3 (width-l_progressbar)/2+progress_bar height*2/3+h_progressbar]);

    %Print out the result for this trial
    totalScore=totalScore+curScore;
    str2=sprintf('\n\n\n本次得分为 \n\n 总分为%.2f \n',totalScore);
    str_score=sprintf('               %.2f',curScore);
    DrawFormattedText(w, str2, 'center', 'center',WhiteIndex(curScreen));
    if curScore >0
        DrawFormattedText(w, str_score, 'center', 'center',[0 255 0]);
        play_sound(reward_sound,volume);
    else
        DrawFormattedText(w, str_score, 'center', 'center',[255 0 0]);
        play_sound(punish_sound,volume);
    end
   
    
    
    StartTime2=Screen('Flip', w);
    Screen('Flip', w, StartTime2+duration);
    responsetime=time_click-endTime3;
    right_rate = (count_image_right(graph_num))/(count_graph(graph_num));
    actual_accuracy = (count_actual_accuracy(graph_num))/(count_graph(graph_num));

    WaitSecs(duration);

    end
   
    if  ~ignored
        trials= trials+1;
    end
    
  
    
end
% 
% str3=sprintf('谢谢');
%     DrawFormattedText(w, str3, 'center', 'center', WhiteIndex(w));
%    Screen('Flip', w);
Screen('CloseAll');
ShowCursor;
fclose('all');
 