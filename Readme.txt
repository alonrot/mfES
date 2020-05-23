Copyright 2017 Max Planck Society. All rights reserved.

Alonso Marco
Max Planck Institute for Intelligent Systems
Autonomous Motion Department
amarco(at)tuebingen.mpg.de

----

Multi Fidelity Entropy Search (MF-ES) synthetic example
This project is a high-level user interface that needs from the library ESlib (Entropy Search library)
to run. While ESlib contains all the computations of MF-ES, this project just allows the user to
choose options of the global optimization problem, like maximum number of evaluations, GP kernel to be used, 
hyperparameters of the kernel, etc.

Steps to run MF-ES
==================
	+ Open MATLAB, and go to the folder iES_synthetic:
			>> cd /path/to/iES_synthetic/
	+ Add the library path ESlib permanently in your matlab path. You can do that by running the next commands:
			>> addpath '/full/path/to/ESlib/'
			>> savepath('pathdef.m')
		A file pathdef.m will be created under iES_synthetic/ containing the updated path.
	+ Call the function start_up() from the MATLAB promt. This adds relevants paths to your MATLAB session, 
	  and attempts to compile some c++ functions in order to speed up the code execution. If the compilation
	  does not suceed, the matlab version of those functions (computationally less efficient) will be automatically 
	  called instead.
	+ Run the script run_ES.m and wait for the search to finish (the defalut is 15 evaluations).
	+ The function start_up() needs to be called every time a new MATLAB session is opened, and
	  before running the script run_ES.m.
	+ Several options can be chosen by the user in initialize_ES() and initialize_GP(), as indicated below.

User choices and results
========================
	+ Change the input dimension of your problem (look for the keyword DIM, in the files initialize_ES.m, and initialize_GP.m
	  + Change the input domain limits in initialize_ES(), lines 12-15.
	  + Change the lengthscales and prior standard deviation in initialize_GP(), lines 19-26 and 29-34.
	  + The total variance std_tot^2, is explained by the variance of the simulator plus the variance
	  	of the error gap:
	  	std_tot^2 = std_s^2 + std_e^2
  	+ We propose that the variance of the simulator std_s^2 explains the fac_^2*100 percent of the total variance std_tot^2
  		For example, if we know that the total variance is 4, and that the simulator explains the 60% of it, then:
  		fac_^2 = 0.6
  		std_tot^2 = 4
  		std_s^2 = fac_^2*std_tot^2 = 2.4
  		Then, the variance of the error term can be computed as: std_e^2 = std_tot^2 * (1-fac_^2)
	+ At the moment, it is possible to run MF-ES either with squared exponential (SE) kernel or rational quadratic (RQ) kernel.
		In this example, the RQ kernel is chosen. See lines 15-16. The SE kernel can be used by replacing 
		the calls covRQard and covRQard_dx_MD, by covSEard and covSEard_dx_MD, respectively.
	+ The color code for the Gaussian process plots is:
		Red dots: 	collected data from real system
		Blue dots: 	collected data from simulator
		Black dot: 	Current estimate of the global minimum
		In 1D:
			Red line: 								posterior GP mean of the real system
			Red transparent surface: 	+- posterior GP variance of the real system (+-2 std)
			Red dashed line: 					true function
			Blue line: 								posterior GP mean of the simulator (omitted)
			Blue transparent surface: +- posterior GP variance of the simulator (+-2 std)
			Blue dashed line: 				simulator function (ommitted)
	+ In the function run_ES(), the call to EntropySearch() returns an output structure (out), which contains several relevant fields:
		out.GPs{k}, being k the desired iteration number: useful information related to the utilized Gaussian 
		process model, for example:
		out.GPs{k}.x(i,:) 		collected point i at iteration k
		out.GPs{k}.y(i) 			value of the collected point i at iteration k
		out.deltas{k}(i) 			binary flag of the collected point i at iteration k
		out.flag_new_meas{k}	text flag that indicates whether the most informative point at iteration k 
													is to be selected from the real system ('in_real') or from the simulator ('in_simu')
		out.FunEst(k,:)				estimation of the global minimum at iteration k
	+ Results are saved automatically under results/MF_ES_synth_YYYY-M-D-m/ each time the script run_ES.m is called. 
		If the exploration is stopped prematurely by the user (e.g., pressing Ctr+C), the out structure is saved in the file
		results/MF_ES_synth_YYYY-M-D-m/currentESstatus.mat, up to the iteration in which the optimizer was stopped.
		If the exploration finishes normally, the out structure is saved in results/MF_ES_synth_YYYY-M-D-m/ESout.mat

Contact information
===================
For any questions, please, send an e-mail to: 

   alonso.marco@tuebingen.mpg.de
