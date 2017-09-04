\ProvidesClass{exercises}
\RequirePackage{xkeyval}
\RequirePackage{environ}
\RequirePackage{xpatch}

\newtoggle{solutions}

\DeclareOptionX{pdftitle}{\def\@pdftitle{#1}}
\DeclareOptionX{answers}{\toggletrue{solutions}}
\DeclareOptionX*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptionsX*%

\LoadClass[fleqn,11pt]{article}

\usepackage[top=3cm,bottom=3cm,left=3cm,right=3cm,headsep=10pt,a4paper]{geometry} % Page margins.  Must come before \usepackage{fancyhdr}, and hence before \RequirePackage{custom}

\RequirePackage{custom}

% Don't display solutions unless "answers" key was passed.
\iftoggle{solutions}{}{%
	\csundef{@beforebegin@solution@hook}%
	\csundef{@afterend@solution@hook}%
	\RenewEnviron{solution}{}%
}

\ExplSyntaxOn
\seq_new:N \equationstack
\ExplSyntaxOff

%----------------------------------------------------------------------------------------
%	MAIN TABLE OF CONTENTS
%----------------------------------------------------------------------------------------

\setcounter{tocdepth}{3}
\usepackage{titletoc} % Required for manipulating the table of contents

\contentsmargin{0cm} % Removes the default margin

% Part text styling
\titlecontents{part}[0cm]
{\addvspace{20pt}\centering\large\bfseries}
{}
{}
{}

% Chapter text styling
\titlecontents{chapter}[1.25cm] % Indentation
{\addvspace{12pt}\large\sffamily\bfseries} % Spacing and font options for chapters
{\color{ocre!60}\contentslabel[\Large\thecontentslabel]{1.25cm}\color{ocre}} % Chapter number
{\color{ocre}}  
{\color{black}\normalsize\;\titlerule*[.5pc]{.}\;\color{ocre!60}\thecontentspage} % Page number

% Section text styling
\titlecontents{section}[1.25cm] % Indentation
{\addvspace{3pt}\sffamily\bfseries} % Spacing and font options for sections
{\color{ocre}\contentslabel[\thecontentslabel]{1.25cm}\color{ocre}} % Section number
{\color{ocre}}
{\hfill\color{ocre}\thecontentspage} % Page number
[]

% Subsection text styling
\titlecontents{subsection}[1.25cm] % Indentation
{\addvspace{1pt}\sffamily\small} % Spacing and font options for subsections
{\contentslabel[\thecontentslabel]{1.25cm}} % Subsection number
{}
{\ \titlerule*[.5pc]{.}\;\thecontentspage} % Page number
[]

% Subsubsection text styling
\titlecontents{subsubsection}[1.25cm] % Indentation
{\addvspace{1pt}\sffamily\footnotesize} % Spacing and font options for subsubsections
{\contentslabel[\thecontentslabel]{1.25cm}} % Subsection number
{}
{\ \titlerule*[.5pc]{.}\;\thecontentspage} % Page number
[]


% This code is in order to suppress any '0 sections' (e.g., so that it will not print eqn (2.0.1) if you have not begun a subsection of section 2 yet).  This must come after the section redefinitions above.
\let\oldsection\section% Store \section
\renewcommand{\section}{% Update \section
	\renewcommand{\theequation}{\thesection.\arabic{equation}} % Update equation number
	\oldsection}% Regular \section

\newcommand{\chapternumber}{0}
\renewcommand{\chapternumber}{}

\newtoggle{isexercise} % Keeps track of whether we are in an exercise.  Used to modify \theHequation accordingly
\let\oldtheHequation\theHequation % Used to save default behavior, which is used outside of exercises.
\newcounter{exercise}
\setcounter{exercise}{1}
\BeforeBeginEnvironment{exr}{%
	\vspace*{0pt plus 3pt} % To help with underfull vbox warnings
	\push{\equationstack}{\arabic{equation}} % So can restore equation number after exercises
	\setcounter{equation}{0}%
	\push{\backgroundcolorstack}{black!5}%
	\tikzcdset{background color=black!5}%
	\global\toggletrue{isexercise}%
	% \setcounter{equation}{0} changed definition of \theHequation.  Set it back.
	\renewcommand{\theHequation}{%
		\iftoggle{isexercise}{%
			exercise.\arabic{exercise}.\arabic{equation}%
		}%
		{%
			\arabic{section}.\arabic{subsection}.\arabic{equation}%
		}%	
	}
}
\AfterEndEnvironment{exr}{%
	\global\togglefalse{isexercise}%
	\get{\equationstack}[\tempcount]* % Restores
	\setcounter{equation}{\tempcount} % equation
	\pop{\equationstack} % number
	\stepcounter{exercise}%
	\vspace*{0pt plus 3pt}% To help with underfull vbox warnings
	\pop{\backgroundcolorstack}%
	\get{\backgroundcolorstack}[\tempcolor]*%
	\tikzcdset{background color=\tempcolor}%
}
\makeatletter
\let\c@tcb@cnt@exr\undefined
\renewtcbtheorem[number freestyle={\noexpand\chapternumber \noexpand\arabic{exercise}},%
crefname={Exercise}{Exercises}]%
{exr}{Exercise}%
{enhanced,%
	enforce breakable=unlimited,%
	segmentation style=solid,%
	theorem style=plain,%
	fonttitle=\sffamily\upshape,%
	coltitle=darkcerulean,%
	fontupper=\normalfont,%
	terminator sign ={:\ },%
	label separator=,%
	before lower={\parindent11pt\noindent}}%
{}
\makeatother
\renewcommand{\theequation}{\arabic{exercise}.\arabic{equation}}


\newcommand{\Name}[1]{\def\exrname{#1}}
\newcommand{\Class}[1]{\def\exrclass{#1}}
\newcommand{\Assignment}[1]{\def\exrassignment{#1}}
\newcommand{\Date}[1]{\def\exrdate{#1}}
\fancyhf{}
\lhead{\large \scshape%
	\if\exrname\relax%
		\exrclass \hfill \exrassignment%
	\else
		\exrname \hfill \exrclass \hfill \exrassignment%
	\fi%
}
\cfoot{\ifnum\thepage=1\large \scshape Due:  \exrdate \fi}
\def\exrname{\relax}
\def\exrclass{\relax}
\def\exrassignment{\relax}
\def\exrdate{\relax}
%\lhead{\large \scshape \exrclass \hfill \exrassignment \hfill Due:  \exrdate}

\newcommand{\InstrBox}[1]{\begin{center}\begin{tcolorbox}[title={\fontsize{13pt}{13pt}\selectfont  Instructions},colframe=black,colback=black!1,width=.9\linewidth,sharp corners=north]\fontsize{11.5pt}{12pt}\selectfont #1\end{tcolorbox}\end{center}}