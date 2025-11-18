  
/**
* Decode Z-curve index into Y -position.
* 
* @param {Real} _index
*/ 
function BBoxesZDecodeY(_index)
{
  return BBoxesZDecodeX(_index >> 1);
}