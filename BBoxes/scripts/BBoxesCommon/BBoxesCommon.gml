
/**
* Shared comong things between BBoxes constructs.
* 
* @ignore
*/ 
function BBoxesCommon() constructor
{
  // Used for identification purposes.
  // @ignore
  self.label = "BBoxesItem";

  
  
  /**
  * Creates a new label.
  * 
  * @param {String} _label
  */
  static CreateLabel = function()
  {
    static counter = { };
    var _instanceof = instanceof(self);
    counter[$ _instanceof] ??= 0;
    return $"{_instanceof}.{counter[$ _instanceof]++}";
  };
  
  
  
  /**
  * Get current label.
  */
  static GetLabel = function()
  {
    return self.label;
  };
  
  
  
  /**
  * 
  * @param {String} _label
  */
  static SetLabel = function(_label=self.CreateLabel())
  {
    self.label = _label;
    return self;
  };
  
  
  
  /**
  * When BBoxes is printed etc. just give the label.
  */ 
  static toString = function()
  {
    return self.GetLabel();
  };
}



