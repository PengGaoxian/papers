%% Dimensionless energy savings for individuals
% Input
%   Energy：Energy saved by the candidate services corresponding to the population
%   Eh：Energy required for the full preheating process of the candidate service
% Output
%   Energy_dimensionless：The dimensionless energy consumption of each individual in the population
function [Energy_dimensionless] = dimensionless_Energy(Energy,Energy_max)
Energy_dimensionless = Energy/Energy_max;
end

