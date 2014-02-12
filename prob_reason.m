function [totalScore]=prob_reason(subName,subNo,totalTrial,mode,status)
% USAGE: [totalScore]=prob_reason(subName,subNo,totalTrial,mode,status)
% prob_reason is used for a fMRI experiment concerning probabilistic 
% decision-making and rewarding ability of human. 'mode' is a switch for
% choosing desirable graph(graph 7 or 8). For now, mode should be zero. 
% 'status' controls the order of graphs. 'status = 0' means nomal order 
% and 'status = 1'means reverse. 
% The result data is saved in 'subName_subNo.dat' file.
% Example:
% prob_reason('Liam', 1, 250, 0, 0) stands for 
% Liam is doing the 1st test which has 250 trials with graph 7 in normal  
% order. The result data file is 'Liam_1.dat'
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

% bind keys for subject's input
HideCursor;
KbName('UnifyKeyNames');
EscapeKey = KbName('ESCAPE');
EnterKey = KbName('return');
button_five = KbName('5%');  % in the fMRI machine, left button binds to 5 
button_six = KbName('6^');   % right button binds to 6

left=0;
count_graph = [0,0,0,0,0,0,0,0];             % count the times a graph is presented                   
count_image_right = [0,0,0,0,0,0,0,0];       % count the times subject is correct about a graph
count_actual_accuracy = [0,0,0,0,0,0,0,0];   % actual accuracy for a graph
graph_percentage = [0.05 0.05 0.15 0.15 0.15 0.15 0.45 0.45];  % the probability a graph is presented
graph_prob = [0 0 2/3 2/3 0 0 2/3 2/3 ];     % the probability of correctness of a graph
graph_volatile = [0 0 0 0 1/40 0 1/40 1/80 ];% the speed of a graph to change its correct answer

% set the graph order
if status == 0
    graph_no = 1:8;
else
    graph_no = [4 3 2 1 8 7 6 5];
end


Date = datenum(date, 'dd-mmm-yyyy'); % record the date
rng('shuffle');                      % seeds the random number generator based on the current time 

state = [1,1,1,1];      % graph state of being 1 point or 5 point         
totalScore = 0;           
awardScore1 = 1;
awardScore2 = 5;
duration = 0.75;
graph_num = 0;
total_time = 0;
runCnt = 1;             
blockCnt = 0;
trialCnt = 0;
blockNum = 250;
trialsNum = 5;



% init the window
screens = Screen('Screens');
curScreen = max(screens);
[w, wRect] = Screen('OpenWindow', curScreen, 0, [], 32, 2);
[width, height] = Screen('WindowSize', w);

l_progressbar = 100; % the length of the progress bar
h_progressbar = 20;  % the height of the progress bar

% open a dat file for data
datafilename = strcat('data\',subName, '_', num2str(subNo), '.dat'); % name of data file to write to
datafilepointer = fopen(datafilename, 'wt');                 % open ASCII file for writing

KbCheck;
GetSecs;

trials = 1;
total_trial = totalTrial;


% open a serial port. connect to fMRI machine.
s = serial('COM1');         % Create a serial port object — Create the serial port object s associated with serial port COM1.
fclose(instrfind);          % close all the other communication interface 
fopen(s);                   % Open seirial port 1(COM1).
statebase = s.PinStatus;    % record the base COM status
state_trig = s.PinStatus;   % init the current status 
trigCnt = 0;                % count the trigger

% give a instruction on the screen
str1=double(sprintf('请做好准备'));
DrawFormattedText(w, str1, 'center', 'center', WhiteIndex(w));
Screen('Flip', w);
begin_time = GetSecs;

try
    while trials <= total_trial
      % judge wich run is it now, 1 run includes 250 blocks.
      if mod(trials, blockNum) == 1 && trials > 1
          runCnt = runCnt + 1;
          str_total_score = sprintf('Total Score: %.1f\nNow Take a Break', totalScore);
          DrawFormattedText(w, str_total_score, 'center', 'center', WhiteIndex(w));
          Screen('Flip', w);  % give a instruction screen when one run is completed
          WaitSecs(3);
          Screen('Flip', w);
          % keep a black screen until 'enter' is pressed
          while 1
              [KeyIsDown, endrt, KeyCode] = KbCheck;
              if KeyIsDown
                  if KeyCode(EnterKey)
                      break
                  end
              end
          end
      end
       
    % baseline: show a dot in the center for 10 triggers
       if mod(trials, trialsNum) == 1 
           blockCnt = blockCnt +1;
           trialCnt = 0;
           for i = 1:10
               Screen('TextSize', w, 40);
               str1 = double(sprintf('.'));
               DrawFormattedText(w, str1, 'center','center', WhiteIndex(w));
               [statebase, trigCnt, quit] = isTrigger(statebase, trigCnt, s);
               if quit == 1
                   break
               end
               Screen('Flip', w);
           end
       end
   
       startTime = GetSecs;
       trialCnt = trialCnt+1;
       graph_type = rand;   % random a graph        

       v1 = rand;
       v2 = rand;
       v3 = rand;
       v4 = rand;
       prob = rand;
        
        % state of graph 5
        if graph_type>=0.4 && graph_type<0.55 && v1<0.1667
            state(1) = 6-state(1);     
        end
        
        % state of graph 7
        if graph_type >= 0.55 && graph_type < 1 && v2<0.0556  
            state(3) = 6-state(3);  
        end

        % state of graph 6
        if v3 < 0.0133
            state(2) = 6-state(2);        
        end

        % state of graph 8
        if graph_type >= 0.55 && graph_type < 1 && v4<0.0278 
            state(4) = 6-state(4);
        end


    % get new graph according to the probability assigned to each graph
        if status == 0
            if graph_type < 0.05
                    imdata = imread('static\1.png');
            elseif graph_type >= 0.05 &&graph_type < 0.1
                    imdata = imread('static\2.png');
            elseif graph_type >= 0.1 && graph_type < 0.25
                    imdata = imread('static\3.png');
            elseif graph_type >= 0.25 && graph_type < 0.4
                    imdata = imread('static\4.png');
            elseif graph_type >= 0.4 && graph_type < 0.55
                    imdata = imread('static\5.png');
            elseif mode == 0 && graph_type >= 0.55 && graph_type < 1
                    imdata = imread('static\7.png');
            elseif mode == 1 && graph_type >= 0.55 && graph_type < 1
                    imdata = imread('static\8.png');
            end
        elseif status == 1
            if graph_type < 0.05
                    imdata = imread('static\4.png');
            elseif graph_type >= 0.05 &&graph_type < 0.1
                    imdata = imread('static\3.png');
            elseif graph_type >= 0.1 && graph_type < 0.25
                    imdata = imread('static\2.png');
            elseif graph_type >= 0.25 && graph_type < 0.4
                    imdata = imread('static\1.png');
            elseif graph_type >= 0.4 && graph_type < 0.55
                    imdata = imread('static\8.png');
            elseif mode == 0 && graph_type >= 0.55 && graph_type < 1
                    imdata = imread('static\6.png');
            elseif mode == 1 && graph_type >= 0.55 && graph_type < 1
                    imdata = imread('static\5.png');
            end
        end

        % paint the graph for 0.8 secs   
        tex = Screen('MakeTexture', w, imdata);
        Screen('DrawTexture', w, tex);
        % trigger the picture
        [statebase,trigCnt,quit] = isTrigger(statebase,trigCnt,s);
        if quit == 1;
            break
        end
        [StartTime1 UserTime1 endTime1]=Screen('Flip', w);
  
        % print the instruction       
        Screen('TextSize', w, 32);    
        str1=double(sprintf('请选择'));
        DrawFormattedText(w, str1, 'center',  height/3, WhiteIndex(w));
        [statebase, trigCnt, quit] = isTrigger(statebase, trigCnt, s);
        if quit == 1;
            break
        end
        [StartTime3 UserTime3 endTime3] = Screen('Flip', w, StartTime1+duration);


    % get clicks, if no clicks in 2 secs, repeat this trial.
       start = GetSecs;
       while 1
            [KeyIsDown1, endrt1, KeyCode1]=KbCheck;
            if  KeyCode1(button_five) || KeyCode1(button_six)
                 str1=double(sprintf('请选择'));
                 str6 = double(sprintf('.'));
                 DrawFormattedText(w, str1, 'center',height/3, WhiteIndex(w));
                 Screen('TextSize', w, 40);
                 DrawFormattedText(w, str6, 'center',height/2, WhiteIndex(w));
                 Screen('Flip',w);
                 break;
            else
                if GetSecs > start+0.75
                    break;
                end
            end
        end

    % exit if user press 'ESC'
        [KeyIsDown, endrt, KeyCode]=KbCheck;
        if KeyIsDown
            if KeyCode(EscapeKey)
                break
            end
        end

    % get the user's click, miss = 1 if none button pressed
        miss = 0;
        if ~KeyCode1(button_five) && ~KeyCode1(button_six)
            left = 1;
            miss = 1;
        end
        time_click = GetSecs;
        if KeyCode1(button_five)
            left = 1;
        elseif KeyCode1(button_six)
            left = 0;
        end

        % call do_computation to computate the result of subject's choice
        [curScore,graph_num,count_actual_accuracy]=do_computation(left,graph_type,...
                                                              awardScore1,awardScore2,...
                                                              prob,state,...
                                                              count_actual_accuracy,mode);

        % compute the other result data
        if curScore > 0
            rightans = curScore;
            count_image_right(graph_num) = count_image_right(graph_num) + 1;
            rightclick = left;
        elseif curScore < 0
            rightans = 6 + curScore;
            rightclick=1 - left;
        end
        
        if miss == 1
            curScore = 0;
            left = -1;            
        end
        
        
        % ready to present the feedback screen
        Screen('TextSize', w, 32);
        % Draw a progress bar
        progress = (trials/total_trial);
        progress_bar = progress * l_progressbar;
        str_score=sprintf('%.1f',curScore);
        if curScore > 0
            DrawFormattedText(w, str_score,'center', 'center',[0 255 0]);
        elseif curScore < 0
            DrawFormattedText(w, str_score, 'center', 'center',[255 0 0]);
        else
            DrawFormattedText(w, str_score, 'center', 'center',[255 255 255]);
        end

        DrawFormattedText(w, str1, 'center', height/3, WhiteIndex(w));

        Screen('FrameRect', w,[255 255 255],...
                [(width-l_progressbar)/2 height*1.9/3 (width+l_progressbar)/2 height*1.9/3+h_progressbar]);
        Screen('Fillrect', w,[255 255 255],...
                [(width-l_progressbar)/2 height*1.9/3 (width-l_progressbar)/2+progress_bar height*1.9/3+h_progressbar]);

        % Print feedback screen after catch a trigger          
        [statebase,trigCnt,quit] = isTrigger(statebase, trigCnt, s);
        if quit == 1;
            break
        end 
        StartTime2 = Screen('Flip', w, StartTime3+duration);
        Screen('Flip', w, StartTime2+duration);
        
        totalScore = totalScore+curScore;   
        count_graph(graph_num) = count_graph(graph_num) + 1;
        right_rate = (count_image_right(graph_num)) / (count_graph(graph_num));
        actual_accuracy = (count_actual_accuracy(graph_num)) / (count_graph(graph_num));
        responsetime = time_click - endTime3;
        if graph_num==1 || graph_num==2 || graph_num==3 || graph_num==4
            state_now = 0;
        else
            state_now = state(graph_num-4);
        end


        endTime = GetSecs;
        total_time = endTime - startTime;


        fprintf(datafilepointer,'%g %g %g %g %g %g %g %g %g %g %.3f %.3f %i %.3f %g %i %i %i %.2f %.3f %.3f %i %g %g %i\n', ...
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
            status,...
            runCnt,...
            blockCnt,...
            trialCnt,...
            graph_percentage(graph_num),...
            graph_prob(graph_num),...
            graph_volatile(graph_num),...
            Date,...
            begin_time,...
            startTime,...
            graph_no(graph_num));       
            trials= trials+1;
          
    end
    
fclose(s);
delete(s);
clear s;
Screen('CloseAll');
ShowCursor;
fclose('all');
    
catch
    delete(s);
    clear s;
    Screen('CloseAll');
    ShowCursor;
    fclose('all');
    return
end



 