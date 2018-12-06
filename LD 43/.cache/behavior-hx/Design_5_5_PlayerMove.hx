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



class Design_5_5_PlayerMove extends ActorScript
{
	public var _XDir:Float;
	public var _YDir:Float;
	public var _BaseSpeed:Float;
	public var _CanMove:Bool;
	public var _DashCooldown:Float;
	public var _DashCooldownMax:Float;
	public var _dashing:Bool;
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_Entered():Void
	{
		_CanMove = true;
		actor.setAnimation("Anim0");
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_Exiting():Void
	{
		_CanMove = false;
		actor.setAnimation("Cut0");
	}
	
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("Actor", "actor");
		nameMap.set("XDir", "_XDir");
		_XDir = 0.0;
		nameMap.set("YDir", "_YDir");
		_YDir = 0.0;
		nameMap.set("BaseSpeed", "_BaseSpeed");
		_BaseSpeed = 0.0;
		nameMap.set("CanMove", "_CanMove");
		_CanMove = false;
		nameMap.set("DashCooldown", "_DashCooldown");
		_DashCooldown = 0.0;
		nameMap.set("DashCooldownMax", "_DashCooldownMax");
		_DashCooldownMax = 100.0;
		nameMap.set("dashing", "_dashing");
		_dashing = false;
		
	}
	
	override public function init()
	{
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if(_CanMove)
				{
					_XDir = 0;
					_YDir = 0;
					if((isKeyDown("w") || isKeyDown("up")))
					{
						_YDir = (_YDir - 1);
					}
					if((isKeyDown("s") || isKeyDown("down")))
					{
						_YDir = (_YDir + 1);
					}
					if((isKeyDown("a") || isKeyDown("left")))
					{
						_XDir = (_XDir - 1);
					}
					if((isKeyDown("d") || isKeyDown("right")))
					{
						_XDir = (_XDir + 1);
					}
					actor.setYVelocity((((Engine.engine.getGameAttribute("Speed Multiplier") : Float) * ((Engine.engine.getGameAttribute("Speed") : Float) + _BaseSpeed)) * (_YDir * (1 - Math.abs((_XDir * .38))))));
					actor.setXVelocity((((Engine.engine.getGameAttribute("Speed Multiplier") : Float) * ((Engine.engine.getGameAttribute("Speed") : Float) + _BaseSpeed)) * (_XDir * (1 - Math.abs((_YDir * .38))))));
				}
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}