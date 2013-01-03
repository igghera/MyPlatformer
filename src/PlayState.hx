package;

import nme.Assets;
import nme.geom.Rectangle;
import nme.net.SharedObject;
import org.flixel.FlxButton;
import org.flixel.FlxG;
import org.flixel.FlxPath;
import org.flixel.FlxSave;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.FlxText;
import org.flixel.FlxTilemap;
import org.flixel.FlxU;
import org.flixel.FlxObject;
import org.flixel.FlxPoint;
import org.flixel.FlxGroup;
import org.flixel.FlxText;
import org.flixel.FlxRect;
//import org.flixel.FlxMouse;

class PlayState extends FlxState
{
	private var map:FlxTilemap;
	private var player:FlxSprite;
	private var player_jumping:Bool;
	private var collectables_layer:FlxGroup;
	private var txtScore:FlxText;
	private var enemyGroup:FlxGroup;
	private var bg:FlxSprite;

	override public function create():Void
	{
		#if !neko
		FlxG.bgColor = 0xff131c1b;
		#else
		FlxG.bgColor = {rgb: 0x131c1b, a: 0xff};
		#end
		//FlxG.mouse.show();

		bg = new FlxSprite(0, 0, "assets/mountain.jpg");
		bg.scrollFactor = new FlxPoint(.6, .6);
		add(bg);
		//load up the map

		map = new FlxTilemap();
		map.loadMap(Assets.getText("assets/map.txt"), "assets/tiles.png");
		add(map);

		//add the player

		player = new FlxSprite();
		player.loadGraphic("assets/player.png", true, true, 25, 34);
		add(player);

		//customize the player

		player.x = 40;
		player.y = 70;
		player.acceleration.y = 100;
		player.drag.x = 100;
		player.addAnimation("default", [0,1], 3);
		player.addAnimation("jump", [2]);
		player.play("default");
		player_jumping = false;

		//setup collectables

		collectables_layer = new FlxGroup();
		add(collectables_layer);

		for (i in 0 ... 10)
		{
			var collectible:FlxSprite = new FlxSprite(Math.random() * map.width, Math.random() * map.height);
			collectible.loadGraphic("assets/collectible.png");
			collectables_layer.add(collectible);
		}

		//Setup enemy

		makeEnemies();

		//Creating the text to display the score

		txtScore = new FlxText(0, 0, 50);
		txtScore.text = Std.string(FlxG.score);
		txtScore.scrollFactor.x = 0;
		txtScore.scrollFactor.y = 0;
		add(txtScore);

		FlxG.camera.follow(player);
		FlxG.worldBounds = new FlxRect(0, 0, map.width, map.height);

		//setupListeners();
	}

	override public function destroy():Void
	{
		super.destroy();
	}

	override public function update():Void
	{
		super.update();
		FlxG.collide(map, player);

		FlxG.collide(map, enemyGroup);
		FlxG.overlap(player, enemyGroup, playerHitEnemy, null);

		//Going left

		if (FlxG.keys.LEFT) {
			player.velocity.x = -70;
			player.facing = FlxObject.LEFT;
		}

		//Going right

		if (FlxG.keys.RIGHT) {
			player.velocity.x = 70;
			player.facing = FlxObject.RIGHT;
		}

		//Jumping

		if (player_jumping && player.velocity.y == 0) {
			player_jumping = false;
			player.play('default');
		}

		if (player.velocity.y == 0 && FlxG.keys.UP && !player_jumping) {
			player.velocity.y -= 160;
			player.play('jump');
			player_jumping = true;
		}

		//Get collectibles

		FlxG.overlap(player, collectables_layer, playerHitCollectible);

		// if(FlxMouse.pressed())
		// 	trace("Pressed");
	}

	function playerHitCollectible(playerRef:FlxObject, collectibleRef:FlxObject):Void
	{
		collectables_layer.remove(collectibleRef);
		FlxG.score ++;
		txtScore.text = Std.string(FlxG.score);
	}

	private function makeEnemies():Void
	{
		//make the group for the enemies, add it to the game
		enemyGroup = new FlxGroup();
		add(enemyGroup);

		//make three enemies
		var enemy:Enemy = new Enemy();
		enemy.setTarget(player);
		enemy.x = 500;
		enemy.y = 100;
		enemyGroup.add(enemy);

		enemy = new Enemy();
		enemy.setTarget(player);
		enemy.x = 200;
		enemy.y = 500;
		enemyGroup.add(enemy);

		enemy = new Enemy();
		enemy.setTarget(player);
		enemy.x = 900;
		enemy.y = 300;
		enemyGroup.add(enemy);
	}

	function playerHitEnemy(playerRef:FlxObject, enemyRef:FlxObject):Void {
		playerRef.flicker();
		enemyGroup.remove(enemyRef);
	}
}