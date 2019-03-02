% Displays an exemplary peak shaving application.


loaded_data = load('../data/consumption_data.mat');
consumption_data = loaded_data.consumption_data;
input_timeseries = SamplingManipulator_Averaging(5).manipulate(consumption_data(26));

targetMaxPeak = 30;
efficiency = 0.97;

optimization_result = optimizePeakShaving(input_timeseries, targetMaxPeak, efficiency);


figure('Units', 'points', ...
    'Position',[0 0 260 150], ...
    'PaperPositionMode', 'auto', ...
    'Visible', 'off');

p1 = plot(input_timeseries.Time * 24, input_timeseries.Data, ...
    'Color', [55 126 184] / 255);


axis([0 24 0 60])

set(gca, ...
    'Units', 'normalized', ...
    'Position', [.15 .2 .75 .7], ...
    'YTick', 0:10:60, ...
    'XTick', 0:3:24, ...
    'TickLabelInterpreter', 'latex', ...
    'FontUnits', 'points', ...
    'FontWeight', 'normal', ...
    'FontSize', 9, ...
    'FontName', 'Linux Libertine');

yL = ylabel({'Load [kW]'},...
    'FontUnits','points',...
    'interpreter','latex',...
    'FontWeight','normal',...
    'FontSize', 9, ...
    'FontName', 'Linux Libertine');
    
xL = xlabel({'Time [h]'},...
    'FontUnits','points',...
    'FontWeight','normal',...
    'interpreter','latex',...
    'FontSize', 9, ...
    'FontName', 'Linux Libertine');


hold on;


input_timeseries.Data = input_timeseries.Data - optimization_result.P_d + optimization_result.P_c;

plot(input_timeseries.Time * 24, input_timeseries.Data, ...
    'Color', [77 175 74] / 255);

yline(30, ...
    'LineStyle', ':', ...
    'LineWidth', 1, ...
    'Label', 'target peak', ...
    'FontSize', 8,...
    'FontName', 'Linux Libertine',...
    'LabelHorizontalAlignment', 'left', ...
    'interpreter', 'latex', ...
    'Color', [77 175 74] / 255);

[hh,icons,plots,txt] = legend({'load', 'shaved'},...
    'interpreter', 'latex',...
    'FontSize', 8,...
    'FontName', 'Linux Libertine',...
    'Location', 'NorthEast');

print('out/peak-shaving-example.eps', '-depsc2');
print('out/peak-shaving-example.pdf', '-dpdf');

hold off;