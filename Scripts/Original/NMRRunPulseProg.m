%
% File: NMRRunPulseProg.m
% Date: 21-Jan-03
% Author: Kenneth Jensen <sanctity@mit.edu>
%
% Description:  Given a pulse sequence, performs the complete
% computation including the temporal averaging.  Outputs both the
% temporal averaged carbon and hydrogen spectra as well as the raw
% data before the averaging.
%
% Usage: spect = do_pulses( pw90, phref, pulses, phases, delays,
%                           tavgflag, nucflag, d1 );
%
%
% pw90 - 1x2 array of 90 degree pulse widths for the hydrogen and
% carbon.  pw90 = [6.6 5] works well with 7% sample.
%
% phref - 1x2 array of offset phases for the hydrogen and carbon
% spectra.
%
% pulses - 2xN array of pulses lengths where the first row
% represents the pulses on the proton, and the second row
% represents the pulses on the carbon the pulse lengths are in
% terms of the 90 degree pulse length (ie. 1 = 90 degrees)
%
% phases - 2xN array of phases where the first row represents
% the phases of the proton pulses and the second row represents
% the phases of the carbon pulses.  the phases are in units of 
% 90 degrees (ie. 1 = 90 degrees )
%
% delays - 1xN array of delays in millisec.  the Nth delay follows 
% the Nth set of pulses on the carbon and proton.
%
% tavgflag (optional) - 0 for no temporal averaging.
%                       1 for temporal averaging.
%
% nucflag (optional) - 0 for both spectra
%                      1 for just the hydrogen spectrum
%                      2 for just the carbon spectrum
%
% d1 (optional) - delay time between experiments in seconds
%
% spect - a structure for holding all the data from the experiment
%   spect.tacq               - acquistion time for both hydrogen
%                              and carbon
%   spect.hfreq              - hydrogen frequency data
%   spect.hsfo               - hydrogen transmitter frequency
%   spect.hspect             - hydrogen spectrum after temporal averaging
%   spect.hfid               - hydrogen free induction decay after
%                              temporal averaging
%   spect.hraw               - cell containing the hydrogen spectra
%                              before temporal averaging
%   spect.hpeaks             - hydrogen peak integral values
%   spect.hphase             - hydrogen receiver offset phase
%   spect.cfreq              - carbon frequency data 
%   spect.csfo               - carbon transmitter frequency
%   spect.cspect             - carbon spectrum after temporal averaging
%   spect.cfid               - carbon free inducation decay after
%                              temporal averaging
%   spect.craw               - cell containing the carbon spectra
%                              before temporal averaging
%   spect.cpeaks             - carbon peak integral values
%   spect.cphase             - carbon receiver offset phase
%   spect.pp                 - pulse program structure
%     spect.pp.pw90              - 90 degree pulse widths used
%     spect.pp.pulses            - pulses
%     spect.pp.phases            - phases
%     spect.pp.delays            - delays
%   spect.dt                 - date and time
%   spect.tavgflg            - temporal average flag
%   spect.nucflag            - nucleus flag
%
%
% Example: spect = NMRRunPulseProgram( [6.6 5], [0 0], [1; 0], [0; 0],
%                                      [0], 1, 0 );
%
% This performs a quick test of the temporal averaging.  The pulse sequence
% represents no pulses followed by a read-out pulse on the hydrogen.  The
% output should be a hydrogen spectra with only one peak in the |00> position. 
%
%

function spect = NMRRunPulseProg( pw90, phref, pulses, phases, ...
				     delays, tavgflag, nucflag, d1 )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% perform basic error checking 
          
if ~(nargin==5 | nargin==6 | nargin==7 | nargin==8)
  error('Wrong number of arguments');
end; 
     
if size(pw90,1) ~= 1 | size(pw90,2) ~= 2 
  error('pw90 should have the form [hydrogen_pw carbon_pw]');
end;

if size(pulses,1) ~= 2
  error(['pulses should have the form [hydrogen_pulse_1 ...' ...
	 ' hydrogen_pulse_n;  carbon_pulse_1 ... carbon_pulse_n]']); 
end;

if size(phases,1) ~= 2
  error(['phases should have the form [hydrogen_phase_1 ...' ...
	 ' hydrogen_phase_n;  carbon_phase_1 ... carbon_phase_n]']); 
end;

if size(delays,1) ~= 1
  error('delays should have the form [delay_1 ... delay_n]');
end;

if size(delays,2)~=size(pulses,2) | size(delays,2)~=size(phases,2)
  error(['pulses, phases, and delays should all have the same' ...
	 ' length']); 
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% initialize variables, processes input
   
% temporal averaging is on by default
if nargin < 8
  d1 = 50;
  if nargin < 7
    nucflag = 0;
    if nargin < 6
      tavgflag = 1;
    end;
  end;
end;
   
NMRSetCalibPhases(phref(1),phref(2));  % store phase references data in calib
   
% empties cells
mysdc = {};
mysdh = {};
   
% partial cnot pulse sequence
% (x1)-(tau)-(-y1)
% 1/2J = 2.326 ms
% permute = c1not2 c2not1
% permute2 = c2not1 c1not2
permute_pulses = [1 1  0 0; 0 0  1 1];
permute_phases = [0 3  0 0; 0 0  0 3];
permute_delays = [2.326 0 2.326 0];
   
permute2_pulses = [0 0  1 1; 1 1  0 0];
permute2_phases = [0 0  0 3; 0 3  0 0];
permute2_delays = [2.326 0 2.326 0];



% do experiment once with no preliminary pulses
% i.e. initial density matrix looks like:
%  a 0 0 0
%  0 b 0 0
%  0 0 c 0
%  0 0 0 d    
temporalAvg_pulses{1} = [pulses];
temporalAvg_phases{1} = [phases];
temporalAvg_delays{1} = [delays];

% permute density matrix once
% i.e. initial density matrix looks like:
%  a 0 0 0
%  0 d 0 0
%  0 0 b 0
%  0 0 0 c
temporalAvg_pulses{2} = [permute_pulses pulses];
temporalAvg_phases{2} = [permute_phases phases];
temporalAvg_delays{2} = [permute_delays delays];

% permute density matrix twice
% i.e. initial density matrix looks like:
%  a 0 0 0
%  0 c 0 0
%  0 0 d 0
%  0 0 0 b
temporalAvg_pulses{3} = [permute2_pulses pulses];
temporalAvg_phases{3} = [permute2_phases phases];
temporalAvg_delays{3} = [permute2_delays delays];

   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
%%% run the pulse sequences

% if temporal averaging is not set, only run the first pulse sequence
if tavgflag
  nruns = 3;
else
  nruns = 1;
end;
   
   
for k = 1:nruns

  if nucflag==0 | nucflag==1
    % get the hydrogen spectrum
       
    % create pulse program
    write_pp( temporalAvg_pulses{k}, ...
	      temporalAvg_phases{k}, ...
	      temporalAvg_delays{k}, 0 ); 
    
    % upload pulse program to xwinnmr 
    nmrx( 'putpp juniorlabpp' );     
    
    % load parameter file for hydrogen
    NMRLoadParam('H');
       
    % overide the delay time in the parameter file
    if nargin==8
      nmrx( strcat(['d1 ', num2str( d1 )]) );
    end;
     
    % set 90 degree pulse with for hydrogen
    nmrx( strcat(['p1 ', num2str( pw90(1) )]) );
     
    % set 90 degree pulse with for carbon
    nmrx( strcat(['p2 ', num2str( pw90(2) )]) );
     
    % set pulse program
    nmrx( 'pulprog juniorlabpp' );  
      
    fprintf( 1, 'Performing pulse sequence on hydrogen...\n' );
    
    % run countdown program
    system( sprintf('/home/nmrqc/matlab/delay %d &', d1) );
    
    % run pulse program
    nmrx( 'zg' );      
     
    % get data and fourier transform
    mysdh{k} = b2sdatNoPlot; 
    
    % play the fid through the speakers
    playfid( mysdh{k}.fid );
  end;
     
     
  if nucflag==0 | nucflag==2
    % get the carbon spectrum
       
    % write pulse program
    write_pp( temporalAvg_pulses{k}, ...
	      temporalAvg_phases{k}, ...
	      temporalAvg_delays{k}, 1 );      
       
    % upload pulse program to xwinnmr 
    nmrx( 'putpp juniorlabpp' );     

    % load parameter file for carbon
    NMRLoadParam('C');

    % overide the delay time in the parameter file
    if nargin==8
      nmrx( strcat(['d1 ', num2str( d1 )]) );
    end;

    % set 90 degree pulse with for carbon
    nmrx( strcat(['p1 ', num2str( pw90(2) )]) );
     
    % set 90 degree pulse with for hydrogen
    nmrx( strcat(['p2 ', num2str( pw90(1) )]) );

    % set pulse program
    nmrx( 'pulprog juniorlabpp' );

    fprintf( 1, 'Performing pulse sequence on carbon...\n');
    
    % run countdown program
    system( sprintf('/home/nmrqc/matlab/delay %d &', d1) );

    % run pulse program
    nmrx( 'zg' );
       
    % get data and fourier transform
    mysdc{k} = b2sdatNoPlot;        
        
    % play the fid through the speakers
    playfid( mysdc{k}.fid );
  end;
end;
   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% compute peak integrals
%%% organize and save the data
   
pf = evalin('base','calib.pf');
iw = evalin('base','calib.iwidth');

   
if nucflag==0 | nucflag==1
  spect.hfreq = mysdh{1}.fdat;
  spect.hsfo = mysdh{1}.sfo;     
  
  ivh_sum(1:2) = 0;
  spect.hspect = 0;
  spect.hfid = 0;
  for k = 1:nruns
    spect.hspect = spect.hspect + mysdh{k}.spect;       
    spect.hfid = spect.hfid + mysdh{k}.fid;
    spect.hraw{k} = mysdh{k}.spect;           
    [ivh, fvh] = do_integral(mysdh{k}.fdat, mysdh{k}.spect, ...
				pf, iw, mysdh{k}.sfo);       
    ivh_sum(1:2) = ivh_sum(1:2) + ivh(1:2);
  end;     
  spect.hpeaks = ivh_sum;     
     
  spect.hphase = phref(1);
  spect.tacq = mysdh{1}.tacq;
end;
     
if nucflag==0 | nucflag==2
  spect.cfreq = mysdc{1}.fdat;
  spect.csfo = mysdc{1}.sfo;
     
  ivc_sum(1:2) = 0;
  spect.cspect = 0;
  spect.cfid = 0;
  for k = 1:nruns
    spect.cspect = spect.cspect + mysdc{k}.spect;
    spect.cfid =  spect.cfid + mysdc{k}.fid;
    spect.craw{k} = mysdc{k}.spect;
       
    [ivc, fvc] = do_integral(mysdc{k}.fdat, mysdc{k}.spect, ...
				pf, iw, mysdc{k}.sfo);
    ivc_sum(1:2) = ivc_sum(1:2) + ivc(3:4);
  end;
  spect.cpeaks = ivc_sum;
     
  spect.cphase = phref(2);
  spect.tacq = mysdc{1}.tacq;
end;


spect.dt = dt;
spect.pp.pw90 = pw90;
spect.pp.pulses = pulses;
spect.pp.phases = phases;
spect.pp.delays = delays;
spect.tavgflg = tavgflag;
spect.nucflag = nucflag;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
%%% save data
   
s = sprintf('save spect-%s spect', spect.dt); eval(s);
fprintf(1,'Data saved in file spect-%s.spect\n',spect.dt);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% save both mysdc and mysdh as global variables  (added 10-Feb-06 ILC)

assignin('base','mysdc',mysdc);
assignin('base','mysdh',mysdh);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
%%% plot spectra

NMRplotSpectra( spect );

return;
   
   
   
   
   
