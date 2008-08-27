﻿package com.normsoule.pixelblitz.core{	import com.normsoule.pixelblitz.PixelBlitz;	import com.normsoule.pixelblitz.layers.IRenderLayer;	import com.normsoule.pixelblitz.layers.RenderLayer;		import flash.display.Bitmap;	import flash.display.BitmapData;	import flash.geom.Point;	import flash.geom.Rectangle;		/**	 * The Renderer2D class is the manager for all of the RenderLayer instances.	 */	public class Renderer2D extends Bitmap	{			private var layers:Array = [];		private var _parallaxLayers:Array = [];		private var layerLength:int;		private var rect:Rectangle;		/**		 * @private		 */		public var hasBG:Boolean = false;				private const ZERO_POINT:Point = new Point();		/**		 * Creates a Renderer2D instance.		 * <p>		 * <b>Note:</b> there should not be any reason to create more than one instance of Renderer2D.		 * </p>		 * 		 * @param width The width of the renderable area.		 * @param height The height of the renderable area.		 */		public function Renderer2D( width:int, height:int )		{					bitmapData = new BitmapData( width, height );			rect = bitmapData.rect;		}				/**		 * The camera target point.		 * <p>		 * The target is the focal point that the camera follows to calculate scrolling.		 *  This point could be mapped to the Mouse coordinates, or to a renderable object's <code>x, y</code> 		 * coordinates, or simply to a Point object being manipulated in any number of ways.		 * </p>		 * <p>		 * <b>Note:</b> if no target is specified, scrolling will not occur.		 * </p>		 * @see Camera2D		 */		public function set cameraTarget( value:Point ):void		{			PixelBlitz.camera2D.target = value;		}		/**		 * @private		 */		public function get cameraTarget():Point		{			return PixelBlitz.camera2D.target;		}				/**		 * Sets the bounds or perimeter of the camera.		 * <p>		 * Usually starting at the 0,0 point and then being as wide as the widest layer 		 * and as tall as the tallest layer.		 * </p>		 * @default a new Rectangle of the default size		 * @see Camera2D		 */		public function set cameraBoundary( value:Rectangle ):void		{			value.x = bitmapData.width >> 1;			value.y = bitmapData.height >> 1;			value.width -= bitmapData.width;			value.height -= bitmapData.height;			PixelBlitz.camera2D.boundary = value;		}		/**		 * @private		 */		public function get cameraBoundary():Rectangle		{			return PixelBlitz.camera2D.boundary;		}				/**		 * The amount of 'lag' that the camera uses.		 * <p>		 * Ideal values are between 0 and 1. A value greater than 1 will produce 		 * the opposite effect and cause the camera to advance past the target point, which will result in abnormal scrolling.		 * </p>		 * @default .1		 */		public function set cameraEase( value:Number ):void		{			PixelBlitz.camera2D.ease = value;		}		/**		 * @private		 */		public function get cameraEase():Number		{			return PixelBlitz.camera2D.ease;		}				/**		 * An array containing all of the layers registered to use parallax scrolling.		 * @see Camera2D		 */		public function get parallaxLayers():Array		{			_parallaxLayers = layers.filter( findParallax );			return _parallaxLayers.reverse();		}				/**		 * @private		 */		private function findParallax( element:RenderLayer, index:int, arr:Array ):Boolean		{			return element.useParallax == true;		}				/**		 * Adds a layer to the renderer.		 * 		 * @param layer The RenderLayer instance to add to the renderer.		 */		public function addLayer ( layer:RenderLayer ):void		{			layers.push( layer );			layer.renderer = this;			layer.setSize( bitmapData.width, bitmapData.height );		}				/**		 * Removes the supplied Layer from the renderer.		 * 		 * @param layer The layer to remove from the renderer.		 * @return A boolean value indicating if the layer was removed.		 */		public function removeLayer ( layer:RenderLayer ):Boolean		{			for ( var i:int = 0; i < layers.length; i++ )			{				if ( layers[i] == layer )				{					layers.splice( i, 1 );					return true;				}			}			return false;		}				/**		 * Returns the depth or z-order of the supplied layer.		 * 		 * @param layer The layer to retrieve the depth value of.		 * @return The depth of the layer.		 */		public function getLayerDepth( layer:IRenderLayer ):int		{			return layers.indexOf( layer );		}				/**		 * Swaps the depth or z-order of the two supplied layers.		 * 		 * @param layer1 The first layer to swap.		 * @param layer2 The second layer to swap.		 */		public function swapLayers( layer1:IRenderLayer, layer2:IRenderLayer ):void		{			// get indexes			var index1:int = layers.indexOf( layer1 );			var index2:int = layers.indexOf( layer2 );			// swap their data			layers[index1] = layer1;			layers[index2] = layer2;		}		/**		 * The number of layers registered to the renderer.		 */		public function get numLayers():int		{			return layers.length;		}		/**		 * Renders all of the layers registered to the renderer.		 * <p>		 * This method should be called in a <code>Timer</code> or <code>EnterFrame</code> loop.		 * </p>		 */		public function render ():void		{			PixelBlitz.camera2D.scroll();						bitmapData.lock();						if ( !hasBG )			{				bitmapData.fillRect( rect, 0x00000000 );			}						layerLength = layers.length;			for ( var i:int = 0; i < layerLength; i++ )			{				var layer:RenderLayer = layers[int(i)];				layer.render();				bitmapData.copyPixels( layer.bitmapData, rect, ZERO_POINT, null, null, true );			}						bitmapData.unlock();		} 			}}