%
% Copyright 2017 Max Planck Society. All rights reserved.
% 
% Alonso Marco
% Max Planck Institute for Intelligent Systems
% Autonomous Motion Department
% amarco(at)tuebingen.mpg.de
%
function GP = initialize_GP(specs)

    % Create GP structure:
        GP = struct;
        
    % Covariance function:
        GP.covfunc       = construct_ker_bivariate({@covRQard},{@covRQard});
        GP.covfunc_dx    = construct_dx_ker_bivariate({@covRQard_dx_MD},{@covRQard_dx_MD},{@covRQard});
        
        % Simulator hyperparameters (DIM):
            ls = 0.2;
            % ls = [0.1 0.1];
            % ls = [0.1 0.1 0.1];
            % ls = [0.1 0.1 0.1 0.1];
            ls = reshape(ls,[length(ls),1]);
            std_tot = 1;
            fac_ = 0.6;
            std_s = std_tot * fac_;
            
        % Error hyperparameters (DIM):
            le = 0.2;
            % le = [0.1 0.1];
            % le = [0.1 0.1 0.1];
            % le = [0.1 0.1 0.1 0.1];
            le = reshape(le,[length(le),1]);
            std_e = std_tot * sqrt(1-fac_^2);
            
        % Parameter alpha for the RQ kernel (DIM):
            % alph = 0.5; % 1D
            alph = 0.25; % 2D
        
        % Cov. function hyperparameters (in this order):
            hyp.cov.c1 = log([ls;std_s;alph]); 
            hyp.cov.c2 = log([le;std_e;alph]); 
    
    % Likelihood function:
        GP.likfunc = @likGauss;
        std_n_s = 0.001;
        std_n_r = 0.05;
        std_n_e = sqrt(std_n_r^2-std_n_s^2); % used
        hyp.lik.c1 = log(std_n_s); % std of the simulated function
        hyp.lik.c2 = log(std_n_e); %std of the error function
        
    % Mean function:
        GP.mean      = construct_meanBivariate({@meanConst},{@meanConst});
        GP.mean_dx   = construct_dx_meanBivariate({@meanConst_dx_MD},{@meanConst_dx_MD},{@meanConst});
        hyp.mean.c1   = 0.0;
        hyp.mean.c2   = 0.0;
        
    % Dimensions:
        hyp.cov.D_euc = specs.D;
        hyp.lik.D_euc = specs.D;
        hyp.mean.D_euc = specs.D;

    % Include the hyperparameters:
        GP.hyp     	= hyp;
        
    % Empty set of initial evaluations:
        % GP.x          = [0.1 0;0.8 1];
        % GP.y          = [-1.0187;-0.3357]; % old
        % GP.y          = [-0.8031;-0.3357]; % new
        % GP.delta      = logical([0;1]);
        GP.x        = [];
        GP.y        = [];
        GP.delta    = [];
        
    % Relevant variables:
        GP = add_relevant_variables(GP,specs);
        
    % Smaller lengthscale, to update the best guesses list:
        [~,which_ell] = min([norm(ls),norm(le)]);
        if which_ell == 1
            GP.l_small = ls;
        elseif which_ell == 2
            GP.l_small = le;
        end
        
end

function GP = add_relevant_variables(GP,specs)

    % Number of dimensions:
        GP.D        = specs.D;
        
	% Add a vector of test locations to plot in:
        GP.z_plot   = specs.z_plot;
        
    % Location of representer points:
        GP.z     	= specs.z;
        
    % Other variables needed for ES:
        GP.deriv    = specs.with_deriv;
        GP.res    	= 1;
        GP.poly  	= specs.poly;
        GP.log     	= specs.log;

end

