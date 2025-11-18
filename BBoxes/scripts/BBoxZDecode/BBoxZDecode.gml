  
/**
* Decode Z-curve index into XY -position.
* 
* @param {Real} _index
*/ 
function BBoxZDecode(_index)
{
  return [
    BBoxZDecodeX(_index),
    BBoxZDecodeY(_index)
  ];
}