function PlotOffset(fig)

if nargin < 1,
    fig = gcf;
end

Line = [];
set(fig,'WindowButtonDownFcn', @FigButtonDown)
set(fig,'WindowKeyReleaseFcn', @FigKeyPress)

    function FigButtonDown(src, eventdata)
        obj = gco;
        if strcmp(get(obj,'Type') , 'line'),
            Line.obj = obj;
            Line.XData = get(obj,'XData');
            Line.YData = get(obj,'YData');
            Line.LineWidth = get(obj,'LineWidth');
            set(obj,'LineWidth',3);
            Line.YOffset = 0;
            Line.XOffset = 0;
            yt = get(get(Line.obj,'Parent'),'YTick');
            Line.YStep = 0.1 * mean(diff(yt));
            % TODO: fix XStep and YStep for LOG spacing
            xt = get(get(Line.obj,'Parent'),'XTick');
            Line.XStep = 0.1*mean(diff(xt));
            Line.text = text(.1,.1,'Offset = ( 0.0   , 0.0   )','units','normalized','Background','white');
        end
    end

    function FigKeyPress(src,eventdata)
        if ~isempty(Line),
            switch eventdata.Key,
                case 'uparrow'
                    if ~isempty(eventdata.Modifier) && any(strcmp('shift',eventdata.Modifier)),
                        Line.YOffset = Line.YOffset + 0.1*Line.YStep;
                    else
                        Line.YOffset = Line.YOffset + Line.YStep;
                    end
                    set(Line.obj,'YData',Line.YData+Line.YOffset);
                    set(Line.text,'String',sprintf('Offset = ( %.3f , %.3f )',Line.XOffset,Line.YOffset));
                    drawnow
                case 'downarrow'
                    if ~isempty(eventdata.Modifier) && any(strcmp('shift',eventdata.Modifier)),
                        Line.YOffset = Line.YOffset - 0.1*Line.YStep;
                    else
                        Line.YOffset = Line.YOffset - Line.YStep;
                    end
                    set(Line.obj,'YData',Line.YData+Line.YOffset);
                    set(Line.text,'String',sprintf('Offset = ( %.3f , %.3f )',Line.XOffset,Line.YOffset));
                    drawnow
                case 'leftarrow'
                    if ~isempty(eventdata.Modifier) && any(strcmp('shift',eventdata.Modifier)),
                        Line.XOffset = Line.XOffset - 0.1*Line.XStep;
                    else
                        Line.XOffset = Line.XOffset - Line.XStep;
                    end
                    set(Line.obj,'XData',Line.XData+Line.XOffset);
                    set(Line.text,'String',sprintf('Offset = ( %.3f , %.3f )',Line.XOffset,Line.YOffset));
                    drawnow
                case 'rightarrow'
                    if ~isempty(eventdata.Modifier) && any(strcmp('shift',eventdata.Modifier)),
                        Line.XOffset = Line.XOffset + 0.1*Line.XStep;
                    else
                        Line.XOffset = Line.XOffset + Line.XStep;
                    end
                    set(Line.obj,'XData',Line.XData+Line.XOffset);
                    set(Line.text,'String',sprintf('Offset = ( %.3f , %.3f )',Line.XOffset,Line.YOffset));
                    drawnow
                case 'space'
                     Line.YOffset = 0;
                     Line.XOffset = 0;
                     set(Line.obj,'XData',Line.XData+Line.XOffset);
                     set(Line.obj,'YData',Line.YData+Line.YOffset);
                    set(Line.text,'String',sprintf('Offset = ( %.3f , %.3f )',Line.XOffset,Line.YOffset));
                    drawnow
                case 'escape'
                    set(Line.obj,'XData',Line.XData);
                    set(Line.obj,'YData',Line.YData);
                    set(Line.obj,'LineWidth',Line.LineWidth);
                    delete(Line.text);
                    drawnow
                    Line = [];
                    set(gcf,'WindowButtonDownFcn', [])
                    set(gcf,'WindowKeyReleaseFcn', [])
                otherwise
            end
        end
    end

end
