clear all
close all
clc

% Set ABC Control Parameters
% Parameter initialization
ABCOpts = struct( 'ColonySize',  10, ...   % Number of Employed Bees+ Number of Onlooker Bees 
    'MaxCycles', 200,...   % Maximum cycle number in order to termaxate the algorithm
    'ErrGoal',     1e-20, ...  % Error goal in order to termaxate the algorithm (not used in the code in current version)
    'Dim',       2 , ... % Number of parameters of the objective function   
    'Limit',   100, ... % Control paramter in order to abandone the food source 
    'lb',  0, ... % Lower bound of the parameters to be optimized
    'ub',  255, ... %Upper bound of the parameters to be optimized
    'ObjFun' , 'sistem', ... %Write the name of the objective function you want to maximize
    'RunTime',1); % Number of the runs 


Globalmaxs=zeros(ABCOpts.RunTime,ABCOpts.MaxCycles);

% runtime
% for r=1:ABCOpts.RunTime
    
% Initialise population
Range = repmat((ABCOpts.ub-ABCOpts.lb),[ABCOpts.ColonySize ABCOpts.Dim]);
Lower = repmat(ABCOpts.lb, [ABCOpts.ColonySize ABCOpts.Dim]);
Colony = rand(ABCOpts.ColonySize,ABCOpts.Dim) .* Range + Lower;

Employed=Colony(1:(ABCOpts.ColonySize/2),:);


%evaluate and calculate fitness
ObjEmp=feval(ABCOpts.ObjFun,Employed);
%FitEmp=calculateFitness(ObjEmp);
FitEmp=ObjEmp


