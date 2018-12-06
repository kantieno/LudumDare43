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



class Design_4_4_SceneBehave extends SceneScript
{
	public var _ItemsTable:Array<Dynamic>;
	public var _TempList:Array<Dynamic>;
	public var _TempNum:Float;
	public var _ItemsImg:BitmapData;
	public var _ItemsImgInst:BitmapWrapper;
	public var _DescImg:BitmapData;
	public var _DescImgInst:BitmapWrapper;
	public var _WoundImg:BitmapData;
	public var _WoundImgInst:BitmapWrapper;
	public var _XMouseTile:Float;
	public var _YMouseTile:Float;
	public var _ActiveHighlight:Bool;
	public var _HighlightImg:BitmapData;
	public var _HighlightImgInst:BitmapWrapper;
	public var _XMouseHighlight:Float;
	public var _YMouseHighlight:Float;
	public var _ItemsInPosition:Bool;
	public var _AttemptingItemCheck:Bool;
	public var _ItemCheckTimer:Float;
	public var _TempText:String;
	public var _Sacrificing:Bool;
	public var _SacrificeShader:Dynamic;
	public var _RoomInProgress:Bool;
	public var _RoomTypes:Array<Dynamic>;
	public var _EnemiesAlive:Float;
	public var _SpawnX:Array<Dynamic>;
	public var _SpawnY:Array<Dynamic>;
	public var _RoomNumType:Float;
	public var _EnemyTypes:Float;
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_RoomStart():Void
	{
		for(actorInGroup in cast(getActorGroup(8), Group).list)
		{
			if(actorInGroup != null && !actorInGroup.dead && !actorInGroup.recycled){
				actorInGroup.shout("_customEvent_" + "close");
			}
		}
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_EnemyDead():Void
	{
		if(((Engine.engine.getGameAttribute("RoomNumber") : Float) == 20))
		{
			startShakingScreen(1 / 100, 1);
			newgroundsUnlockMedal("BeatGame");
			switchScene(GameModel.get().scenes.get(1).getID(), createFadeOut(1, Utils.getColorRGB(0,0,0)), createFadeIn(1, Utils.getColorRGB(0,0,0)));
		}
		_EnemiesAlive = 0;
		for(actorInGroup in cast(getActorGroup(4), Group).list)
		{
			if(actorInGroup != null && !actorInGroup.dead && !actorInGroup.recycled){
				_EnemiesAlive = (_EnemiesAlive + 1);
			}
		}
		if((_EnemiesAlive == 1))
		{
			_customEvent_RoomClear();
		}
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_RoomClear():Void
	{
		for(actorInGroup in cast(getActorGroup(8), Group).list)
		{
			if(actorInGroup != null && !actorInGroup.dead && !actorInGroup.recycled){
				actorInGroup.shout("_customEvent_" + "open");
			}
		}
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_DrawItemDesc():Void
	{
		if((hasValue(_DescImgInst)))
		{
			removeImage(_DescImgInst);
		}
		if((hasValue(_HighlightImgInst)))
		{
			removeImage(_HighlightImgInst);
		}
		_ActiveHighlight = true;
		attachImageToHUD(_HighlightImgInst, Std.int((_XMouseHighlight * 50)), Std.int((_YMouseHighlight * 50)));
		_DescImg = newImage(800, 30);
		fillImage(_DescImg, Utils.getColorRGB(218,201,194));
		drawTextOnImage(_DescImg, "" + _customBlock_GetItemDesc(asNumber((Engine.engine.getGameAttribute("Items") : Array<Dynamic>)[Std.int(((16 * (_YMouseHighlight - 10)) + _XMouseHighlight))])), 5, 5, getFont(36));
		_DescImgInst = new BitmapWrapper(new Bitmap(_DescImg));
		attachImageToHUD(_DescImgInst, 0, 500);
		setOrderForImage(_DescImgInst, 0);
		moveImageTo(_DescImgInst, 0, 470, .1, Easing.linear);
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_UndrawItemDesc():Void
	{
		_ActiveHighlight = false;
		_XMouseHighlight = 0;
		_YMouseHighlight = 0;
		setXForImage(_HighlightImgInst, 0);
		setYForImage(_HighlightImgInst, -50);
		if((hasValue(_DescImgInst)))
		{
			setYForImage(_DescImgInst, 600);
		}
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_DrawItems():Void
	{
		if((hasValue(_ItemsImgInst)))
		{
			removeImage(_ItemsImgInst);
		}
		_ItemsImg = newImage(800, 100);
		fillImage(_ItemsImg, Utils.getColorRGB(144,125,110));
		for(index0 in 0...(Engine.engine.getGameAttribute("Items") : Array<Dynamic>).length)
		{
			drawImageOnImage(getExternalImage((((("Item") + (("" + (Engine.engine.getGameAttribute("Items") : Array<Dynamic>)[index0])))) + (".png"))).clone(), _ItemsImg, ((index0 % 16) * 50), (Math.floor((index0 / 16)) * 50), BlendMode.NORMAL);
		}
		_ItemsImgInst = new BitmapWrapper(new Bitmap(_ItemsImg));
		attachImageToHUD(_ItemsImgInst, 0, 700);
		moveImageTo(_ItemsImgInst, 0, 500, .3, Easing.linear);
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_DrawWounds():Void
	{
		if((hasValue(_WoundImgInst)))
		{
			removeImage(_WoundImgInst);
		}
		_WoundImg = getExternalImage("Wounds.png");
		for(index0 in 0...Std.int(asNumber((Engine.engine.getGameAttribute("WoundMax") : Array<Dynamic>)[0])))
		{
			drawImageOnImage(getExternalImage("WoundsSmallDarkX.png"), _WoundImg, (48 + (19 * index0)), 67, BlendMode.NORMAL);
		}
		for(index0 in 0...Std.int(asNumber((Engine.engine.getGameAttribute("WoundMax") : Array<Dynamic>)[1])))
		{
			drawImageOnImage(getExternalImage("WoundsSmallDarkX.png"), _WoundImg, (266 + (19 * index0)), 98, BlendMode.NORMAL);
		}
		for(index0 in 0...Std.int(asNumber((Engine.engine.getGameAttribute("WoundMax") : Array<Dynamic>)[2])))
		{
			drawImageOnImage(getExternalImage("WoundsSmallDarkX.png"), _WoundImg, (41 + (19 * index0)), 180, BlendMode.NORMAL);
		}
		for(index0 in 0...Std.int(asNumber((Engine.engine.getGameAttribute("WoundMax") : Array<Dynamic>)[3])))
		{
			drawImageOnImage(getExternalImage("WoundsSmallDarkX.png"), _WoundImg, (291 + (19 * index0)), 205, BlendMode.NORMAL);
		}
		for(index0 in 0...Std.int(asNumber((Engine.engine.getGameAttribute("WoundMax") : Array<Dynamic>)[4])))
		{
			drawImageOnImage(getExternalImage("WoundsSmallDarkX.png"), _WoundImg, (68 + (19 * index0)), 288, BlendMode.NORMAL);
		}
		for(index0 in 0...Std.int(asNumber((Engine.engine.getGameAttribute("WoundMax") : Array<Dynamic>)[5])))
		{
			drawImageOnImage(getExternalImage("WoundsSmallDarkX.png"), _WoundImg, (267 + (19 * index0)), 295, BlendMode.NORMAL);
		}
		for(index0 in 0...Std.int(asNumber((Engine.engine.getGameAttribute("Wounds") : Array<Dynamic>)[0])))
		{
			drawImageOnImage(getExternalImage("WoundsSmallX.png"), _WoundImg, (48 + (19 * index0)), 67, BlendMode.NORMAL);
		}
		for(index0 in 0...Std.int(asNumber((Engine.engine.getGameAttribute("Wounds") : Array<Dynamic>)[1])))
		{
			drawImageOnImage(getExternalImage("WoundsSmallX.png"), _WoundImg, (266 + (19 * index0)), 98, BlendMode.NORMAL);
		}
		for(index0 in 0...Std.int(asNumber((Engine.engine.getGameAttribute("Wounds") : Array<Dynamic>)[2])))
		{
			drawImageOnImage(getExternalImage("WoundsSmallX.png"), _WoundImg, (41 + (19 * index0)), 180, BlendMode.NORMAL);
		}
		for(index0 in 0...Std.int(asNumber((Engine.engine.getGameAttribute("Wounds") : Array<Dynamic>)[3])))
		{
			drawImageOnImage(getExternalImage("WoundsSmallX.png"), _WoundImg, (291 + (19 * index0)), 205, BlendMode.NORMAL);
		}
		for(index0 in 0...Std.int(asNumber((Engine.engine.getGameAttribute("Wounds") : Array<Dynamic>)[4])))
		{
			drawImageOnImage(getExternalImage("WoundsSmallX.png"), _WoundImg, (68 + (19 * index0)), 288, BlendMode.NORMAL);
		}
		for(index0 in 0...Std.int(asNumber((Engine.engine.getGameAttribute("Wounds") : Array<Dynamic>)[5])))
		{
			drawImageOnImage(getExternalImage("WoundsSmallX.png"), _WoundImg, (267 + (19 * index0)), 295, BlendMode.NORMAL);
		}
		if((asNumber((Engine.engine.getGameAttribute("Wounds") : Array<Dynamic>)[0]) >= asNumber((Engine.engine.getGameAttribute("WoundMax") : Array<Dynamic>)[0])))
		{
			drawImageOnImage(getExternalImage("WoundsBigX.png"), _WoundImg, (192 - 34), (115 - 34), BlendMode.NORMAL);
		}
		if((asNumber((Engine.engine.getGameAttribute("Wounds") : Array<Dynamic>)[1]) >= asNumber((Engine.engine.getGameAttribute("WoundMax") : Array<Dynamic>)[1])))
		{
			drawImageOnImage(getExternalImage("WoundsBigX.png"), _WoundImg, (195 - 34), (180 - 34), BlendMode.NORMAL);
		}
		if((asNumber((Engine.engine.getGameAttribute("Wounds") : Array<Dynamic>)[2]) >= asNumber((Engine.engine.getGameAttribute("WoundMax") : Array<Dynamic>)[2])))
		{
			drawImageOnImage(getExternalImage("WoundsBigX.png"), _WoundImg, (134 - 34), (212 - 34), BlendMode.NORMAL);
		}
		if((asNumber((Engine.engine.getGameAttribute("Wounds") : Array<Dynamic>)[3]) >= asNumber((Engine.engine.getGameAttribute("WoundMax") : Array<Dynamic>)[3])))
		{
			drawImageOnImage(getExternalImage("WoundsBigX.png"), _WoundImg, (260 - 34), (212 - 34), BlendMode.NORMAL);
		}
		if((asNumber((Engine.engine.getGameAttribute("Wounds") : Array<Dynamic>)[4]) >= asNumber((Engine.engine.getGameAttribute("WoundMax") : Array<Dynamic>)[4])))
		{
			drawImageOnImage(getExternalImage("WoundsBigX.png"), _WoundImg, (166 - 34), (316 - 34), BlendMode.NORMAL);
		}
		if((asNumber((Engine.engine.getGameAttribute("Wounds") : Array<Dynamic>)[5]) >= asNumber((Engine.engine.getGameAttribute("WoundMax") : Array<Dynamic>)[5])))
		{
			drawImageOnImage(getExternalImage("WoundsBigX.png"), _WoundImg, (225 - 34), (316 - 34), BlendMode.NORMAL);
		}
		_WoundImgInst = new BitmapWrapper(new Bitmap(_WoundImg));
		attachImageToHUD(_WoundImgInst, 200, -420);
		moveImageTo(_WoundImgInst, 200, 50, .3, Easing.linear);
		_customEvent_DrawItems();
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_UnDrawWounds():Void
	{
		if((hasValue(_WoundImgInst)))
		{
			moveImageTo(_WoundImgInst, 200, -420, .3, Easing.linear);
		}
		if((hasValue(_ItemsImgInst)))
		{
			moveImageTo(_ItemsImgInst, 0, 700, .3, Easing.linear);
		}
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_AddItem(__ItemNum:Float):Void
	{
		(Engine.engine.getGameAttribute("Items") : Array<Dynamic>).push(__ItemNum);
		_TempList = (("" + _ItemsTable[Std.int(__ItemNum)])).split(",").copy();
		for(index0 in 0...Std.int(((_TempList.length - 1) / 2)))
		{
			_TempNum = ((index0 * 2) + 1);
			if((asNumber(_TempList[Std.int(_TempNum)]) == 0))
			{
				_customBlock_AdjustSpeed(asNumber(_TempList[Std.int((_TempNum + 1))]));
			}
			else if((asNumber(_TempList[Std.int(_TempNum)]) == 1))
			{
				_customBlock_AdjustSpeedMod(asNumber(_TempList[Std.int((_TempNum + 1))]));
			}
			else if((asNumber(_TempList[Std.int(_TempNum)]) == 2))
			{
				_customBlock_AdjustAttack(asNumber(_TempList[Std.int((_TempNum + 1))]));
			}
			else if((asNumber(_TempList[Std.int(_TempNum)]) == 3))
			{
				_customBlock_AdjustAttackMod(asNumber(_TempList[Std.int((_TempNum + 1))]));
			}
			else if((asNumber(_TempList[Std.int(_TempNum)]) == 4))
			{
				_customBlock_AdjusAttackCooldown(asNumber(_TempList[Std.int((_TempNum + 1))]));
			}
			else if((asNumber(_TempList[Std.int(_TempNum)]) == 5))
			{
				_customBlock_AdjustHealth(asNumber(_TempList[Std.int((_TempNum + 1))]));
			}
			else if((asNumber(_TempList[Std.int(_TempNum)]) == 6))
			{
				_customBlock_AdjustCooldown(asNumber(_TempList[Std.int((_TempNum + 1))]));
			}
			else if((asNumber(_TempList[Std.int(_TempNum)]) == 7))
			{
				_customBlock_AddEffect(asNumber(_TempList[Std.int((_TempNum + 1))]));
			}
			else if((asNumber(_TempList[Std.int(_TempNum)]) == 8))
			{
				_customBlock_AddWeapon(asNumber(_TempList[Std.int((_TempNum + 1))]));
			}
			else if((asNumber(_TempList[Std.int(_TempNum)]) == 9))
			{
				_customBlock_AddSecondary(asNumber(_TempList[Std.int((_TempNum + 1))]));
			}
			else if((asNumber(_TempList[Std.int(_TempNum)]) == 10))
			{
				_customBlock_AddWound(asNumber(_TempList[Std.int((_TempNum + 1))]));
			}
			else if((asNumber(_TempList[Std.int(_TempNum)]) == 11))
			{
				_customBlock_AddMaxWound(asNumber(_TempList[Std.int((_TempNum + 1))]));
			}
		}
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_RemoveItem(__ItemNum:Float):Void
	{
		(Engine.engine.getGameAttribute("Items") : Array<Dynamic>).remove(__ItemNum);
		_TempList = (("" + _ItemsTable[Std.int(__ItemNum)])).split(",").copy();
		for(index0 in 0...Std.int(((_TempList.length - 1) / 2)))
		{
			_TempNum = ((index0 * 2) + 1);
			if((_TempNum == 0))
			{
				_customBlock_AdjustSpeed(-(asNumber(_TempList[Std.int((_TempNum + 1))])));
			}
			else if((_TempNum == 1))
			{
				_customBlock_AdjustSpeedMod((1 / asNumber(_TempList[Std.int((_TempNum + 1))])));
			}
			else if((_TempNum == 2))
			{
				_customBlock_AdjustAttack(-(asNumber(_TempList[Std.int((_TempNum + 1))])));
			}
			else if((_TempNum == 3))
			{
				_customBlock_AdjustAttackMod((1 / asNumber(_TempList[Std.int((_TempNum + 1))])));
			}
			else if((_TempNum == 4))
			{
				_customBlock_AdjusAttackCooldown((1 / asNumber(_TempList[Std.int((_TempNum + 1))])));
			}
			else if((_TempNum == 5))
			{
				_customBlock_AdjustHealth(-(asNumber(_TempList[Std.int((_TempNum + 1))])));
			}
			else if((_TempNum == 6))
			{
				_customBlock_AdjustCooldown((1 / asNumber(_TempList[Std.int((_TempNum + 1))])));
			}
			else if((_TempNum == 7))
			{
				_customBlock_RemoveEffect(asNumber(_TempList[Std.int((_TempNum + 1))]));
			}
			else if((_TempNum == 8))
			{
				_customBlock_RemoveWeapon(asNumber(_TempList[Std.int((_TempNum + 1))]));
			}
			else if((_TempNum == 9))
			{
				_customBlock_RemoveSecondary(asNumber(_TempList[Std.int((_TempNum + 1))]));
			}
			else if((_TempNum == 10))
			{
				_customBlock_RemoveWound(asNumber(_TempList[Std.int((_TempNum + 1))]));
			}
			else if((_TempNum == 11))
			{
				_customBlock_RemoveMaxWound(asNumber(_TempList[Std.int((_TempNum + 1))]));
			}
		}
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_AdjustSpeed(__Amount:Float):Void
	{
		Engine.engine.setGameAttribute("Speed", ((Engine.engine.getGameAttribute("Speed") : Float) + __Amount));
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_AdjustSpeedMod(__Mult:Float):Void
	{
		Engine.engine.setGameAttribute("Speed Multiplier", ((Engine.engine.getGameAttribute("Speed Multiplier") : Float) * __Mult));
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_AdjustAttack(__Amount:Float):Void
	{
		Engine.engine.setGameAttribute("Attack", ((Engine.engine.getGameAttribute("Attack") : Float) + __Amount));
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_AdjustAttackMod(__Mult:Float):Void
	{
		Engine.engine.setGameAttribute("Attack Multiplier", ((Engine.engine.getGameAttribute("Attack Multiplier") : Float) * __Mult));
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_AdjusAttackCooldown(__Mult:Float):Void
	{
		Engine.engine.setGameAttribute("Attack Cooldown Multiplier", ((Engine.engine.getGameAttribute("Attack Cooldown Multiplier") : Float) * __Mult));
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_AdjustHealth(__Amount:Float):Void
	{
		Engine.engine.setGameAttribute("Max Health", ((Engine.engine.getGameAttribute("Max Health") : Float) + __Amount));
		_customBlock_HealHealth(__Amount);
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_AdjustCooldown(__Mult:Float):Void
	{
		Engine.engine.setGameAttribute("Cooldown Multiplier", ((Engine.engine.getGameAttribute("Cooldown Multiplier") : Float) * __Mult));
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_AddEffect(__EffectNum:Float):Void
	{
		(Engine.engine.getGameAttribute("Effects") : Array<Dynamic>).push(__EffectNum);
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_RemoveEffect(__EffectNum:Float):Void
	{
		(Engine.engine.getGameAttribute("Effects") : Array<Dynamic>).remove(__EffectNum);
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_AddWeapon(__WeaponNum:Float):Void
	{
		(Engine.engine.getGameAttribute("Weapons") : Array<Dynamic>).push(__WeaponNum);
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_RemoveWeapon(__WeaponNum:Float):Void
	{
		(Engine.engine.getGameAttribute("Weapons") : Array<Dynamic>).remove(__WeaponNum);
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_AddSecondary(__SecondaryNum:Float):Void
	{
		(Engine.engine.getGameAttribute("SecondaryItems") : Array<Dynamic>).push(__SecondaryNum);
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_RemoveSecondary(__SecondaryNum:Float):Void
	{
		(Engine.engine.getGameAttribute("SecondaryItems") : Array<Dynamic>).remove(__SecondaryNum);
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_AddWound(__WoundNum:Float):Void
	{
		if((asNumber((Engine.engine.getGameAttribute("Wounds") : Array<Dynamic>)[Std.int(__WoundNum)]) == 0))
		{
			(Engine.engine.getGameAttribute("Wounds") : Array<Dynamic>)[Std.int(__WoundNum)] = 1;
			_customBlock_AddMinorWound(__WoundNum);
		}
		else if((asNumber((Engine.engine.getGameAttribute("Wounds") : Array<Dynamic>)[Std.int(__WoundNum)]) < asNumber((Engine.engine.getGameAttribute("WoundMax") : Array<Dynamic>)[Std.int(__WoundNum)])))
		{
			(Engine.engine.getGameAttribute("Wounds") : Array<Dynamic>)[Std.int(__WoundNum)] = (asNumber((Engine.engine.getGameAttribute("Wounds") : Array<Dynamic>)[Std.int(__WoundNum)]) + 1);
			if((asNumber((Engine.engine.getGameAttribute("Wounds") : Array<Dynamic>)[Std.int(__WoundNum)]) >= asNumber((Engine.engine.getGameAttribute("WoundMax") : Array<Dynamic>)[Std.int(__WoundNum)])))
			{
				_customBlock_AddMajorWound(__WoundNum);
			}
		}
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_RemoveWound(__WoundNum:Float):Void
	{
		if(!((asNumber((Engine.engine.getGameAttribute("Wounds") : Array<Dynamic>)[Std.int(__WoundNum)]) == 0)))
		{
			if(((Engine.engine.getGameAttribute("Wounds") : Array<Dynamic>)[Std.int(__WoundNum)] == asNumber((Engine.engine.getGameAttribute("WoundMax") : Array<Dynamic>)[Std.int(__WoundNum)])))
			{
				_customBlock_AddMaxWound(__WoundNum);
			}
			(Engine.engine.getGameAttribute("Wounds") : Array<Dynamic>)[Std.int(__WoundNum)] = (asNumber((Engine.engine.getGameAttribute("Wounds") : Array<Dynamic>)[Std.int(__WoundNum)]) - 1);
			if((asNumber((Engine.engine.getGameAttribute("Wounds") : Array<Dynamic>)[Std.int(__WoundNum)]) == 0))
			{
				_customBlock_RemoveMinorWound(__WoundNum);
			}
		}
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_AddMaxWound(__WoundNum:Float):Void
	{
		if((asNumber((Engine.engine.getGameAttribute("WoundMax") : Array<Dynamic>)[Std.int(__WoundNum)]) < 5))
		{
			if((asNumber((Engine.engine.getGameAttribute("Wounds") : Array<Dynamic>)[Std.int(__WoundNum)]) == asNumber((Engine.engine.getGameAttribute("WoundMax") : Array<Dynamic>)[Std.int(__WoundNum)])))
			{
				_customBlock_RemoveMajorWound(__WoundNum);
			}
			(Engine.engine.getGameAttribute("WoundMax") : Array<Dynamic>)[Std.int(__WoundNum)] = (asNumber((Engine.engine.getGameAttribute("WoundMax") : Array<Dynamic>)[Std.int(__WoundNum)]) + 1);
		}
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_RemoveMaxWound(__WoundNum:Float):Void
	{
		if((asNumber((Engine.engine.getGameAttribute("WoundMax") : Array<Dynamic>)[Std.int(__WoundNum)]) > 1))
		{
			if((asNumber((Engine.engine.getGameAttribute("Wounds") : Array<Dynamic>)[Std.int(__WoundNum)]) == (asNumber((Engine.engine.getGameAttribute("WoundMax") : Array<Dynamic>)[Std.int(__WoundNum)]) - 1)))
			{
				_customBlock_AddMajorWound(__WoundNum);
			}
			(Engine.engine.getGameAttribute("WoundMax") : Array<Dynamic>)[Std.int(__WoundNum)] = (asNumber((Engine.engine.getGameAttribute("WoundMax") : Array<Dynamic>)[Std.int(__WoundNum)]) - 1);
		}
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_AddMinorWound(__WoundNum:Float):Void
	{
		if((__WoundNum == 2))
		{
			_customBlock_AdjusAttackCooldown(.75);
		}
		else if((__WoundNum == 3))
		{
			_customBlock_AdjustCooldown(.75);
		}
		else if((__WoundNum == 4))
		{
			_customBlock_AdjustSpeedMod(.75);
		}
		else if((__WoundNum == 5))
		{
			_customBlock_AdjustSpeedMod(.75);
		}
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_RemoveMinorWound(__WoundNum:Float):Void
	{
		if((__WoundNum == 2))
		{
			_customBlock_AdjusAttackCooldown((1 / .75));
		}
		else if((__WoundNum == 3))
		{
			_customBlock_AdjustCooldown((1 / .75));
		}
		else if((__WoundNum == 4))
		{
			_customBlock_AdjustSpeedMod((1 / .75));
		}
		else if((__WoundNum == 5))
		{
			_customBlock_AdjustSpeedMod((1 / .75));
		}
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_AddMajorWound(__WoundNum:Float):Void
	{
		if((__WoundNum == 0))
		{
			_customBlock_AdjustHealth(-1);
		}
		else if((__WoundNum == 1))
		{
			_customBlock_AdjustHealth(-1);
		}
		if((__WoundNum == 2))
		{
			_customBlock_AdjusAttackCooldown(.6);
		}
		else if((__WoundNum == 3))
		{
			_customBlock_AdjustCooldown(.6);
		}
		else if((__WoundNum == 4))
		{
			_customBlock_AdjustSpeedMod(.6);
		}
		else if((__WoundNum == 5))
		{
			_customBlock_AdjustSpeedMod(.6);
		}
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_RemoveMajorWound(__WoundNum:Float):Void
	{
		if((__WoundNum == 0))
		{
			_customBlock_AdjustHealth(1);
		}
		else if((__WoundNum == 1))
		{
			_customBlock_AdjustHealth(1);
		}
		if((__WoundNum == 2))
		{
			_customBlock_AdjusAttackCooldown((1 / .6));
		}
		else if((__WoundNum == 3))
		{
			_customBlock_AdjustCooldown((1 / .6));
		}
		else if((__WoundNum == 4))
		{
			_customBlock_AdjustSpeedMod((1 / .6));
		}
		else if((__WoundNum == 5))
		{
			_customBlock_AdjustSpeedMod((1 / .6));
		}
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_DrawItemDescription(__ItemNum:Float):Void
	{
		if((hasValue(_DescImgInst)))
		{
			removeImage(_ItemsImgInst);
		}
		_DescImg = newImage(800, 100);
		fillImage(_DescImg, Utils.getColorRGB(224,222,215));
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_GetItemDesc(__ItemNum:Float):String
	{
		_TempList = (("" + _ItemsTable[Std.int(__ItemNum)])).split(",").copy();
		_TempText = ((("" + _TempList[0])) + ("- "));
		for(index0 in 0...Std.int(((_TempList.length - 1) / 2)))
		{
			_TempNum = ((index0 * 2) + 1);
			if((index0 > 0))
			{
				_TempText = ((_TempText) + (("" + ", ")));
			}
			if((asNumber(_TempList[Std.int(_TempNum)]) == 0))
			{
				if((asNumber(_TempList[Std.int((_TempNum + 1))]) > 0))
				{
					_TempText = ((_TempText) + (("" + "Increases Speed")));
				}
				else
				{
					_TempText = ((_TempText) + (("" + "Decreases Speed")));
				}
			}
			else if((asNumber(_TempList[Std.int(_TempNum)]) == 1))
			{
				if((asNumber(_TempList[Std.int((_TempNum + 1))]) > 1))
				{
					_TempText = ((_TempText) + (("" + "Increases Speed")));
				}
				else
				{
					_TempText = ((_TempText) + (("" + "Decreases Speed")));
				}
			}
			else if((asNumber(_TempList[Std.int(_TempNum)]) == 2))
			{
				if((asNumber(_TempList[Std.int((_TempNum + 1))]) > 0))
				{
					_TempText = ((_TempText) + (("" + "Increases Attack")));
				}
				else
				{
					_TempText = ((_TempText) + (("" + "Decreases Attack")));
				}
			}
			else if((asNumber(_TempList[Std.int(_TempNum)]) == 3))
			{
				if((asNumber(_TempList[Std.int((_TempNum + 1))]) > 1))
				{
					_TempText = ((_TempText) + (("" + "Increases Attack")));
				}
				else
				{
					_TempText = ((_TempText) + (("" + "Decreases Attack")));
				}
			}
			else if((asNumber(_TempList[Std.int(_TempNum)]) == 4))
			{
				if((asNumber(_TempList[Std.int((_TempNum + 1))]) < 1))
				{
					_TempText = ((_TempText) + (("" + "Increases Attack Speed")));
				}
				else
				{
					_TempText = ((_TempText) + (("" + "Decreases Attack Speed")));
				}
			}
			else if((asNumber(_TempList[Std.int(_TempNum)]) == 5))
			{
				if((asNumber(_TempList[Std.int((_TempNum + 1))]) > 0))
				{
					_TempText = ((_TempText) + (("" + "Increases Health")));
				}
				else
				{
					_TempText = ((_TempText) + (("" + "Decreases Health")));
				}
			}
			else if((asNumber(_TempList[Std.int(_TempNum)]) == 6))
			{
				if((asNumber(_TempList[Std.int((_TempNum + 1))]) < 1))
				{
					_TempText = ((_TempText) + (("" + "Increases Secondary Cooldown")));
				}
				else
				{
					_TempText = ((_TempText) + (("" + "Decreases Secondary Cooldown")));
				}
			}
			else if((asNumber(_TempList[Std.int(_TempNum)]) == 7))
			{
				_TempText = ((_TempText) + (("" + "Adds Special Effect")));
			}
			else if((asNumber(_TempList[Std.int(_TempNum)]) == 8))
			{
				_TempText = ((_TempText) + (("" + "Weapon")));
			}
			else if((asNumber(_TempList[Std.int(_TempNum)]) == 9))
			{
				_TempText = ((_TempText) + (("" + "Secondary")));
			}
			else if((asNumber(_TempList[Std.int(_TempNum)]) == 10))
			{
				_TempText = ((_TempText) + (("" + "Adds Wound")));
			}
			else if((asNumber(_TempList[Std.int(_TempNum)]) == 11))
			{
				_TempText = ((_TempText) + (("" + "Increases Wound Tolerance")));
			}
		}
		return _TempText;
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_Sacrifice():Void
	{
		_Sacrificing = true;
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_SacrificeEnd():Void
	{
		_Sacrificing = false;
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_PoseSacrifice(__SacNum:Float):Void
	{
		_Sacrificing = true;
		engine.pause();
		_customEvent_Sacrifice();
		createRecycledActor(getActorType(41), -300, 600, Script.FRONT);
		getLastCreatedActor().setValue("Sacrifice Behave", "_Num", 0);
		getLastCreatedActor().setValue("Sacrifice Behave", "_Modi", randomInt(0, 5));
		getLastCreatedActor().setValue("Sacrifice Behave", "_Left", true);
		getLastCreatedActor().say("Sacrifice Behave", "_customEvent_" + "created");
		createRecycledActor(getActorType(41), 800, 600, Script.FRONT);
		getLastCreatedActor().setValue("Sacrifice Behave", "_Num", 1);
		getLastCreatedActor().setValue("Sacrifice Behave", "_Modi", 1);
		getLastCreatedActor().say("Sacrifice Behave", "_customEvent_" + "created");
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_Sacrifice(__SacrificeNum:Float, __Modi:Float):Void
	{
		if((__SacrificeNum == 0))
		{
			_customBlock_AddWound(__Modi);
		}
		else if((__SacrificeNum == 1))
		{
			_customBlock_DamageHealth(__Modi);
		}
		else
		{
			_customBlock_RemoveItem(__Modi);
		}
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_DamageHealth(__Damage:Float):Void
	{
		Engine.engine.setGameAttribute("Health", ((Engine.engine.getGameAttribute("Health") : Float) - __Damage));
		if(((Engine.engine.getGameAttribute("Health") : Float) <= 0))
		{
			Engine.engine.setGameAttribute("Health", 0);
			_customEvent_dead();
		}
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_HealHealth(__Heal:Float):Void
	{
		Engine.engine.setGameAttribute("Health", ((Engine.engine.getGameAttribute("Health") : Float) + __Heal));
		if(((Engine.engine.getGameAttribute("Health") : Float) > (Engine.engine.getGameAttribute("Max Health") : Float)))
		{
			Engine.engine.setGameAttribute("Health", (Engine.engine.getGameAttribute("Max Health") : Float));
		}
	}
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_dead():Void
	{
		for(actorInGroup in cast(getActorGroup(0), Group).list)
		{
			if(actorInGroup != null && !actorInGroup.dead && !actorInGroup.recycled){
				recycleActor(actorInGroup);
			}
		}
		runLater(1000 * 1, function(timeTask:TimedTask):Void
		{
			switchScene(GameModel.get().scenes.get(1).getID(), createFadeOut(.1, Utils.getColorRGB(0,0,0)), createFadeIn(.1, Utils.getColorRGB(0,0,0)));
		}, null);
	}
	
	
	public function new(dummy:Int, dummy2:Engine)
	{
		super();
		nameMap.set("Items Table", "_ItemsTable");
		_ItemsTable = ["Boots,0,5", "Quick Boots,1,1.25", "Spiked Gloves,2,3", "Strength Charm,3,1.5", "Swift Gloves,4,.75", "Plate Armor,5,1", "Mechanical Glove,4,.8", "Multi Charm,7,0", "Shortsword,2,2", "Shade,5,1,0,5", "Beartrap,10,4,2,5", "Helmet,11,0"];
		nameMap.set("TempList", "_TempList");
		nameMap.set("TempNum", "_TempNum");
		_TempNum = 0.0;
		nameMap.set("ItemsImg", "_ItemsImg");
		nameMap.set("ItemsImgInst", "_ItemsImgInst");
		nameMap.set("DescImg", "_DescImg");
		nameMap.set("DescImgInst", "_DescImgInst");
		nameMap.set("WoundImg", "_WoundImg");
		nameMap.set("WoundImgInst", "_WoundImgInst");
		nameMap.set("XMouseTile", "_XMouseTile");
		_XMouseTile = 0.0;
		nameMap.set("YMouseTile", "_YMouseTile");
		_YMouseTile = 0.0;
		nameMap.set("ActiveHighlight", "_ActiveHighlight");
		_ActiveHighlight = false;
		nameMap.set("HighlightImg", "_HighlightImg");
		nameMap.set("HighlightImgInst", "_HighlightImgInst");
		nameMap.set("XMouseHighlight", "_XMouseHighlight");
		_XMouseHighlight = 0.0;
		nameMap.set("YMouseHighlight", "_YMouseHighlight");
		_YMouseHighlight = 0.0;
		nameMap.set("ItemsInPosition", "_ItemsInPosition");
		_ItemsInPosition = false;
		nameMap.set("AttemptingItemCheck", "_AttemptingItemCheck");
		_AttemptingItemCheck = false;
		nameMap.set("ItemCheckTimer", "_ItemCheckTimer");
		_ItemCheckTimer = 0.0;
		nameMap.set("TempText", "_TempText");
		_TempText = "";
		nameMap.set("Sacrificing", "_Sacrificing");
		_Sacrificing = false;
		nameMap.set("SacrificeShader", "_SacrificeShader");
		nameMap.set("RoomInProgress", "_RoomInProgress");
		_RoomInProgress = false;
		nameMap.set("RoomTypes", "_RoomTypes");
		_RoomTypes = ["0,0,0,0,0,1", "1,0,4", "0,1,5,0,1,6,1,0,4", "0,0,0,0,0,1,0,0,2,0,0,3"];
		nameMap.set("Enemies Alive", "_EnemiesAlive");
		_EnemiesAlive = 0.0;
		nameMap.set("SpawnX", "_SpawnX");
		_SpawnX = [100.0, 700.0, 700.0, 100.0, 400.0, 250.0, 550.0];
		nameMap.set("Spawn Y", "_SpawnY");
		_SpawnY = [100.0, 100.0, 500.0, 500.0, 300.0, 200.0, 200.0];
		nameMap.set("RoomNumType", "_RoomNumType");
		_RoomNumType = 0.0;
		nameMap.set("EnemyTypes", "_EnemyTypes");
		_EnemyTypes = 3.0;
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		_HighlightImg = getExternalImage("ItemHighlight.png");
		_HighlightImgInst = new BitmapWrapper(new Bitmap(_HighlightImg));
		attachImageToHUD(_HighlightImgInst, 0, -50);
		Engine.engine.setGameAttribute("RoomNumber", ((Engine.engine.getGameAttribute("RoomNumber") : Float) + 1));
		if(((Engine.engine.getGameAttribute("RoomEntryNum") : Float) == 1))
		{
			for(item in cast((Engine.engine.getGameAttribute("ItemsToAdd") : Array<Dynamic>), Array<Dynamic>))
			{
				_customBlock_AddItem(asNumber(item));
			}
			createRecycledActor(getActorType(2), 0, 240, Script.MIDDLE);
			getLastCreatedActor().fadeTo(30 / 100, 0, Easing.linear);
			getLastCreatedActor().fadeTo(100 / 100, .3, Easing.linear);
			getLastCreatedActor().moveBy(50, 0, .3, Easing.linear);
			runLater(1000 * .3, function(timeTask:TimedTask):Void
			{
				for(actorInGroup in cast(getActorGroup(0), Group).list)
				{
					if(actorInGroup != null && !actorInGroup.dead && !actorInGroup.recycled){
						actorInGroup.shout("_customEvent_" + "Entered");
					}
				}
			}, null);
		}
		else if(((Engine.engine.getGameAttribute("RoomEntryNum") : Float) == 2))
		{
			createRecycledActor(getActorType(2), 750, 240, Script.MIDDLE);
			getLastCreatedActor().fadeTo(30 / 100, 0, Easing.linear);
			getLastCreatedActor().fadeTo(100 / 100, .3, Easing.linear);
			getLastCreatedActor().moveBy(-50, 0, .3, Easing.linear);
			runLater(1000 * .3, function(timeTask:TimedTask):Void
			{
				for(actorInGroup in cast(getActorGroup(0), Group).list)
				{
					if(actorInGroup != null && !actorInGroup.dead && !actorInGroup.recycled){
						actorInGroup.shout("_customEvent_" + "Entered");
					}
				}
			}, null);
		}
		else
		{
			createRecycledActor(getActorType(2), 375, 600, Script.MIDDLE);
			getLastCreatedActor().fadeTo(30 / 100, 0, Easing.linear);
			getLastCreatedActor().fadeTo(100 / 100, .3, Easing.linear);
			getLastCreatedActor().moveBy(0, -90, .8, Easing.linear);
			runLater(1000 * .3, function(timeTask:TimedTask):Void
			{
				for(actorInGroup in cast(getActorGroup(0), Group).list)
				{
					if(actorInGroup != null && !actorInGroup.dead && !actorInGroup.recycled){
						actorInGroup.shout("_customEvent_" + "Entered");
					}
				}
			}, null);
		}
		if(!(((Engine.engine.getGameAttribute("RoomNumber") : Float) == 1)))
		{
			if(((Engine.engine.getGameAttribute("RoomNumber") : Float) == 20))
			{
				createRecycledActor(getActorType(54), 400, 250, Script.MIDDLE);
				getLastCreatedActor().setX((getLastCreatedActor().getX() - (getLastCreatedActor().getWidth()/2)));
				getLastCreatedActor().setY((getLastCreatedActor().getY() - (getLastCreatedActor().getHeight()/2)));
			}
			else if(((Engine.engine.getGameAttribute("RoomNumber") : Float) == 19))
			{
				createRecycledActor(getActorType(56), 395, 100, Script.BACK);
				getLastCreatedActor().setX((getLastCreatedActor().getX() - (getLastCreatedActor().getWidth()/2)));
				getLastCreatedActor().setY((getLastCreatedActor().getY() - (getLastCreatedActor().getHeight()/2)));
			}
			else
			{
				_RoomNumType = randomInt(0, (_RoomTypes.length - 1));
				_TempList = (("" + _RoomTypes[Std.int(_RoomNumType)])).split(",");
				for(index0 in 0...Std.int((_TempList.length / 3)))
				{
					if((asNumber(_TempList[(index0 * 3)]) == 0))
					{
						if((asNumber(_TempList[((index0 * 3) + 1)]) == 0))
						{
							createRecycledActor(getActorTypeByName((("Enemy") + (("" + randomInt(1, Std.int(_EnemyTypes)))))), asNumber(_SpawnX[Std.int(asNumber(_TempList[((index0 * 3) + 2)]))]), asNumber(_SpawnY[Std.int(asNumber(_TempList[((index0 * 3) + 2)]))]), Script.MIDDLE);
							getLastCreatedActor().setX((getLastCreatedActor().getX() - (getLastCreatedActor().getWidth()/2)));
							getLastCreatedActor().setY((getLastCreatedActor().getY() - (getLastCreatedActor().getHeight()/2)));
						}
						else
						{
							createRecycledActor(getActorTypeByName((("Enemy") + (("" + asNumber(_TempList[((index0 * 3) + 1)]))))), asNumber(_SpawnX[Std.int(asNumber(_TempList[((index0 * 3) + 2)]))]), asNumber(_SpawnY[Std.int(asNumber(_TempList[((index0 * 3) + 2)]))]), Script.MIDDLE);
							getLastCreatedActor().setX((getLastCreatedActor().getX() - (getLastCreatedActor().getWidth()/2)));
							getLastCreatedActor().setY((getLastCreatedActor().getY() - (getLastCreatedActor().getHeight()/2)));
						}
					}
					else if((asNumber(_TempList[(index0 * 3)]) == 0))
					{
						createRecycledActor(getActorType(44), asNumber(_SpawnX[Std.int(asNumber(_TempList[((index0 * 3) + 2)]))]), asNumber(_SpawnY[Std.int(asNumber(_TempList[((index0 * 3) + 2)]))]), Script.BACK);
						getLastCreatedActor().setX((getLastCreatedActor().getX() - (getLastCreatedActor().getWidth()/2)));
						getLastCreatedActor().setY((getLastCreatedActor().getY() - (getLastCreatedActor().getHeight()/2)));
					}
					else
					{
						createRecycledActor(getActorType(44), asNumber(_SpawnX[Std.int(asNumber(_TempList[((index0 * 3) + 2)]))]), asNumber(_SpawnY[Std.int(asNumber(_TempList[((index0 * 3) + 2)]))]), Script.BACK);
						getLastCreatedActor().setX((getLastCreatedActor().getX() - (getLastCreatedActor().getWidth()/2)));
						getLastCreatedActor().setY((getLastCreatedActor().getY() - (getLastCreatedActor().getHeight()/2)));
					}
				}
				_EnemiesAlive = 0;
				for(actorInGroup in cast(getActorGroup(4), Group).list)
				{
					if(actorInGroup != null && !actorInGroup.dead && !actorInGroup.recycled){
						_EnemiesAlive = (_EnemiesAlive + 1);
					}
				}
				if((_EnemiesAlive > 0))
				{
					_RoomInProgress = true;
				}
			}
		}
		runLater(1000 * .25, function(timeTask:TimedTask):Void
		{
			if(_RoomInProgress)
			{
				_customEvent_RoomStart();
			}
			else
			{
				_customEvent_RoomClear();
			}
		}, null);
		if(((Engine.engine.getGameAttribute("RoomNumber") : Float) < 20))
		{
			createRecycledActor(getActorType(46), 338, 1, Script.BACK);
		}
		if(((((Engine.engine.getGameAttribute("RoomNumber") : Float) < 19) && (randomInt(0, 1) == 1)) || ((Engine.engine.getGameAttribute("RoomEntryNum") : Float) == 1)))
		{
			createRecycledActor(getActorType(48), 0, 224, Script.BACK);
		}
		if(((((Engine.engine.getGameAttribute("RoomNumber") : Float) < 19) && (randomInt(0, 1) == 1)) || ((Engine.engine.getGameAttribute("RoomEntryNum") : Float) == 2)))
		{
			createRecycledActor(getActorType(50), 747, 224, Script.BACK);
		}
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if(engine.isPaused())
				{
					if((_ItemCheckTimer < 30))
					{
						_ItemCheckTimer = (_ItemCheckTimer + 1);
					}
				}
				else
				{
					if((_ItemCheckTimer > 0))
					{
						_ItemCheckTimer = (_ItemCheckTimer - 1);
					}
				}
				if((_ItemCheckTimer >= 30))
				{
					_XMouseTile = Math.floor((getMouseX() / 50));
					_YMouseTile = Math.floor((getMouseY() / 50));
					if((!(_XMouseTile == _XMouseHighlight) || !(_YMouseTile == _YMouseHighlight)))
					{
						_XMouseHighlight = _XMouseTile;
						_YMouseHighlight = _YMouseTile;
						if((((16 * (_YMouseTile - 10)) + _XMouseTile) < (Engine.engine.getGameAttribute("Items") : Array<Dynamic>).length))
						{
							if((_YMouseTile >= 10))
							{
								_customEvent_DrawItemDesc();
							}
							else
							{
								if(_ActiveHighlight)
								{
									_customEvent_UndrawItemDesc();
								}
							}
						}
						else
						{
							if(_ActiveHighlight)
							{
								_customEvent_UndrawItemDesc();
							}
						}
					}
				}
			}
		});
		
		/* =========================== Keyboard =========================== */
		addKeyStateListener("p", function(pressed:Bool, released:Bool, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && pressed)
			{
				if(!(_Sacrificing))
				{
					if(engine.isPaused())
					{
						engine.unpause();
						_customEvent_UnDrawWounds();
						_customEvent_UndrawItemDesc();
					}
					else
					{
						engine.pause();
						_customEvent_DrawWounds();
					}
				}
			}
		});
		
		/* ========================= When Drawing ========================= */
		addWhenDrawingListener(null, function(g:G, x:Float, y:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if(engine.isPaused())
				{
					Script.setDrawingLayer(engine.getLayerById(3));
					g.fillColor = Utils.convertColor(Utils.getColorRGB(51,51,51));
					g.alpha = (50/100);
					g.fillRect(0, 0, getScreenWidth(), getScreenHeight());
				}
				g.setFont(getFont(43));
				g.drawString("" + (("Health-") + ((("" + Engine.engine.getGameAttribute("Health")) + ((("/") + ("" + Engine.engine.getGameAttribute("Max Health"))))))), 10, 8);
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}