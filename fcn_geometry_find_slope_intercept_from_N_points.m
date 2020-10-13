
function [slope,intercept] = fcn_geometry_find_slope_intercept_from_N_points(points,varargin)
% fcn_geometry_find_slope_intercept_from_N_points
% Finds the slope and intercept of a line connecting two or more points
% Format: 
% [slope,intercept] = fcn_geometry_find_slope_intercept_from_N_points(points)
%
% INPUTS:
%      points: a Nx2 vector where N is the number of points, but at least 2. 
%
% OUTPUTS:
%      slope: a scalar (1x1) representing the slope connecting the two
%      points
%      intercept: a scalar (1x1) representing the y-axis intercept of the
%      line fit
%
% Examples:
%      
%      % BASIC example
%      points = [2 3; 4 5];
%      [slope,intercept] = fcn_geometry_find_slope_intercept_from_N_points(points)
% 
% See the script: script_test_fcn_geometry_find_slope_intercept_from_N_points
% for a full test suite.
%
% This function was written on 2020_06_25 by S. Brennan
% Questions or comments? sbrennan@psu.edu 

% Revision history:
% 2020_06_25 - wrote the code
% 2020_10_13 - added verbose mode with dbstack

flag_do_debug = 0; % Flag to plot the results for debugging
flag_check_inputs = 1; % Flag to perform input checking

if flag_do_debug
    st = dbstack; %#ok<*UNRCH>
    fprintf(1,'Starting function: %s, in file: %s\n',st(1).name,st(1).file);
end


%% check input arguments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   _____                   _       
%  |_   _|                 | |      
%    | |  _ __  _ __  _   _| |_ ___ 
%    | | | '_ \| '_ \| | | | __/ __|
%   _| |_| | | | |_) | |_| | |_\__ \
%  |_____|_| |_| .__/ \__,_|\__|___/
%              | |                  
%              |_| 
% See: http://patorjk.com/software/taag/#p=display&f=Big&t=Inputs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Are the input vectors the right shape?
Npoints = length(points(:,1));

if flag_check_inputs == 1
    % Are there the right number of inputs?
    if nargin < 1 || nargin > 2
        error('Incorrect number of input arguments')
    end
    
    if Npoints<2
        error('The points vector must have at least 2 rows, with each row representing a different (x y) point');
    end
    if length(points(1,:))~=2
        error('The points vector must have 2 columns, with column 1 representing the x portions of the points, column 2 representing the y portions.');
    end
end

% Does user want to show the plots?
if 2 == nargin
    fig_num = varargin{1};
    figure(fig_num);
    flag_do_debug = 1;
else
    if flag_do_debug
        fig = figure; 
        fig_num = fig.Number;
    end
end

%% Solve for the circle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   __  __       _       
%  |  \/  |     (_)      
%  | \  / | __ _ _ _ __  
%  | |\/| |/ _` | | '_ \ 
%  | |  | | (_| | | | | |
%  |_|  |_|\__,_|_|_| |_|
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
% The solution in the code is set up in matrix form.
% 
% The code sets up the problem as a regression form. Since the
% equation of a line is:
% 
%     y = m*x + b
% 
% then:
% 
%     y1 = m*x1 + b
% 
%     y2 = m*x2 + b
% 
%     (etc)
% 
% or:
% 
%     Y = m*X+b
% 
% or:
% 
%     Y = [X 1]*[m b]';
% 
% Where X and Y are column vectors. This allows one to solve for [m b] via matrix multiplication via matrix algebra and pseudo-inversion:
%  
%     result = ([X 1]'*[X 1])\([X 1]*Y)
%  
% where the result variable contains the slope and intercept of the best-fit line through the points:
% 
%     result = [m b]. 
%  
% If the matrix is singular, e.g. if the x-coordinates are all the same,
% the line is vertical and the slope is infinite, as is the intercept.
%  
% If the X matrix is 2x2, there's no need for the transpose. Each of these
% conditions is handled separately in the code for speed.


% Fill in X and Y
X = points(:,1);
Y = points(:,2);

% Check to see if the result is going to be singular. This happens if all
% the x values are the same, e.g. the line is vertical
if all(X == X(1))  % Are all the x values the same? This is a vertical line.
    slope = inf;
    intercept = inf;
else  % The result will be an ordinary, non-vertical line
    
    % If X is square already, no need to do the transpose calculations
    if Npoints == 2
        result = [X ones(Npoints,1)]\Y;
    else
        A = [X ones(Npoints,1)];
        result = (A'*A)\(A'*Y);
    end
    
    slope = result(1,1);
    intercept = result(2,1);
end

%% Plot the results (for debugging)?
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   _____       _                 
%  |  __ \     | |                
%  | |  | | ___| |__  _   _  __ _ 
%  | |  | |/ _ \ '_ \| | | |/ _` |
%  | |__| |  __/ |_) | |_| | (_| |
%  |_____/ \___|_.__/ \__,_|\__, |
%                            __/ |
%                           |___/ 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if flag_do_debug
    figure(fig_num);
    hold on;
    grid on;
    plot(points(:,1),points(:,2),'r.');
    
    % Create an x vector of 100 points connecting lowest and highest points
    % in x, and plot the line fit
    x = linspace(min(points(:,1)),max(points(:,1)),100)';
    y = x*slope + intercept;

    if isinf(slope)  % The result is a vertical line
        y = linspace(min(points(:,2)),max(points(:,2)),100)';
    end
    
    plot(x,y,'b.');
    
end

if flag_do_debug
    fprintf(1,'ENDING function: %s, in file: %s\n\n',st(1).name,st(1).file); %#ok<NODEF>
end
end

