  
/**
* Decode Z-curve index into Y -position.
* 
* @param {Real} _index
*/ 
function BBoxZDecodeY(_index)
{
  return BBoxZDecodeX(_index >> 1);
}