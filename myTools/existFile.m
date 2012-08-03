  function found= existsFile(path,fname)
        initialPath=pwd();
        cd(path);
        [unused_1,result]=dos(['dir ',fname]);
        n=findstr(result,fname);
        if isempty(n)
          found = false;
        else
          found = true;
        end
        cd(initialPath);
    end
  