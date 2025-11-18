# BBoxes
## [GameMaker] Asset for finding 2D bounding boxes by utilizing power of GPU.
---

**Introduction**

With this asset you can find bounding box of a surfaces or sprites by utilizing power of you graphics card. You can compute bbox for several images and surfaces at the same time, so only single GPU-to-CPU readback is done for all requests. 

Note, that this asset requires support at least "rgba16float" surface format, and for larger than 2048 images you need "rgba32float".

This can also be utilized outside the game, for example during compiling you can run bbox-calculation for your included assets. 

Originally made for Cookbook Jam #5

---

**How asset actually works**

The sprites and images are placed into a surface, which uses floating point numbers. This means it can represent numbers other than 0.0 to 1.0. In practice rgba16float can represent all whole numbers up to 2048, and rgba32float can represent higher than that. So those are plentiful to represent pixel positions. The images are placed into surface, and shader is used to pick up pixel coordinates for non-transparent pixels. 

Then surface contents are reduces by drawing into another surface, and finding min-max values for each 2x2 area. These surfaces are swapped, and step is repeated. This reduces each item, until each item has size of 1x1, containing their min-max values of whole item.

In practice, items can be different sizes, which makes things hard. This is handled by placing each input item into own "power of two" -slot, and placing items in Z-curve order. This doesn't directly solve the problem. But during reduction steps, largest items will be reduced into smaller ones, therefore at some point they will have the same size as the smaller items.

So all items are not immediately inserted into single surface, instead items are inserted whenever it's their time.

---

**Simple examples how to use:** 
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

// Finally when you have collected requests, you can dispatch it later any time.
// -> This means you can collect requests over several frames.
// -> Note that surfaces are only looked when Submit is called.
// -> So be careful, as if long enough time has passed between Add and Submit, surface may have evaporated.
// -> Also the surface contents may have been altered.
var _result = self.bboxes.Submit();

// Result will have array of arrays.
// Inner arrays are bounding boxes for each request in given order.
show_debug_message(_result); // [ [ 0, 0, 32, 32 ], [ 8, 16, 64, 48 ], ... ]

```

