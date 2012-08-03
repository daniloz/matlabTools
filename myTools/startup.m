%% Add Paths
addpath('C:\Users\dz\Documents\MATLAB\Tools') %#ok<*MCAP>
addpath('N:\GPA\Development\Design\Firmware\Matlab\GPA\Tools\cprintf')
addpath('N:\GPA\Development\Design\Firmware\Matlab\GPA\Tools\Windows')
addpath('N:\GPA\Development\Design\Firmware\Matlab\GPA\Tools')
addpath('N:\GPA\Development\Design\Firmware\Matlab\GPA\Tools\roundoff\adam')
addpath('N:\GPA\Development\Design\Firmware\Matlab\GPA\Tools\roundoff')
addpath('N:\GPA\Development\Design\Firmware\Matlab\GPA\Tools\qdsp');

addpath('C:\Data\GPA\Matlab\CommonTools\EasyGUI\examples')
addpath('C:\Data\GPA\Matlab\CommonTools\EasyGUI')
addpath('C:\Data\GPA\Matlab\CommonTools')
addpath('C:\Data\myMatlabTools')

%% Set grids on all axis.
set(0, 'defaultAxesXGrid', 'on');
set(0, 'defaultAxesYGrid', 'on');
set(0, 'defaultAxesZGrid', 'on');

%% Set plot position
set(0, 'defaultFigurePosition', [ 2738 195 814 504 ]);

%% Deafult Paper Size
set(0, 'DefaultFigurePaperType', 'A4');

%% Format
format compact
format longG
