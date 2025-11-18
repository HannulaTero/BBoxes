

/**
* 
* 
* @param {Id.Surface} _surface
* @param {Function}   _Callback
*/ 
function BBoxesRequestSurface(_surface, _Callback=undefined) : BBoxesRequest(_surface, undefined, _Callback) constructor
{
  // Calculate the sorting key.
  var _w = surface_get_width(_surface);
  var _h = surface_get_height(_surface);
  self.size = max(
    BBoxesNextPoT(_w), 
    BBoxesNextPoT(_h)
  );
  
  
  
  /**
  * Draw currently requested surface at given position.
  * The verification should already been done.
  */
  static Draw = function(_x, _y)
  {
    draw_surface(self.data, _x, _y);
  };
}