

/**
* A request, which items bounding box should be solved.
* This is parent construct, and should not be used as is.
* 
* @ignore 
*/ 
function BBoxesRequest() : BBoxesCommon() constructor
{
  // Request status.
  self.status = BBoxesRequestStatus.PENDING;
  
  
  // The Power of Two-size, and also the sorting key.
  self.size = -1;
  
  
  // How transparent pixel is allowed to take part on bbox.
  self.threshold = 1.0 / 255.0;
  
  
  // Function to be called when request is done.
  self.Callback = undefined;
  
  
  // The origin, like in sprite offset for example.
  self.xorigin = 0;
  self.yorigin = 0;
  
  
  // Bounding box, the request result.
  self.xmin = -1;
  self.ymin = -1;
  self.xmax = -1;
  self.ymax = -1;
  
  
  // Morton code, Z-curves X-positions. This is based on size-sorted index.
  // @ignore 
  self.mortonX = -1; 
  
  
  // Morton code, Z-curves Y-position. This is based on size-sorted index.
  // @ignore 
  self.mortonY = -1; 
  
  
  
  /**
  * The signature for callbacks, when Submit is finished.
  * The request is given as argument, which contains all required information.
  *
  * @param {Struct.BBoxRequest} _request 
  * @ignore
  */ 
  static DefaultCallback = function(_request)
  {
    return;
  };
  
  
  
  /**
  * Draw the item at given position.
  * This is is used by the BBoxes.Submit(), and defined per construct.
  * 
  * @param {Real} _x
  * @param {Real} _y
  * @ignore
  */
  static Draw = function(_x, _y)
  {
    return self;
  };
  
  
  
  /**
  * Returns bounding box as array.
  */
  static GetBBox = function()
  {
    return [ self.xmin, self.ymin, self.xmax, self.ymax ];
  };
  
  
  
  /**
  * Return current request status.
  */
  static GetStatus = function()
  {
    return self.status;
  };
  
  
  
  /**
  * Return whether current request is valid.
  */
  static IsValid = function()
  {
    return false;
  };
  
  
  
  /**
  * Set the bounding box, called from Submit.
  * This will apply origin applied to given values.
  *
  * @param {Real} _xmin
  * @param {Real} _ymin
  * @param {Real} _xmax
  * @param {Real} _ymax
  */ 
  static SetBBox = function(_xmin, _ymin, _xmax, _ymax)
  {
    self.xmin = _xmin - self.xorigin;
    self.ymin = _ymin - self.yorigin;
    self.xmax = _xmax - self.xorigin;
    self.ymax = _ymax - self.yorigin;
    return self;
  };
  
  
  
  /**
  * Assign the callback, which is called when request finishes / fails.
  * The function signature should be same as DefaultCallback.
  * 
  * @param {Function} _callback
  */
  static SetCallback = function(_callback)
  {
    self.Callback = _callback;
    return self;
  };
  
  
  
  /**
  * Set the item origin, like sprite offset. 
  *
  * @param {Real} _xorigin
  * @param {Real} _yorigin
  */ 
  static SetOrigin = function(_xorigin, _yorigin)
  {
    self.xorigin = _xorigin;
    self.yorigin = _yorigin;
    return self;
  };
  
  
  
  /**
  * Threshold on which pixels should be accounted towards bbox solving.
  * 
  * @param {Real} _threshold
  */ 
  static SetThreshold = function(_threshold=1.0/255.0)
  {
    self.threshold = _threshold;
    return self;
  };
  
  
  
  /**
  * Fails the request.
  *
  * @ignore
  */ 
  static SetFailed = function()
  {
    self.status = BBoxesRequestStatus.FAILURE;
    self.size = -1;
    return self;
  };
}




