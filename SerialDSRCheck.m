function SerialDSRCheck
% This function check the statue of DataSetReady pin of serial port.
clear all;
close all;
reps = 20;
trigCnt = 0;
% fclose(instrfind);
try
    s = serial('COM1');%Create a serial port object ¡ª Create the serial port object s associated with serial port COM1.
    fclose(instrfind);
    fopen(s); % Open seirial port 1(COM1).
    statebase = s.PinStatus;
    disp('Waiting for trigger...');
    while trigCnt <= reps
        state =s.PinStatus;
        if ~strcmp(state.DataSetReady, statebase.DataSetReady)
            statebase=s.PinStatus;
            trigCnt = trigCnt+1;
            disp(['Trigger ' num2str(trigCnt) ' received']);            
        end
    end
    fclose(s);
    delete(s);
    clear s;
    
catch
    
    fclose(s);
    delete(s);
    clear s
end