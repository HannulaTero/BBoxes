/// @desc APPLY BBOXES.


// CLEAR EXAMPLES.
if (keyboard_check_pressed(vk_delete) == true)
{
  array_resize(self.results, 0);
}



// SPRITE EXAMPLE.
if (keyboard_check(ord("Q")) == true)
{
  // Clear the results.
  array_resize(self.results, 0);
  
  
  // Preparations.
  var _sprite; 
  var _count;
  
  
  // Add example 64x64 sprites.
  _sprite = spriteBBoxesExample190x160;
  _count = sprite_get_number(_sprite);
  for(var i = 0; i < _count; i++)
  {
    self.bboxes.AddImage(_sprite, i, self.Callback);
  }
  
  
  // Add example 192x160 sprites.
  _sprite = spriteBBoxesExample64x64;
  _count = sprite_get_number(_sprite);
  for(var i = 0; i < _count; i++)
  {
    self.bboxes.AddImage(_sprite, i, self.Callback);
  }
  
  
  // Execute the BBoxes.
  // The results are given as array too, so callbacks are not needed.
  var _results = self.bboxes.Submit();
}



// SURFACE EXAMPLE.
if (keyboard_check(ord("W")) == true)
&& (surface_exists(self.surface) == true)
{
  // Clear the results.
  array_resize(self.results, 0);
  
  // Add example surface.
  self.bboxes.AddSurface(self.surface, self.Callback);
  
  // Execute the BBoxes.
  self.bboxes.Submit();
}



