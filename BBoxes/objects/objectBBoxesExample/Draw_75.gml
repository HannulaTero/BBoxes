/// @desc APPLY BBOXES.


// CLEAR EXAMPLES.
if (keyboard_check_pressed(vk_delete) == true)
{
  array_resize(self.results, 0);
}



// SPRITE EXAMPLE.
if (keyboard_check(ord("Q")) == true)
{ 
  // Preparations.
  var _sprite; 
  var _count;
  
  
  // Add example 640x640 sprite images.
  _sprite = spriteBBoxesExample640x640;
  _count = sprite_get_number(_sprite);
  for(var i = 0; i < _count; i++)
  {
    self.bboxes.AddImage(_sprite, i);
  }
  
  
  // Add example 64x64 sprite images.
  _sprite = spriteBBoxesExample190x160;
  _count = sprite_get_number(_sprite);
  for(var i = 0; i < _count; i++)
  {
    self.bboxes.AddImage(_sprite, i);
  }
  
  
  // Add example 192x160 sprite images.
  _sprite = spriteBBoxesExample64x64;
  _count = sprite_get_number(_sprite);
  for(var i = 0; i < _count; i++)
  {
    self.bboxes.AddImage(_sprite, i);
  }
  
  
  // Execute the BBoxes.
  // The results are given as array too, so callbacks are not needed.
  self.results = self.bboxes.Submit();
}



// SURFACE EXAMPLE.
if (keyboard_check_pressed(ord("W")) == true)
&& (surface_exists(self.surface) == true)
{
  // Add example surface.
  self.bboxes.AddSurface(self.surface);
  
  // Execute the BBoxes.
  self.results = self.bboxes.Submit();
}



