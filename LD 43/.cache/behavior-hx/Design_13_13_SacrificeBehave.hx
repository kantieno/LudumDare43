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



class Design_13_13_SacrificeBehave extends ActorScript
{
	public var _Img:BitmapData;
	public var _ImgInst:BitmapWrapper;
	public var _Num:Float;
	public var _Modi:Float;
	public var _SacrificeShader:Dynamic;
	public var _Left:Bool;
	public var _self:Actor;
	public var _decided:Bool;
	public var _Text:String;
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_created():Void
	{
		_Img = getExternalImage("SacrificeTemplate.png").clone();
		drawImageOnImage(getExternalImage((("Sacrifice") + (((("" + _Num)) + (".png"))))).clone(), _Img, 0, 0, BlendMode.NORMAL);
		if((_Num == 0))
		{
			drawTextOnImage(_Img, "Wound", Std.int((115 - (getFont(43).font.getTextWidth("Wound", getFont(43).letterSpacing)/Engine.SCALE / 2))), 30, getFont(43));
			if((_Modi == 0))
			{
				_Text = "Head";
			}
			else if((_Modi == 1))
			{
				_Text = "Torso";
			}
			else if((_Modi == 2))
			{
				_Text = "Right Arm";
			}
			else if((_Modi == 3))
			{
				_Text = "Left Arm";
			}
			else if((_Modi == 4))
			{
				_Text = "Right Leg";
			}
			else if((_Modi == 5))
			{
				_Text = "Left Leg";
			}
			drawTextOnImage(_Img, _Text, Std.int((115 - (getFont(43).font.getTextWidth(_Text, getFont(43).letterSpacing)/Engine.SCALE / 2))), 185, getFont(43));
		}
		else if((_Num == 1))
		{
			drawTextOnImage(_Img, "Take Damage", Std.int((115 - (getFont(43).font.getTextWidth("Take Damage", getFont(43).letterSpacing)/Engine.SCALE / 2))), 30, getFont(43));
		}
		_ImgInst = new BitmapWrapper(new Bitmap(_Img));
		attachImageToActor(_ImgInst, actor, 0, 0, 1);
		actor.growTo(30/100, 30/100, 0, Easing.linear);
		actor.growTo(100/100, 100/100, .5, Easing.linear);
		if(_Left)
		{
			actor.moveTo(130, 150, .5, Easing.linear);
		}
		else
		{
			actor.moveTo(470, 150, .5, Easing.linear);
		}
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_clicked():Void
	{
		sayToScene("Scene Behave", "_customBlock_Sacrifice", [_Num, _Modi]);
		actor.fadeTo(0 / 100, .3, Easing.linear);
		startShakingScreen(.5 / 100, .3);
		shoutToScene("_customEvent_" + "SacrificeEnd");
		runLater(1000 * .3, function(timeTask:TimedTask):Void
		{
			engine.unpause();
			recycleActor(actor);
		}, actor);
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_notclicked():Void
	{
		actor.growTo(30/100, 30/100, .3, Easing.linear);
		actor.moveBy(0, 600, .3, Easing.linear);
		runLater(1000 * .3, function(timeTask:TimedTask):Void
		{
			recycleActor(actor);
		}, actor);
	}
	
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("Actor", "actor");
		nameMap.set("Img", "_Img");
		nameMap.set("ImgInst", "_ImgInst");
		nameMap.set("Num", "_Num");
		_Num = 0.0;
		nameMap.set("Modi", "_Modi");
		_Modi = 0.0;
		nameMap.set("SacrificeShader", "_SacrificeShader");
		nameMap.set("Left", "_Left");
		_Left = false;
		nameMap.set("self", "_self");
		nameMap.set("decided", "_decided");
		_decided = false;
		nameMap.set("Text", "_Text");
		_Text = "";
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		actor.makeAlwaysSimulate();
		_self = actor;
		
		/* =========================== On Actor =========================== */
		addMouseOverActorListener(actor, function(mouseState:Int, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && 1 == mouseState)
			{
				fadeImageTo(_ImgInst, 80 / 100, .0, Easing.linear);
			}
		});
		
		/* =========================== On Actor =========================== */
		addMouseOverActorListener(actor, function(mouseState:Int, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && -1 == mouseState)
			{
				fadeImageTo(_ImgInst, 100 / 100, .0, Easing.linear);
			}
		});
		
		/* =========================== On Actor =========================== */
		addMouseOverActorListener(actor, function(mouseState:Int, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && 3 == mouseState)
			{
				if(!(_decided))
				{
					_customEvent_clicked();
					_decided = true;
					for(actorOfType in getActorsOfType(getActorType(41)))
					{
						if(actorOfType != null && !actorOfType.dead && !actorOfType.recycled){
							if(!(actorOfType == _self))
							{
								actorOfType.shout("_customEvent_" + "notclicked");
								actorOfType.setValue("Sacrifice Behave", "_decided", true);
							}
						}
					}
				}
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}