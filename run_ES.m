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
    
%% Run ES:
    out = EntropySearch(specs);
    