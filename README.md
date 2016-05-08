# LPS - Linear Programe Solver
##Introduction
This package is used for solving a linear programming problem, it is capable of handling of minimization was well as maximization problems.
The package contains a command line solver which can be interfaced with Matlab. It also contains a Graphical User Interface(GUI) thats adds on top of the solver making it easier to use the solver.

The solver package is capable of solving linear programing problems of the form


               Min,Max     $C^T.X$
            Subject to    A.X<=B
                            X>=0

The vector B can take positive, negtaive and zero values. 

The solver was written by Sharabh Shukla as a part of class assignment in EE5900 under the guidance of Dr.Sumit Paudyal at Michigan Tech in the spring of 2016. 

The package contains a solver that can be used in Matlab. It also comes with an Graphical User Interface(GUI) that can be installed as an application in Matlab. The GUI can also be run as a standalone excutable in windows.

##Installation
The solver can be used with Matlab 2010 or above. Extract the downloaded files and place them in the working Matlab directory. 

Matlab 2012 or Higher is needed for using the GUI application.



Matlab runtime complier needs to be installed for running the standalone executable in windows.

##Using the Package
###Command Line Solver
The solver is used as a function in Matlab after parameters A,B,C is stored in Matlab. The general format for calling the solver is 

######[optimal_value,x,status,warning] = LP_solve(A,B,C,'direction','mode'). 

A,B and C are matrices or vectors as defined in the general problem structure. The direction is specified as 'min' or 'max' for minimization or maximization problems respectively. The mode is specified as silent or normal.

For output the optimal_value is the optimal value of the function, x is the variable vector or the decision vector, staus indicated the status of the problem after it is solve while the warning records any warning that might be generated during the process of solving the problem.


     Example : min     z=-3x1+x2+x3
              s.t.     x1-2x2+x3<= 11
                       4x1-x2-2x3<=-3
                       -2x1+x3<=1
                        2x1-x3<=-1
                        x1,x2,x3>=0.
    Solution : C=[-3 1 1];
               B=[11; -3; 1;-1];
               A=[1 -2 1;4 -1 -2;-2 0 1;2 0 -1];
    After supplying these inputs call LP_solve(A,B,C,'min').

The decision vector or the variables are displayed as x vector and the objective value computed at that point is also displayed. The Tableaus for the first and second pass are also diplayed. The printing of tableaus can be suppressed by spepcifying the mode. 

###Running the Graphical User Interface(GUI)
The graphical user interface or the GUI can be be installed as an application in matlab which is available under apps in Matlab after the installation is complete. It can also be run as a standalone executable in windows. Running the executable requires installation of Matlab Runtime Complier, that needs to be done separatley before running the file. The Matlab Runtime compiler is availabe at   
and can also be downloaded from this repository.
![alt text](https://github.com/sharabhs/Linear-Program-Solver-LPS-/blob/master/Snapshot.jpg "Snapshot of the GUI")


