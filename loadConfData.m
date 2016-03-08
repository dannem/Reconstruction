function outmat=loadConfData(sub,dataDir,typeCol,idCol,resCol);
%% this function gathers data from multiple files (sessions) of the same subject
% and agregates it into one 2D matrix with type (beggining of the trial, repetition, or 
% new identity), idenity (identity number) and response (0 for "wrong", 1 for "correct")
cd(dataDir)
dataFileName=['DN_s' num2str(sub) '*.mat'];
names=dir(dataFileName);
if isempty(names)
    error(['No subject number ' num2str(sub) ' in directory "' dataDir '" is found']);
end
outmat=[];
for i=1:length(names)
    load(names(i).name);
    outmat=[outmat;output.mat(:,[typeCol idCol resCol])];
end