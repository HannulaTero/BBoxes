

/**
* 
* TODOs:
* - This could be done more smarter, as GM already does trimming.
*   -> sprite_get_uvs return how much is trimmed.
*   -> So the PoT size could pay attention to this.
*   -> BBox can't be directly derived from trimmed size, as trimming might have padding.
* 
* @param {Asset.GMSprite}   _spr
* @param {Real}             _img
* @param {Function}         _Callback
*/ 
function BBoxesRequestImage(_spr, _img=0, _Callback=undefined) : BBoxesRequest(_spr, _img, _Callback) constructor
{
  // Calculate the sorting key.
  var _w = sprite_get_width(_spr);
  var _h = sprite_get_height(_spr);
  self.size = max(
    BBoxesNextPoT(_w), 
    BBoxesNextPoT(_h)
  ); 
  
  
  
  /**
  * Draw currently requested image at given position.
  */
  static Draw = function(_x, _y)
  {
    draw_sprite(self.data, self.meta, _x, _y);
  };
}