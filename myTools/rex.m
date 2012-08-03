%REX	synopsis of MATLAB's Regular EXpressions operators
%
%	REX prints a synopsis of the current regular expression operator
%	syntax into the command window or a listbox figure
%
%	see also:   regexp, regexpi, regexprep, regexptranslate
%
%SYNTAX
%-------------------------------------------------------------------------------
%		    REX;
%		    REX <any>;
%		S = REX;
%		S = REX(<any>);
%
%INPUT
%-------------------------------------------------------------------------------
%<any>	:	any character: print S into a listbox figure
%
%OUTPUT
%-------------------------------------------------------------------------------
% S	:	synopsis
%
%NOTE
%-------------------------------------------------------------------------------
%		programmers can easily add their own, preferred stuff
%		as simple text at the bottom of this file between two
%		delimiters:
%		- edit rex
%		- go to the end of the file to see instructions
%
%EXAMPLE
%-------------------------------------------------------------------------------
%		rex;	% print synopsis into the command window
%		rex x;	% print synopsis into a   listbox figure

% created:
%	us	04-Jul-2005 us@neurol.unizh.ch
% modified:
%	us	11-Jul-2008 07:56:17

%-------------------------------------------------------------------------------
function	s=rex(varargin)

% common parameters
% - contents taken from ML doc version:
		dver='7.6.0.324 (R2008a)';
		ntab=3;					% tabs+/line
		TAB=8;					% tab length
		COL=70;					% column size
		lfs=9;					% font size (listbox)

		tok={
%			token		offset
%			----------------------
			'%@REXBEG'	1
			'%@REXEND'	-1
		};
		ts=size(tok,1);

		fnam=which(mfilename);
		s=textread(fnam,'%s','delimiter','\n','whitespace','');
	if	isempty(s)
		disp(sprintf('REX> file empty!'));
		return;
	end

		ix=nan(ts,1);
	for	i=1:ts
		ct=tok{i,1};
		ixt=find(strncmp(s,ct,numel(ct)),1,'last')+tok{i,2};
	if	isempty(ixt)
		disp(sprintf('REX> file corrupt!'));
		clear	s;
		return;
	else
		ix(i)=ixt;
	end
	end

	if	any(isnan(ix))				||...
		ix(1) > ix(2)
		disp(sprintf('REX> file corrupt!'));
	if	~nargout
		clear	s;
	else
		s='';
	end
		return;
	else
		s=s(ix(1):ix(2));
		s={
			sprintf('REX> synopsis\tof Regular EXpression operators')
			sprintf('REX> compiled\t%s','11-Jul-2008 07:56:17')
			sprintf('REX> source\tML version %s',dver)
			sprintf('REX> current\tML version %s',version)
			sprintf('%s','%-------------------------------------------------------------------------------')
			s
		};
		s=cat(1,s{:});
	end

		s=detab(s,'-t',TAB);
		s=REX_wrap(s,ntab,TAB,COL);
		s=char(s);

	if	nargin
		fh=findall(0,'tag','REX: 11-Jul-2008 07:56:17');
	if	isempty(fh)
		figure(...
			'tag','REX: 11-Jul-2008 07:56:17');
		uh=uicontrol;
		set(uh,...
			'units','normalized',...
			'position',[0,0,1,1],...
			'backgroundcolor',[1,1,.85],...
			'foregroundcolor',[0,0,1],...
			'fontname','courier new',...
			'fontsize',lfs,...
			'style','listbox',...
			'listboxtop',1,...
			'string',s);
		shg;					% !!!!!
		set(uh,...				% !!!!!
			'value',5);
		set(gcf,...
			'menubar','none',...
			'numbertitle','off',...
			'name',sprintf('REX: Regular EXpression operator synopsis   [%s]',dver));
	else
		figure(fh);
	end
	elseif	~nargout
		disp(s);
	end

	if	~nargout
		clear	s;
	end
end
%-------------------------------------------------------------------------------
function	s=REX_wrap(s,ntab,tab,mc)

% NOTE
% - this does NOT handle cases where the first table entry is split
% - across several lines!

		TAB=repmat(' ',1,ntab*tab);
		ts=s;
		tso={};

	while	~isequal(ts,tso)
		tso=ts;
		ns=numel(tso);
		ts=cell(2*size(tso,1),1);
		nt=0;
	for	i=1:ns
	if	numel(tso{i}) > mc
		cs=tso{i};
		ix=regexp(cs,'\s');
		ip=ceil(ix/mc);
		ir=strfind([false,diff(ip)],[0,1]);
		ib=[1,ix(ir)];
	if	numel(ib) > 1
		ie=[ix(ir),numel(cs)+2];
		nt=nt+1;
		ts{nt}=sprintf('%s',cs(1:ie(1)-1));
		nt=nt+1;
		ts{nt}=sprintf('%s%s',TAB,cs(ib(2)+1:end));
	else
		nt=nt+1;
		ts(nt)=tso(i);
	end
	else
		nt=nt+1;
		ts(nt)=tso(i);
	end
	end
		ts(nt+1:end)=[];
	end
		s=ts;
end
%-------------------------------------------------------------------------------
%-------------------------------------------------------------------------------
%	utilities
%	-	DETAB		us	21-Apr-1992
%-------------------------------------------------------------------------------
%-------------------------------------------------------------------------------
%$SSC_INSERT_BEG   11-Jul-2008/07:56:17   F:/usr/matlab/unix/detab.m
function	[ss,p]=detab(cstr,varargin)
		magic='DETAB';
		pver='04-Jul-2008 20:35:47';
		ss=[];
		p=[];
		fnam='CELL';
		deftlen=8;
		deftchar=' ';
		otmpl={
		'-t'	true	1	deftlen		'tab length in char'
		'-c'	true	1	deftchar	'tab end marker'
		'-l'	false	0	[]		'show listbox'
		'-lp'	false	1	{}		'listbox parameters'
		};
	if	nargin < 1
		help(mfilename);
		return;
	end
		[opt,par]=DETAB_get_par(otmpl,varargin{:});
	if	ischar(cstr)
		fnam=which(cstr);
	if	~exist(cstr,'file')
		disp(sprintf('DETAB> file not found <%s>',fnam));
		return;
	end
		[fp,msg]=fopen(fnam,'rb');
	if	fp < 0
		disp(sprintf('DETAB> cannot open file <%s>',fnam));
		disp(sprintf('       %s',msg));
		return;
	end
		cstr=textscan(fp,'%s',...
			'delimiter','\n',...
			'whitespace','');
		fclose(fp);
		cstr=cstr{:};
	elseif	~iscell(cstr)
		disp('DETAB> input must be a file name or a cell');
		return;
	end
		tab=sprintf('\t');
		p.magic=magic;
		p.([magic,'ver'])=pver;
		p.MLver=version;
		p.rundate=datestr(clock);
		p.runtime=clock;
		p.par=par;
		p.opt=opt;
		p.input=fnam;
		p.cs=size(cstr);
		p.ns=numel(cstr);
		p.nc=0;
		p.nl=0;
		p.nt=0;
		cstr=cstr(:);
		ix=cellfun('isclass',cstr,'char');
		p.nc=sum(ix);
	if	~p.nc
		ss=cstr;
		return;
	end
		ss=cstr(ix);
		tmax=max(cellfun('length',ss));
		tlen=p.opt.t.val;
		tt=tlen:tlen:tmax*tlen;
		p.par.tab=repmat(['.......',p.par.tc],1,ceil(tmax/tlen));
		ttb=sprintf('TAB=%-1d',tlen);
		p.par.tab(1:length(ttb))=ttb;
		p.runtime=clock;
	for	i=1:p.nc
		s=ss{i};
		tp=strfind(s,tab);
	if	~isempty(tp)
		nt=numel(tp);
		p.nl=p.nl+1;
		p.nt=p.nt+nt;
		tn=1:nt;
		tm=tt(tn);
		tx=tm-tp+tn;
		tx(end)=[];
		tx=[0,tx]+tp-tn;
		tx=tm-tx;
		tx=mod(tx-1,tlen)+1;
		tx=p.par.t(tx);
		ss{i,1}=regexprep(s,'\t',tx,'once');
	end
	end
		p.runtime=etime(clock,p.runtime);
		cstr(ix)=ss;
		ss=reshape(cstr,p.cs);
		
	if	p.opt.l.flg
		blim=.005;
		clf;
		shg;
		p.par.uh=uicontrol('units','norm',...
			'position',[blim,blim,1-2*blim,1-2*blim],...
			'style','listbox',...
			'max',2,...
			'fontname','courier new',...
			'backgroundcolor',1*[.75 1 1],...
			'foregroundcolor',[0 0 1],...
			'tag',p.magic,...
			p.opt.lp.val{:});
		sh=char([{p.par.tab};ss(ix)]);
		set(p.par.uh,'string',sh);
	end
end
function	[opt,par]=DETAB_get_par(otmpl,varargin)
		par.t=[];
		par.tab=[];
		narg=nargin-1;
	for	i=1:size(otmpl,1)
		[oflg,val,arg,dval]=otmpl{i,1:4};
		flg=oflg(2:end);
		opt.(flg).flg=val;
		opt.(flg).val=dval;
		ix=strcmp(oflg,varargin);
		ix=find(ix,1,'last');
	if	ix
		opt.(flg).flg=true;
	if	arg
	if	narg >= ix+arg
		opt.(flg).val=varargin{ix+1:ix+arg};
	else
		opt.(flg).flg=val;
	end
	end
	end
	end
		tlen=opt.t.val;
		par.t=cell(tlen,1);
	for	i=1:tlen
		par.t{i,1}=sprintf('%*s',i,opt.c.val);
	end
	if	~isempty(opt.c.val)	&&...
		~isspace(opt.c.val)
		par.tc=opt.c.val;
	else
		par.tc=char(166);	% <¦>
	end
		par.uh=[];
end
%$SSC_INSERT_END   11-Jul-2008/07:56:17   F:/usr/matlab/unix/detab.m
%-------------------------------------------------------------------------------
%-------------------------------------------------------------------------------
%{
PROGRAMMERS
add your own stuff anywhere between the
%tokens
 @REXBEG	preceded by a %
 @REXEND	preceded by a %
TAB characters	will be replaced by an appropriate amount of SPACES
%-------------------------------------------------------------------------------
%@REXBEG
(A)		Keywords (default output order)
%-------------------------------------------------------------------------------
1: 'start'		Row vector of starting indices of each match
2: 'end'		Row vector of ending indices of each match
3: 'tokenExtents'	Cell array of extents of tokens in each match
4: 'match'		Cell array of the text of each match
5: 'tokens'		Cell array of the text of each token in each match
6: 'names'		Structure array of each named token in each match
7: 'split'		Cell array of the text delimited by each match
%-------------------------------------------------------------------------------
(B)		Options
%-------------------------------------------------------------------------------
'once'			Return only the first match found.
'warnings'		Display any hidden warning messages issued by MATLAB during the execution of the command. This option only enables warnings for the one command being executed.
%-------------------------------------------------------------------------------
(C)		Case-sensitivity mode (keyword/flag)
%-------------------------------------------------------------------------------
'matchcase'/(?-i)	Letter case must match when matching patterns to a string. (The default for regexp).
'ignorecase'/(?i)	Do not consider letter case when matching patterns to a string. (The default for regexpi).
%-------------------------------------------------------------------------------
(D)		Dot matching mode (keyword/flag)
%-------------------------------------------------------------------------------
'dotall'/(?s)		Match dot ('.') in the pattern string with any character. (This is the default).
'dotexceptnewline'/(?-s)Match dot in the pattern with any character that is not a newline.
%-------------------------------------------------------------------------------
(E)		Anchor type mode (keyword/flag)
%-------------------------------------------------------------------------------
'stringanchors'/(?-m)	Match the ^ and $ metacharacters at the beginning and end of a string. (This is the default).
'lineanchors'/(?m)	Match the ^ and $ metacharacters at the beginning and end of a line.
%-------------------------------------------------------------------------------
(F)		Spacing mode (keyword/flag)
%-------------------------------------------------------------------------------
'literalspacing'/(?-x)	Parse space characters and comments (the # character and any text to the right of it) in the same way as any other characters in the string. (This is the default).
'freespacing'/(?x)	Ignore spaces and comments when parsing the string. (You must use '\ ' and '\#' to match space and # characters.)
%-------------------------------------------------------------------------------
(1)		Character Classes
%-------------------------------------------------------------------------------
.			Any single character, including white space.
[c1c2c3]		Any character contained within the brackets: c1 or c2 or c3.
[^c1c2c3]		Any character not contained within the brackets: anything but c1 or c2 or c3.
[c1-c2]			Any character in the range of c1 through c2.
\s			Any white-space character; equivalent to [ \f\n\r\t\v].
\S			Any non-whitespace character; equivalent to [^ \f\n\r\t\v].
\w			Any alphabetic, numeric, or underscore character; equivalent to [a-zA-Z_0-9]. (True only for English character sets).
\W			Any character that is not alphabetic, numeric, or underscore; equivalent to [^a-zA-Z_0-9]. (True only for English character sets).
\d			Any numeric digit; equivalent to [0-9].
\D			Any nondigit character; equivalent to [^0-9].
\oN or \o{N}		Character of octal value N.
\xN or \x{N}		Character of hexadecimal value N.
%-------------------------------------------------------------------------------
(2)		Character Representation (CR)
%-------------------------------------------------------------------------------
\\			Backslash
\$			Dollar sign
\a			Alarm (beep)
\b			Backspace
\f			Form feed
\n			New line
\r			Carriage return
\t			Horizontal tab
\v			Vertical tab
\char			If a character has special meaning in a regular expression, precede it with backslash (\) to match it literally.
%-------------------------------------------------------------------------------
(3)		Grouping Operators
%-------------------------------------------------------------------------------
(expr)			Group regular expressions and capture tokens.
(?:expr)		Group regular expressions, but do not capture tokens.
(?>expr)		Group atomically.
expr1|expr2		Match expression expr1 or expression expr2.
%-------------------------------------------------------------------------------
(4)		Nonmatching Operators
%-------------------------------------------------------------------------------
(?#comment)		Insert a comment into the expression. Comments are ignored in matching.
%-------------------------------------------------------------------------------
(5)		Positional Operators
%-------------------------------------------------------------------------------
^expr			Match expr if it occurs at the beginning of the input string.
expr$			Match expr if it occurs at the end of the input string.
\<expr			Match expr when it occurs at the beginning of a word.
expr\>			Match expr when it occurs at the end of a word.
\<expr\>		Match expr when it represents the entire word.
%-------------------------------------------------------------------------------
(6)		Lookaround Operators
%-------------------------------------------------------------------------------
(?=expr)		Look ahead from current position and test if expr is found.
(?!expr)		Look ahead from current position and test if expr is not found.
(?<=expr)		Look behind from current position and test if expr is found.
(?<!expr)		Look behind from current position and test if expr is not found.
%-------------------------------------------------------------------------------
(7)		Quantifiers
%-------------------------------------------------------------------------------
expr{m,n}		Match expr when it occurs at least m times but no more than n times consecutively.
expr{m,}		Match expr when it occurs at least m times consecutively.
expr{n}			Match expr when it occurs exactly n times consecutively. Equivalent to {n,n}.
expr?			Match expr when it occurs 0 times or 1 time. Equivalent to {0,1}.
expr*			Match expr when it occurs 0 or more times consecutively. Equivalent to {0,}.
expr+			Match expr when it occurs 1 or more times consecutively. Equivalent to {1,}.
q_expr*			Match as much of the quantified expression as possible, where q_expr represents any of the expressions shown in the first six rows of this table.
q_expr+			Match as much of the quantified expression as possible, but do not rescan any portions of the string if the initial match fails.
q_expr?			Match only as much of the quantified expression as necessary.
%-------------------------------------------------------------------------------
(8)		Ordinal Token Operators
%-------------------------------------------------------------------------------
(expr)			Capture in a token all characters matched by the expression within the parentheses.
\N			Match the Nth token generated by this command. That is, use \1 to match the first token, \2 to match the second, and so on.
$N			Insert the match for the Nth token in the replacement string. Used only by the regexprep function. If N is equal to zero, then insert the entire match in the replacement string.
(?(N)s1|s2)		If Nth token is found, then match s1, else match s2.
%-------------------------------------------------------------------------------
(9)		Named Token Operators
%-------------------------------------------------------------------------------
(?<name>expr)		Capture in a token all characters matched by the expression within the parentheses. Assign a name to the token.
\k<name>		Match the token referred to by name.
$<name>			Insert the match for named token in a replacement string. Used only with the regexprep function.
(?(name)s1|s2)		If named token is found, then match s1; otherwise, match s2.
%-------------------------------------------------------------------------------
(10)		Conditional Expression Operators
%-------------------------------------------------------------------------------
(?(cond)expr)		If condition cond is true, then match expression expr.
(?(cond)expr1|expr2)	If condition cond is true, then match expression expr1. Otherwise match expression expr2.
%-------------------------------------------------------------------------------
(11)		Dynamic Expression Operators
%-------------------------------------------------------------------------------
(??expr)		Parse expr as a separate regular expression, and include the resulting string in the match expression. This gives you the same results as if you called regexprep inside of a regexp match expression.
(??@cmd)		Execute the MATLAB command cmd, discarding any output that may be returned. This is often used for diagnosing a regular expression.
(?@cmd)			Execute the MATLAB command cmd, and include the string returned by cmd in the match expression. This is a combination of the two dynamic syntaxes shown above: (??expr) and (?@cmd).
${cmd}			Execute the MATLAB command cmd, and include the string returned by cmd in the replacement expression.
%-------------------------------------------------------------------------------
(12)		Replacement String Operators
%-------------------------------------------------------------------------------
CR Operators		The character represented by the metacharacter sequence. See (3) above.
$`			That part of the input string that precedes the current match.
$& or $0		That part of the input string that is currently a match.
$´			That part of the input string that follows the current match. In MATLAB, use $'' to represent the character sequence $´.
$N			The string represented by the token identified by name.
$<name>			The string represented by the token identified by name.
${cmd}			The string returned when MATLAB executes the command cmd.
%@REXEND
%-------------------------------------------------------------------------------
PROGRAMMERS
add your own stuff anywhere between the
%tokens
 @REXBEG	preceded by a %
 @REXEND	preceded by a %
TAB characters	will be replaced by an appropriate amount of SPACES
%}