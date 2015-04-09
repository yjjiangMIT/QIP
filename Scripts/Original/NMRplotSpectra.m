%
% File: NMRplotSpectra.m
% Date: 22-Jan-03
% Author: Kenneth Jensen <sanctity@mit.edu>
%
% Description:  Plots the hydrogen and carbon spectra as returned
% by NMRrunPulseProg.m and NMRcalib.m with peak integrals!
%
% Usage:  NMRplotSpectra( spect, peakintFlag, saveFlag, phases );
%
% spect - spect structure returned by NMRCalib or NMRRunPulseProg
%
% peakintFlag (optional) - 1 (default) to display peak integrals
%                          0 otherwise
%
% saveFlag (optional) - 0 (default) do not save to ps file
%                       1 save to ps file
%
% phases - optional argument specifying phases to change spectra by,
%          phases = [hp0, hp1, cp0, cp1]
%          where hp0 and hp1 are the first and second order phases for H
%          where cp0 and cp1 are the first and second order phases for C
%          These are given in degrees (not radians)
%          
% The phases modify the spectral data to become
% 
%    newspectrum = oldspectrum * exp(i*(hp0+hp1*fdat/sw)*pi/180)
%
% where fdat is the frequency axis data, and sw is the spectral width, i.e.
% fdat(end) - fdat(1).

function NMRplotSpectra( spect, peakintFlag, saveFlag, phases )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% process inputs

if nargin<4
  phases = [];
end	

if nargin<3
  saveFlag = 0;
  if nargin < 2
    peakintFlag = 1;
  end;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% process optional phases argument

if isempty(phases)
  if isfield( spect, 'hfreq' )
    pvh = ones(length(spect.hfreq),1);
  end
  if isfield( spect, 'cfreq' )
    pvc = ones(length(spect.cfreq),1);
  end
else
  if isfield( spect, 'hfreq' )
    hp0 = phases(1);
    hp1 = phases(2);
    fdat = spect.hfreq;
    sw = fdat(end)-fdat(1);
    pvh = exp(i*(hp0+hp1*fdat/sw)*pi/180);
  end
  if isfield( spect, 'cfreq' )
    cp0 = phases(3);
    cp1 = phases(4);
    fdat = spect.cfreq;
    sw = fdat(end)-fdat(1);
    pvc = exp(i*(cp0+cp1*fdat/sw)*pi/180);
  end
end  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% plot spectra

pf = evalin('base','calib.pf');
iw = evalin('base','calib.iwidth');

if isfield( spect, 'hfreq' )
  figure(1);
  clf;
  ydat = real(spect.hspect .* pvh);
  plot( spect.hfreq, ydat );

  % plot numbers for peak integrals near where peaks actually are

  if peakintFlag
    s = sprintf('%.2f+%.2fi', real(spect.hpeaks(1))/100, ...
		imag(spect.hpeaks(1))/100 );
    x = pf(1,1)-spect.hsfo;	% relative frequency of peak center
    y = textYPos( x, iw, spect.hfreq, spect.hspect .* pvh);
    text( 'posi', [x y], 'vis', 'on', 'string', s, 'color','k', ...
	  'horiz','center','vertical','middle', 'FontSize', 18  );
  
    s = sprintf('%.2f+%.2fi', real(spect.hpeaks(2))/100, ...
		imag(spect.hpeaks(2))/100 );  
    x = pf(1,2)-spect.hsfo;	% relative frequency of peak center
    y = textYPos( x, iw, spect.hfreq, spect.hspect .* pvh);
    text( 'posi', [x y], 'vis', 'on', 'string', s, 'color','k', ...
	  'horiz','center','vertical','middle', 'FontSize', 18  );
  end;
  
  % plot bars demarking integration region
  % hold on;
  % x1 = pf(1,1)-spect.hsfo;	% relative frequency of peak center
  % x2 = pf(1,2)-spect.hsfo;	% relative frequency of peak center
  % plot( [x1-iw, x1-iw], [min(ydat),max(ydat)], 'r');
  % plot( [x1+iw, x1+iw], [min(ydat),max(ydat)], 'r');
  % 
  % plot( [x2-iw, x2-iw], [min(ydat),max(ydat)], 'g');
  % plot( [x2+iw, x2+iw], [min(ydat),max(ydat)], 'g');

  % label axes

  grid on;
  xlabel( sprintf('Frequency from %.2fMhz [Hz]', spect.hsfo/1e6) );
  ylabel( 'Signal [arb. units]' );
  title( sprintf('Hydrogen spectrum [%s]', spect.dt) );
  drawnow;

  if saveFlag
    print( 1, '-dps', sprintf('NMRplotSpectra-hydrogen-%s', spect.dt) );
  end;

end;

if isfield( spect, 'cfreq' )
  figure(2);
  clf;
  ydat = real(spect.cspect .* pvc);
  plot( spect.cfreq, ydat );

  if peakintFlag
    s = sprintf('%.2f+%.2fi', real(spect.cpeaks(1))/1000, ...
		imag(spect.cpeaks(1))/1000 );  
    x = pf(2,1)-spect.csfo;	% relative frequency of peak center
    y = textYPos( x, iw, spect.cfreq, spect.cspect .* pvc);
    text( 'posi', [x y], 'vis', 'on', 'string', s, 'color','k', ...
	  'horiz','center','vertical','middle', 'FontSize', 18  );
  
    s = sprintf('%.2f+%.2fi', real(spect.cpeaks(2))/1000, ...
		imag(spect.cpeaks(2))/1000 );
    x = pf(2,2)-spect.csfo;	% relative frequency of peak center
    y = textYPos( x, iw, spect.cfreq, spect.cspect .* pvc);
    text( 'posi', [x y], 'vis', 'on', 'string', s, 'color','k', ...
	  'horiz','center','vertical','middle', 'FontSize', 18  );
  end;
  
  grid on;
  xlabel( sprintf('Frequency from %.2fMhz [Hz]', spect.csfo/1e6) );
  ylabel( 'Signal [arb. units]' );
  title( sprintf('Carbon spectrum [%s]', spect.dt) );
  drawnow;
  
  if saveFlag
    print( 2, '-dps', sprintf('NMRplotSpectra-carbon-%s', spect.dt) );
  end;
  
end;

return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function to compute convenient position to place text of peak int results

function y = textYPos( pf, iw, freq, spect )

region = find( (freq>=(pf-iw) & freq<=(pf+iw)) );

ymax = max( real(spect(region)) );  
ymin = min( real(spect(region)) );
% yavg = mean( real(spect(region)) );
% ystd = std( real(spect(region)) );
%y = yavg/2;

if abs(ymin) > abs(ymax)
  y = 0.9 * ymin;
else
  y = 0.9 * ymax;
end;

return;
