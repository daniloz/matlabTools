classdef textStatusUpdate < handle
    
    properties
        strStatusUpdate = 'Running %7d of %7d... %s elapsed, ETA: %s [%5.2f s/trial]';
        eraseLength = -1
        strClearLine = ''
        nbTrials = -1
        nbTrialsDone = -1
        startTic = -1
    end
    
    methods
        function obj = textStatusUpdate(Ntrials, erase)
            if nargin < 2,
                erase = true;
            end
            if erase,
                obj.eraseLength = length(sprintf(obj.strStatusUpdate,0,0,sec2minsecString(0),sec2minsecString(0),0));
                obj.strClearLine = repmat('\b',1,obj.eraseLength);
            else
                obj.eraseLength = 0;
                obj.strStatusUpdate = strcat(obj.strStatusUpdate, '\n');
            end
            obj.nbTrials = Ntrials;
        end
        
        function start(obj)
            obj.nbTrialsDone = 0;
            fprintf(repmat(' ',1,obj.eraseLength));
            obj.startTic = tic;
        end
        
        function update(obj,trials)
            if trials <= obj.nbTrials,
                obj.nbTrialsDone = trials;
                tElapsed = toc(obj.startTic);
                rate = tElapsed/obj.nbTrialsDone;
                ETA = (obj.nbTrials-obj.nbTrialsDone)*rate;
                fprintf(obj.strClearLine);
                fprintf(obj.strStatusUpdate, obj.nbTrialsDone,obj.nbTrials,sec2minsecString(tElapsed),sec2minsecString(ETA),rate);
            else
                warning('[textStatusUpdate] More trials than "Number of Trials"...');
                fprintf(repmat(' ',1,obj.eraseLength));
            end
        end
        
        function oneMoreTrialDone(obj)
            obj.update(obj.nbTrialsDone+1);
        end
        
        function printSummary(obj)
            fprintf(obj.strClearLine);
            tElapsed = toc(obj.startTic);
            fprintf('Total Elapsed Time for %d Trials: %s [average of %.1f s/trial]\n',...
                obj.nbTrials, sec2minsecString(tElapsed), tElapsed/obj.nbTrials);
        end
    end
    
end
