
/**
* Returns next power of two for given value.
* Assumes whole number or integer.
*
* @param {Real} _value
*/ 
function BBoxNextPoT(_value)
{
  return power(2, ceil(log2(_value))); 
}