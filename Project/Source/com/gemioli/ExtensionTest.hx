/*
 * Copyright (c) 2013, Dmitriy Kapustin (dimanux), gemioli.com
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package com.gemioli;

import com.gemioli.pomelo.events.PomeloEvent;
import com.gemioli.pomelo.Pomelo;
import nme.display.Sprite;
import nme.display.StageAlign;
import nme.display.StageScaleMode;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.Lib;

class ExtensionTest extends Sprite
{
	public function new()
	{	
		super();
		addEventListener(Event.ADDED_TO_STAGE, init);
	}
	
	private function init(event : Event) : Void
	{
		removeEventListener(Event.ADDED_TO_STAGE, init);
		addEventListener(Event.ENTER_FRAME, onUpdate);
		Lib.current.graphics.beginFill(0x000000);
		Lib.current.graphics.drawRect(0, 0, Lib.current.stage.stageWidth, Lib.current.stage.stageHeight);
		Lib.current.graphics.endFill();
		graphics.beginFill(0xffffff);
		graphics.drawRect( -20, -20, 40, 40);
		graphics.endFill();
		
		var host = "localhost";
		var port = 8080;
		//var host = "pomeloserver-dimanux.dotcloud.com";
		//var port = 80;
		
		_pomelo = new Pomelo();
		
		_pomelo.addEventListener(PomeloEvent.ERROR, function(event : PomeloEvent) {
			trace("Pomelo error: " + event.data);
		});
		
		_pomelo.init({
			host : host,
			port : port }, function() : Void {
				trace("Pomelo connected.");
				
				_pomelo.addEventListener(PomeloEvent.DISCONNECT, function(event : PomeloEvent) {
					trace("Pomelo disconnected.");
				});
		
				_pomelo.request("connector.entryHandler.entry", null/*message*/, function(data : Dynamic) : Void {
					trace(data.msg);
				});
			});
	}
	
	private function onUpdate(e:Event) : Void
	{
		x = Lib.current.stage.stageWidth / 2;
		y = Lib.current.stage.stageHeight / 2;
		rotation += 1;
	}
	
	public static function main()
	{
		var stage = Lib.current.stage;
		stage.scaleMode = nme.display.StageScaleMode.NO_SCALE;
		stage.align = nme.display.StageAlign.TOP_LEFT;
		
		Lib.current.addChild(new ExtensionTest ());
	}
	
	private var _pomelo : Pomelo;
}