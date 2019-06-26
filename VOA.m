%% Feedback - Brain Tumour NeuroVR

%% Read logs
currentlocation = cd;

cd('\\NEUROTOUCH2\Trainee\MyNeuroTouchData\Test_Sharing');
filename = dir('*_log.csv');
[~,request] = max([filename(:).datenum]); 
core = readtable(filename(request).name,'delimiter',',');
%core = readtable('SubPialResection101-KFMC_scenario.xml_2015-Jul-13_10h10m42s_log.csv','delimiter',',');

TipDistance = [core.TranslationRight_x-core.TranslationLeft_x core.TranslationRight_y-core.TranslationLeft_y core.TranslationRight_z-core.TranslationLeft_z];
TipDistance3D = sqrt(TipDistance(:,1).^2 + TipDistance(:,2).^2 + TipDistance(:,3).^2);

if contains(core.InstrumentRightHand(1), 'CUSA')
    Translation = [core.TranslationRight_x core.TranslationRight_y core.TranslationRight_z core.TranslationLeft_x core.TranslationLeft_y core.TranslationLeft_z];
    forcecusa = core.ForceFeedbackRightHand;
    forcebipolar = core.ForceFeedbackLeftHand;
else
    Translation = [core.TranslationLeft_x core.TranslationLeft_y core.TranslationLeft_z core.TranslationRight_x core.TranslationRight_y core.TranslationRight_z];
    forcebipolar = core.ForceFeedbackRightHand;
    forcecusa = core.ForceFeedbackLeftHand;
end

Velocity = diff(Translation);
Velocity3D = [sqrt(Velocity(:,1).^2 + Velocity(:,2).^2 + Velocity(:,3).^2) sqrt(Velocity(:,4).^2 + Velocity(:,5).^2 + Velocity(:,6).^2)];
Acceleration3D = abs(diff(Velocity3D));

meanTipDistance3D = mean(TipDistance3D);
maxForceBipolarHand = max(forcebipolar);
meanTotalBloodEmittedDr = mean(diff(core.BloodEmittedFrame));
meanAcceleration3DBipolar = mean(Acceleration3D(:,2));

%% Load sounds
% cd 'D:\MCGILL PRO\Desktop\Nykan Code\AI_Feedback\Instructions';
% soundName = dir('*');
% for i=3
%     [soundp,fs] = audioread(soundName(i).name);
% end


cd(currentlocation)

%% Metric Generation
Metric1=maxForceBipolarHand;
Metric2=meanTotalBloodEmittedDr;
Metric3=meanTipDistance3D;
Metric4=meanAcceleration3DBipolar;

Metrics = [Metric1 Metric2 Metric3 Metric4];

%% Classification
% normalise
means = [0.89493 0.0000177099 9.982608 0.041028];
std = [0.18175 0.0000139646 3.609504 0.012272];

for i=1:4
    norm_Metrics(i) = (Metrics(i) - means(i)) / std(i);
end

Metricstab = table(norm_Metrics);
Metricstab.Properties.VariableNames={'percentSVM2groups'};
if trainedModel.predictFcn(Metricstab) == 0
    class = 'Novice';
elseif trainedModel.predictFcn(Metricstab) == 1
    class = 'Skilled';
end




%% Classification
% transform to sigmoid function
%[ScoreCVSVMModel,ScoreParameters] = fitSVMPosterior(trainedModel.ClassificationSVM);
close all;
mean_exp = [-0.5116 -0.29702 -0.54663 -0.39348];
[label,score] = predict(ScoreCVSVMModel,norm_Metrics);

NeuroSimColor = [26/256,55/256,91/256];
f1=figure('Position',[1921 361 1365 720]);
figure(f1);
subplot(7,2,[3,4]);plot(1,1);axis off;title('THE VIRTUAL OPERATIVE ASSISTANT','HorizontalAlignment','center','FontSize',45)
subplot(7,2,[5,6]);plot(1,1);axis off;title('Scenario: Subpial Tumour Resection, NeuroVR','Fontsize',30);
subplot(7,2,[9,10]);plot(1,1);axis off;title('Your performance:','Fontsize',40);
Exp_percentage = mat2str(score(2)*100);
Nov_percentage = mat2str(score(1)*100);
if label==0
    subplot(7,2,[11,12]);hold on;
    plot(1,1);axis off;
    text(0.65,-1,'Skilled','FontSize',30,'Color','g');
    text(1.05,-1,{strcat(Exp_percentage(1:4),'%')},'FontSize',30);
    text(0.5,3,'Novice','FontSize',45,'Color','r');
    text(1.05,3,{strcat(Nov_percentage(1:4),'%')},'FontSize',45);
elseif label==1
    subplot(7,2,[11,12]);hold on;
    plot(1,1);axis off;
    text(0.5,3,'Skilled','FontSize',45,'Color','g');
    text(1.05,3,{strcat(Exp_percentage(1:4),'%')},'FontSize',45);
    text(0.65,-1,'Novice','FontSize',30,'Color','r');
    text(1.05,-1,{strcat(Nov_percentage(1:4),'%')},'FontSize',30);
end
% subplot(6,2,[11,]);
% plot(1,1);axis off;title('with a confidence of','FontSize',35);
% if label==0 %if novice
%     subplot(6,2,[9,10]);
%     plot(1,1);axis off;title(score(1),'FontSize',40);
% elseif label==1 %if expert
%     subplot(6,2,[9,10]);
%     plot(1,1);axis off;title(score(2),'FontSize',40);
% end

f4=figure('Position',[6017 313 1360 768]);
figure(f4);plot(1,1);axis off;text(1,1,{'Press any key to see your','individualized metric assessment'},...
        'Color','b',...
        'FontSize',45,...
        'HorizontalAlignment','center');
waitforbuttonpress;
close all;
% Step 1: Safety Assessment
[proceed] = SA(trainedModel,norm_Metrics,Metrics,means,std,mean_exp);
w=waitforbuttonpress; 
if w==1
    if proceed < 2
%         return;
%         close all;
    elseif proceed == 2
    end
end

% Step 2: Motion Assessment
[proceed2] = MA(trainedModel,norm_Metrics,Metrics,means,std,mean_exp);
w2=waitforbuttonpress;
close all;

