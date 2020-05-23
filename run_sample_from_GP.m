%
% Simulator VS Experiments: Synthetic cost function
% Entropy Search library (ESlib)
%
% =========================================================================
% Entropy Search
%
% Copyright 2016 Max Planck Society. All rights reserved.
% 
% Alonso Marco
% Max Planck Institute for Intelligent Systems
% Autonomous Motion Department
% amarco(at)tuebingen.mpg.de
%
% Revision history
% First version: 04.12.2016

%% Initialization:
    close all; clear all; clc;
    
%% Prepare ES:
    specs = initialize_ES();
    
%% Prepare:

    in_simu = 0; in_real = 1;

    % Grid:
    specs.Ns = 10;
    Ws = randn(specs.Nbel^specs.D * 2,specs.Ns);

    % Prediction:
    ztest = [specs.z_plot in_simu * ones(specs.Nbel^specs.D,1);...
             specs.z_plot in_real * ones(specs.Nbel^specs.D,1)];

    % Get Gramm Matrix:
    [mpost,vpost,~] = get_posterior(specs.GP,ztest,[],[]);
     
%% Get samples:

    % Get a sample from the multivariate Gaussian:
    std_post_mat = chol(chol_fix(vpost));
    sample = bsxfun(@plus,mpost,std_post_mat' * Ws);

    % Separate the samples:
    sample_simu = sample(1:specs.Nbel^specs.D,:);
    sample_real = sample(specs.Nbel^specs.D+1:end,:);
    
%% Plotting 1D:

    % Plotting variables:
    global GP_plot;
    GP_plot = struct;
    GP_plot.iter_n = 1;
    [fig_hdl,axes_hdl] = specs.initialize_plots(specs.GP,specs);
    update_plot(fig_hdl,axes_hdl);
    
    % Attributes:
	simu_color        = [65,105,225]/255; % blueish
	real_color        = [205,92,92]/255;
    
    % Plot samples:
    figure(fig_hdl);
    subplot(axes_hdl.gp);
    hold on;
    for k = 1:specs.Ns
        plot(specs.z_plot,sample_real(:,k),'Color',real_color,'linestyle','--','linewidth',1);
    end
    
%% Saving 1D:

    x_drawn_vec = specs.z_plot;
    for k = 1:specs.Ns
        which_fun = ['fun' num2str(k)];
        f_synthetic.(which_fun) = construct_synthetic_cost(specs.GP.hyp.lik,sample_real(:,k),sample_simu(:,k),x_drawn_vec);
    end

%     save('evaluation_functions/synthetic_function_1D_lots.mat','f_synthetic','x_drawn_vec');

%% Plotting 2D:

% 	simu_color        = [65,105,225]/255; % blueish
% 	real_color        = [205,92,92]/255;
% 
%     figure;
%     X_grid = reshape(specs.z_plot(:,1),[specs.Nb specs.Nb]);
%     Y_grid = reshape(specs.z_plot(:,2),[specs.Nb specs.Nb]);
%     Z_simu = reshape(sample_simu,[specs.Nb specs.Nb]);
%     Z_real = reshape(sample_real,[specs.Nb specs.Nb]);
%     hdl_surf.simu = surf(X_grid,Y_grid,Z_simu,'FaceColor',simu_color,'EdgeColor',flip([1.0 0.702 0.855]),'FaceAlpha',0.4);
%     hold on;
%     hdl_surf.real = surf(X_grid,Y_grid,Z_real,'FaceColor',real_color,'EdgeColor',flip([1.0 0.702 0.855]),'FaceAlpha',0.4);
    
%% Saving 2D:

%     x_drawn_vec = Z_real;
%     for k = 1:specs.Ns
%         which_fun = ['fun' num2str(k)];
%         f_synthetic.(which_fun) = construct_synthetic_cost(specs.GP.hyp.lik,sample_real(:,k),sample_simu(:,k),x_drawn_vec);
%     end
% 
%     f_synthetic_real    = @(x) interp2(X_grid,Y_grid,Z_real,x(1),x(2));
%     f_synthetic_simu    = @(x) interp2(X_grid,Y_grid,Z_simu,x(1),x(2));
%     x_drawn_vec         = specs.z_plot;

%     save('evaluation_functions/synthetic_function_2D.mat','f_synthetic_real','f_synthetic_simu','x_drawn_vec');
    