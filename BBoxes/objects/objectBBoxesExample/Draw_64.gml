/// @desc VISUALIZE RESULTS.

// Change current example.
var _count = array_length(self.results);
self.index += mouse_wheel_down() - mouse_wheel_up();
self.index = clamp(self.index, 0, _count - 1);

// Draw infor.
{
  var _i = 0;
  var _h = 16;
  var _x = 64; 
  var _y = 128; 
  draw_text(_x, _y + _h * _i++, "Press [Q] to run Sprite example.");
  draw_text(_x, _y + _h * _i++, "Press [W] to run Surface example.");
  draw_text(_x, _y + _h * _i++, "Press [DELETE] to clear examples.");
  draw_text(_x, _y + _h * _i++, "Mouse [WHEEL] to change current result.");
  draw_text(_x, _y + _h * _i++, "Mouse [MIDDLE] for debugging Z-curve / Morton code.");
  draw_text(_x, _y + _h * _i++, "Mouse [LEFT/RIGHT] Edit surface.");
  draw_text(_x, _y + _h * _i++, "---");
  draw_text(_x, _y + _h * _i++, $"Result: {self.index + 1} / {_count}");
}


// Draw onto surface.
if (surface_exists(self.surface) == false)
{
  self.surface = surface_create(room_width, room_height);  
  surface_set_target(self.surface);
  draw_clear_alpha(c_black, 0);
  surface_reset_target();
  
}

surface_set_target(self.surface);
{
  if (device_mouse_check_button(0, mb_left) == true)
  {
    var _color = make_color_hsv(irandom(255), 160, 192);
    draw_circle_color(mouse_x, mouse_y, 16, _color, _color, false);
  }

  if (device_mouse_check_button(0, mb_right) == true)
  {
    gpu_set_blendmode_ext(bm_one, bm_zero);
    draw_set_alpha(0.0);
    draw_circle(mouse_x, mouse_y, 24, false);
    draw_set_alpha(1.0);
    gpu_set_blendmode(bm_normal);
  }
}
surface_reset_target();


// Draw the surface.
draw_surface(self.surface, 0, 0);


// Visualize selected example.
// You shouldn't use request directly but I am just doing it for quick example.
if (_count > 0)
{
  var _request = self.results[self.index];
  
  if (is_instanceof(_request, BBoxesRequestImage) == true)
  {
    // Draw the sprite.
    var _x = room_width * 0.5;
    var _y = room_height * 0.5;
    draw_sprite(_request.sprite, _request.image, _x, _y);

    // Draw the bounding box. 
    // -> BBox for now is relative to the images top-left corner.
    var _xoffset = sprite_get_xoffset(_request.sprite);
    var _yoffset = sprite_get_yoffset(_request.sprite);
    draw_rectangle(
      _x + _request.xmin - _xoffset,
      _y + _request.ymin - _yoffset,
      _x + _request.xmax - _xoffset,
      _y + _request.ymax - _yoffset,
      true
    );
  }
  
  // Draw the surface bounding box. 
  // Assume surface is being drawn already on (0,0)
  if (is_instanceof(_request, BBoxesRequestSurface) == true)
  {
    draw_rectangle(
      _request.xmin,
      _request.ymin,
      _request.xmax,
      _request.ymax,
      true
    );
  }
}
