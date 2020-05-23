<!-- Copyright 2017 Max Planck Society. All rights reserved.

Alonso Marco
Max Planck Institute for Intelligent Systems
Autonomous Motion Department
amarco(at)tuebingen.mpg.de

---- -->

Description
=========
Multi Fidelity Entropy Search (MF-ES) synthetic example. This algorithm extends the original [Entropy Search (ES)](http://www.jmlr.org/papers/volume13/hennig12a/hennig12a.pdf) ([code](https://github.com/ProbabilisticNumerics/entropy-search)) to the multifidelity setting. The publication to which this code is given below

  Alonso Marco, Felix Berkenkamp, Philipp Hennig, Angela P. Schoellig, Andreas Krause, Stefan Schaal, Sebastian Trimpe
  "Virtual vs. Real: Trading Off Simulations and Physical Experiments in Reinforcement Learning with Bayesian Optimization", 
  IEEE International Conference on Robotics and Automation (ICRA),
  2017, accepted.

The paper can be found [here](https://arxiv.org/abs/1703.01250). 

This project is a high-level user interface that needs from the Entropy Search library [ESlib](https://github.com/alonrot/ESlib). to run. While ESlib contains all the computations of MF-ES, this project just allows the user to choose options of the global optimization problem, like maximum number of evaluations, GP kernel to be used, hyperparameters of the kernel, etc. For a full description on how to run the code, please refer to `instructions.txt`.


An alternative version that improves on efficiency of the original ES code and provides several plotting tools can be found [here](https://github.com/alonrot/userES).

Requirements
============
This package needs the Entropy Search (ES) library, which can be found [here](https://github.com/alonrot/ESlib).
It works under Matlab 2017 or higher.

Contact information
===================
For any questions, please, send an e-mail to: 

   alonso.marco@tuebingen.mpg.de

