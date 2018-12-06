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
import box2D.collision.shapes.B2Shape;

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



class Design_7_7_InitializeGame extends SceneScript
{
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_switch():Void
	{
		if(((Engine.engine.getGameAttribute("KoT") : Float) == 0))
		{
			(Engine.engine.getGameAttribute("ItemsToAdd") : Array<Dynamic>).push(11);
		}
		else
		{
			(Engine.engine.getGameAttribute("ItemsToAdd") : Array<Dynamic>).push(0);
			(Engine.engine.getGameAttribute("ItemsToAdd") : Array<Dynamic>).push(8);
		}
		switchScene(GameModel.get().scenes.get(0).getID(), createFadeOut(.1, Utils.getColorRGB(0,0,0)), createFadeIn(.1, Utils.getColorRGB(0,0,0)));
	}
	
	
	public function new(dummy:Int, dummy2:Engine)
	{
		super();
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		Engine.engine.setGameAttribute("RoomNumber", 0);
		Engine.engine.setGameAttribute("Speed", 0);
		Engine.engine.setGameAttribute("Speed Multiplier", 1);
		Engine.engine.setGameAttribute("Max Health", 5);
		Engine.engine.setGameAttribute("Health", (Engine.engine.getGameAttribute("Max Health") : Float));
		Engine.engine.setGameAttribute("Attack", 10);
		Engine.engine.setGameAttribute("Attack Cooldown Multiplier", 1);
		Engine.engine.setGameAttribute("Attack Multiplier", 1);
		Engine.engine.setGameAttribute("Cooldown Multiplier", 1);
		Engine.engine.setGameAttribute("CurrentWeapon", 2);
		Utils.clear((Engine.engine.getGameAttribute("Effects") : Array<Dynamic>));
		Utils.clear((Engine.engine.getGameAttribute("Items") : Array<Dynamic>));
		Utils.clear((Engine.engine.getGameAttribute("ItemsToAdd") : Array<Dynamic>));
		Utils.clear((Engine.engine.getGameAttribute("WoundMax") : Array<Dynamic>));
		Utils.clear((Engine.engine.getGameAttribute("Wounds") : Array<Dynamic>));
		for(index0 in 0...6)
		{
			(Engine.engine.getGameAttribute("WoundMax") : Array<Dynamic>).push(3);
		}
		for(index0 in 0...6)
		{
			(Engine.engine.getGameAttribute("Wounds") : Array<Dynamic>).push(0);
		}
		
		/* =========================== Any Key ============================ */
		addAnyKeyPressedListener(function(event:KeyboardEvent, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				_customEvent_switch();
			}
		});
		
		/* ========================= When Drawing ========================= */
		addWhenDrawingListener(null, function(g:G, x:Float, y:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				g.setFont(getFont(43));
				g.drawString("" + "Dungeon of Sacrifice", (400 - (getFont(43).font.getTextWidth("Dungeon of Sacrifice", getFont(43).letterSpacing)/Engine.SCALE / 2)), 200);
				g.drawString("" + "Click Anywhere to Start the Game", (400 - (getFont(43).font.getTextWidth("Click Anywhere to start the game", getFont(43).letterSpacing)/Engine.SCALE / 2)), 350);
				g.drawString("" + "Made by Kantieno for Ludum Dare 43 in 48 Hours", (400 - (getFont(43).font.getTextWidth("made by kantieno for ludum dare 43 in 48 hours", getFont(43).letterSpacing)/Engine.SCALE / 2)), 500);
			}
		});
		
		/* ============================ Click ============================= */
		addMousePressedListener(function(list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				_customEvent_switch();
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}