@echo off
::Assign Today Date 
set today_date= %date:~3,2%-%date:~0,2%-%date:~6,4%

::Assign Today Date as file name with .csv Extension
set file=%today_date%.csv

::Passing file as Argument to Python Scripts
python CLAIMS_Transaction.py %file%
python POLICY.py 
python CLAIMS.py

pause