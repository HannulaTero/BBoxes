
/**
* Returns the bit-length of given value.
* Assumes whole number or integer.
*
* @param {Real} _value
*/ 
function BBoxesBitLength(_value)
{
  return floor(log2(_value)) + 1;
}