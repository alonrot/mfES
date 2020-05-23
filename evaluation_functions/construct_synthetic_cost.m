% Copyright 2020 Max Planck Society. All rights reserved.
% 
% Author: Alonso Marco Valle (amarcovalle/alonrot) amarco(at)tuebingen.mpg.de
% Affiliation: Max Planck Institute for Intelligent Systems, Autonomous Motion
% Department / Intelligent Control Systems
% 
% This file is part of mfES.
% 
% mfES is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by the Free
% Software Foundation, either version 3 of the License, or (at your option) any
% later version.
% 
% mfES is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
% FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
% details.
% 
% You should have received a copy of the GNU General Public License along with
% mfES.  If not, see <http://www.gnu.org/licenses/>.
%
%
function J = construct_synthetic_cost(hyp_lik,f_real,f_simu,x_drawn_vec)

    if nargin == 1

        % Load pre-computed synthetic functions:
        switch hyp_lik.D_euc
            case 1
                load('synthetic_function_1D');
            case 2
                load('synthetic_function_2D');
            otherwise
                J = @(th,flag_new_meas) sum(th.^2);
                return;
        end
        
    else
        
        switch hyp_lik.D_euc
            
            case 1
                
                f_synthetic_real = @(x)interp1(x_drawn_vec,f_real,x);
                f_synthetic_simu = @(x)interp1(x_drawn_vec,f_simu,x);
                
            case 2
                
                X_grid = reshape(x_drawn_vec(:,1),[specs.Nb specs.Nb]);
                Y_grid = reshape(x_drawn_vec(:,2),[specs.Nb specs.Nb]);
                
                f_synthetic_real = @(x)interp2(X_grid,Y_grid,f_real,x(1),x(2));
                f_synthetic_simu = @(x)interp2(X_grid,Y_grid,f_simu,x(1),x(2));

            otherwise
                J = @(th,flag_new_meas) sum(th.^2);
                return;
        end
        
    end
    
    % Actual functions:
    J = @(th,flag_new_meas) get_J(th,flag_new_meas,f_synthetic_real,f_synthetic_simu,x_drawn_vec,hyp_lik);

end

function J_val = get_J(th,flag_new_meas,f_synthetic_real,f_synthetic_simu,x_drawn_vec,hyp_lik)

    % Error checking:
    error_checking(th,x_drawn_vec);

    % Get likelihood noise:
    if isfield(hyp_lik,'c1') || isfield(hyp_lik,'c2') % Simu + experiments
        std_n_s = exp(hyp_lik.c1);
        std_n_e = exp(hyp_lik.c2);
        std_n_r = sqrt(std_n_s^2+std_n_e^2); % used
    else % Only experiments
        std_n_r = exp(hyp_lik);
    end

    
    % Evaluate:
    switch flag_new_meas
        case 'in_real'
            J_val = f_synthetic_real(th);% + std_n_r * randn;
        case 'in_simu'
            J_val = f_synthetic_simu(th);% + std_n_s * randn;
    end

end

function error_checking(th,x_drawn_vec)

    % Get euclidean dimension:
    D_euc = size(x_drawn_vec,2);

    % Error checking:
    error_msg = ['The input space can only be of dimension ' num2str(D_euc)];
    if size(th,2) ~= D_euc
        error(error_msg);
    end

    error_msg = 'The requested th is out of the limits where J(th) is defined';
    if any( th < x_drawn_vec(1,:) ) || any( th > x_drawn_vec(end,:) )
        error(error_msg);
    end

end