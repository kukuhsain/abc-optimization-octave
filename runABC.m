%%%%%ARTIFICIAL BEE COLONY ALGORITHM%%%%

clear all
close all
clc


% sistem
global p

	inp = imread('cameraman.png');
	gray = rgb2gray(inp);
	dim = size(gray);

	filt = fspecial('average',[3,3]);
	avgfilt = filter2(filt, gray, 'valid');
	avgim = uint8(avgfilt);

	hist1 = imhist(gray);
	hist2 = imhist(avgim);

	histo = hist1*hist2';
	show = histo/(255^2);
	ishow = uint8(show);

	p = histo/(dim(1,1) * dim(1,2));

% end of sistem


% Set ABC Control Parameters
% Parameter initialization
ABCOpts = struct( 'ColonySize',  10, ...   % Number of Employed Bees+ Number of Onlooker Bees 
    'MaxCycles', 200,...   % Maximum cycle number in order to termaxate the algorithm
    %'ErrGoal',     1e-20, ...  % Error goal in order to termaxate the algorithm (not used in the code in current version)
    'Dim',       2 , ... % Number of parameters of the objective function   
    'Limit',   100, ... % Control paramter in order to abandone the food source 
    'lb',  1, ... % Lower bound of the parameters to be optimized
    'ub',  255, ... %Upper bound of the parameters to be optimized
    'ObjFun' , 'sistem', ... %Write the name of the objective function you want to maximize
    'RunTime',1); % Number of the runs 


Globalmaxs=zeros(ABCOpts.RunTime,ABCOpts.MaxCycles);

% runtime
for r=1:ABCOpts.RunTime
    
% Initialise population
Range = repmat((ABCOpts.ub-ABCOpts.lb),[ABCOpts.ColonySize ABCOpts.Dim]);
Lower = repmat(ABCOpts.lb, [ABCOpts.ColonySize ABCOpts.Dim]);
Colony = rand(ABCOpts.ColonySize,ABCOpts.Dim) .* Range + Lower;

Employed=Colony(1:(ABCOpts.ColonySize/2),:);


%evaluate and calculate fitness
ObjEmp=feval(ABCOpts.ObjFun,Employed);
%FitEmp=calculateFitness(ObjEmp);
FitEmp=ObjEmp;



%set initial values of Bas
Bas=zeros(1,(ABCOpts.ColonySize/2));


Globalmax=ObjEmp(find(ObjEmp==max(ObjEmp),end)); %%%%% max
GlobalParams=Employed(find(ObjEmp==max(ObjEmp),end),:); %%%%% max

Cycle=1;
while ((Cycle <= ABCOpts.MaxCycles)),
    
    %%%%% Employed phase
    Employed2=Employed;
    for i=1:ABCOpts.ColonySize/2
        Param2Change=fix(rand*ABCOpts.Dim)+1;
        neighbour=fix(rand*(ABCOpts.ColonySize/2))+1;
            while(neighbour==i)
                neighbour=fix(rand*(ABCOpts.ColonySize/2))+1;
            end;
        Employed2(i,Param2Change)=Employed(i,Param2Change)+(Employed(i,Param2Change)-Employed(neighbour,Param2Change))*(rand-0.5)*2;
         if (Employed2(i,Param2Change)<ABCOpts.lb)
             Employed2(i,Param2Change)=ABCOpts.lb;
         end;
        if (Employed2(i,Param2Change)>ABCOpts.ub)
            Employed2(i,Param2Change)=ABCOpts.ub;
        end;
        
end;   

    ObjEmp2=feval(ABCOpts.ObjFun,Employed2);
    %FitEmp2=calculateFitness(ObjEmp2);
    FitEmp2=ObjEmp2;
	[Employed ObjEmp FitEmp Bas]=GreedySelection(Employed,Employed2,ObjEmp,ObjEmp2,FitEmp,FitEmp2,Bas,ABCOpts);
    
    %Normalize
    NormFit=FitEmp/sum(FitEmp);
    
    %%% Onlooker phase  
Employed2=Employed;
i=1;
t=0;
while(t<ABCOpts.ColonySize/2)
    if(rand<NormFit(i))
        t=t+1;
        Param2Change=fix(rand*ABCOpts.Dim)+1;
        neighbour=fix(rand*(ABCOpts.ColonySize/2))+1;
            while(neighbour==i)
                neighbour=fix(rand*(ABCOpts.ColonySize/2))+1;
            end;
         Employed2(i,:)=Employed(i,:);
         Employed2(i,Param2Change)=Employed(i,Param2Change)+(Employed(i,Param2Change)-Employed(neighbour,Param2Change))*(rand-0.5)*2;
         if (Employed2(i,Param2Change)<ABCOpts.lb)
             Employed2(i,Param2Change)=ABCOpts.lb;
         end;
        if (Employed2(i,Param2Change)>ABCOpts.ub)
            Employed2(i,Param2Change)=ABCOpts.ub;
         end;
    ObjEmp2=feval(ABCOpts.ObjFun,Employed2);
    %FitEmp2=calculateFitness(ObjEmp2);
	FitEmp2=ObjEmp2;	    
	[Employed ObjEmp FitEmp Bas]=GreedySelection(Employed,Employed2,ObjEmp,ObjEmp2,FitEmp,FitEmp2,Bas,ABCOpts,i);
   
   end;
    
    i=i+1;
    if (i==(ABCOpts.ColonySize/2)+1) 
        i=1;
    end;   
end;
    
    
    %%%Memorize Best
 CycleBestIndex=find(FitEmp==max(FitEmp));
 CycleBestIndex=CycleBestIndex(end);
 CycleBestParams=Employed(CycleBestIndex,:);
 Cyclemax=ObjEmp(CycleBestIndex);
 
 if Cyclemax>Globalmax 
       Globalmax=Cyclemax;
       GlobalParams=CycleBestParams;
 end
 
 Globalmaxs(r,Cycle)=Globalmax;
 
 %% Scout phase
 ind=find(Bas==max(Bas));
ind=ind(end);
if (Bas(ind)>ABCOpts.Limit)
Bas(ind)=0;
Employed(ind,:)=(ABCOpts.ub-ABCOpts.lb)*(0.5-rand(1,ABCOpts.Dim))*2;%+ABCOpts.lb;
%message=strcat('burada',num2str(ind))
end;
ObjEmp=feval(ABCOpts.ObjFun,Employed);
%FitEmp=calculateFitness(ObjEmp);
FitEmp=ObjEmp;    


    fprintf('Cycle=%d ObjVal=%g\n',Cycle,Globalmax);
    
    Cycle=Cycle+1;

end % End of ABC

end; %end of runs

semilogy(mean(Globalmaxs))
title('Mean of Best function values');
xlabel('cycles');
ylabel('error');
fprintf('Mean =%g Std=%g\n',mean(Globalmaxs(:,end)),std(Globalmaxs(:,end)));
  
