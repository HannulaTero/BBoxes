
/**
* Requesting to solve bbox for given text or characters.
* -> Account only for visible parts, so whitespaces are ignored.
* -> You could get string_width(text), but it account whitespace too.
* 
* @param {String} _label For identifying purposes.
*/ 
function BBoxesRequestText(_label=undefined) : BBoxesRequest() constructor
{
  // Define the label.
  self.SetLabel(_label);
  
  
  // The string.
  self.text = "";
  
  
  // The font where size is taken.
  self.font = undefined;
  
  
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
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_font(self.font);
    draw_text(_x, _y, self.text);
    return self;
  };
  
  
  
  /**
  * Return whether current request is valid.
  */
  static IsValid = function()
  {
    return font_exists(self.font);
  };
  
  
  
  /**
  * Assigns the text and font, and updates the PoT -size.
  * 
  * @param {String} _text
  */ 
  static SetText = function(_text)
  {
    // Assign the asset.
    self.text = _text;
    self.font = draw_get_font();
    
    // Calculate the PoT -size.
    self.size = max(
      BBoxesNextPoT(string_width(_text)), 
      BBoxesNextPoT(string_height(_text))
    ); 
    return self;
  };
}



