%
% Vanilla Entropy Search: run Entropy Search for a simple case using the
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
    
%% Run ES:

    % Load set of functions:
    load('evaluation_functions/synthetic_function_1D_lots.mat');

    Nruns = length(fieldnames(f_synthetic_real_struct));
    out_vec = cell(Nruns,1);
    f_real_vec = zeros(specs.Nbel,1);
    f_simu_vec = zeros(specs.Nbel,1);
    for k = 1:Nruns
        
        % Select field:
        which_field = ['fun' num2str(k)];
        
        % Select a different evaluation function:
        f_real = f_synthetic_real_struct.(which_field);
        f_simu = f_synthetic_simu_struct.(which_field);

        % Get the vectors:
        for ii = 1:specs.Nbel
            f_real_vec(ii) = f_real(specs.z_plot(ii,:));
            f_simu_vec(ii) = f_simu(specs.z_plot(ii,:));
        end
        
        specs.f = construct_synthetic_cost(specs.GP.hyp.lik,f_real_vec,f_simu_vec,x_drawn_vec);
        
        % Get underlying function:
        specs.f_true = f_real_vec;
        % for ii = 1:specs.Nbel
        %     specs.f_true(ii)    = specs.f(specs.z_plot(ii,:));
        % end
        
        out_vec{k} = EntropySearch(specs);
    end
    