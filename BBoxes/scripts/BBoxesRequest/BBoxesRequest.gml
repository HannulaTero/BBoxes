

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
  
  
  // Morton code, Z-curve positions.
  // This is based on size-sorted index.
  self.mortonX = -1; // Grid 2D x-position.
  self.mortonY = -1; // Grid 2D y-position.
  
  
  // The Power of Two-size, and also the sorting key.
  self.size = -1;
  
  
  // How transparent pixel is allowed to take part on bbox.
  self.threshold = 1.0 / 255.0;
  
  
  // Function to be called when request is done.
  self.Callback = undefined;
  
  
  // Bounding box, the request result.
  self.xmin = -1;
  self.ymin = -1;
  self.xmax = -1;
  self.ymax = -1;
  
  
  
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




