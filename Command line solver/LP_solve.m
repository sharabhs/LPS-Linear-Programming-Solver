function [ optimal_value x status warning] = LP_solve(A,B,C,direction,mode)
%##############################################################################################################
%This script solves LP with two phase method 
%The two phase method used is a slight modification of the one given on page 20-24 of the
%book "Linear Programing: Foundations and Extensions by Robert J Vanderbei"
%Bland's pivoting rules are used to prevent cycling. This is implemeted
%through function "blands_rule".
%The solver accepts the Linear programing of the general form
%    min/max         C'X
%    subject to      Ax<=B
%                     x>=0
%If the problem is not in this standard LP then the user must first convert the LP in the above standard format.
%inputs: A,B and C matrix go as specified in the format above. 
%        Direction must be specified as 'min' or 'max', if the direction is not specified it throws an error
%        Mode: silent or normal. In normal mode tableaus, messages and warning are
%        displayed during execution. In silent mode all of these is
%        suppressed.
%
%
%outputs
%The function  return the optimal value through optimal_value 
%and the value of the decision variables at the optimal value through x.
%Status flag gives the status of the solution after the process is
%terminated
%Warning flag records any warning that may be generated during the process
%of solving LP.
%
%
%Example : min     z=-3x1+x2+x3
%           s.t.   x1-2x2+x3<= 11
%                 4x1-x2-2x3<=-3
%                    -2x1+x3<=1
%                     2x1-x3<=-1
%                   x1,x2,x3>=0.
% Solution : C=[-3 1 1];
%            B=[11; -3; 1;-1];
%            A=[1 -2 1;4 -1 -2;-2 0 1;2 0 -1];
% After supplying these inputs call LP_solve(A,B,C,'min').
%
%
%This code was was written by Sharabh R Shukla as a class assignment for EE5900-'Optimization
%techniques in power systems' taken in spring 2016 under Prof. Sumit
%Paudyal at Michigan Technological University. The author shall be gratefull for comments/suggestions or errors.
%These can be reported at sshukla2@mtu.edu
%
% To cite, use: S. R. Shukla, "LP Solver with Two-phase Method,"  Michigan Technological University. [Online]. http://www.ece.mtu.edu/~sumitp/freetools/lpsolve.htm

% Bibtex users (use url package): 
%@misc{SRshukla101,
%    author = {Sharabh R Shukla},
%    title = {{LP Solver with Two-phase Method}},
%    howpublished = {Michigan Technological University. [Online]. \url{ http://www.ece.mtu.edu/~sumitp/freetools/lpsolve.htm}},
%    } 

%References:
%(1) Linear Programing: Foundations and Extensions by Robert J Vanderbei
%(2) New Finite Pivoting Rules for Simplex Method, Robert G Bland,
%    Mathematics of Operations Research, Vol. 2, No. 2, May 1997.
%##############################################################################################################



%Initilizing Vales
optimal_value = NaN;
x = NaN;
status = 'NaN';
warning = 'NaN';

%Input Initialization
if nargin <4
    fprintf('Stop Error!!! Enter the direction as min or max\n');
    return;
elseif ~(strcmp(direction,'min') | strcmp(direction,'max'))
    fprintf('Please check the direction!!!');
    return;
end

if nargin == 5
    mode = lower(mode);
    if strcmp(mode,'normal')
        
    elseif strcmp(mode,'silent')
        
    else
        fprintf('Error!!! specify the mode correctly\n');
        return;
    end
end
if nargin < 5
    mode = 'normal';
end

a1 = A;
b1 = B(:);
if direction == 'max'                    %Intializing the c vector for max or min problem
    c1 = -1*C(:);
else
    c1 = C(:);
end
[m1 n1] = size(a1);                      %Forming the tableau     
a1 = [a1 eye(m1)];
tableau = [a1 b1;c1' zeros(1,m1) 0];
[m n]=size(tableau);
if mode == 'normal'
    disp('Initial Tableau:');
    disp(tableau);
end
%Starting phase 1
NB=1:n1;
B=n1+1:n1+m1;

%Phase 1 start here
%Phase 1 gets rid of all negative elements in the b Vector

while (min(tableau(1:m-1,end))<0)
    [val row_index] = blands_rule(tableau(:,end));          %Choosing the entering variable using blands rule
    [val col_index] = blands_rule(tableau(row_index,:));    %Choose the leaving variable using the blands rule
    B(row_index)=col_index;                                 %updating the basic variable index
    NB(col_index) = row_index;
    %Performing pivot operations
    tableau(row_index,:) = tableau(row_index,:)/tableau(row_index,col_index);
    for i=1:m
    if i ~= row_index
        tableau(i,:)=tableau(i,:)-tableau(i,col_index)*tableau(row_index,:);
    else
        
    end
    end
  
    
    
end
if mode == 'normal'
    disp('Final Tableau after phase 1');
    disp(tableau);
end

%end of phase1

    
    
 %Phase 2 start here
 %Phase 2 solves the primal problem with simplex
[temp col_index]=blands_rule(tableau(end,1:end-1));          %Choosing the entring variable using blands rule
iter = 0;
while(~isempty(col_index) & temp<0)
    
     if (double(tableau(:,col_index)<=0))                    %Termination condition for unboundedness
        fprintf('Terminated  because of Unboundedness\n');
        status = ('Terminated  because of Unboundedness');
        return;
    end
    
    
    if (double(tableau(1:end-1,end)<0))                      %Termination condition for Infeasibility
        fprintf('Solution space Infeasible Terminated!!!!');
        status = ('Solution space Infeasible Terminated!!!!');
        return;
    end
    
    %Performing the ratio test for leaving variable
    [ratio row_index] = ratio_test(tableau(1:end-1,end),tableau(1:end-1,col_index));    
    B(row_index)=col_index;                                  %Updating the basic variable index
    NB(col_index)= row_index;
    %Performing pivot operations
    tableau(row_index,:) = tableau(row_index,:)/tableau(row_index,col_index);
    for i=1:m
    if i ~= row_index
        tableau(i,1:end)=tableau(i,1:end)-tableau(i,col_index)*tableau(row_index,1:end);
        
    end
    end
    [temp col_index] = blands_rule(tableau(end,1:end-1));     %Choosing the entering variable using bland's rule for next iteration
    iter = iter+1;
    if iter>10*m                                              %Checking for too many iterations
        disp('Too many iterations');
        status = 'Too many itretaions soltuion not found';
        break;
    end
    
     if (ratio<=0 | double(tableau(:,col_index))<=0)           %Checking for unboundedness
        fprintf('Terminated  because of Unboundedness\n');
        status = 'Terminated  because of Unboundedness';
        return;
    end
    
    
    if (double(tableau(1:end-1,end)<0))                        %Checking for Infeasibility
        fprintf('Solution space Infeasible Terminated!!!!');
        status = 'Solution space Infeasible Terminated!!!!';
        return;
    end
end
status  = 'optimal';
val = tableau(end,end);

if direction =='max'                                           %Extracting the optimal value from the tableau
    optimal_value = 1*tableau(end,end);
else
    optimal_value = -1*tableau(end,end);
end

mul_num = 0;

for k = 1:n1                                                   %Alternate optima condition
    
    if tableau(end,k)==0
        mul_num = mul_num + 1;
    end
    
end

for i=1:n1                                                     %Extracting the variable values from the Tableau
        if (find(B==i))
             j=find(B==i);
             x(i) = tableau(j,end);
        else
              x(i) = 0;
        end
end
    
 if mul_num == n1
    warning = 'optimum is not unique';
     end

if mode == 'normal'
    fprintf('Final Tableau after phase 2:\n');
    disp(tableau);
    fprintf('Optimal solution found: ');
    fprintf('Optimization Terminated\n');
    fprintf('\n');
    x(1:n1) = 0;
    for i=1:n1                                                      %Displaying the optimal decision values 
        if (find(B==i))
             j=find(B==i);
             x(i) = tableau(j,end);
             fprintf('x(%d) = %.3f\n',i,x(i));
        else
              fprintf('x(%d)  = %.3f\n',i,x(i));
        end
    end
     if mul_num == n1
    fprintf('\nWarning !!! Be advised that the optimum is not unique\n\n');
    warning = ('optimum not unique');
     end
    fprintf('The optimal value is %.2f\n',optimal_value);
end

x = x';

end


    