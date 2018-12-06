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



class Design_3_3_AttackManager extends ActorScript
{
	public var _Attacking:Bool;
	public var _MultiCounter:Float;
	public var _AttackAngle:Float;
	public var _AttackWidth:Float;
	public var _AttackAngleBase:Float;
	public var _AttackWidthMax:Float;
	public var _AttackWidthInc:Float;
	public var _Cooldown:Float;
	public var _CooldownTimer:Float;
	public var _BaseCooldown:Float;
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_attack():Void
	{
		if((_CooldownTimer == 0))
		{
			_CooldownTimer = Math.max(3, Math.floor((_BaseCooldown * (Engine.engine.getGameAttribute("Attack Cooldown Multiplier") : Float))));
			if(Utils.contains((Engine.engine.getGameAttribute("Effects") : Array<Dynamic>), asNumber(0)))
			{
				_MultiCounter = 1;
				for(item in cast((Engine.engine.getGameAttribute("Effects") : Array<Dynamic>), Array<Dynamic>))
				{
					if((item == 0))
					{
						_MultiCounter = (_MultiCounter + 1);
					}
				}
				_AttackWidth = Math.min(_AttackWidthMax, (_MultiCounter * _AttackWidthInc));
				_AttackAngleBase = ((Utils.DEG * actor.getAngle()) - (_AttackWidth / 2));
				for(index0 in 0...Std.int(_MultiCounter))
				{
					_AttackAngle = (_AttackAngleBase + (index0 * (_AttackWidth / (_MultiCounter - 1))));
					if(((Engine.engine.getGameAttribute("CurrentWeapon") : Float) == 2))
					{
						_customEvent_bow();
					}
				}
			}
			else
			{
				_AttackAngle = (Utils.DEG * actor.getAngle());
				if(((Engine.engine.getGameAttribute("CurrentWeapon") : Float) == 2))
				{
					_customEvent_bow();
				}
			}
		}
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_bow():Void
	{
		createRecycledActor(getActorType(30), actor.getX(), actor.getY(), Script.BACK);
		getLastCreatedActor().setX((actor.getXCenter() - (getLastCreatedActor().getWidth()/2)));
		getLastCreatedActor().setY((actor.getYCenter() - (getLastCreatedActor().getHeight()/2)));
		getLastCreatedActor().setAngle(Utils.RAD * (_AttackAngle));
		getLastCreatedActor().setVelocity(_AttackAngle, 60);
	}
	
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("Actor", "actor");
		nameMap.set("Attacking", "_Attacking");
		_Attacking = false;
		nameMap.set("MultiCounter", "_MultiCounter");
		_MultiCounter = 0.0;
		nameMap.set("AttackAngle", "_AttackAngle");
		_AttackAngle = 0.0;
		nameMap.set("AttackWidth", "_AttackWidth");
		_AttackWidth = 0.0;
		nameMap.set("AttackAngleBase", "_AttackAngleBase");
		_AttackAngleBase = 0.0;
		nameMap.set("AttackWidthMax", "_AttackWidthMax");
		_AttackWidthMax = 90.0;
		nameMap.set("AttackWidthInc", "_AttackWidthInc");
		_AttackWidthInc = 5.0;
		nameMap.set("Cooldown", "_Cooldown");
		_Cooldown = 0.0;
		nameMap.set("CooldownTimer", "_CooldownTimer");
		_CooldownTimer = 0.0;
		nameMap.set("BaseCooldown", "_BaseCooldown");
		_BaseCooldown = 50.0;
		
	}
	
	override public function init()
	{
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if(((actor.getValue("Player Move", "_CanMove") : Bool) && !(_Attacking)))
				{
					actor.setAngle(Utils.RAD * (Utils.DEG * (Math.atan2((getMouseY() - actor.getYCenter()), (getMouseX() - actor.getXCenter())))));
					if((_CooldownTimer > 0))
					{
						_CooldownTimer = (_CooldownTimer - 1);
					}
				}
			}
		});
		
		/* ============================ Click ============================= */
		addMousePressedListener(function(list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if(!(engine.isPaused()))
				{
					_customEvent_attack();
				}
			}
		});
		
		/* =========================== Keyboard =========================== */
		addKeyStateListener("enter", function(pressed:Bool, released:Bool, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && pressed)
			{
				sayToScene("Scene Behave", "_customBlock_AddItem", [7]);
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}