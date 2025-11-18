/// @desc DEBUGGING.


// Z-Curve / morton code visualization.
if (device_mouse_check_button(0, mb_middle) == true)
{
  for(var i = 0; i < mouse_x; i++)
  {
    var _w = 8;
    var _h = 8;
    var _x = 256 + _w * BBoxesZDecodeX(i);
    var _y = 256 + _h * BBoxesZDecodeY(i);
    draw_sprite_stretched(spriteBBoxes1x1, 1, _x, _y, _w, _h);
  }
}

