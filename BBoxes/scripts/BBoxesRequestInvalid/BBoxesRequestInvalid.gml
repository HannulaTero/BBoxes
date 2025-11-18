

/**
* For invalid requests, non-supported ones.
* 
* @param {String} _label For identifying purposes.
*/ 
function BBoxesRequestInvalid(_label=undefined) : BBoxesRequest() constructor
{
  // Define the label.
  self.SetLabel(_label);
}