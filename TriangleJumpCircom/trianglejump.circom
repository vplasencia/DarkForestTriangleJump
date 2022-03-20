pragma circom 2.0.0;

include "./utils/comparators.circom";

/*

A(x1,y1)
B(x2,y2)
C(x3,y3)

TriangleArea = [x1(y2-y3) + x2(y3-y1) + x3(y1-y2)]/2

Three point form a triangle if and only if the TriangleArea > 0

- To verify this, we only need to check: x1(y2-y3) + x2(y3-y1) + x3(y1-y2) != 0

Distance between two points: sqrt((x2-x1)^2 + (y2-y1)^2 <= energy^2)

- Check if the distance between two points is <= energy: (x2-x1)^2 + (y2-y1)^2 <= energy^2

*/



template TriangleJump() {   
   signal input x1;  
   signal input y1;
   signal input x2;  
   signal input y2;
   signal input x3;  
   signal input y3;

   signal input energy;

   signal output isValidMove;

   // AB Distance
   signal diffABX;
   diffABX <== x2 - x1;
   signal diffABY;
   diffABY <== y2 - y1;
   signal squareABX;
   squareABX <== diffABX * diffABX;
   signal squareABY;
   squareABY <== diffABY * diffABY;
   
   // BC Distance
   signal diffBCX;
   diffBCX <== x3 - x2;
   signal diffBCY;
   diffBCY <== y3 - y2;
   signal squareBCX;
   squareBCX <== diffBCX * diffBCX;
   signal squareBCY;
   squareBCY <== diffBCY * diffBCY;

   // AC Distance
   signal diffACX;
   diffACX <== x3 - x1;
   signal diffACY;
   diffACY <== y3 - y1;
   signal squareACX;
   squareACX <== diffACX * diffACX;
   signal squareACY;
   squareACY <== diffACY * diffACY;

   // AB Distance <= energy 
   component ltEnergy1 = LessEqThan(32);
   ltEnergy1.in[0] <== squareABX + squareABY;
   ltEnergy1.in[1] <== energy * energy;
   ltEnergy1.out === 1;

   // BC Distance <= energy 
   component ltEnergy2 = LessEqThan(32);
   ltEnergy2.in[0] <== squareBCX + squareBCY;
   ltEnergy2.in[1] <== energy * energy;
   ltEnergy2.out === 1;

   // A part of the triangle area 
   signal triangleOp1;
   triangleOp1 <== x1*(y2-y3);
   signal triangleOp2;
   triangleOp2 <== x2*(y3-y1);
   signal triangleOp3;
   triangleOp3 <== x3*(y1-y2);

   // If that part of the triangle area is zero, it means that it is not a triangle 
   component iz = IsZero();
   iz.in <== triangleOp1 + triangleOp2 + triangleOp3;

   signal isTriangle;
   isTriangle <== 1 - iz.out;
   isTriangle === 1;

   signal isValidMove1;
   isValidMove1 <== isTriangle;
   signal isValidMove2;
   isValidMove2 <== ltEnergy1.out * ltEnergy2.out;

   isValidMove <== isValidMove1 * isValidMove2;   
}

component main {public [energy]} = TriangleJump();