function [statebase,trigCnt,quit]=isTrigger(statebase,trigCnt,s)    
% judge is there a fMRI trigger received
% press 'esc' to quit the experiment
 while 1
        quit=0;
        state_trig =s.PinStatus;
        if ~strcmp(state_trig.DataSetReady, statebase.DataSetReady)
            statebase=s.PinStatus;
            trigCnt = trigCnt+1;
            disp(['Trigger ' num2str(trigCnt) ' received']); 
            break
        end
        KbName('UnifyKeyNames');
        EscapeKey=KbName('ESCAPE');
         [KeyIsDown, endrt, KeyCode]=KbCheck;
            if KeyIsDown
                if KeyCode(EscapeKey)
                    quit =1;
                    break
                end
            end
 end