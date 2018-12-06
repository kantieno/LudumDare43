package scripts;

import com.stencyl.graphics.G;
import com.stencyl.graphics.BitmapWrapper;
import com.stencyl.graphics.ScaleMode;

import com.stencyl.behavior.Script;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.ActorScript;
import com.stencyl.behavior.SceneScript;
import com.stencyl.behavior.TimedTask;

import com.stencyl.models.Actor;
import com.stencyl.models.GameModel;
import com.stencyl.models.actor.Animation;
import com.stencyl.models.actor.ActorType;
import com.stencyl.models.actor.Collision;
import com.stencyl.models.actor.Group;
import com.stencyl.models.Scene;
import com.stencyl.models.Sound;
import com.stencyl.models.Region;
import com.stencyl.models.Font;
import com.stencyl.models.Joystick;

import com.stencyl.Config;
import com.stencyl.Engine;
import com.stencyl.Input;
import com.stencyl.Key;
import com.stencyl.utils.motion.*;
import com.stencyl.utils.Utils;

import openfl.ui.Mouse;
import openfl.display.Graphics;
import openfl.display.BlendMode;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.events.TouchEvent;
import openfl.net.URLLoader;

import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2Fixture;
import box2D.dynamics.joints.B2Joint;

import com.stencyl.graphics.shaders.BasicShader;
import com.stencyl.graphics.shaders.GrayscaleShader;
import com.stencyl.graphics.shaders.SepiaShader;
import com.stencyl.graphics.shaders.InvertShader;
import com.stencyl.graphics.shaders.GrainShader;
import com.stencyl.graphics.shaders.ExternalShader;
import com.stencyl.graphics.shaders.InlineShader;
import com.stencyl.graphics.shaders.BlurShader;
import com.stencyl.graphics.shaders.SharpenShader;
import com.stencyl.graphics.shaders.ScanlineShader;
import com.stencyl.graphics.shaders.CSBShader;
import com.stencyl.graphics.shaders.HueShader;
import com.stencyl.graphics.shaders.TintShader;
import com.stencyl.graphics.shaders.BloomShader;



class Design_17_17_DoorBehave extends ActorScript
{
	public var _XOff:Float;
	public var _YOff:Float;
	public var _EntryNum:Float;
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_open():Void
	{
		if(!((Engine.engine.getGameAttribute("RoomEntryNum") : Float) == _EntryNum))
		{
			actor.setAnimation("open");
		}
		else
		{
			actor.setAnimation("closed");
		}
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_close():Void
	{
		actor.setAnimation("closed");
	}
	
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("Actor", "actor");
		nameMap.set("XOff", "_XOff");
		_XOff = 0.0;
		nameMap.set("YOff", "_YOff");
		_YOff = 0.0;
		nameMap.set("EntryNum", "_EntryNum");
		_EntryNum = 0.0;
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		
		
		/* ======================= Member of Group ======================== */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorGroup(0),event.otherActor.getType(),event.otherActor.getGroup()))
			{
				if((_EntryNum == 1))
				{
					Engine.engine.setGameAttribute("RoomEntryNum", 2);
				}
				else if((_EntryNum == 2))
				{
					Engine.engine.setGameAttribute("RoomEntryNum", 1);
				}
				else
				{
					Engine.engine.setGameAttribute("RoomEntryNum", 0);
				}
				event.otherActor.shout("_customEvent_" + "Exiting");
				event.otherActor.fadeTo(0 / 100, .3, Easing.linear);
				event.otherActor.moveTo((actor.getX() - _XOff), (actor.getY() - _YOff), .3, Easing.linear);
				runLater(1000 * .2, function(timeTask:TimedTask):Void
				{
					if((_EntryNum == 1))
					{
						switchScene(GameModel.get().scenes.get(0).getID(), null, createSlideLeftTransition(.5));
					}
					else if((_EntryNum == 2))
					{
						switchScene(GameModel.get().scenes.get(0).getID(), null, createSlideRightTransition(.5));
					}
					else
					{
						switchScene(GameModel.get().scenes.get(0).getID(), null, createSlideUpTransition(.5));
					}
				}, actor);
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}