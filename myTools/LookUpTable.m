classdef LookUpTable < handle
    
    properties
        X
        Y
        Mode
    end
    
    methods
        function obj = LookUpTable(x,y,mode)
            if length(x) ~= length(y),
                error('Both X and Y vectors must have the same length.')
            end
            obj.X = x;
            obj.Y = y;
            if all(~strcmp(mode,{'nearest','interpolate'})),
               error('Mode must be either "lookup" or "interpolate".')
            end 
            obj.Mode = mode;
        end
        
        function y = lookup(obj,x)
            Nx = length(x);
            y = zeros(size(x));
            switch obj.Mode,
                case 'nearest'
                    for n = 1:Nx,
                        [tmp ind] = min(abs(x(n)-obj.X));
                        %fprintf(1, 'x: %g, ind: %d, X(ind): %d\n',x(n),ind,obj.X(ind))
                        y(n) = obj.Y(ind);
                    end
                    
                case 'interpolate'
                    NX = length(obj.X);
                    for n = 1:Nx,
                        diff = abs(x(n)-obj.X);
                        [tmp ind] = min(diff);
                        if (ind ~= NX) && ((ind == 1) || (diff(ind+1) < diff(ind-1)))
                            % Interpolate to the RIGHT
                            ind1 = ind; ind2 = ind+1;
                        else
                            % Interpolate to the LEFT
                            ind1 = ind-1; ind2 = ind;
                        end
                        xi1 = obj.X(ind1); yi1 = obj.Y(ind1);
                        xi2 = obj.X(ind2); yi2 = obj.Y(ind2);
                        dx = x(n) - xi1;
                        y(n) = yi1 + (yi2-yi1)/(xi2-xi1) * dx;
                    end
                    
                otherwise
                    error('Unknown lookup mode.')
            end
        end
    end

end
