function [proceed_step2] = MA(SVM_model,norm_Metrics,Metrics,means,std,mean_exp);

Class = sum(SVM_model.ClassificationSVM.Beta' .* ((norm_Metrics-SVM_model.ClassificationSVM.Mu)/SVM_model.ClassificationSVM.KernelParameters.Scale)) + SVM_model.ClassificationSVM.Bias;
Motion1 = sum(SVM_model.ClassificationSVM.Beta(3) .* ((norm_Metrics(3)-SVM_model.ClassificationSVM.Mu(3))/SVM_model.ClassificationSVM.KernelParameters.Scale));
Motion2 = sum(SVM_model.ClassificationSVM.Beta(4) .* (norm_Metrics(4)-SVM_model.ClassificationSVM.Mu(4))/SVM_model.ClassificationSVM.KernelParameters.Scale);

proceed_step2 = 0;

%% Figures
f4=figure('Position',[6017 313 1360 768]);

f1=figure('Position',[1921 361 1365 720]);
figure(f1);subplot(6,2,[3,4]);
plot(1,1);axis off;title('Instrument Motion Assessment','FontSize',40);

% Motion 1 - Instrument Tip Distance
figure(f1);subplot(6,2,[5,7,9,11]);title('Instrument Tip Distance','FontSize',30);hold on;
patch([0,1,1,0],[0,0,10,10],[255/256,102/256,102/256]);  %red
patch([0,1,1,0],[0,0,-10,-10],[152/256,251/256,152/256]); %green
line([0,1],[0 0]);
set(findall(gca, 'Type', 'Line'),'LineWidth',4);
% line([0,1],[-1 -1],'LineStyle','--');
% line([0,1],[1 1],'LineStyle','--');
line([0,1],[mean_exp(3) mean_exp(3)],'LineStyle','--');
scatter(0.5,norm_Metrics(3),90,'o','filled','w');
ylim([-2,2]);hold on;set(gca,'XTick',[]);
if norm_Metrics(3) < -2
    h=annotation('arrow',[.3 .3],[.22 .12],'Color','w');
elseif norm_Metrics(3) > 2
    h=annotation('arrow',[.3 .3],[.5 .6],'Color','w');
end
if Motion1 > 0
    xlabel({'You are controlling both of your instruments properly!'},...
    'Color','green',...
    'FontSize',10,...
    'FontWeight','bold',...
    'HorizontalAlignment','center');
    proceed_step2 = proceed_step2+1;
else
    xlabel({'To improve, we suggest that','you try keeping both of your instruments','in closer proxemity, or use them together'},...
    'Color','red',...
    'FontSize',10,...
    'FontWeight','bold',...
    'HorizontalAlignment','center');
end


% Motion 2 - Acceleration with Bipolar
figure(f1);subplot(6,2,[6,8,10,12]);title('Acceleration w/ Bipolar','FontSize',30);hold on;
patch([0,1,1,0],[0,0,10,10],[255/256,102/256,102/256]); %red  
patch([0,1,1,0],[0,0,-10,-10],[152/256,251/256,152/256]); %green
line([0,1],[0 0]);
set(findall(gca, 'Type', 'Line'),'LineWidth',4);
% line([0,1],[-1 -1],'LineStyle','--');
% line([0,1],[1 1],'LineStyle','--');
line([0,1],[mean_exp(4) mean_exp(4)],'LineStyle','--');
scatter(0.5,norm_Metrics(4),90,'o','filled','w');
ylim([-2,2]);hold on;set(gca,'XTick',[]);
if norm_Metrics(4) < -2
    h=annotation('arrow',[.3 .3],[.22 .12],'Color','w');
elseif norm_Metrics(4) > 2
    h=annotation('arrow',[.3 .3],[.5 .6],'Color','w');
end

if Motion2 > 0
    xlabel({'You moving your bipolar correctly!'},...
    'Color','green',...
    'FontSize',10,...
    'FontWeight','bold',...
    'HorizontalAlignment','center');
    proceed_step2 = proceed_step2+1;
else
    xlabel({'To improve, we suggest that you','refrain from changing the speed of your bipolar','too quickly.','Try to make smoother changes in your instrument movements.'},...
    'Color','red',...
    'FontSize',10,...
    'FontWeight','bold',...
    'HorizontalAlignment','center');
end


%% Proceed Message
figure(f4);plot(1,1);subplot(6,2,[3,4]);axis off;title('Step 2: Feedback','FontSize',40);hold on;
subplot(6,2,[5,6,7,8,9,10,11,12]);axis off;
if proceed_step2 < 1
    text(0.5,0.7,{'We noticed that you are still struggling with both measures of',...
        'Instrument Motion assessment.',...
        'In order to move on to further steps, you need to become proficient in these components first.'},...
        'Color','b',...
        'FontSize',20,...
        'HorizontalAlignment','center');
elseif proceed_step2 < 2
    text(0.5,0.7,{'You are almost there. You still need to work on one components of Step 2.'},...
        'Color','b',...
        'FontSize',20,...
        'HorizontalAlignment','center');
elseif proceed_step2 == 2
    text(0.5,0.7,{'Congratulations! You have successfully completed the final step of training.',...
        'Remember to keep these all metrics which you have learned today in mind as you',...
        'move on to more complex scenarios.'},...
        'Color','b',...
        'FontSize',20,...
        'HorizontalAlignment','center');
end

end