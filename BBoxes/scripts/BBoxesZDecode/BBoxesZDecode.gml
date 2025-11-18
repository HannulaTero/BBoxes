  
/**
* Decode Z-curve index into XY -position.
* 
* @param {Real} _index
*/ 
function BBoxesZDecode(_index)
{
  return [
    BBoxesZDecodeX(_index),
    BBoxesZDecodeY(_index)
  ];
}