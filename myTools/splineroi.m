classdef splineroi < handle
    % Spline Region of Interest Class
    % Usage:
    % >> r = splineroi;
    % >> r.addNode % to add nodes to the spline
    % >> r.addNode
    % >> r.addNode
    
    %  Copyright (c) 2009 Azim Jinha <azimjinha@gmail.com>
    %
    %  Permission to use, copy, modify, and distribute this software for any
    %  purpose with or without fee is hereby granted, provided that the above
    %  copyright notice and this permission notice appear in all copies.
    %
    %  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
    %  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
    %  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
    %  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
    %  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
    %  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
    %  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
    properties
        lineColor='b' % Spline color property
        markerColor='r' % Spline control node marker color
        marker='s' % Spline control node marker shape
        doSplineChangedNotification = true
    end
    properties(SetAccess=private)
        parent
        splineNodes =[] % spline node
        nodeCount = 0 % number of nodes in spline
        hSpline =-1 % handle to spline line
        hPoint=[] % handle to node markers
    end
    
    methods
        function self = splineroi(par)
            % SPLINEROI Create Spline Region of Interest object
            self.parent = par;
        end
        
        function delete(self)
            % DELETE deletes a splineroi instance.
            if ishandle(self.hPoint)
                delete(self.hPoint)
            end
            if ishandle(self.hSpline)
                delete(self.hSpline);
            end
        end
        
        function set(self,varargin)
            % SET set instance properties
            proplist = fields(self);
            for n=1:2:length(varargin)
                tmp=proplist(strcmpi(proplist,varargin{n}));
                switch length(tmp)
                    case 0
                        msg = ['There is no "', varargin{n},'" property'];
                        error('splineroi:setPropertyChk', msg );
                    case 1
                        switch char(tmp)
                            case 'lineColor'
                                self.lineColor=varargin{n+1};
                                if ishandle(self.hSpline), set(self.hSpline,'color',self.lineColor); end
                            case 'markerColor'
                                self.markerColor=varargin{n+1};
                                if ishandle(self.hPoint),
                                    set(self.hPoint,'markerEdgeColor',self.markerColor, ...
                                        'markerFaceColor',self.markerColor);
                                end
                            case 'marker'
                                self.marker=varargin{n+1};
                                if ishandle(self.hPoint)
                                    set(self.hPoint,'marker',varargin{n+1});
                                end
                            otherwise
                                error('splineroi:setReadOnlyProp', ...
                                    ['Attempt to modify readonly property "' varargin{n}, '".']);
                        end
                end
            end
        end
        
        function self=addNode(self,pt)
            % FUNCTION addNode
            % add a node to spline
            %
            % addNode(point) adds the point=[x,y]
            % to the spline
            %
            % addNode with out arguments uses ginput
            % to add points.
            self.plot
            if nargin<2, [pt(1,1),pt(1,2)]=ginput(1); end
            self.splineNodes=[self.splineNodes;pt(1,1:2)];
            self.nodeCount = self.nodeCount+1;
            self.hPoint(self.nodeCount) = -1;
            %             self.plotNode(self.nodeCount);
            %             self.plotSpline;
            self.plot
        end
        
        function self=plot(self)
            % FUNCTION plot
            % generate a plot of the spline in the current axes
            if isempty(self.parent), self.parent = -1; end
            if ~ishandle(self.parent)
                self.parent = axes;
                set(self.parent,'nextplot','add')
            end
            
            if isempty(self.hSpline)
                self.hSpline = -1;
            end
            
            
            if self.nodeCount>0
                self.plotSpline;
            end
            
            
            if isempty(self.hPoint)
                if self.nodeCount>0
                    self.hPoint = -1*ones(self.nodeCount,1);
                end
            end
            
            for i=1:self.nodeCount
                self.plotNode(i);
            end
        end
        
        function sp=calcSpline(self)
            % FUNCTION calcSpline
            % Calculates points on the spline
            if self.nodeCount>2
                %splineFun=cscvn([self.splineNodes' self.splineNodes(1,:)']);
                splineFun=cscvn([self.splineNodes']);
                sp=fnplt(splineFun);
            else
                sp = self.splineNodes';
            end
        end
    end
    
    methods(Access=private)
        function self=plotNode(self,iNode)
            % FUNCTION plotNode
            % Plots one node and sets properties to default values
            if ~ishandle(self.hPoint(iNode))
                hNew = plot(self.splineNodes(iNode,1),self.splineNodes(iNode,2),'rs');
                self.hPoint(iNode) = hNew;
                set(self.hPoint(iNode),'markerfacecolor',self.markerColor,'markerEdgeColor',self.markerColor,'Marker',self.marker);
                set(self.hPoint(iNode),'buttondownfcn',{@splineroi.animator,self,'start'});
            end
        end
        
        function self=plotSpline(self)
            % FUNCTION plotSPline
            % Plots the spline
            sPoints = self.calcSpline;
            if ishandle(self.hSpline)
                set(self.hSpline,'xdata',sPoints(1,:),'ydata',sPoints(2,:))
            else
                set(self.parent,'nextplot','add')
                self.hSpline=plot(sPoints(1,:),sPoints(2,:),'color',self.lineColor,'lineStyle','-');
                set(self.hSpline,'hittest','off');
            end
        end
    end
    
    methods(Static)
        function animator(src,eventdata,self,action) %#ok<INUSL>
            % FUNCTION animator
            % Adds drag and drop functionality to spline nodes
            switch(action)
                case 'start'
                    set(gcbf,'WindowButtonMotionFcn',{@splineroi.animator,self,'move'});
                    set(gcbf,'WindowButtonUpFcn',{@splineroi.animator,self,'stop'});
                    self.doSplineChangedNotification = false;
                case 'move'
                    currPt=get(gca,'CurrentPoint');
                    set(gco,'XData',currPt(1,1));
                    set(gco,'YData',currPt(1,2));
                    self.splineNodes(self.hPoint==gco,:)=currPt(1,1:2);
                    self.plotSpline;
                case 'stop'
                    set(gcbf,'WindowButtonMotionFcn','');
                    set(gcbf,'windowButtonUpFcn','');
                    self.doSplineChangedNotification = true;
                    notify(self,'splineChanged');
            end%switch
        end
    end
    events
        splineChanged
    end
end
