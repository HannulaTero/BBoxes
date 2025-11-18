/// @desc VISUALIZE RESULTS.

var _count = array_length(self.results);
draw_text(64, 128, "Press [SPACE] to run example.");
draw_text(64, 144, "Mouse [WHEEL] to show results.");
draw_text(64, 160, "Mouse [LEFT/RIGHT] for debugging Z-curve / Morton code.");
draw_text(64, 176, $"Result: {self.index + 1} / {_count}");

// Change current example.
self.index += mouse_wheel_down() - mouse_wheel_up();
self.index = clamp(self.index, 0, _count - 1);


// Visualize selected example.
// You shouldn't use request directly but I am just doing it for quick example.
if (_count > 0)
{
  var _request = self.results[self.index];
  
  // Draw the sprite.
  var _x = room_width * 0.5;
  var _y = room_height * 0.5;
  draw_sprite(_request.data, _request.meta, _x, _y);

  // Draw the bounding box. 
  // -> BBox for now is relative to the images top-left corner.
  var _xoffset = sprite_get_xoffset(_request.data);
  var _yoffset = sprite_get_yoffset(_request.data);
  draw_rectangle(
    _x + _request.xmin - _xoffset,
    _y + _request.ymin - _yoffset,
    _x + _request.xmax - _xoffset,
    _y + _request.ymax - _yoffset,
    true
  );
}
