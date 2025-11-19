
/**
* Requesting to solve bbox for sprite image. 
* -> Though GML should solve those for you already whenever you create sprite, or use sprite_collision_mask
* -> So this is more of for debugging purposes.
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
  
  
  // For utilizing asset for making sprite smaller - maybe less passes required.
  // @ignore
  self.uvs = undefined;
  
  
  
  /**
  * Draw currently requested image at given position.
  * Draws partial to ignore xy-offset, and
  * 
  * @param {Real} _x
  * @param {Real} _y
  * @ignore
  */
  static Draw = function(_x, _y)
  {
    draw_sprite(self.sprite, self.image, 
      _x + self.xorigin - self.uvs[4],
      _y + self.yorigin - self.uvs[5]
    );
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
  * Set the bounding box, called from Submit.
  * This will apply origin and trim-value.
  *
  * @param {Real} _xmin
  * @param {Real} _ymin
  * @param {Real} _xmax
  * @param {Real} _ymax
  * @ignore
  */ 
  static SetBBox = function(_xmin, _ymin, _xmax, _ymax)
  {
    static super = BBoxesRequest.SetBBox;
    super(_xmin, _ymin, _xmax, _ymax);
    self.xmin += self.uvs[4]
    self.ymin += self.uvs[5]
    self.xmax += self.uvs[4]
    self.ymax += self.uvs[5]
    return self;
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
    self.sprite   = _sprite;
    self.image    = _image;
    self.xorigin  = sprite_get_xoffset(_sprite);
    self.yorigin  = sprite_get_yoffset(_sprite);
    self.uvs      = sprite_get_uvs(_sprite, _image);
    
    // Calculate the PoT -size.
    var _w = self.uvs[6] * sprite_get_width(_sprite);
    var _h = self.uvs[7] * sprite_get_height(_sprite);
    self.size = max(
      BBoxesNextPoT(_w), 
      BBoxesNextPoT(_h)
    ); 
    return self;
  };
}



