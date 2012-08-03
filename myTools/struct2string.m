function str = struct2string(exc)
   if ~isstruct(exc)
       error('Argument must be a structure');
   end
   names=fieldnames(exc);
   for ind=1:length(names)
       name=names{ind};
       content=getfield(exc,name);
       if ischar(content) %content is a string
           str{ind}=[name,content];
       else % content is not a string
           if length(content) > 1
                 error('length of structure fields is limited to one');
           end
           str{ind}=[name,num2str(content)];
       end
   end
end
