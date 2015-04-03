%
% File:   NMRLoadParam.m
% Date:   21-Sep-04
%         Updated 23-Dec-05 by S. Sewell
%         Updated 05-Jan-07 by S. Sewell
%         Updated 08-Feb-10 by S.P.Robinson
%         Updated 14-Feb-10 by S.P.Robinson
% Author: I. Chuang <ichuang@mit.edu>
% 
%
% Load the Bruker NMR parameters for the junior lab QIP experiments
% We put this here, in a single place, so that it is easy to change.
%
% Used by NMRCalib and NMRRunPulseProg
% 
% Usage:   NMRLoadParam('H') or NMRLoadParam('C')

function NMRLoadParam(nuc)
  
if(nuc=='H')
%  nmrx( 'rpar JLab1H-21jan03 all' );
%  nmrx( 'rpar JLab1H-19jan05 all' );
%   nmrx( 'rpar sds20jan06-1H all' );
%   nmrx( 'rpar ike10feb06-1H all' );
%   nmrx( 'rpar ike10feb06-1H_mod30Jan2009 all' );
%nmrx( 'rpar eke02Mar09-1H all' );
% nmrx( 'rpar eke02Mar09-1H all' );
%    nmrx( 'rpar sds05jan07-1H all' );
%  nmrx( 'rpar spr08feb10-1H all' );
%  nmrx( 'rpar spr14feb11-1H all' );
%  nmrx( 'rpar spr25feb11-1H all' );
%  nmrx( 'rpar rhf11jan12-1H all' );
%  nmrx( 'rpar spr05feb13-1H all' );
%  nmrx( 'rpar spr11mar14-1H all' );
  nmrx( 'rpar spr06feb15-1H all' );
  return
end  

if(nuc=='C')
%  nmrx( 'rpar JLab13C-21jan03 all' );
%  nmrx( 'rpar JLab13C-19jan05 all' );
%   nmrx( 'rpar sds20jan06-13C all' );
%   nmrx( 'rpar ike10feb06-13C all' );
%   nmrx( 'rpar eke02Mar09-13C all' );
%    nmrx( 'rpar sds05jan07-13C all' );
%  nmrx( 'rpar spr08feb10-13C all' );
%  nmrx( 'rpar spr14feb11-13C all' );
% nmrx( 'rpar spr25feb11-13C all' );
% nmrx(' rpar rhf11jan12-13C all' );
% nmrx( 'rpar spr05feb13-13C all' );
% nmrx( 'rpar spr11mar14-13C all' );
 nmrx( 'rpar spr06feb15-13C all' );
   return
end  

fprintf(1,'[NMRLoadParam] ERROR! Unknown nuc=%s\n',nuc);
