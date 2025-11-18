/// @desc INITIALIZE

show_debug_overlay(true, true);

self.bboxes = new BBoxes("BBoxes Example");


self.surface = undefined;
self.results = [ ];
self.index = 0;

self.Callback = function(_request)
{
  array_push(self.results, _request);
};