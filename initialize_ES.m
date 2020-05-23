%
% Copyright 2017 Max Planck Society. All rights reserved.
% 
% Alonso Marco
% Max Planck Institute for Intelligent Systems
% Autonomous Motion Department
% amarco(at)tuebingen.mpg.de
%
function specs = initialize_ES()
    
    % Constraints defining search space (DIM):
        % specs.xmin = [0 0 0 0]; specs.xmax = [1 1 1 1];
        % specs.xmin = [0 0 0]; specs.xmax = [1 1 1];
        % specs.xmin = [0 0]; specs.xmax = [1 1];
        specs.xmin = 0; specs.xmax = 1;

    % Maximum number of evaluations allowed:
        specs.MaxEval = 15;    % Horizon (number of evaluations allowed)
        
	% Weights trade-off between simulation and real system:
        t_simu = 10; t_real = 30; % With std_tot = 1; fac_ = 0.6;
        weight_simu = 1/t_simu; weight_real = 1/t_real;
        specs.trade_off_weights = [weight_simu;weight_real];
        
    % Saving path:
        specs.path2store = get_saving_name('results','MF_ES_synth');
        mkdir(specs.path2store);
                
    % Plotting position:
        specs.plot_position = [32 80 1500 680];

    % Plotting?
        specs.plotting_general = true;
        
    % Load the rest of default options:
        specs = load_default_ES_options(specs);
        
    % Prepare GP:
        specs.GP = initialize_GP(specs);
        
	% Function to get data from; specs.f is a function handle:
        specs.f = construct_synthetic_cost(specs.GP.hyp.lik);
        
    % Plot true function:
        specs.plot_true_function = true;

	% Get underlying function:
    if specs.plot_true_function && specs.D <=2
        for k = 1:specs.Nbel
            specs.f_true(k)    = specs.f(specs.z_plot(k,:),'in_real');
        end
    end

    % Other stuff:
    specs = other_stuff(specs);

end


%%%%

function specs_out = other_stuff(specs)

% Copy specs structure:
    specs_out = specs;

    % Which method:
        specs_out.which_method = 'iES';

    % Debug mode:
        specs_out.dbg = 0;

   % Use the iES:
        specs_out.delta_flag = [];
        
    % Hide/show plots:
        specs_out.show_plots.exploration = 'on';

    % Stoping criterion: set to true if you want to use any:
        bg_loc = false; bg_value = false; n_exp = false; 
        specs_out  = activate_stopping_criterions(specs_out,bg_loc,bg_value,n_exp);
    
    % Plotting performance viewer:
        plotting_perf = false;
        specs_out.perfplots_opts = define_performance_plots_opts(specs_out,plotting_perf);

end

function specs_out = activate_stopping_criterions(specs,bg_loc,bg_value,n_exp)

% Copy specs structure:
    specs_out = specs;

% Stoping criterion: set to true if you want to use any
    specs_out.stopcrit.bg_loc   = bg_loc;
    specs_out.stopcrit.bg_value = bg_value;
    specs_out.stopcrit.n_exp    = n_exp;

% Stopping criterion options:
    if specs_out.stopcrit.bg_loc
        specs_out.stopcrit_opts.bg_loc      = define_stopcrit_opts_bg_loc(specs_out);
    end

    if specs_out.stopcrit.bg_value
        specs_out.stopcrit_opts.bg_value    = define_stopcrit_opts_bg_value(specs_out);
    end

    if specs_out.stopcrit.n_exp
        specs_out.stopcrit_opts.n_exp       = define_stopcrit_opts_n_exp(specs_out);
    end

end


function opts = define_stopcrit_opts_bg_loc(specs)

    % Best guess location:
    opts.Neval_static     = 2;
    opts.ellipsoid_axes   = specs.GP.l_small'/1;
    opts.Nbg_test         = 1; % Number of best guess tests
    opts.f                = specs.f;
    opts.noise_thres      = 2 * exp(specs.GP.hyp.lik);
    opts.Jheur_thres      = +Inf;
    opts.std_bg_thres     = 1/2 * 0.3;
    opts.xmin             = specs.xmin;
    opts.xmax             = specs.xmax;
    opts.draw_ellipsoid   = specs.D == 2; % It only make sense to draw the ellipsoid in the 2D case
    opts.which_method     = specs.which_method;

end

function opts = define_stopcrit_opts_bg_value(specs)

    % Best guess value:
    opts.Neval_static     = 3;
    opts.Nbg_test         = 1; % Number of best guess tests
    opts.f                = specs.f;
    % opts.Jheur_thres      = 1/3 * ( specs.GP.hyp.mean(1)  + specs.GP.hyp.mean(2) );
    opts.Jheur_thres      = +Inf;
    opts.std_bg_thres     = 0.009797958971133;
    opts.m_bg_range       = opts.std_bg_thres/2;
    opts.which_method     = specs.which_method;

end


function opts = define_stopcrit_opts_n_exp(specs)

    % Maximum number of experiments:
    opts.Nexp_max         = 3;
    opts.Nbg_test         = 1; % Number of best guess tests
    opts.f                = specs.f;
    opts.which_method     = specs.which_method;

end

function opts = define_performance_plots_opts(specs,plotting)

    opts.plot = plotting;

    opts.which_method           = specs.which_method;
    opts.D                      = specs.D;
    % opts.ylim                   = [0 0.07];
    opts.splot.evals            = 1;
    opts.splot.bestguess        = 2;
    opts.splot.bg_loc_dim1      = 3;
    opts.splot.struct           = [3 1];
    if specs.D == 2
        opts.splot.bg_loc_dim2  = 4;
        opts.splot.struct       = [4 1];
    end
    opts.MaxEvals               = specs.MaxEval;
    opts.fig_position           = [17 150 1396 623];
    opts.update_performance_plots  = @update_performance_plots;

end
