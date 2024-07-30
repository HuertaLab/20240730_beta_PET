clear 
close all
clc

%% Load data

addpath('/Users/jstrohl/Desktop/20231108 Strohl Sepsis fear network/materials/')
[num,txt,raw] = xlsread('20240519 PET LS data for ML.xlsx')

%% Import data

group = categorical(raw(2:end,1));
pet_data = cell2mat(raw(2:end,4:end));
pet_labels = raw(3:end);

% Label dataset
true_labels = double(group == "LS");  % 0 for control, 1 for experimental

% True data
labels = true_labels;

% scramble data
% rng("default")
% labels = true_labels(randperm(length(true_labels)));

%% Leave-one-out cross validation loop

% Pre-allocate variables
n_mice = size(pet_data, 1);
mdl_predicted = zeros(n_mice, 1);
mdl_scores = cell(n_mice,1);

 
for i = 1:n_mice
    % Separate one mouse for validation
    test_pet_data = pet_data(i, :);
    
    % Use the remaining mice for training
    trainingData = pet_data([1:i-1,i+1:end],:);
    trainingLabels = labels([1:i-1,i+1:end]);

    % randomness
    rng("default")

    % Fit classification models

    % Fit the logistic regression model
    mdl = fitclinear(trainingData, trainingLabels,'Solver','sparsa',...
        'OptimizeHyperparameters','all','HyperparameterOptimizationOptions',...
        struct('Optimizer','bayesopt','AcquisitionFunctionName','expected-improvement-plus'));
    [mdl_predicted(i),mdl_scores{i}] = predict(mdl,test_pet_data);

end

%% Confusion matrix

% confustion matrix 
llr_confusionmatrix = confusionmat(true_labels, mdl_predicted);

% accuracy 
llr_accuracy = sum(diag(llr_confusionmatrix)) / sum(llr_confusionmatrix(:));

figure
cchart = confusionchart(true_labels,mdl_predicted)

% Normalize the confusion matrix
cchart.Normalization = 'row-normalized';

% Customize the title and labels
cchart.Title = 'Normalized Confusion Matrix';
cchart.XLabel = 'Predicted Labels';
cchart.YLabel = 'True Labels';

% Customize the cell labels to show percentages
cchart.CellLabelFormat = '%.2f%%';


%% ROC curves

% Iterations and threshold 
n_iter = 1000;
threshold = linspace(0,1,n_iter);

% ROC curve for llr

llr_probabilities = cell2mat(mdl_scores);
llr_TPR = zeros(1,n_iter);
llr_FPR = zeros(1,n_iter);
for i = 1:n_iter
    predicted = llr_probabilities(:,2)>threshold(i);
    llr_TPR(i) = sum(true_labels==1 & predicted==true_labels) ./ sum(true_labels==1);
    llr_FPR(i) = sum(true_labels==0 & predicted~=true_labels) ./ sum(true_labels==0);
end

figure
plot(llr_FPR,llr_TPR,'-k','LineWidth',4)
title('Linear logistic regression ROC curve','FontSize',18)
ylabel('True positive rate','FontSize',14)
xlabel('False positive rate','FontSize',14)
axis([0,1,0,1])

