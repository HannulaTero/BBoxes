


/**
* For finding out 2D bounding boxes with help of GPU.
* -> This uses shaders, so you need to call this asset on Draw-event!
*
* You can collect requests over multiple frames.
* -> Collects requests as references, the situation is taken at "Submit".
* -> So mind this when checking bbox for surfaces, which may change.
* 
* @param {String} _label For identifying purposes.
*/
function BBoxes( _label=undefined) : BBoxesCommon() constructor
{
  // Define the label.
  self.SetLabel(_label);
  
  
  // The list of requests.
  self.requests = [ ];
  
  
  
  /**
  * Add separately created BBoxRequest as pending request.
  *
  * @param {Struct.BBoxesRequest} _request Any of acceptable request types.
  */ 
  static Add = function(_request)
  {
    array_push(self.requests, _request);
    return _request;
  };
  
  
  
  /**
  * Add sprite-image as pending request.
  * 
  * @param {Asset.GMSprite} _spr
  * @param {Real}           _img
  * @param {Function}       _Callback
  */
  static AddImage = function(_spr, _img, _Callback)
  {
    var _request = new BBoxesRequestImage();
    _request.SetSprite(_spr, _img);
    _request.SetCallback(_Callback);
    _request.SetOffset();
    array_push(self.requests, _request);
    return _request;
  };
  
  
  
  /**
  * Add surface as pending request.
  * At submit, the existance is verified.
  * 
  * @param {Id.Surface} _surface
  * @param {Function}   _Callback
  */
  static AddSurface = function(_surface, _Callback)
  {
    var _request = new BBoxesRequestSurface();
    _request.SetSurface(_surface);
    _request.SetCallback(_Callback);
    array_push(self.requests, _request);
    return _request;
  };
  
  
  
  /**
  * Clears all current requests.
  */
  static Clear = function()
  {
    array_resize(self.requests, 0);
    return self;
  };
  
  
  
  /**
  * Submits current requests.
  * Has to be called in Draw-event!
  * -> Uses shaders, and alters active shader.
  * -> Alters GPU state, but tries return it back to normal.
  *
  * @returns {Array<Struct.BBoxesRequest>}
  */
  static Submit = function()
  {
    // Preparations.
    var _requests = self.requests;
    var _requestCount = array_length(_requests);
    if (_requestCount == 0)
    {
      return undefined;
    }
    BBoxesGPUBegin();
    
    
    // Check for evaporated surfaces.
    // Fail all requests, which don't have proper data.
    array_foreach(_requests, function(_request, _index)
    {
      if (_request.IsValid() == false)
      {
        _request.SetFailed();
      }
    });
    
    
    // Find out whether require rgba32float -format.
    // -> rgba16float can handle sizes up to 2048.
    var _format = surface_rgba16float;
    var _higherRequired = false;
    for(var i = 0; i < _requestCount; i++)
    {
      if (_requests[i].size > 2048)
      {
        _format = surface_rgba32float;
        _higherRequired = true;
        break;
      }
    }
    
    
    // Check if requires larger format, but can't use it.
    // -> Fail all cases wherever require f32, and keep rolling with rgba16float.
    if (_higherRequired == true)
    && (surface_format_is_supported(surface_rgba32float) == false)
    {
      _format = surface_rgba16float;
      array_foreach(_requests, function(_request, _index)
      {
        if (_request.size > 2048)
        {
          _request.status = BBoxesRequestStatus.FAILURE;
          _request.size = -1;
        }
      });
    }
    
    
    // Sort the requests from largest to smallest.
    // This is so we can be smarter about surface sizes.
    array_sort(_requests, function(_lhs, _rhs)
    {
      return sign(_rhs.size - _lhs.size); 
    });
    
    
    // Precalculate Z-curve positions for the requests.
    // We will have to calculate these couple of times otherwise, so caching is good.
    array_foreach(_requests, function(_request, _index)
    {
      _request.mortonX = BBoxesZDecodeX(_index);
      _request.mortonY = BBoxesZDecodeY(_index);
    });
    
    
    // Precompute the largest surface size required.
    // The sources are added and surface shrunk alternatvely, so can't directly know.
    // The item inserting follows Z-curve (morton code).
    var _maxW = 1;
    var _maxH = 1;
    for(var i = 0; i < _requestCount; i++)
    {
      var _request = _requests[i];
      _maxW = max(_maxW, (_request.mortonX + 1) * _request.size);
      _maxH = max(_maxH, (_request.mortonY + 1) * _request.size);
    }
    _maxW = BBoxesNextPoT(_maxW);
    _maxH = BBoxesNextPoT(_maxH);
    
    
    // Prepare the surfaces.
    // Surfaces are being cleared while items are inserted.
    var _surfSrc = surface_create(_maxW, _maxH, _format);
    var _surfDst = surface_create(_maxW, _maxH, _format);
    var _surfTmp = undefined;
    
    
    // Start with the biggest requests and go down, include smaller requests on the way.
    // 1) Find how many following items share same PoT-size.
    // 2) Clear surface under their target positions.
    // 3) Push their "seed" values, initial mixmax-values.
    // 4) Apply reduce pass, where 2x2 area is shrunk into 1x1.
    // 5) Repeat until no more requests are there, all requests are shrunk into 1x1.
    var _tail = 0;
    var _head = 0;
    while(_tail < _requestCount)
    {
      // The size of current pass.
      var _tailSize = _requests[_tail].size;
      var _headSize = 1;
      
      // Find the range how many requests belong to the pass.
      // Also find how large next one should be.
      _head = _tail + 1;
      while(_head < _requestCount)
      {
        if (_requests[_head].size != _tailSize)
        {
          _headSize = _requests[_head].size; 
          break;
        }
        _head++;
      }
      
      
      // Clean the source for the requests.
      // Because request might be smaller than PoT, also we are reusing surfaces.
      surface_set_target(_surfSrc);
      {
        shader_set(shaderBBoxesClear);
        for(var i = _tail; i < _head; i++)
        {
          var _request = _requests[i];
          var _size = _request.size;
          var _x = _request.mortonX * _size;
          var _y = _request.mortonY * _size;
          draw_sprite_stretched(spriteBBoxes1x1, 0, _x, _y, _size, _size);
        }
        shader_reset();
      }
      surface_reset_target();
      
      
      // Push requests into source.
      // This updates minmax-positions for each pixel.
      // Also calucalte the maximum size for the reduction pass.
      surface_set_target(_surfSrc);
      {
        // Preparations.
        var _shader = shaderBBoxesInit;
        var _FSH_threshold = shader_get_uniform(_shader, "FSH_threshold");
        var _FSH_offset = shader_get_uniform(_shader, "FSH_offset");
        _maxW = 1;
        _maxH = 1;
        
        // Apply the shader.
        // The minmax is calculated from output position, so offset is required.
        shader_set(_shader);
        for(var i = _tail; i < _head; i++)
        {
          var _request = _requests[i];
          
          // Get the position.
          var _x = _request.mortonX * _request.size;
          var _y = _request.mortonY * _request.size;
          
          // Get the size.
          _maxW = max(_maxW, _x + _request.size);
          _maxH = max(_maxH, _y + _request.size);
          
          // Whether try drawing at all.
          if (_request.status != BBoxesRequestStatus.FAILURE)
          {
            shader_set_uniform_f(_FSH_threshold, _request.threshold);
            shader_set_uniform_f(_FSH_offset, _x, _y);
            _request.Draw(_x, _y);
          }
        }
        shader_reset();
      }
      surface_reset_target();
      
      
      // Reduce the source by 2x2 blocks.
      // This is repeated as many times until meet next request size.
      while(_tailSize > _headSize)
      {
        // Do the reduction steps.
        surface_set_target(_surfDst);
        {
          // Preparations.
          var _shader = shaderBBoxesPass;
          var _FSH_baseTexels = shader_get_uniform(_shader, "FSH_baseTexels");
          var _texture = surface_get_texture(_surfSrc);
          var _texelW = texture_get_texel_width(_texture);
          var _texelH = texture_get_texel_height(_texture);
          _maxW = _maxW >> 1;
          _maxH = _maxH >> 1;
        
          // Apply the shader.
          shader_set(_shader);
          shader_set_uniform_f(_FSH_baseTexels, _texelW, _texelH);
          draw_surface_stretched(_surfSrc, 0, 0, _maxW, _maxH);
          shader_reset();
        }
        surface_reset_target();
        
        // The size has been reduced.
        _tailSize = _tailSize >> 1;
        
        // Swap the surface.
        _surfTmp = _surfDst;
        _surfDst = _surfSrc;
        _surfSrc = _surfTmp;
      }
      
      // Move tail to the head.
      _tail = _head;
    }
    
    
    // Copy final items to a smaller surface for the readback.
    // Z-curve has specific area, which needs to be accomodated. 
    var _surfReadback = surface_create(_maxW, _maxH, _format);
    surface_set_target(_surfReadback);
    draw_surface_part(_surfSrc, 0, 0, _maxW, _maxH, 0, 0);
    surface_reset_target();
    surface_free(_surfSrc);
    surface_free(_surfDst);
    
    
    // Get datatype and size.
    // In HTML5, reading indirectly size of buffer_f16 is bugged.
    // It works only if used directly 'buffer_sizeof(buffer_f16)' because of compile-time optimization.
    var _dtype, _dsize;
    if (_format == surface_rgba16float)
    {
      _dtype = buffer_f16;
      _dsize = buffer_sizeof(buffer_f16);
    }
    else
    {
      _dtype = buffer_f32;
      _dsize = buffer_sizeof(buffer_f32);
    }
    
    // Do the readback.
    var _stride = _dsize * 4;
    var _bytes = _stride * _maxW * _maxH;
    var _buffer = buffer_create(_bytes, buffer_grow, 1);
    buffer_get_surface(_buffer, _surfReadback, 0);
    surface_free(_surfReadback);
    
    
    // The items are in linearized 2D positions, in row-major curve.
    // 2D positions represent Z-curve index, current item order.
    // So have to change row-major index into Z-curve index.
    for(var i = 0; i < _requestCount; i++)
    {
      // Get the request.
      var _request = _requests[i];
      
      // Get the actual request index.
      var _x = BBoxesZDecodeX(i);
      var _y = BBoxesZDecodeY(i);
      var _index = _x + _y * _maxW;
      
      // Read the result.
      buffer_seek(_buffer, buffer_seek_start, _index * _stride);
      var _xmin = buffer_read(_buffer, _dtype);
      var _ymin = buffer_read(_buffer, _dtype);
      var _xmax = buffer_read(_buffer, _dtype);
      var _ymax = buffer_read(_buffer, _dtype);
      
      // Set the result.
      _request.SetBBox(_xmin, _ymin, _xmax, _ymax);
    }
    buffer_delete(_buffer);
    
    
    // Change status to reflect success.
    // Do the callbacks, if the request has one.
    array_foreach(_requests, function(_request, index)
    {
      // Don't change if failed beforehand.
      if (_request.status == BBoxesRequestStatus.PENDING)
      {
        _request.status = BBoxesRequestStatus.SUCCESS;
      }
      
      // Do the callback.
      if (_request.Callback != undefined)
      {
        _request.Callback(_request);
      }
    });
    
    
    // Finalize, detach current array, and give to user.
    BBoxesGPUEnd();
    self.requests = [ ];
    return _requests;
  };
}



