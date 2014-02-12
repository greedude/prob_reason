function bothhard(SubjID,SessionID,TR,diff)
% Each trial contains 16s baseline,  20s test(2s cue1, 14s delay, 2s cue2,
% 2s response), 16s baseline, and 20s control(2s cue1, 14s delay, 2s cue2, 2s response)

% self create the cue  each cue contrains 4 of 6 types color randomly.
% sample and novel cue have same 4 types of color, but the color's position
% is different.

close all;

addpath('d:\CYL\MRI-DNMS\both hard\Control');
addpath('d:\CYL\MRI-DNMS\both hard\DNMS');
addpath('d:\CYL\MRI-DNMS\both hard');

Color=[255 0 0; 0 255 0; 0 0 255; 255 255 0; 255 0 255; 0 255 255];

%%%%%%%%%%%%%%%% communication with MRI scanner%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%         open serial "COM1" to                     %%%%%
    %%%       communicate with MRI scanner                %%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
s = serial('COM1');
fclose(instrfind);
fopen(s); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ID = 0;
TrialNum=0;
StampImg = [];
StampMatrix=[];
StampButton = [];
StampTri=[];

screenNum=max(Screen('Screens'));
[wPtr,rect]=Screen('OpenWindow',screenNum);
black=BlackIndex(wPtr);
white=WhiteIndex(wPtr);
Screen('FillRect',wPtr,black);
Screen(wPtr, 'Flip');
HideCursor;

startTime=GetSecs;

%%%%%%%%%%%%%%%% communication with MRI scanner%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%         set initial state of COM1                 %%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
statebase =s.PinStatus;
state =s.PinStatus;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

while ID < 400
%%%%%%%%%%%%%%%% communication with MRI scanner%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%          check TTL from MRI scanner               %%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     while strcmp(state.DataSetReady, statebase.DataSetReady) %compare if state of 'DSR' pin changes, which means a TTL from MRI scanner
        pause(0.001)
        state=s.PinStatus; %monitor the COM1 state
     end
     statebase=state;%reset statebase to current COM1 state 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     
     TRTime=GetSecs-startTime;
     ID=ID+1;      % detected a TTL trigger signal  
     StampTri = [StampTri; ID,  TRTime];
     ExPh = mod(ID,18);     % determine cycle phase
   
    switch  ExPh
        %%%%%%%%%%%%%%
        % baseline 1 %
        %%%%%%%%%%%%%%
        case 1 % start of baseline 1, do nothing? black ? fixation point?
            TrialNum=TrialNum+1;
            cd ('d:\CYL\MRI-DNMS\both hard\');
            Baseline(wPtr,black, white);
        case 2
            Baseline(wPtr,black, white);                
        case 3
            Baseline(wPtr,black, white);
        case 4
            Baseline(wPtr,black, white);
        case 5 % start of experimental group, cue 1 appeared, for one sec
            cd ('d:\CYL\MRI-DNMS\both hard\DNMS');
            b=1:6;
            ColorList=Shuffle(b(1:6));    
            [SampleColorList,ltm,rtm,lbm,rbm]=PhaseOneStimulus(wPtr,ColorList,Color);
            ImgTime=GetSecs-startTime;
            StampImg = [StampImg; [{ID}, {TrialNum}, {ImgTime}, {SampleColorList}]];% ImID is the ID for the appeard image
            StampMatrix=[StampMatrix;[{ltm},{rtm},{lbm},{rbm}]];
            tic
            while toc<2
            end
            Screen('FillRect',wPtr,black);
            Screen('FillOval',wPtr,[255 255 0],[502 374 522 394]);
            Screen(wPtr, 'Flip');
        case 6 % delay        
            cd ('d:\CYL\MRI-DNMS\both hard\');
            Delay(wPtr,black);
        case 7 % delay
            Delay(wPtr,black);
        case 8 % delay        
            Delay(wPtr,black);
        case 9 % cue 2 appeard, one sec later go cue on
             cd ('d:\CYL\MRI-DNMS\both hard\DNMS');
            [PhaseTwo_SameCue_Position,PhaseTwo_NovelCue_Position,ChoiceColorList,SampleColorList,TargetPosition,ltm,rtm,lbm,rbm,...
                ltmt,rtmt,lbmt,rbmt]=PhaseTwoStimulus(wPtr, SampleColorList,Color,ltm,rtm,lbm,rbm);
            ImgTime=GetSecs-startTime;
            StampImg = [StampImg; [{ID}, {TrialNum}, {ImgTime}, {ChoiceColorList}]]; % ImID is the ID for the appeard image 
            StampMatrix=[StampMatrix;[{ltmt},{rtmt},{lbmt},{rbmt}]];
            tic
            while toc<2
            end
            cd ('d:\CYL\MRI-DNMS\both hard\');
            Go(wPtr,PhaseTwo_SameCue_Position,PhaseTwo_NovelCue_Position,ChoiceColorList,...
                SampleColorList,black,white,Color,ltm,rtm,lbm,rbm,ltmt,rtmt,lbmt,rbmt);
             RespTime=GetSecs-startTime;
            [KeyIsDownTwo, SecsTwo, KeyCodeTwo]=Response;
            [PhaseTwoResult,SecsTwo,KeyCodeTwo]=RespAnalysis(KeyIsDownTwo,SecsTwo,KeyCodeTwo,TargetPosition);
            type=1;  % 1=test  2=control
            StampButton = [StampButton; ID, TrialNum, RespTime,type,KeyIsDownTwo,SecsTwo,TargetPosition,find(KeyCodeTwo),PhaseTwoResult];
            Screen('FillRect',wPtr,black);
            Screen(wPtr, 'Flip');
            
         %%%%%%%%%%%%%%
         % baseline 2 %
         %%%%%%%%%%%%%%
         case 10  
            cd ('d:\CYL\MRI-DNMS\both hard\');
            Baseline(wPtr,black, white);
        case 11
            Baseline(wPtr,black, white);
        case 12
            Baseline(wPtr,black, white);
        case 13
            Baseline(wPtr,black, white);
        case 14 % start of control group,  control cue 1 appeared, for 2 sec
            cd ('d:\CYL\MRI-DNMS\both hard\Control');
            b=1:6;
            ColorList=Shuffle(b(1:6));    
            [SampleColorList,ltm,rtm,lbm,rbm]=PhaseOneStimulus(wPtr,ColorList); %PhaseOneStimulus
            ImgTime=GetSecs-startTime;
            StampImg = [StampImg; [{ID}, {TrialNum}, {ImgTime}, {SampleColorList}]];% ImID is the ID for the appeard image            
            StampMatrix=[StampMatrix;[{ltm},{rtm},{lbm},{rbm}]];
            tic
            while toc<2
            end           
            Screen('FillRect',wPtr,black);
            Screen('FillOval',wPtr,[255 255 0],[502 374 522 394]);
            Screen(wPtr, 'Flip');
        case 15 % delay
            cd ('d:\CYL\MRI-DNMS\both hard\');
            Delay(wPtr,black);
        case 16 % delay
            Delay(wPtr,black);
        case 17 % delay       
            Delay(wPtr,black);
        case 0 % last in control group, control cue 2 appeard, one sec later go cue on
            cd ('d:\CYL\MRI-DNMS\both hard\Control');
            [PhaseTwo_SameCue_Position,PhaseTwo_NovelCue_Position,ChoiceColorList,SampleColorList,TargetPosition,ltm,rtm,lbm,rbm,...
                ltmt,rtmt,lbmt,rbmt]=PhaseTwoStimulus(wPtr, SampleColorList,Color,ltm,rtm,lbm,rbm);
            ImgTime=GetSecs-startTime;
            StampImg = [StampImg; [{ID}, {TrialNum}, {ImgTime}, {ChoiceColorList}]];% ImID is the ID for the appeard image
            StampMatrix=[StampMatrix;[{ltmt},{rtmt},{lbmt},{rbmt}]];
            tic
            while toc<2    
            end
            cd ('d:\CYL\MRI-DNMS\both hard\');
            Go(wPtr,PhaseTwo_SameCue_Position,PhaseTwo_NovelCue_Position,ChoiceColorList,...
                SampleColorList,black,white,Color,ltm,rtm,lbm,rbm,ltmt,rtmt,lbmt,rbmt);
            RespTime=GetSecs-startTime;
            [KeyIsDownTwo, SecsTwo, KeyCodeTwo]=Response;               
            [PhaseTwoResult,SecsTwo,KeyCodeTwo]=RespAnalysis(KeyIsDownTwo,SecsTwo,KeyCodeTwo,TargetPosition);
            type=0; % 1=test  2=control
            StampButton = [StampButton; ID, TrialNum, RespTime,type,KeyIsDownTwo,SecsTwo,TargetPosition,find(KeyCodeTwo),PhaseTwoResult];
            Screen('FillRect',wPtr,black);
            Screen(wPtr, 'Flip');

            if ID==TR
                break
            end

        otherwise
    end
 end
      
ShowCursor;
Screen('CloseAll')
disp('Now we are writing file ');
cd ('d:\CYL\MRI-DNMS');
tmpdate = date;
logfn = [tmpdate(end-3:end) ,tmpdate(4:end-5), tmpdate(1:2) '_' num2str(SubjID) '_' num2str(SessionID) '_' num2str(diff) '.mat'];
save(logfn, 'SubjID', 'SessionID', 'Color', 'StampImg', 'StampButton','StampTri','StampMatrix');

%%%%%%%%%%%%%%%% communication with MRI scanner%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%                   close COM1                      %%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fclose(s);
delete(s);
clear s
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




