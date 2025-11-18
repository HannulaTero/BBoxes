  
/**
* Encode X/Y -position into Z-curve index.
* 
* @param {Real} _x
* @param {Real} _t
*/ 
function BBoxZEncode(_x, _y)
{
  static functor = function(_pos)
  {
    _pos &= 0x0000FFFF;
    _pos = (_pos | (_pos << 8)) & 0x00FF00FF;
    _pos = (_pos | (_pos << 4)) & 0x0F0F0F0F;
    _pos = (_pos | (_pos << 2)) & 0x33333333;
    _pos = (_pos | (_pos << 1)) & 0x55555555;
    return _pos;
  };
  return functor(_x) | (functor(_y) << 1);
}