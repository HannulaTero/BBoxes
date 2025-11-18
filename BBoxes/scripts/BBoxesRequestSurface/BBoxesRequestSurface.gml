

/**
* 
* 
* @param {String} _label For identifying purposes.
*/ 
function BBoxesRequestSurface(_label=undefined) : BBoxesRequest() constructor
{
  // Define the label.
  self.SetLabel(_label);
  
  
  // The surface reference, which bbox is trying to solve.
  self.surface = undefined;
  
  
  
  /**
  * Draw currently requested surface at given position.
  * The verification should already been done.
  *
  * @param {Real} _x
  * @param {Real} _y
  * @ignore
  */
  static Draw = function(_x, _y)
  {
    draw_surface(self.surface, _x, _y);
    return self;
  };
  
  
  
  /**
  * Assigns the surface, and updates the PoT -size.
  * 
  * @param {Id.Surface} _surface
  */ 
  static SetSurface = function(_surface)
  {
    // Sanity check.
    if (surface_exists(_surface == false))
    {
      show_debug_message($"[{self}] Surface '{_surface}' doesn't exist.");
      return self;
    }
    
    // Assign the asset.
    self.surface = _surface;
    
    // Calculate the sorting key.
    var _w = surface_get_width(_surface);
    var _h = surface_get_height(_surface);
    self.size = max(
      BBoxesNextPoT(_w), 
      BBoxesNextPoT(_h)
    );
    return self;
  };
}