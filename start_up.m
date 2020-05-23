%
% Copyright 2017 Max Planck Society. All rights reserved.
% 
% Alonso Marco
% Max Planck Institute for Intelligent Systems
% Autonomous Motion Department
% amarco(at)tuebingen.mpg.de
%
function start_up

    % Reset the path to the one that MAtlab loads automatically at the
    % begining of the session:
    path(pathdef);

    % Start the Entropy Search library:
    library_path = start_ESlib;
    
    % Start the GPML library:
    start_GPML;
    
    % Add the evaluation function to the path:
    addpath([pwd '/evaluation_functions/']);
    
    % Put the library extension above everything else, so that the
    % corresponding files get chosen:
    addpath([library_path '/libext']);
    addpath([library_path '/libext/utils']);
    addpath([library_path '/libext/plotting']);
end