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



class Design_28_28_BossBehave extends ActorScript
{
	public var _Timer:Float;
	public var _TimerMax:Float;
	public var _Speed:Float;
	public var _MoveSpeed:Float;
	
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("Actor", "actor");
		nameMap.set("Timer", "_Timer");
		_Timer = 0.0;
		nameMap.set("TimerMax", "_TimerMax");
		_TimerMax = 1000.0;
		nameMap.set("Speed", "_Speed");
		_Speed = 60.0;
		nameMap.set("MoveSpeed", "_MoveSpeed");
		_MoveSpeed = 30.0;
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		_Timer = _TimerMax;
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if((_Timer > 0))
				{
					_Timer = (_Timer - 1);
					if((_Timer == 900))
					{
						actor.say("Enemy Shoot Bullet", "_customBlock_ShootBullet", [(Utils.DEG * actor.getAngle()), 0, 0]);
						actor.setVelocity(randomInt(Std.int(((Utils.DEG * actor.getAngle()) - 30)), Std.int(((Utils.DEG * actor.getAngle()) + 30))), _MoveSpeed);
					}
					else if((_Timer == 800))
					{
						actor.setXVelocity(0);
						actor.setYVelocity(0);
						actor.say("Enemy Shoot Bullet", "_customBlock_ShootBullet", [(Utils.DEG * actor.getAngle()), 0, 0]);
					}
					else if((_Timer == 750))
					{
						actor.say("Enemy Shoot Bullet", "_customBlock_ShootBullet", [(Utils.DEG * actor.getAngle()), 0, 0]);
						actor.say("Enemy Shoot Bullet", "_customBlock_ShootBullet", [((Utils.DEG * actor.getAngle()) + 30), 0, 0]);
						actor.say("Enemy Shoot Bullet", "_customBlock_ShootBullet", [((Utils.DEG * actor.getAngle()) - 30), 0, 0]);
					}
					else if((_Timer == 700))
					{
						actor.setVelocity((Utils.DEG * actor.getAngle()), (_MoveSpeed * 3));
					}
					else if((_Timer == 650))
					{
						actor.setXVelocity(0);
						actor.setYVelocity(0);
						actor.say("Enemy Shoot Bullet", "_customBlock_ShootBullet", [(Utils.DEG * actor.getAngle()), 30, 0]);
					}
					else if((_Timer == 500))
					{
						actor.setXVelocity(0);
						actor.setYVelocity(0);
						actor.say("Enemy Shoot Bullet", "_customBlock_ShootBullet", [(Utils.DEG * actor.getAngle()), 30, 0]);
					}
					else if((_Timer == 400))
					{
						actor.say("Enemy Shoot Bullet", "_customBlock_ShootBullet", [(Utils.DEG * actor.getAngle()), 0, 0]);
						actor.say("Enemy Shoot Bullet", "_customBlock_ShootBullet", [((Utils.DEG * actor.getAngle()) + 30), 0, 0]);
						actor.say("Enemy Shoot Bullet", "_customBlock_ShootBullet", [((Utils.DEG * actor.getAngle()) - 30), 0, 0]);
					}
					else if((_Timer == 350))
					{
						actor.say("Enemy Shoot Bullet", "_customBlock_ShootBullet", [(Utils.DEG * actor.getAngle()), 0, 0]);
						actor.say("Enemy Shoot Bullet", "_customBlock_ShootBullet", [((Utils.DEG * actor.getAngle()) + 30), 0, 0]);
						actor.say("Enemy Shoot Bullet", "_customBlock_ShootBullet", [((Utils.DEG * actor.getAngle()) - 30), 0, 0]);
					}
					else if((_Timer == 300))
					{
						actor.say("Enemy Shoot Bullet", "_customBlock_ShootBullet", [(Utils.DEG * actor.getAngle()), 0, 0]);
						actor.say("Enemy Shoot Bullet", "_customBlock_ShootBullet", [((Utils.DEG * actor.getAngle()) + 30), 0, 0]);
						actor.say("Enemy Shoot Bullet", "_customBlock_ShootBullet", [((Utils.DEG * actor.getAngle()) - 30), 0, 0]);
					}
					else if((_Timer == 250))
					{
						actor.setVelocity(randomInt(Std.int(((Utils.DEG * actor.getAngle()) - 20)), Std.int(((Utils.DEG * actor.getAngle()) + 20))), _MoveSpeed);
					}
					else if((_Timer == 100))
					{
						actor.setXVelocity(0);
						actor.setYVelocity(0);
						actor.say("Enemy Shoot Bullet", "_customBlock_ShootBullet", [(Utils.DEG * actor.getAngle()), 30, 0]);
					}
				}
				else
				{
					_Timer = _TimerMax;
					actor.say("Enemy Shoot Bullet", "_customBlock_ShootBullet", [(Utils.DEG * actor.getAngle()), 30, 0]);
					actor.say("Enemy Shoot Bullet", "_customBlock_ShootBullet", [((Utils.DEG * actor.getAngle()) + 30), 30, 0]);
					actor.say("Enemy Shoot Bullet", "_customBlock_ShootBullet", [((Utils.DEG * actor.getAngle()) - 30), 30, 0]);
				}
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}