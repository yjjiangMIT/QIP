<<<<<<< HEAD
%
% File: qipgates.m
% Date: 26-Feb-03
% Author: I. Chuang <ichuang@mit.edu>
%
% Standard QC gates; with proper sign convention to be
% consistent with MIT Junior Lab quantum information processing labguide
global hadamard cnot cphase sx sy sz si rx ry rz zz xx yy
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pauli matrices
sx = [0 1; 1 0];
sy = [0 -1i; 1i 0];
sz = [1 0; 0 -1];
si = [1 0; 0 1];
pauli = {sx,sy,sz};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% two-qubit interaction terms
zz = kron(sz,sz);
xx = kron(sx,sx);
yy = kron(sy,sy);
zi = kron(sz,si);
iz = kron(si,sz);
ii = kron(si,si);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% single qubit rotations (acting on 1 qubit: 2x2 unitaries)
rx = expm(-1i*pi/4*sx);
ry = expm(-1i*pi/4*sy);
rz = expm(-1i*pi/4*sz);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% single qubit rotations (acting on 1 of 2 qubits: 4x4 unitaries)
rx1 = kron(si,rx);
rx2 = kron(rx,si);
ry1 = kron(si,ry);
ry2 = kron(ry,si);
rz1 = kron(si,rz);
rz2 = kron(rz,si);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% one-qubit computational basis states
psi0 = [1 ; 0];
psi1 = [0 ; 1];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% two-qubit computational basis states
psi00 = kron(psi0,psi0);
psi01 = kron(psi0,psi1);
psi10 = kron(psi1,psi0);
psi11 = kron(psi1,psi1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% two-qubit Hamiltonian (for CHCl3) & coupled evolution gate
ham = zz;
tau = expm(-1i*pi/4*zz);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% standard ideal quantum logic gates
hadamard = [1 1 ; 1 -1]/sqrt(2);
cnot = [1 0 0 0 ; 0 1 0 0 ; 0 0 0 1 ; 0 0 1 0];
cphase = [1 0 0 0 ; 0 1 0 0 ; 0 0 1 0 ; 0 0 0 -1];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Example: near-controlled-not
Uncnot = ry1' * tau * rx1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Example: effect of Uncnot on thermal state density matrix
rho_therm = [5 0 0 0; 0 3 0 0; 0 0 -3 0; 0 0 0 -5];
rho_out = Uncnot * rho_therm * Uncnot';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Example: Deutsch-Jozsa
Uf1 = [ 1 0 0 0 ; 0 1 0 0 ; 0 0 1 0 ; 0 0 0 1 ];
Uf2 = [ 0 1 0 0 ; 1 0 0 0 ; 0 0 0 1 ; 0 0 1 0 ];
Uf3 = [ 1 0 0 0 ; 0 1 0 0 ; 0 0 0 1 ; 0 0 1 0 ];
Uf4 = [ 0 1 0 0 ; 1 0 0 0 ; 0 0 1 0 ; 0 0 0 1 ];
Udj1 = ry2' * ry1 * Uf1 * ry2 * ry1';
Udj2 = ry2' * ry1 * Uf2 * ry2 * ry1';
Udj3 = ry2' * ry1 * Uf3 * ry2 * ry1';
Udj4 = ry2' * ry1 * Uf4 * ry2 * ry1';
Out1 = Udj1 * psi00;
Out2 = Udj2 * psi00;
Out3 = Udj3 * psi00;
=======
%
% File: qipgates.m
% Date: 26-Feb-03
% Author: I. Chuang <ichuang@mit.edu>
%
% Standard QC gates; with proper sign convention to be
% consistent with MIT Junior Lab quantum information processing labguide
global hadamard cnot cphase sx sy sz si rx ry rz zz xx yy
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pauli matrices
sx = [0 1; 1 0];
sy = [0 -1i; 1i 0];
sz = [1 0; 0 -1];
si = [1 0; 0 1];
pauli = {sx,sy,sz};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% two-qubit interaction terms
zz = kron(sz,sz);
xx = kron(sx,sx);
yy = kron(sy,sy);
zi = kron(sz,si);
iz = kron(si,sz);
ii = kron(si,si);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% single qubit rotations (acting on 1 qubit: 2x2 unitaries)
rx = expm(-1i*pi/4*sx);
ry = expm(-1i*pi/4*sy);
rz = expm(-1i*pi/4*sz);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% single qubit rotations (acting on 1 of 2 qubits: 4x4 unitaries)
rx1 = kron(si,rx);
rx2 = kron(rx,si);
ry1 = kron(si,ry);
ry2 = kron(ry,si);
rz1 = kron(si,rz);
rz2 = kron(rz,si);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% one-qubit computational basis states
psi0 = [1 ; 0];
psi1 = [0 ; 1];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% two-qubit computational basis states
psi00 = kron(psi0,psi0);
psi01 = kron(psi0,psi1);
psi10 = kron(psi1,psi0);
psi11 = kron(psi1,psi1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% two-qubit Hamiltonian (for CHCl3) & coupled evolution gate
ham = zz;
tau = expm(-1i*pi/4*zz);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% standard ideal quantum logic gates
hadamard = [1 1 ; 1 -1]/sqrt(2);
cnot = [1 0 0 0 ; 0 1 0 0 ; 0 0 0 1 ; 0 0 1 0];
cphase = [1 0 0 0 ; 0 1 0 0 ; 0 0 1 0 ; 0 0 0 -1];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Example: near-controlled-not
Uncnot = ry1' * tau * rx1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Example: effect of Uncnot on thermal state density matrix
rho_therm = [5 0 0 0; 0 3 0 0; 0 0 -3 0; 0 0 0 -5];
rho_out = Uncnot * rho_therm * Uncnot';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Example: Deutsch-Jozsa
Uf1 = [ 1 0 0 0 ; 0 1 0 0 ; 0 0 1 0 ; 0 0 0 1 ];
Uf2 = [ 0 1 0 0 ; 1 0 0 0 ; 0 0 0 1 ; 0 0 1 0 ];
Uf3 = [ 1 0 0 0 ; 0 1 0 0 ; 0 0 0 1 ; 0 0 1 0 ];
Uf4 = [ 0 1 0 0 ; 1 0 0 0 ; 0 0 1 0 ; 0 0 0 1 ];
Udj1 = ry2' * ry1 * Uf1 * ry2 * ry1';
Udj2 = ry2' * ry1 * Uf2 * ry2 * ry1';
Udj3 = ry2' * ry1 * Uf3 * ry2 * ry1';
Udj4 = ry2' * ry1 * Uf4 * ry2 * ry1';
Out1 = Udj1 * psi00;
Out2 = Udj2 * psi00;
Out3 = Udj3 * psi00;
>>>>>>> e036077d997bdc4dc4e29c2e83a04c067580d30c
Out4 = Udj4 * psi00;