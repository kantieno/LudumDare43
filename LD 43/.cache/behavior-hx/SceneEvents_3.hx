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



class SceneEvents_3 extends SceneScript
{
	
	
	public function new(dummy:Int, dummy2:Engine)
	{
		super();
		
	}
	
	override public function init()
	{
		
		/* ========================= When Drawing ========================= */
		addWhenDrawingListener(null, function(g:G, x:Float, y:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				g.setFont(getFont(43));
				g.drawString("" + "Tutorial", 32, 32);
				g.drawString("" + "You have chosen knowledge", 32, 64);
				g.drawString("" + "You have sacrificed time, so you must read the tutorial", 32, 96);
				g.drawString("" + "If you had chosen to sacrifice time instead of knowledge...", 32, 128);
				g.drawString("" + "You would have gotten a damage and speed upgrade...", 32, 160);
				g.drawString("" + "Now you know.", 32, 192);
				g.drawString("" + "Don't worry you have to have a BIG OL NOGGIN to hold that much knowledge", 32, 224);
				g.drawString("" + "So you will get a special item as well, it will protect your head from wounds", 32, 256);
				g.drawString("" + "The chests in this dungeon are very dangerous, opening one requires sacrifice", 32, 288);
				g.drawString("" + "Either gain a wound on a body part or take damage", 32, 320);
				g.drawString("" + "Do not allow yourself to acquire too many wounds", 32, 352);
				g.drawString("" + "As a body part becomes more wounded, you will notice deleterious effects", 32, 384);
				g.drawString("" + "You can view your wounds and look at your items by pressing p", 32, 416);
			}
		});
		
		/* =========================== Any Key ============================ */
		addAnyKeyPressedListener(function(event:KeyboardEvent, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				switchScene(GameModel.get().scenes.get(1).getID(), createFadeOut(.1, Utils.getColorRGB(0,0,0)), createFadeIn(.1, Utils.getColorRGB(0,0,0)));
			}
		});
		
		/* ============================ Click ============================= */
		addMousePressedListener(function(list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				switchScene(GameModel.get().scenes.get(1).getID(), createFadeOut(.1, Utils.getColorRGB(0,0,0)), createFadeIn(.1, Utils.getColorRGB(0,0,0)));
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}