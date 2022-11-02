function onCreatePost()
	luaDebugMode = true;
	addHaxeLibrary('FlxMath', 'flixel.math');
	addHaxeLibrary('HealthIcon');
	runHaxeCode([[
		iconP3 = new HealthIcon('edd', true);
		iconP3.x = game.healthBar.x + 20;
		iconP3.y = game.healthBar.y - 75;
		iconP3.visible = false;
		game.add(iconP3);
		game.remove(iconP3, true);
		game.insert(game.members.indexOf(game.iconP1) + 1, iconP3);
		iconP3.cameras = [game.camHUD];
	]]);
end

canFunc = true;
curBound = 'dad';
function onUpdatePost(e)
	runHaxeCode([[
		var canFunc = ]] .. tostring(canFunc) .. [[;
		var curBound = ']] .. curBound .. [[';
		var elapsed = ]] .. e .. [[;
		var iconOffset = 26;
		
		var mult = FlxMath.lerp(1, iconP3.scale.x, FlxMath.bound(1 - (elapsed * 9), 0, 1));
		iconP3.scale.set(mult, mult);
		
		if (canFunc && curBound == 'dad'){
			iconP3.flipX = true;
			iconP3.x = game.healthBar.x + (game.healthBar.width * (FlxMath.remapToRange(game.healthBar.percent, 0, 100, 100, 0) * 0.01)) - (150 * iconP3.scale.x) / 2 - iconOffset * 2;
			if (game.healthBar.percent > 80)
				iconP3.animation.curAnim.curFrame = 1;
			else
				iconP3.animation.curAnim.curFrame = 0;
		}
		if(canFunc && curBound == 'bf'){
			iconP3.flipX = false;
			iconP3.x = game.healthBar.x + ((game.healthBar.width * (FlxMath.remapToRange(game.healthBar.percent, 0, 100, 100, 0) * 0.01)) + (150 * iconP3.scale.x - 150) / 2 - iconOffset) + 85;
			if (game.healthBar.percent < 20)
				iconP3.animation.curAnim.curFrame = 1;
			else
				iconP3.animation.curAnim.curFrame = 0;
		}
	]]);
end

function onBeatHit()
	runHaxeCode([[
		var canFunc = ]] .. tostring(canFunc) .. [[;
		if (canFunc){
			iconP3.scale.set(1.2, 1.2);
			iconP3.updateHitbox();
		}
	]]);
end

function onEvent(n)
	if n == 'eddIconSwitch' then
		canFunc = false;
		runHaxeCode([[
			iconP3.visible = game.iconP1.visible;
			var isDown = ]] .. tostring(downscroll) .. [[;
			
			if (isDown){
				FlxTween.tween(iconP3, {x: game.iconP1.x + 85, y: game.iconP1.y + 58}, 0.3, {
					ease: FlxEase.cubeOut
				});
			}else{
				FlxTween.tween(iconP3, {x: game.iconP1.x + 85, y: game.iconP1.y - 50}, 0.3, {
					ease: FlxEase.cubeOut
				});
			}
		]]);
		runTimer('flipTimer', 0.15);
	end
end

function onTimerCompleted(t)
	if t == 'flipTimer' then
		runHaxeCode([[
			iconP3.flipX = false;
			if (game.healthBar.percent < 20)
				iconP3.animation.curAnim.curFrame = 1;
			else
				iconP3.animation.curAnim.curFrame = 0;
		]]);
		runTimer('finishTimer', 0.15);
		curBound = 'bf';
	end
	if t == 'finishTimer' then
		canFunc = true;
	end
end
