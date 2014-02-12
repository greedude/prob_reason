function [statebase,trigCnt]=baseline(statebase,trigCnt,s,w)
for i=1:10
    if i==1
        disp('---------');
    end
   [statebase,trigCnt]=isTrigger(statebase,trigCnt,s);  
      
       Screen('TextSize', w, 80);
            str1=double( sprintf('.'));
            DrawFormattedText(w, str1, 'center','center', WhiteIndex(w));
            Screen('Flip',w);
       
    
      
      
end

