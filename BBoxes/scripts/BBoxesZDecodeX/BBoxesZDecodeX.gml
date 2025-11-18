  
/**
* Decode Z-curve index into X -position.
* 
* @param {Real} _index
*/ 
function BBoxesZDecodeX(_index)
{
  var _pos = _index & 0x55555555;
  _pos = (_pos ^ (_pos >> 1)) & 0x33333333;
  _pos = (_pos ^ (_pos >> 2)) & 0x0F0F0F0F;
  _pos = (_pos ^ (_pos >> 4)) & 0x00FF00FF;
  _pos = (_pos ^ (_pos >> 8)) & 0x0000FFFF;
  return _pos;
}