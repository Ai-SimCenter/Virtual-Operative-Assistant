function [proceed_step1] = SA(SVM_model,norm_Metrics,Metrics,means,std,mean_exp);

Class = sum(SVM_model.ClassificationSVM.Beta' .* ((norm_Metrics-SVM_model.ClassificationSVM.Mu)/SVM_model.ClassificationSVM.KernelParameters.Scale)) + SVM_model.ClassificationSVM.Bias;
Safety1 = sum(SVM_model.ClassificationSVM.Beta(1) .* ((norm_Metrics(1)-SVM_model.ClassificationSVM.Mu(1))/SVM_model.ClassificationSVM.KernelParameters.Scale));
Safety2 = sum(SVM_model.ClassificationSVM.Beta(2) .* ((norm_Metrics(2)-SVM_model.ClassificationSVM.Mu(2))/SVM_model.ClassificationSVM.KernelParameters.Scale));

proceed_step1 = 0;

%% Figures
f4=figure('Position',[6017 313 1360 768]);

f1=figure('Position',[1921 361 1365 720]);
figure(f1);subplot(6,2,[3,4]);
plot(1,1);axis off;title('Safety Assessment','FontSize',40);

% Safety 1 - Max Force Bipolar
figure(f1);subplot(6,2,[5,7,9,11]);title('Max Force w/ Bipolar','FontSize',30);hold on;
patch([0,1,1,0],[0,0,10,10],[255/256,102/256,102/256]);  
patch([0,1,1,0],[0,0,-10,-10],[152/256,251/256,152/256]);
line([0,1],[0 0]);
set(findall(gca, 'Type', 'Line'),'LineWidth',4);
% line([0,1],[-1 -1],'LineStyle','--');
% line([0,1],[1 1],'LineStyle','--');
line([0,1],[mean_exp(1) mean_exp(1)],'LineStyle','--');
scatter(0.5,norm_Metrics(1),90,'o','filled','w');
ylim([-2,2]);hold on;set(gca,'XTick',[]);
if norm_Metrics(1) < -2
    h=annotation('arrow',[.3 .3],[.22 .12],'Color','w');
elseif norm_Metrics(1) > 2
    h=annotation('arrow',[.3 .3],[.5 .6],'Color','w');
end
if Safety1 > 0
    xlabel({'Your bipolar forces are in the proficiency zone!'},...
    'Color','green',...
    'FontSize',12,...
    'FontWeight','bold',...
    'HorizontalAlignment','center');
    proceed_step1 = proceed_step1+1;
else
    xlabel({'To improve, try reducing','the amount of force you','apply with your bipolar'},...
    'Color','red',...
    'FontSize',12,...
    'FontWeight','bold',...
    'HorizontalAlignment','center');
end


% Safety 2 - Rate of Bleeding
figure(f1);subplot(6,2,[6,8,10,12]);title('Rate of Bleeding','FontSize',30);hold on;
patch([0,1,1,0],[0,0,10,10],[255/256,102/256,102/256]);  
patch([0,1,1,0],[0,0,-10,-10],[152/256,251/256,152/256]);
line([0,1],[0 0]);
set(findall(gca, 'Type', 'Line'),'LineWidth',4);
% line([0,1],[-1 -1],'LineStyle','--');
% line([0,1],[1 1],'LineStyle','--');
line([0,1],[mean_exp(2) mean_exp(2)],'LineStyle','--');
scatter(0.5,norm_Metrics(2),90,'o','filled','w');
ylim([-2,2]);hold on;set(gca,'XTick',[]);
if norm_Metrics(2) < -2
    h=annotation('arrow',[.3 .3],[.22 .12],'Color','w');
elseif norm_Metrics(2) > 2
    h=annotation('arrow',[.3 .3],[.5 .6],'Color','w');
end

if Safety2 > 0
    xlabel({'You are controlling bleeding properly.'},...
    'Color','green',...
    'FontSize',12,...
    'FontWeight','bold',...
    'HorizontalAlignment','center');
    proceed_step1 = proceed_step1+1;
else
    xlabel({'To improve, try reducing the rate','of bleeding by using your suction to','control bleeding as soon as you notice it.'},...
    'Color','red',...
    'FontSize',12,...
    'FontWeight','bold',...
    'HorizontalAlignment','center');
end


%% Proceed Message
figure(f4);plot(1,1);subplot(6,2,[3,4]);axis off;title('Step 1: Feedback','FontSize',40);hold on;
subplot(6,2,[5,6,7,8,9,10,11,12]);axis off;
if proceed_step1 < 1
    text(0.5,0.7,{'We noticed that you are still struggling with both measures of',...
        'Safety assessment.',...
        'In order to move on to further steps, you need to become proficient in these components first.'},...
        'Color','b',...
        'FontSize',20,...
        'HorizontalAlignment','center');
elseif proceed_step1 < 2
    text(0.5,0.7,{'You are almost there. You still need to work on one components of Step 1.'},...
        'Color','b',...
        'FontSize',20,...
        'HorizontalAlignment','center');
elseif proceed_step1 == 2
    text(0.5,0.7,{'You have successfully completed the first step of training.',...
        'Remember to keep these Safety metrics in mind as you move on to next steps.',...
        'Press any key to move on to the next step.'},...
        'Color','b',...
        'FontSize',20,...
        'HorizontalAlignment','center');
end

end