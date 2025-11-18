

/**
* 
* TODOs:
* - This could be done more smarter, as GM already does trimming.
*   -> sprite_get_uvs return how much is trimmed.
*   -> So the PoT size could pay attention to this.
*   -> BBox can't be directly derived from trimmed size, as trimming might have padding.
* - Change behaviour to accommodate offset?
*   -> Either BBOX to be relative to image top-left corner, or sprite origin.
* 
* @param {String} _label For identifying purposes.
*/ 
function BBoxesRequestImage(_label=undefined) : BBoxesRequest() constructor
{
  // Define the label.
  self.SetLabel(_label);
  
  
  // Sprite index, it can has many images, so that should be defined.
  self.sprite = undefined;
  
  
  // The image index within sprite.
  self.image = 0;
  
  
  
  /**
  * Draw currently requested image at given position.
  * Uses stretched to ignore X and Y offsets.
  * 
  * @param {Real} _x
  * @param {Real} _y
  * @ignore
  */
  static Draw = function(_x, _y)
  {
    var _spr = self.sprite;
    var _w = sprite_get_width(_spr);
    var _h = sprite_get_height(_spr);
    draw_sprite_stretched(_spr, self.image, _x, _y, _w, _h);
    return self;
  };
  
  
  
  /**
  * Return whether current request is valid.
  */
  static IsValid = function()
  {
    return sprite_exists(self.sprite);
  };
  
  
  
  /**
  * Assigns the sprite and image, and updates the PoT -size.
  * 
  * @param {Asset.GMSprite} _sprite
  * @param {Real}           _image
  */ 
  static SetSprite = function(_sprite, _image=self.image)
  {
    // Assign the asset.
    self.sprite = _sprite;
    self.image = _image;
    
    // Calculate the PoT -size.
    var _w = sprite_get_width(_sprite);
    var _h = sprite_get_height(_sprite);
    self.size = max(
      BBoxesNextPoT(_w), 
      BBoxesNextPoT(_h)
    ); 
    return self;
  };
}



