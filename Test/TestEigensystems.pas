// ###################################################################
// #### This file is part of the mathematics library project, and is
// #### offered under the licence agreement described on
// #### http://www.mrsoft.org/
// ####
// #### Copyright:(c) 2011, Michael R. . All rights reserved.
// ####
// #### Unless required by applicable law or agreed to in writing, software
// #### distributed under the License is distributed on an "AS IS" BASIS,
// #### WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// #### See the License for the specific language governing permissions and
// #### limitations under the License.
// ###################################################################


unit TestEigensystems;

interface

{$IFDEF MACOS}
  {$DEFINE FMX}
{$ENDIF}

uses {$IFDEF FPC} testregistry {$ELSE} {$IFDEF FMX}DUnitX.TestFramework {$ELSE}TestFramework {$ENDIF} {$ENDIF} ,
     Classes, SysUtils, BaseMatrixTestCase;

type
 {$IFDEF FMX} [TestFixture] {$ENDIF}
 TTestEigensystems = class(TBaseMatrixTestCase)
 published
  procedure TestTridiagonalHousholderMethod;
  procedure TestQLImplicitShift;
  procedure TestHessenberg;
  procedure TestHessenberg2;
  procedure TestHessenbergCmplx;
  procedure TestEigVec1;
  procedure TestEigVecComplex;
  procedure TestBalance;
  procedure TestLinearDependentVectors;
 end;

implementation

uses Eigensystems, MatrixConst;

{ TTestEigensystems }

procedure TTestEigensystems.TestBalance;
const B : Array[0..8] of double = (3, 1, 1, 2, -2, -1, 5, -1, 8);
      EigVals : Array[0..2] of double = (2.757, 8.862, -2.619);
      EigVec : Array[0..8] of double = (1, 0.1599, -0.2125, 0.5969, -0.0626, 1.0000, -0.8399, 1, 0.1942);
var dest : Array[0..8] of double;
    Eivec : Array[0..8] of double;
    Wr : Array[0..2] of double;
    Wi : Array[0..2] of double;
begin
     FillChar(Eivec[0], sizeof(Eivec), 0);
     
     Move(B, dest, sizeof(B));
     Check(qlOk = MatrixUnsymEigVecInPlace(@dest[0], 3*sizeof(double), 3, @Wr[0], sizeof(double), @wi[0], sizeof(double), 
                              @eivec[0], 3*sizeof(double)), 'Error no convergence');
     MatrixNormEivecInPlace(@Eivec[0], 3*SizeOf(double), 3, @WI[0], sizeof(double));

     Check(CheckMtx(EigVals, Wr, -1, -1, 0.001), 'Error wrong eigenvalues');
     Check(CheckMtx(EigVec, Eivec, -1, -1, 0.001), 'Error wrong eigenvectors');
end;


procedure TTestEigensystems.TestEigVec1;
const B : Array[0..8] of double = (3, 1, 1, 2, -2, -1, 5, -1, 8);
      EigVals : Array[0..2] of double = (2.757, 8.862, -2.619);
      EigVec : Array[0..8] of double = (1, 0.1599, -0.2125, 0.5969, -0.0626, 1.0000, -0.8399, 1, 0.1942);
var dest : Array[0..8] of double;
    Eivec : Array[0..8] of double;
    Wr : Array[0..2] of double;
    Wi : Array[0..2] of double;
begin
     FillChar(wr, sizeof(wr), 0);
     FillChar(wi, sizeof(wi), 0);
     FillChar(Eivec[0], sizeof(Eivec), 0);
     Move(B, dest, sizeof(dest));
     
     checK(qlOk = MatrixUnsymEigVecInPlace(@dest[0], 3*sizeof(double), 3, @wr[0], sizeof(double), @wi[0], sizeof(double), 
                                           @eivec[0], 3*sizeof(double)), 'Error no convergence');

     MatrixNormEivecInPlace(@Eivec[0], 3*SizeOf(double), 3, @WI[0], sizeof(double));

     Check(CheckMtx(EigVals, Wr, -1, -1, 0.001), 'Error wrong eigenvalues');
     Check(CheckMtx(EigVec, Eivec, -1, -1, 0.001), 'Error wrong eigenvectors');
end;

procedure TTestEigensystems.TestEigVecComplex;
const A : Array[0..15] of double = (10, 9, 8, 9, 2, 8, 4, 7, 6, 5, 6, 2, 5, 0, 8, 4);
      EigValsR : Array[0..3] of double = (23.2603, 0.9905, 0.9905, 2.7587);
      EigValsI : Array[0..3] of double = (0, 4.5063, -4.5063, 0);
      EigVec : Array[0..15] of double = (1, -0.358, -0.1699, -0.921, 0.498, -0.421, -0.604, 1, 0.548, -0.152, 0.669, 0.715, 0.487, 1, 0, -0.894);
var dest : Array[0..15] of double;
    Eivec : Array[0..15] of double;
    Wr : Array[0..3] of double;
    Wi : Array[0..3] of double;
begin
     FillChar(wr, sizeof(wr), 0);
     FillChar(wi, sizeof(wi), 0);
     FillChar(Eivec[0], sizeof(Eivec), 0);
     Move(A, dest, sizeof(dest));
     checK(qlOk = MatrixUnsymEigVecInPlace(@dest[0], 4*sizeof(double), 4, @wr[0], sizeof(double), @wi[0], sizeof(double), 
                                           @eivec[0], 4*sizeof(double)), 'Error no convergence');

     MatrixNormEivecInPlace(@Eivec[0], 4*SizeOf(double), 4, @WI[0], sizeof(double));

     Check(CheckMtx(EigValsR, WR, -1, -1, 0.001), 'Error wrong real Eigenvalue part');
     Check(CheckMtx(EigValsI, WI, -1, -1, 0.001), 'Error wrong imaginary Eigenvalue part');
     Check(CheckMtx(EigVec, Eivec, -1, -1, 0.001), 'Error wrong eigenvector');
end;

procedure TTestEigensystems.TestHessenberg;
const A : Array[0..8] of double = (3, 1, 1, 2, -2, -1, 5, -1, 8);
      Res : Array[0..8] of double = (3, 1.4, 1, 5, 7.6, -1, 0.4, -4.84, -1.6);
      EigVals : Array[0..2] of double = (2.757, 8.862, -2.619);
var dest : Array[0..8] of double;
    Wr : Array[0..2] of double;
    Wi : Array[0..2] of double;
    checkEig : boolean;
    i, j : integer;
begin
     MatrixHessenberg(@dest[0], 3*sizeof(double), @A[0], 3*sizeof(double), 3);
     Check(CheckMtx(dest, Res), 'Error Hessenberg');

     // check eigenvalues on hessenberg matrix
     MatrixEigHessenberg(@dest[0], 3*sizeof(double), 3, @Wr[0], sizeof(double), @Wi[0], sizeof(double));

     for i := 0 to High(EigVals) do
     begin
          checkEig := False;
          for j := 0 to High(Wr) do
              checkEig := checkEig or (Abs(EigVals[i] - WR[j]) < 0.001);

          if not CheckEig then
             break;
     end;

     Check(CheckEig, 'Error wrong eigenvalues: ' + WriteMtx(WR, 3) + #13#10 + WriteMtx(WI, 3));
end;

procedure TTestEigensystems.TestHessenberg2;
const A : Array[0..15] of double = (    1.0000,    0.5000,    0.3333,    0.2500,
                                        2.0000,    0.1100,    0.2500,    1.1100,
                                        0.3333,    0.6667,    1.0000,    0.7500,
                                        2.0000,    0.9222,    0.2500,    0.1250 );
var dest : Array[0..15] of double;
begin
     move(a, dest, sizeof(dest));
     MatrixHessenbergPermInPlace(@dest[0], 4*sizeof(double), 4, nil, 0);
     Status(WriteMtx(dest, 4));
end;

procedure TTestEigensystems.TestHessenbergCmplx;
const A : Array[0..15] of double = (10, 9, 8, 9, 2, 8, 4, 7, 6, 5, 6, 2, 5, 0, 8, 4);
      EigVals : Array[0..3,0..1] of double = ( (23.2603, 0), (0.9905, -4.5063), (0.9905, 4.5063), (2.7587, 0));
var dest : Array[0..15] of double;
    Wr : Array[0..3] of double;
    Wi : Array[0..3] of double;
begin
     MatrixHessenberg(@dest[0], 4*sizeof(double), @A[0], 4*sizeof(double), 4);

     // check eigenvalues on hessenberg matrix
     MatrixEigHessenberg(@dest[0], 4*sizeof(double), 4, @Wr[0], sizeof(double), @Wi[0], sizeof(double));

     Check((abs(EigVals[0,0] - wr[0]) < 0.0001), 'Error on eigvals calculation');
     Check((abs(EigVals[1,0] - wr[1]) < 0.0001), 'Error on eigvals calculation');
     Check((abs(EigVals[2,0] - wr[2]) < 0.0001), 'Error on eigvals calculation');
     Check((abs(EigVals[3,0] - wr[3]) < 0.0001), 'Error on eigvals calculation');

     Check((abs(EigVals[0,1] - wi[0]) < 0.0001), 'Error on eigvals calculation');
     Check((abs(EigVals[1,1] - wi[1]) < 0.0001), 'Error on eigvals calculation');
     Check((abs(EigVals[2,1] - wi[2]) < 0.0001), 'Error on eigvals calculation');
     Check((abs(EigVals[3,1] - wi[3]) < 0.0001), 'Error on eigvals calculation');
end;

procedure TTestEigensystems.TestLinearDependentVectors;
const B : Array[0..8] of double = (3, 1, 1, 30, 10, 10, 5, -1, 8);
      EigVals : Array[0..2] of double = (0, 11.618, 9.382);
      EigVec : Array[0..8] of double = (-0.4737, 0.1, 0.1, 1, 1, 1.0000, 0.4211, -0.1382, -0.3618);
var Eivec : Array[0..8] of double;
    Wr : Array[0..2] of double;
    Wi : Array[0..2] of double;
begin
     FillChar(EiVec, sizeof(EiVec), 0);
     FillChar(wr, sizeof(wr), 0);
     FillChar(wi, sizeof(wi), 0);
     Check(qlOk = MatrixUnsymEigVec(@B[0], 3*sizeof(double), 3, @Wr[0], sizeof(double), @Wi[0], sizeof(double), @Eivec[0], 3*sizeof(double)), 'error in convergence of eigenvector routine');
     MatrixNormEivecInPlace(@Eivec[0], 3*sizeof(double), 3, @wi[0], sizeof(double));
     
     Check(CheckMtx(EigVals, Wr, -1, -1, 0.001), 'Error wrong eigenvalues');
     Check(CheckMtx(EigVec, Eivec, -1, -1, 0.001), 'Error wrong eigenvectors');
end;

procedure TTestEigensystems.TestQLImplicitShift;
const A : Array[0..8] of double = (3, 2, 1, 2, -2, -1, 1, -1, 8);
      EigVals : Array[0..2] of double = (-2.8521, 3.6206, 8.2315);
var dest : Array[0..8] of double;
    D : Array[0..2] of double;
    E : Array[0..2] of double;
    res : TEigenvalueConvergence;
    checkEig : boolean;
    i, j : Integer;
begin
     FillChar(D[0], sizeof(D), 0);
     FillChar(E[0], sizeof(E), 0);
     MatrixTridiagonalHouse(@dest[0], 3*sizeof(double), @A[0], 3*sizeof(double), 3, @d[0], sizeof(double), @e[0], sizeof(double));
     res := MatrixTridiagonalQLImplicitInPlace(@dest[0], 3*sizeof(double), 3, @d[0], sizeof(double), @E[0], sizeof(Double));

     Check(res = qlOk, 'Error no convergence.');
     for i := 0 to High(EigVals) do
     begin
          checkEig := False;
          for j := 0 to High(D) do
              checkEig := checkEig or (Abs(EigVals[i] - D[j]) < 0.001);

          if not CheckEig then
             break;
     end;
     Check(checkEig, 'Error wrong eigenvalues');
end;

procedure TTestEigensystems.TestTridiagonalHousholderMethod;
const A : Array[0..8] of double = (3, 2, 1, 2, -2, -1, 1, -1, 8);
var dest : Array[0..8] of double;
    D : Array[0..2] of double;
    E : Array[0..2] of double;
begin
     FillChar(D[0], sizeof(D), 0);
     FillChar(E[0], sizeof(E), 0);
     MatrixTridiagonalHouse(@dest[0], 3*sizeof(double), @A[0], 3*sizeof(double), 3, @d[0], sizeof(double), @e[0], sizeof(double));

     // Check on trigonitality
     Check((dest[2] = 0) and (dest[6] = 0), 'Error no tridiagonal matrix');
end;

initialization
{$IFNDEF FMX}
  // Alle Testf�lle beim Test-Runner registrieren
  RegisterTest(TTestEigensystems{$IFNDEF FPC}.Suite{$ENDIF});
{$ENDIF}

end.
