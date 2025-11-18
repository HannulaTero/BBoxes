

/**
* 
* TODOs:
* - This could be done more smarter, as GM already does trimming.
*   -> sprite_get_uvs return how much is trimmed.
*   -> So the PoT size could pay attention to this.
*   -> BBox can't be directly derived from trimmed size, as trimming might have padding.
* - Change behaviour to accommodate offset?
*   -> Either BBOX to be relative to image top-left corner, or sprite origin.
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
  * Uses stretched to ignore X and Y offsets.
  */
  static Draw = function(_x, _y)
  {
    var _spr = self.data;
    var _w = sprite_get_width(_spr);
    var _h = sprite_get_height(_spr);
    draw_sprite_stretched(_spr, self.meta, _x, _y, _w, _h);
  };
}