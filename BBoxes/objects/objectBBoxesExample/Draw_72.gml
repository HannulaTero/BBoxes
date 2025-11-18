/// @desc APPLY BBOXES.

if (keyboard_check_pressed(vk_space) == true)
{
  // Clear the results.
  array_resize(self.results, 0);
  
  // Add example 64x64 sprites.
  {
    var _spr = spriteBBoxesExample190x160;
    var _count = sprite_get_number(_spr);
    for(var i = 0; i < _count; i++)
    {
      self.bboxes.AddImage(_spr, i, function(_request)
      {
        array_push(self.results, _request);
      });
    }
  }
  
  // Add example 192x160 sprites.
  {
    var _spr = spriteBBoxesExample64x64;
    var _count = sprite_get_number(_spr);
    for(var i = 0; i < _count; i++)
    {
      self.bboxes.AddImage(_spr, i, function(_request)
      {
        array_push(self.results, _request);
      });
    }
  }
  
  // Execute the BBoxes.
  // The results are given as array too, so callbacks are not needed.
  var _results = self.bboxes.Submit();
}
