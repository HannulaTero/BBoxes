# BBoxes
[GameMaker] Asset for finding 2D bounding boxes utilizing GPU.

This asset allows you to find bounding box of a surface or sprite. 
You can make request to find bbox for several surfaces or sprites at once.

How to use: 
```gml
// Create Event:
self.bboxes = new BBoxes("Optional Label");

// Add image.
self.bboxes.AddImage(sprite, image);

// Add surface.
self.bboxes.AddSurface(surface);

// Or let asset try choose whether image or surface
self.bboxes.Add(sprite, image); 
self.bboxes.Add(surface);

// You can add optional callback for both of them.
// Callback argument is the made request / result, which will contain the bounding box, but also request information.
self.bboxes.AddImage(sprite, image, function(_request)
{
  show_debug_message("bbox xmin: {_request.xmin}, ymin {_request.ymin}, xmax {_request.xmax}, ymax {_request.ymax}");
});

// You can put several requests to be solved at once.
var _spr = sprite;
var _count = sprite_get_number(_spr);
for(var i = 0; i < _count; i++)
{
  self.bboxes.AddImage(_spr, i);
}

// Finally when you have collected requests, you can dispatch it any time.
// -> Note that surfaces are looked at this point of time (whether you have changed contents, or they have evaporated can be issue).
var _result = self.bboxes.Submit();

// Result will have array of arrays.
// Inner arrays are bounding boxes for each request in given order.
show_debug_message(_result);

```

