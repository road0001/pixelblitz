﻿package com.normsoule.pixelblitz.layers{	import com.normsoule.pixelblitz.PixelBlitz;	import com.normsoule.pixelblitz.core.Renderer2D;	import com.normsoule.pixelblitz.effects.DefaultEffect;	import com.normsoule.pixelblitz.effects.IEffect;	import com.normsoule.pixelblitz.elements.PixelSprite;		import flash.display.BitmapData;	import flash.geom.Point;	import flash.geom.Rectangle;		/**	 * The RenderLayer class creates a virtual layer much like a layer in an image editing application.	 * <p>	 * In order for any given renderble object to be visibly rendered, 	 * the object mst be added to a RenderLayer instance and the RenderLayer instance must be added to the Renderer2D instance.	 * </p>	 */	public class RenderLayer implements IRenderLayer	{			private var items:Array 		= new Array();		private var pos:Point 			= new Point();		private var _effect:IEffect 	= new DefaultEffect();		private var camPoint:Point 		= PixelBlitz.camera2D.basePoint;		private var _useParallax:Boolean;		private var _renderer:Renderer2D;		private var width:int;		private var height:int;		/**		 * @private		 */		public var parallax:Number 	= 1;		/**		 * The BitmapData object that will be rendered by the Renderer2D instance.		 * @see com.normsoule.pixelblitz.core.Renderer2D		 */		public var bitmapData:BitmapData;		/**		 * The bitmapData rect property.		 */		public var rect:Rectangle;				/**		 * Creates a RenderLayer instance.		 * 		 * @param useParallax Set to true to enable parallax scrolling for this layer.		 */		public function RenderLayer( useParallax:Boolean = false )		{				_useParallax = useParallax;		}				/**		 * Returns true if parallax scrolling is enabled for for this layer, otherwise false.		 */		public function get useParallax():Boolean		{			return _useParallax;		}				/**		 * Set to true to enable parallax scrolling for this layer.		 */		public function set useParallax( value:Boolean ):void		{			_useParallax = value;		}				/**		 * The effect this renderLayer will apply.		 */		public function get effect():IEffect		{			return _effect;		}		/**		 * @private		 */		public function set effect( value:IEffect ):void		{			_effect = value;			if ( _renderer )			{				_effect.init( rect );			}		}				/**		 * Subscribes the Renderer2D instance to this layer.		 */		public function set renderer( value:Renderer2D ):void		{			_renderer = value;		}		/**		 * @private		 */		public function get renderer():Renderer2D		{			return _renderer;		}				/**		 * Sets the width, height, and rect of the layer.		 * 		 * @param width The width to set this layer to.		 * @param height The height to set this layer to.		 */		public function setSize( width:int, height:int ):void		{			bitmapData = new BitmapData( width, height, true, 0 );			rect = bitmapData.rect;			this.width = bitmapData.width;			this.height = bitmapData.height;			_effect.init(rect);		}				/**		 * Adds a Renderable instance to the renderLayer.		 * 		 * @param item The item to add to the renderLayer.		 */		public function addItem ( item:PixelSprite ):void		{			items.push( item );			item.layer = this;		}				/**		 * Removes a Renderable object from this RenderLayer instance.		 * 		 * @param item The item to remove from the renderLayer.		 * @return A boolean value indicating if the item was removed.		 */		public function removeItem ( item:PixelSprite ):Boolean		{			for ( var i:int; i < items.length; i++ )			{				if ( items[i] == item )				{					items.splice ( i, 1 );					return true;				}			}			return false;		}				/**		 * Returns the depth or z-order of the supplied Renderable instance.		 * 		 * @param item The Renderable object to retieve the depth for.		 * @return A value representing the renderable objects depth.		 */		public function getDepth( item:PixelSprite ):int		{			return items.indexOf( item );		}				/**		 * Swaps the depth or z-order of the two supplied renderable items.		 * 		 * @param item1 The first Renderable object to swap.		 * @param item2 The second Renderable object to swap.		 */		public function swapDepths( item1:PixelSprite, item2:PixelSprite ):void		{			// get indexes			var index1:int = items.indexOf( item1 );			var index2:int = items.indexOf( item2 );			// swap their data			items[index1] = item2;			items[index2] = item1;		}				/**		 * The number of Renderable instances registered to this RenderLayer.		 */		public function get numChildren():int		{			return items.length;		}				/**		 * Renders all of the visible items in the layer.		 * <p>		 * Items that are outside of the visible area will not be rendered.		 * Calculates and applies parallax scrolling if useParallax is set to true.		 * </p>		 */		public function render ():void		{				if ( _useParallax )			{				var pLayers:Array = _renderer.parallaxLayers;				var pDepth:int = pLayers.indexOf( this );								parallax = 1;				var p:int = 0;				while ( p < pDepth )				{					parallax *= .5;					p++;				}			}						_effect.preRender( bitmapData );			bitmapData.lock();						var length:int = items.length;						for ( var i:int = 0; i < length; i++ )			{				var item:PixelSprite = items[ int(i) ];								if (item.visible && item.alpha > 0)				{					pos.x = Math.ceil( item.globalX + camPoint.x * parallax );					pos.y = Math.ceil( item.globalY + camPoint.y * parallax );									if ( ( pos.x > -item.width && pos.x < width + item.width ) && ( pos.y > -item.height && pos.y < height + item.height ) )					{						item.update();												bitmapData.copyPixels( item.bitmapData, item.rect, pos, null, null, true );					}				}			}						bitmapData.unlock();						_effect.postRender( bitmapData );		} 	}}