// SPDX-License-Identifier: BSD-4-Clause
pragma solidity ^0.8.1;

import "./ABDKMath64x64.sol";

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

    function muli (int128 x, int256 y) public returns (int256){
        return ABDKMath64x64.muli(x, y);
    }

    function mulu (int128 x, uint256 y) public returns (uint256) {
        return ABDKMath64x64.mulu(x, y);
    }

    function div(int128 x, int128 y) public returns (int128) {
        return ABDKMath64x64.div(x, y);
    }

    function divi (int256 x, int256 y) public returns (int128){
        return ABDKMath64x64.divi(x, y);
    } 

    function divu (uint256 x, uint256 y) public returns (int128){
        return ABDKMath64x64.divu(x, y);
    }

    function neg(int128 x) public returns (int128) {
        return ABDKMath64x64.neg(x);
    }

    function abs (int128 x) public returns (int128){
        return ABDKMath64x64.abs(x);
    }

    function inv(int128 x) public returns (int128) {
        return ABDKMath64x64.inv(x);
    }

    function avg (int128 x, int128 y) public returns (int128) {
         return ABDKMath64x64.avg(x,y);
    }

    function gavg (int128 x, int128 y) public returns (int128){
        return ABDKMath64x64.gavg(x,y);
    }

    function pow(int128 x, uint256 y) public returns (int128) {
        return ABDKMath64x64.pow(x, y);
    }

    function sqrt(int128 x) public returns (int128) {
        return ABDKMath64x64.sqrt(x);
    }

    function log_2 (int128 x) public returns (int128){
        return ABDKMath64x64.log_2(x);       
    }

    function ln (int128 x) public returns (int128){
        return ABDKMath64x64.ln(x);
    }

    function exp_2 (int128 x) public returns (int128){
        return ABDKMath64x64.exp_2(x);
    }

    function exp (int128 x) public returns (int128) {
         return ABDKMath64x64.exp(x);
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

    /*  Check that x < Max64x64 & x > Min64x64
    */
    function testToInt(int128 x) public {
      int64 result = this.toInt(x);

      //post-conditions
      assert(result <= MAX_64x64 && result >= MIN_64x64);
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
    Result should be lesser than max int64
    If the input is lesser than 2*64 the result should be 0
    */
    function testToUInt(int128 x) public {
      uint64 result =  this.toUInt(x);
      //pre-conditions
      bool underflow = x < 0 ? true : false;

      if(underflow){
        try this.toUInt(x) {
          assert(false); //should fail
        } catch {}
      }
      //post-conditions
      assert(result <= 2**63-1 ); //result should be lesser than the max int64
      
      if(x < 2*64){
          assert(result == 0); //for all input lesser than 2*64 the result is 0
      }
    }

    /* Reverts on overflow
    The result should be in range of int128
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

    /* Never reverts if the input is an int128
    */
    function testTo128x128 (int128 x) public {
      int256 max256 = 2**255 -1;
      int256 min256 = -2**255; 
      int256 result = this.to128x128(x);
      //pre-conditions
      assert(x <= MAX_64x64 && x >= MIN_64x64);
      //post-conditions
      assert(result >= min256 && result <= max256);
    }

    /* Check that the following statements are true: 
      x & y >= 0 => result >= x & y
      x & y <= 0 => result <= x & y
      x>=0 & y<=0 => result<=x & result>=y
      x<=0 & y>=0 => result>=x & result<=y

      Check that the following properties hold
    x + y == y + x
    (x + y) + z = x + (y + z)
    x + 0 = x
  */
    function testAdd(int128 x, int128 y, int128 z) public {
        // TODO
        int128 result = add(x, y);
        bool overflow = result > MAX_64x64 || result < MIN_64x64
            ? true
            : false;

        //post-condicions
        if (overflow) {
            try this.add(x, y) {
                assert(false); //should fail
            } catch {}
        }
        if (x >= 0 && y >= 0) {
            assert(result >= x && result >= y);
        } else if (x >= 0 && y <= 0) {
            assert(result <= x && result >= y);
        } else if (x <= 0 && y >= 0) {
            assert(result >= x && result <= y);
        } else {
            assert(result <= x && result <= y);
        }

        assert(result == add(y,x)); //check that commutative hold   

        //check that associative property holds
        try this.add(this.add(x,y),z) returns(int128 result1){ //do (x + y) + z
             try this.add(this.add(y,z),x) returns(int128 result2){ // do x + (y + z)
                assert(result1 == result2);
             } catch {/*assert(false);*/} //revert because overflow 
        } catch { /*assert(false);*/} //reverted skiped to test associative propierty 

        //check that neutro element exist
        assert(add(x,0) == x);
        

       

    }

    /* Check for overflow
    check that: 0 - 0 = 0
                a - a = 0
                x - 0 = x
                0 - y = -y
    Check that substraccion is not commutative
        */
    function testSub(int128 x, int128 y) public {
        // TODO
        int128 result64x64 = this.sub(x,y);
        int128 resultInverted = this.sub(y,x);
        bool overflow = result64x64 < MIN_64x64 || result64x64 > MAX_64x64
            ? true
            : false;

        //post-condicions
        if (overflow) {
            try this.sub(x, y) {
                assert(false); //should fail
            } catch {}
        }
        if( (x==0 && y == 0) || x == y){
            assert(result64x64 == 0);
            return;
        } else if ( y == 0){
            assert(result64x64 == x);
            return;
        } else if ( x == 0){
            assert(result64x64 == this.neg(y));
            return;
        }

        assert(result64x64 != resultInverted);
    }

    
    /* Check that the following statements are true: 
      x & y > 0 => result > 0
      x & y <= 0 => result >= 0
      x>0 & y<0 => result<0  & result < x
      x<0 & y>0 => result<=y & result=0

      Check that the following properties hold:
      1) commutative
      2) associative
      3) neutral element
      4) distributive property
  */
    function testMul(int128 x, int128 y, int128 z) public {
        // TODO
        require(x >= 10000000000000000000 && y >= 10000000000000000000 && z >= 10000000000000000000);//brute force so that the result isnt rounded to 0
        int128 result = this.mul(x, y);
        bool overflow = result > MAX_64x64 || result < MIN_64x64
            ? true
            : false;

        //post-condicions
        if (overflow) {
            try this.mul(x, y) {
                assert(false); //should fail
            } catch {}
        }
        if (x > 0 && y > 0) {
            assert(result > 0);
           
        } else if (x > 0 && y < 0) {
            assert(result < x && result < 0);
          
        } else if (x < 0 && y > 0) {
            assert( result < y && result < 0);
          
        } else {
            assert(result >= 0);
       
        }

        assert(result == mul(y,x)); // commutative propertie

        //check that associative property holds
        try this.mul(this.mul(x,y),z) returns(int128 result1){ //do (x . y) . z
             try this.mul(this.mul(y,z),x) returns(int128 result2){ // do x . (y . z)
                assert(result1 == result2);
             } catch {/*assert(false);*/} //revert because overflow 
        } catch { /*assert(false);*/} //reverted skiped to test associative property 

        // neutral element
        assert( mul(x,one) == x);

        // distributive property
        try this.mul(x,this.add(y,z)) returns(int128 result1){ //do x . (y + z)
             try this.add(this.mul(x,y),this.mul(x,z)) returns(int128 result2){ // do x.y + x.z
               assert(result1 == result2);
             } catch {/*assert(false);*/} //revert because overflow 
        } catch { /*assert(false);*/} //reverted skiped to test associative property 


    }

    /* Check that the result is inside the boundries
    */
    function testMuli(int128 x, int256 y) public {
        int256 max256 = 2**255 -1;
        bool outOfRange; 
        //pre-conditions
        if(x == MIN_64x64){
            outOfRange = y < -0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF || y > 0x1000000000000000000000000000000000000000000000000 ? true : false;
        }
        if (outOfRange) {
            try this.muli(x, y) {
                assert(false); //should fail
            } catch {}
        }

        //post-conditions
        int result = this.muli(x,y);
        bool negativeResult = result >= 0 ? false : true;
        if(negativeResult){
            assert(result <= max256);
            return;
        } else {
            assert(result <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
        }
    }
    /* x cannot be negative
     0 * c = 0
     */
    function testMulu (int128 x, uint256 y) public{
        x = x % (MAX_64x64);
        //pre-conditions
        bool negativeInput = x < 0 ? true : false;
        if(negativeInput){
            try this.mulu(x,y) {
                assert(false);
            } catch {}
        }
        
        uint256 result = this.mulu(x,y);
         //post-conditions
         if( x == 0 || y == 0){
             assert(result == 0);
         }
    }
    /* Check division by 0, overflow and that the rule of signs holds
    Also x/y != y/x if abs(x) != abs(y)
     */
    function testDiv(int128 x, int128 y) public {
        // TODO
        int128 result64x64 = this.div(x, y);
        bool overflow = result64x64 > MAX_64x64 || result64x64 < MIN_64x64
            ? true
            : false;

        //pre-conditions
        bool divisionByZero = y == 0 ? true : false;

        //post-condicions
        if (divisionByZero || overflow) {
            try this.div(x, y) {
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

        if(abs(x) != abs(y)){
            assert(result64x64 != div(y,x));
        }
    }

    /* Check division by 0
    check that the result is in the limits
    Also x/y != y/x if abs(x) != abs(y)
    0/c = 0
     */
    function testDivi (int256 x, int256 y) public {
        // pre-conditions
        bool divitionByZero = y == 0 ? true : false;
        bool negativeResult;
        int128 result = this.divi(x,y);
        if (x < 0 && y < 0){
            negativeResult = false;
        }else if(x < 0 || y < 0){
            negativeResult = true;
        } 
        

        if(divitionByZero){
             try this.divi(x,y){
                 assert(false); //should fail
             } catch{}
        }
        if(x==0) {
            assert(result == 0);
            return;
        }

        //post-conditions
        if(negativeResult) {
            assert(-result <= -MIN_64x64);
        } else {
            assert(result <= MAX_64x64);
        }

        if(abs(x) != abs(y)){
            assert(result64x64 != divi(y,x));
        }
        
    } 

    /* Check division by 0
    check that the result is in the limits
    Also x/y != y/x if abs(x) != abs(y)
    0/c = 0
     */
    function testDivu (uint256 x, uint256 y) public {
        
        //pre-conditions
        bool divitionByZero = y == 0 ? true : false;
        
        if (divitionByZero) {
            try this.divu(x,y) {
                assert(false); // should fail
            } catch {}
        }
        //post-conditions
        int128 result = this.divu(x,y);
        assert(result <= MAX_64x64);

        if(x==0) {
            assert(result == 0);
            return;
        }
        if(abs(x) != abs(y)){
            assert(result64x64 != divu(y,x));
        }

    }

    /* Check if the result will overflow
        -0 = 0
        check for the switch of signs
     */ 
    function testNeg (int128 x) public {
        //pre-conditions
        bool overflow = x == MIN_64x64 ? true : false;

        if(overflow) {
            try this.neg(x) {
                assert(false); //should fail
            } catch {}
        }
        //post-conditions
        int128 result = this.neg(x);
        if(x == 0){
            assert(result == 0);
        } else if (x < 0){
            assert(result > 0);
        } else if (x > 0){
            assert(result < 0);
        }
    }

    /* Check if the result can overflow
    |0| = 0
    |x| = x
    |-x| = x
     */
    function testAbs (int128 x) public {
        //pre-conditions
        bool overflow = x == MIN_64x64 ? true : false;

        if(overflow){
            try this.abs(x) {
                assert(false);
            } catch{}
        }
        int128 result = this.abs(x);
        if(x == 0){
            assert(result == 0);
            return;
        }

        if(x > 0) {
            assert(result == x);
        } else {
            assert(result == -x);
        }
    }

    /* input cannot be 0 
    if x < 1 then the absolute result will be greater than 1
    if x > 1 then the absolute result will be lesser than 1
    */
    function testInv(int128 x) public {
        //pre-conditions
        bool divitionByZero = x == 0 ? true : false;
        if(divitionByZero){
            try this.inv(x){
                assert(false); //should fail
            } catch {return;}
            
        }
        int128 result = this.inv(x);
        //post-conditions
        assert(result >= MIN_64x64 && result <= MAX_64x64);

        if(x > 0){
            if(x == one){
                assert(result == one);
                return;
            } else if (x < one){
                assert(result > one);
                return;
            } else if(x > one){
                assert(result < one);
                return;
             }
        } else {
            if(x == -one){
                assert(result == -one);
                return;
            } else if (x < -one){
                assert(result > -one);
                return;
            } else if(x > one){
                assert(result < -one);
                return;
             }
        }
    }

    /* The average of 2 positive numbers is lesser or equal than the greatest number
     */
    function testAvg (int128 x, int128 y) public {
        int128 result = this.avg(x,y);
        

        //post-conditions
        if(result > 0){
            if(x >= y ){
                assert(result <= x);
            } else {
                assert(result <= y);
            }
        }
    }

    /*inputs should have the same sign
     if x = y the result is c = x = y
     */
    function testGavg (int128 x, int128 y) public {
        //pre-conditions
        bool negativeResult = x * y < 0 ? true : false;

        if(negativeResult){
            try this.gavg(x, y) {
                assert(false); //should fail 
            } catch {}
        }
        //post-conditions
        int128 result = gavg(x,y);
        if(abs(x) == abs(y)){
            assert(result == abs(x));
        }
    }

    /* if x < 0 and y is odd then result < 0
        x < 0 and y is even  then result > 0 
     */
    function testPow (int128 x, uint256 y) public {
        require(x >= 7000000000000); // hardcoded so the result isnt rounded to 0
        int128 result = this.pow(x, y);
        //post-conditions
        bool overflow = result > MAX_64x64 || result < MIN_64x64 ? true : false;

        if(overflow){
            try this.pow(x, y){
                assert(false);
            } catch{}
        }
        bool impar = y & 1 == 1 ? true : false;
        if(x < 0 && impar){
            assert(result < 0);
        } else{
            assert(result > 0);
        }
    } 

    /* x cannot be lesser than 0
    result is always greater than 0
     */
    function testSqrt(int128 x) public {
        //pre-conditions
        bool negativeSqrt = x < 0 ? true : false;
        if(negativeSqrt){
            try this.sqrt(x){
                assert(false);
            } catch {}
        }

        int128 result = this.sqrt(x);
        //post-conditions
        assert(result >= 0);
    }

    /* input cant be 0 or less
    check boundries of the result
     */
    function testLog_2 (int128 x) public{
        //pre-conditions
        bool negativeInput = x <= 0 ? true : false;

        if(negativeInput){
            try this.log_2(x){
                assert(false);
            } catch {}
        }
        int128 result = this.log_2(x);
        
        //post-conditions
        assert(result >= -1180591620717411303424 && result <= 1162144876643701751807); //smallest and greatest results that can return
    }

    /* input cant be 0 or less
    ln 1 = 0
     */
    function testLn (int128 x) public {
        //pre-conditions 
        bool invalidInput = x <= 0 ? true : false;

        if(invalidInput){
            try this.ln(x){
                assert(false);
            } catch{}
        }

        int128 result = ln(x);
        //post-conditions
        if(x == one){
            assert(result == 0);
        }
    }

    /* check the input so the result cannot overflow
    2** 0 = 1
    if x < 1 then 2**x < 2
     */
    function testExp_2 (int128 x) public {
        //pre-conditions
        bool overflow = x >= 1180591620717411303424 ? true  : false;
        

        if(overflow){
            try this.exp_2(x){
                assert(false);
            } catch {}
        }

        int128 result = exp_2(x);
        
        //post-conditions
        if(x == 0){
            assert(result == one);
            return;
        } else if ( x < one){
            assert(result < one * 2);
        }
    }

    /* if x is too low the result will be 0
    check for overflow
     */
    function testExp (int128 x) public {
        //pre-conditions
        bool overflow = x >= 1180591620717411303424 ? true : false; //extract from the library

        if(overflow) {
            try this.exp(x) {
                assert(false);
            } catch {}
        }

        int128 result = exp(x);
        if(int128 (int256 (x) * 0x171547652B82FE1777D0FFDA0D23A7D12 >> 128) < -0x400000000000000000){
            assert(result == 0);
        }

     }

}
