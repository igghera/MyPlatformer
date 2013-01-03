package;

import nme.Assets;
import nme.geom.Rectangle;
import nme.net.SharedObject;
import org.flixel.FlxButton;
import org.flixel.FlxGroup;
import org.flixel.FlxObject;
import org.flixel.FlxG;
import org.flixel.FlxPath;
import org.flixel.FlxSave;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.FlxText;
import org.flixel.FlxTilemap;
import org.flixel.FlxU;
import org.flixel.FlxSound;

class PlayState extends FlxState
{
    private var map:FlxTilemap;
    private var player:FlxSprite;
    private var player_jumping:Bool;
    private var collectables_layer:FlxGroup;
    private var txtScore:FlxText;

    private var bgMusic:FlxSound;
    private var getSFX:FlxSound;

    override public function create():Void
    {
        #if !neko
        FlxG.bgColor = 0xff131c1b;
        #else
        FlxG.bgColor = {rgb: 0x131c1b, a: 0xff};
        #end
        //FlxG.mouse.show();

        //load up the map
        map = new FlxTilemap();
        map.loadMap(Assets.getText("assets/map.txt"), "assets/tiles.png");
        add(map);

        //add the player
        player = new Player();
        add(player);

        //setup collectables
        collectables_layer = new FlxGroup();
        add(collectables_layer);

        for (i in 1 ... 10) {
            var collectible:FlxSprite = new FlxSprite(Math.random() * map.width, Math.random() * map.height);
            collectible.loadGraphic("assets/collectible.png");
            collectables_layer.add(collectible);
        }

        //add score text
        txtScore = new FlxText(0, 0, 50);
        txtScore.text = Std.string(FlxG.score);
        add(txtScore);

        FlxG.playMusic("assets/Sycamore_Drive_-_01_-_Kicks.mp3");
    }

    override public function destroy():Void
    {
        super.destroy();
    }

    override public function update():Void
    {
        super.update();
        FlxG.collide(map, player);
        FlxG.overlap(player, collectables_layer, playerHitCollectible, null);
    }

    function playerHitCollectible(playerRef:FlxObject, collectibleRef:FlxObject):Void {
        collectables_layer.remove(collectibleRef);
        FlxG.score ++;
        txtScore.text = Std.string( FlxG.score );
        FlxG.play("assets/get.wav");
    }
}