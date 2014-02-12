function [statebase,trigCnt]=isTrigger(statebase,trigCnt,s)    
 while 1
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
                    Screen('CloseAll');
                    ShowCursor;
                    delete(s);
                    clear s;
                    fclose('all');
                    
                    break
                end
            end
 end