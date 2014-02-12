function pahandle = play_sound(wavfilename,volume)


[y, freq] = wavread(wavfilename);
wavedata = y';
nrchannels = size(wavedata,1);

if nrchannels < 2
    wavedata = [wavedata ; wavedata];
    nrchannels = 2;
end
AssertOpenGL;
InitializePsychSound;

pahandle = PsychPortAudio('Open', [], [], 0, freq, nrchannels);

PsychPortAudio('FillBuffer', pahandle, wavedata);
PsychPortAudio('Volume', pahandle,volume);
 PsychPortAudio('Start', pahandle);
% PsychPortAudio('Stop', pahandle,1);
% 
% % Close the audio device:
% PsychPortAudio('Close', pahandle);
