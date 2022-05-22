import "./ABDKMath64x64.sol";

pragma solidity ^0.8.0;
contract Greeter {
   int128 internal zero = ABDKMath64x64.fromInt(0);
   int128 internal one = ABDKMath64x64.fromInt(1);

   event Value(string, int64);
   function debug(string calldata x, int128 y) public {
     emit Value(x, ABDKMath64x64.toInt(y));
   }
 
   function add(int128 x, int128 y) public pure returns (int128) {
     return ABDKMath64x64.add(x, y);
   }

   function mul(int128 x, int128 y) public pure returns (int128) {
     return ABDKMath64x64.mul(x, y);
   }

   function div(int128 x, int128 y) public pure returns (int128) {
     return ABDKMath64x64.div(x, y);
   }

   function fromInt(int256 x) public pure returns (int128) {
     return ABDKMath64x64.fromInt(x);
   }

   function toInt(int128 x) public pure returns (int64) {
     return ABDKMath64x64.toInt(x);
   }


   function pow(int128 x, uint256 y) public returns (int128) {
     return ABDKMath64x64.pow(x, y);
   }

   function neg(int128 x) public returns (int128) {
     return ABDKMath64x64.neg(x);
   }

   function inv(int128 x) public returns (int128) {
     return ABDKMath64x64.inv(x);
   }

   function sqrt(int128 x) public returns (int128) {
     return ABDKMath64x64.sqrt(x);
   }

   function shift(int256 x, uint256 y) public pure returns(int256){
      return x << y;
   }
}
