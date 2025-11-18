  
/**
* Decode Z-curve resolution.
* 
* @param {Real} _index
*/ 
function BBoxesZResolution(_index)
{
  // Sanity check.
  if (_index <= 0) 
  {
    return 1;
  }
  
  // Take most significant bit, position of highest 1bit.
  var _highest = BBoxesBitLength(_index) - 1;
  
  // XY area interleaved, remove other.
  var _length = (_highest >> 1);
  
  // Get the size.
  return (1 << _length);
}