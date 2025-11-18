/// @desc APPLY BBOXES.

draw_text(64, 64, "Press [SPACE] to run example.");

if (keyboard_check_pressed(vk_space) == true)
{
  // Add 64x64 sprites.
  {
    var _spr = spriteBBoxesExample190x160;
    var _count = sprite_get_number(_spr);
    for(var i = 0; i < _count; i++)
    {
      self.bboxes.AddImage(_spr, i);
    }
  }
  
  // Add 192x160 sprites.
  {
    var _spr = spriteBBoxesExample64x64;
    var _count = sprite_get_number(_spr);
    for(var i = 0; i < _count; i++)
    {
      self.bboxes.AddImage(_spr, i);
    }
  }
  
  // Execute the BBoxes.
  var _result = self.bboxes.Submit();
  
  show_debug_message(json_stringify(_result, true));
}
