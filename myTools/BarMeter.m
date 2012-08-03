classdef BarMeter < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ah
        bh
        Scale
        Value
    end
    
    methods
        function obj = BarMeter(ax, min, max)
            obj.ah = ax;
            obj.Scale.Min = min;
            obj.Scale.Max = max;
            obj.Value = min;
            
            % Draw bar meter
            fig = get(ax, 'Parent');
            bkgColor = get(fig, 'Color');
            obj.bh = barh(ax, 0.3, min, 0.5);
            set(obj.bh, 'BaseValue', min)
            set(ax, 'Color', bkgColor);
            set(ax, 'YLim',[0 1], 'YScale','lin', 'YGrid','off', 'YTick',[], 'YColor',[0 0 0], ...
                'XLim',[min max], 'XScale','lin', 'XColor',[0 0 0], ... %'XGrid','off', 'XTick',[], 
                'Box','on')
        end
        
        function set.Value(obj, val)
            obj.Value = val;
            set(obj.bh,'YData',val)
        end
    end
    
end
