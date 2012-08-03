classdef Enum1
    
   properties
       Val = '';
   end % properties
    
   properties (SetAccess = private,GetAccess = private)
      NumVal = [];
   end % properties Provate

   properties(Constant,SetAccess = private,GetAccess = private)
      VALUES = {'TEST1', 'TEST2', 'TEST3'};
      NUM_VALUES = length(VALUES);
   end % properties Constant
   
   methods
      function obj = Enum1(stenum)
          if nargin > 0,
              for n = 1:obj.NUM_VALUES,
                  if strcmp(stenum,obj.VALUES{n}) == 1,
                      obj.Val = obj.VALUES{n};
                      break
                  end
              end
          else
              obj.Val = obj.VALUES{1};
          end
      end
      
      function list(obj)
          disp(obj.VALUES)
      end
      
      function disp(obj)
          disp(obj.Val)
      end
   end % methods
end % classdef