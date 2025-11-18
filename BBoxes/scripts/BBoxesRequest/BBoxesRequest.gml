

/**
* 
* 
* @param {Any}        _data
* @param {Any}        _meta
* @param {Function}   _Callback
*/ 
function BBoxesRequest(_data, _meta=undefined, _Callback=undefined) constructor
{
  // Request status.
  self.status = "pending";
  
  
  // Request index.
  self.index = -1;
  
  
  // Morton code, Z-curve index and position.
  // This is based on size-sorted index.
  self.mortonZ = -1; // The Z-curve index.
  self.mortonX = -1; // Grid 2D x-position.
  self.mortonY = -1; // Grid 2D y-position.
  
  
  // The type-related data.
  self.data = _data;
  
  
  // The information needed for the data.
  self.meta = _meta;
  
  
  // The PoT-size, and also the sorting key.
  self.size = -1;
  
  
  // Bounding box, the request result.
  self.xmin = -1;
  self.ymin = -1;
  self.xmax = -1;
  self.ymax = -1;
  
  
  // Function to be called when request is done.
  self.Callback = _Callback;
  
  
  
  /**
  * The signature for callbacks, when Submit is finished.
  * The request is given as argument, which contains all required information.
  *
  * @param {Struct.BBoxRequest} _request 
  */ 
  static DefaultCallback = function(_request)
  {
    return;
  };
  
  
  
  /**
  * Draw currently the item at given position.
  */
  static Draw = function(_x, _y)
  {
    return;
  };
  
  
  
  /**
  * Returns bounding box as array.
  */
  static GetBBox = function()
  {
    return [ self.xmin, self.ymin, self.xmax, self.ymax ];
  };
}




