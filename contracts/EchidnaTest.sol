// SPDX-License-Identifier: BSD-4-Clause
pragma solidity ^0.8.1;

import "ABDKMath64x64.sol";

contract Test {
    int128 internal zero = ABDKMath64x64.fromInt(0);
    int128 internal one = ABDKMath64x64.fromInt(1);

    /*
     * Minimum value signed 64.64-bit fixed point number may have.
     */
    int128 private constant MIN_64x64 = -0x80000000000000000000000000000000;

    /*
     * Maximum value signed 64.64-bit fixed point number may have.
     */
    int128 private constant MAX_64x64 = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

    event Value(string, int64);

    function debug(string calldata x, int128 y) public {
        emit Value(x, ABDKMath64x64.toInt(y));
    }

    function fromInt(int256 x) public returns (int128) {
        return ABDKMath64x64.fromInt(x);
    }

    function toInt(int128 x) public returns (int64) {
        return ABDKMath64x64.toInt(x);
    }

    function fromUInt (uint256 x) public returns(int128){
      return ABDKMath64x64.fromUInt(x);
    }

    function toUInt (int128 x) public returns (uint64){
      return ABDKMath64x64.toUInt(x);
    }

    function from128x128 (int256 x) public returns (int128) {
      return ABDKMath64x64.from128x128(x);
    }

    function to128x128 (int128 x) public returns (int256){
      return ABDKMath64x64.to128x128(x);
    }

    function add(int128 x, int128 y) public returns (int128) {
        return ABDKMath64x64.add(x, y);
    }

    function sub (int128 x, int128 y) public returns (int128) {
      return ABDKMath64x64.sub(x, y);
    }

    function mul(int128 x, int128 y) public returns (int128) {
        return ABDKMath64x64.mul(x, y);
    }

    function div(int128 x, int128 y) public returns (int128) {
        return ABDKMath64x64.div(x, y);
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

    // TODO: add more functions with assertions

    /* Check that the input is in range
    and then check that the result is in range too
    Assert fails in out of range input
    */
    function testFromInt(int256 x) public {
      int128 result = this.fromInt(x);
      //pre-conditions
      bool outOfRange = x > 0x7FFFFFFFFFFFFFFF || x < -0x8000000000000000 ? true : false;
    
      //post-conditions
      if(outOfRange){
        try this.fromInt(x) {assert(false); //should fail
        } catch{}
      }
      assert(result <= MAX_64x64 && result >= MIN_64x64);
    }

    function testToInt(int128 x) public {
      int64 result = this.toInt(x);
      int64 max64 = 2**63 -1;
      int64 min64 = -2**63;

      //post-conditions
      assert(result <= max64 && result >= min64);
    }

    /* Check that the shift operation dont overflow
    Reverts when input is greater than 0x7FFFFFFFFFFFFFFF
    */
    function testFromUInt(uint256 x) public {
      int128 result = this.fromUInt(x);
      //pre-conditions
      bool overflow = x > 0x7FFFFFFFFFFFFFFF ? true : false;
      
      if(overflow){
        try this.fromUInt(x) {
          assert(false); //should fail
        } catch {}
      }

      //post-conditions
      assert(result >= MIN_64x64 && result <= MAX_64x64);
    }

    /* Check that the shift operation dont underflow
    Reverts when input is lesser than 0
    */
    function testToUInt(int128 x) public {
      uint64 max64 = 2**63 -1;
      uint64 result =  this.toUInt(x);
      //pre-conditions
      bool underflow = x < 0 ? true : false;

      if(underflow){
        try this.toUInt(x) {
          assert(false); //should fail
        } catch {}
      }
      //post-conditions
      assert(result <= max64);
    }

    /* Reverts on overflow
    */
    function testFrom128x128(int256 x) public {
      int128 result = this.from128x128(x);

      //post-conditions
      bool overflow = result > MAX_64x64 || result < MIN_64x64 ? true : false;

      if(overflow){
        try this.from128x128(x) {
          assert(false); //should fail
        } catch {}
      }
      
      assert(result <= MAX_64x64 && result >= MIN_64x64);
      
    }

    function testTo128x128 (int128 x) public {
      int256 max256 = 2**255 -1;
      int256 min256 = -2**255; 
      int256 result = this.to128x128(x);

      //post-conditions
      assert(result >= min256 && result <= max256);
    }

    /* Check that the following statements are true: 
      x & y >= 0 => result >= x & y
      x & y <= 0 => result <= x & y
      x>=0 & y<=0 => result<=x & result>=y
      x<=0 & y>=0 => result>=x & result<=y
  */
    function testAdd(int128 x, int128 y) public {
        // TODO
        int128 result64x64 = this.add(this.fromInt(x), this.fromInt(y));
        int128 resultInt = this.toInt(result64x64);
        bool overflow = result64x64 > MAX_64x64 || result64x64 < MIN_64x64
            ? true
            : false;

        //post-condicions
        if (overflow) {
            try this.add(this.fromInt(x), this.fromInt(y)) {
                assert(false); //should fail
            } catch {}
        }
        if (x >= 0 && y >= 0) {
            assert(resultInt >= x && resultInt >= y);
        } else if (x >= 0 && y <= 0) {
            assert(resultInt <= x && resultInt >= y);
        } else if (x <= 0 && y >= 0) {
            assert(resultInt >= x && resultInt <= y);
        } else {
            assert(resultInt <= x && resultInt <= y);
        }
    }

    /* Check that the following statements are true: 
      x & y >= 0  & x >= y => result <= x & result <= y & result >= 0
      x & y >= 0  & x <= y => result <= x & result <= y & result <= 0
      x & y <= 0  & x >= y => result >= x & result >= y & result >= 0
      x & y <= 0  & x <= y => result >= x & result >= y & result >= 0   
        */
    function testSub(int128 x, int128 y) public {
        // TODO
        int128 result64x64 = this.sub(this.fromInt(x), this.fromInt(y));
        int128 resultInt = this.toInt(result64x64);
        bool underflow = result64x64 < MIN_64x64
            ? true
            : false;

        //post-condicions
        if (underflow) {
            try this.sub(this.fromInt(x), this.fromInt(y)) {
                assert(false); //should fail
            } catch {}
        }
        if (x >= 0 && y >= 0 && x >= y) {
            assert(resultInt <= x && resultInt <= y && resultInt >= 0);
        } else if (x >= 0 && y >= 0 && x <= y) {
            assert(resultInt >= x && resultInt >= y && resultInt >= 0);
        } else if (x <= 0 && y <= 0 && x >= y) {
            assert(resultInt >= x && resultInt <= y);
        } else if (x <= 0 && y <= 0 && x <= y) {
            assert(resultInt >= x && resultInt >= y && resultInt <= 0);
        }
    }

    
    /* Check that the following statements are true: 
      x & y >= 0 => result >= 0
      x & y <= 0 => result >= 0
      x>=0 & y<=0 => result<=0 & result <= x
      x<=0 & y>=0 => result<=x & result<=y & result<=0
  */
    function testMul(int128 x, int128 y) public {
        // TODO
        int128 result64x64 = this.mul(this.fromInt(x), this.fromInt(y));
        int128 resultInt = this.toInt(result64x64);
        bool overflow = result64x64 > MAX_64x64 || result64x64 < MIN_64x64
            ? true
            : false;

        //post-condicions
        if (overflow) {
            try this.mul(this.fromInt(x), this.fromInt(y)) {
                assert(false); //should fail
            } catch {}
        }
        if (x >= 0 && y >= 0) {
            assert(resultInt >= 0);
        } else if (x >= 0 && y <= 0) {
            assert(resultInt <= x && resultInt <= 0);
        } else if (x <= 0 && y >= 0) {
            assert(resultInt <= x && resultInt <= y && resultInt <= 0);
        } else {
            assert(resultInt >= x && resultInt >= y && resultInt >= 0);
        }
    }

    function testDiv(int128 x, int128 y) public {
        // TODO
        int128 result64x64 = this.div(this.fromInt(x), this.fromInt(y));
        bool overflow = result64x64 > MAX_64x64 || result64x64 < MIN_64x64
            ? true
            : false;

        //pre-conditions
        bool divisionByZero = y == 0 ? true : false;

        //post-condicions
        if (divisionByZero || overflow) {
            try this.div(this.fromInt(x), this.fromInt(y)) {
                assert(false); //should fail
            } catch {}
        }
        if (x >= 0 && y >= 0) {
            assert(result64x64 >= 0);
        } else if (x >= 0 && y <= 0) {
            assert(result64x64 <= 0);
        } else if (x <= 0 && y >= 0) {
            assert(result64x64 <= 0);
        } else {
            assert(result64x64 >= 0);
        }
    }
}
