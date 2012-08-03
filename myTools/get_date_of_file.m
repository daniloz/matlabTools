function str= get_date_of_file(responsePath,responseFilename)
  cd(responsePath);
  [unused_1,result]=dos(['dir ',responseFilename]);
  n=findstr(result,char(10));
  str = result(n(5)+1:n(5)+17);
end
