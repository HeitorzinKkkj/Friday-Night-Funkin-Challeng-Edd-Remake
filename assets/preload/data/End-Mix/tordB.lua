function onCreatePost()
	luaDebugMode = true;
	runHaxeCode([[
		tord = new Character(-54, 1665, 'tordB');
		tord.scrollFactor.set(1, 1);
		tord.draw();
		game.addBehindDad(tord);
	]]);
end

function onBeatHit()
	runHaxeCode([[
		if (]] .. curBeat .. [[ % tord.danceEveryNumBeats == 0 && tord.animation.curAnim != null && !StringTools.startsWith(tord.animation.curAnim.name, 'sing') && !tord.stunned)
		{
			tord.dance();
		}
	]]);
end

function onUpdate(elapsed)
	runHaxeCode([[
		if (game.startedCountdown && game.generatedMusic)
		{
			if (!tord.stunned && tord.holdTimer > Conductor.stepCrochet * 0.0011 * tord.singDuration && StringTools.startsWith(tord.animation.curAnim.name, 'sing'))
			{
				tord.dance();
			}
		}
	]]);
end

function opponentNoteHit(id, dir, nt, sus)
	if nt == 'tord' then
		runHaxeCode([[
			if (!tord.stunned) {
				tord.playAnim(game.singAnimations[]] .. dir .. [[], true);
				tord.holdTimer = 0;
			}
		]]);
	end
end

function onEvent(n, v1, v2)
	if n == 'tordHa' then --defo revise this code
		runHaxeCode([[
			tord.playAnim('hey', true);
			tord.stunned = true;
		]]);
	end
	if n == 'tordPlayAnim' then
		if v1 ~= 'buttonPress' then
		runHaxeCode([[
			tord.playAnim(']] .. v1 .. [[', true);
			tord.stunned = true;
		]]);
		else
			runHaxeCode([[
			tord.playAnim('buttonPress', true);
			tord.holdTimer = 0;
			tord.stunned = true;
		]]);
		runTimer('buttonTimer', 10/24);
		end
	end
	if n == 'tordIdle' then
		runHaxeCode([[
			tord.stunned = false;
			tord.dance();
		]]);
	end
	if n == 'switchHBColors' then
		if v1:lower() == 'tord' then
			runHaxeCode([[
				game.setOnLuas('tordR', tord.healthColorArray[0]);
				game.setOnLuas('tordG', tord.healthColorArray[1]);
				game.setOnLuas('tordB', tord.healthColorArray[2]);
		
				game.setOnLuas('bfR', game.boyfriend.healthColorArray[0]);
				game.setOnLuas('bfG', game.boyfriend.healthColorArray[1]);
				game.setOnLuas('bfB', game.boyfriend.healthColorArray[2]);
			]]);
			setHealthBarColors(RGBToHex(tordR, tordG, tordB), RGBToHex(bfR, bfG, bfB));
		end
	end
	if n == 'focusChar' then
		if v1:lower() == 'tord' then
		runHaxeCode([[
			game.camFollow.set(tord.getMidpoint().x, tord.getMidpoint().y);
			game.camFollow.x += tord.cameraPosition[0];
			game.camFollow.y += tord.cameraPosition[1];
			game.isCameraOnForcedPos = true;
		]]);
		end
	end
	if n == 'tordAlertColor' then
		runHaxeCode([[
			tord.color = 0xFFF9BFC5;
			FlxTween.color(tord, 0.48, 0xFFF9BFC5, 0xFFFFFFFF, {type: FlxTween.PINGPONG, ease: FlxEase.cubeinout});
			
			game.getLuaObject('tordBG', false).color = 0xFFF9BFC5;
			FlxTween.color(game.getLuaObject('tordBG', false), 0.48, 0xFFF9BFC5, 0xFFFFFFFF, {type: FlxTween.PINGPONG, ease: FlxEase.cubeinout});
		]]);
	end
end

function onTimerCompleted(t)
	if t == 'buttonTimer' then
		runHaxeCode([[
			tord.stunned = false;
		]]);
	end
end

function RGBToHex(red, green, blue)
    return string.format('%.2x%.2x%.2x', red, green, blue);
end