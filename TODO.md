t i kdm -20 # start timer for KDM twenty minutes ago
t i kdm +60 # start timer for KDM 60 minutes from now
t e[dit]       # edit current file for last project
t e[dit] inex  # edit current file for inex

Log command:

t l[og] inex [now]
t l[og] inex 
t log inex -1m
t l -3w kdm

project options

-p project

time interval options: 

-i month
-i week
-i -1w[eek]  # last week
-i -1m[onth] # last month
+1w
+1m

Aliases:

t lg = t log [last-project] 


Git uses:

--since
--until

