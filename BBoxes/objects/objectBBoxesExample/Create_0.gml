/// @desc INITIALIZE

show_debug_overlay(true, true);

self.bboxes = new BBoxes("BBoxes Example");


self.surface = undefined;
self.results = [ ];
self.index = 0;


DrawBBoxes = function(_x, _y, _xmin, _ymin, _xmax, _ymax)
{
  _xmin -= 2;
  _ymin -= 2;
  _xmax += 2;
  _ymax += 2;
  draw_sprite_stretched(spriteBBoxesExampleBorder, image_index,
    _x + _xmin, 
    _y + _ymin, 
    _xmax - _xmin, 
    _ymax - _ymin
  );
}