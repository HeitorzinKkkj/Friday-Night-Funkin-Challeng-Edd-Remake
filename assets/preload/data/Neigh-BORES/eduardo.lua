function onCreatePost()
	luaDebugMode = true;
	addHaxeLibrary("FlxRect", "flixel.math");
	runHaxeCode([[
		eduardo = new Character(-952, -36, 'eduardo');
		eduardo.scrollFactor.set(1, 1);
		eduardo.scale.set(1.025, 1.03);
		game.insert(game.members.indexOf(game.getLuaObject('jon')) + 1, eduardo);
		
		game.setOnLuas('eduardoR', eduardo.healthColorArray[0]);
		game.setOnLuas('eduardoG', eduardo.healthColorArray[1]);
		game.setOnLuas('eduardoB', eduardo.healthColorArray[2]);
	]]);
	for i = 0, getProperty('eventNotes.length') - 1 do
		if getPropertyFromGroup('eventNotes', i, 'event') == 'eduardoPunch' and getPropertyFromGroup('eventNotes', i, 'value1') == 'alt' then --toggle alt eduardo by changing the punch event's value1 to "alt"
			isAlt = true;
			setProperty('mark.y', 26.2);
			setProperty('jon.y', 31);
			scaleObject('mark', 0.89, 0.89, false);
			scaleObject('jon', 0.96, 0.99, false);
		end
	end
end
isAlt = false;

function onBeatHit()
	runHaxeCode([[
		if (eduardo.animation.curAnim != null && !eduardo.stunned && ]]..curBeat..[[ % eduardo.danceEveryNumBeats == 0 && !StringTools.startsWith(eduardo.animation.curAnim.name, 'sing'))
		{
			eduardo.dance();
		}
	]]);
end

function onUpdate()
	runHaxeCode([[
		if (game.startedCountdown && game.generatedMusic)
		{
			if (!eduardo.stunned && eduardo.holdTimer > Conductor.stepCrochet * 0.0011 * eduardo.singDuration && StringTools.startsWith(eduardo.animation.curAnim.name, 'sing'))
			{
				eduardo.dance();
			}
		}
	]]);
end

function opponentNoteHit(id, dir, nt, sus)
	if nt == 'eduardo' then
		runHaxeCode([[
			if (eduardo.animation.curAnim != null){
				if (eduardo.stunned) {
					eduardo.stunned = false;
				}
				eduardo.playAnim(game.singAnimations[]]..dir..[[], true);
				eduardo.holdTimer = 0;
			}
		]]);
	end
end

function onEvent(n, v1, v2)
	if n == 'eduardoWell' then
		runHaxeCode([[
			eduardo.playAnim('hey', true);
			eduardo.stunned = true;
		]]);
	end
	if n == 'eduardoPunch' then
		removeLuaSprite('jon', true);
		removeLuaSprite('mark', true);
		runHaxeCode([[
			var isALt = ]] .. tostring(isAlt) .. [[;
			eduardo.stunned = true;
			if (isALt) {
				eduardo.playAnim('punch-old', true);
			}else{
				eduardo.playAnim('punch', true);
			}
		]]);
	end
	if n == 'focusChar' then
		if v1:lower() == 'eduardo' then
		runHaxeCode([[
			game.camFollow.set(eduardo.getMidpoint().x, eduardo.getMidpoint().y);
			game.camFollow.x += eduardo.cameraPosition[0] + 89;
			game.camFollow.y += eduardo.cameraPosition[1] - 18.5;
			game.isCameraOnForcedPos = true;
		]]);
		end
	end
	if n == 'well1' then
		runHaxeCode([[
			game.camFollow.set(eduardo.getMidpoint().x, eduardo.getMidpoint().y);
			game.camFollow.x += eduardo.cameraPosition[0] + 89;
			game.camFollow.y += eduardo.cameraPosition[1] - 23;
			game.isCameraOnForcedPos = true;
		]]);
	end
	if n == 'panToEduardo' then
		triggerEvent('focusChar', 'eduardo', '');
		doTweenX('eduardoFocusX', 'camFollowPos', getProperty('camFollow.x'), 0.64, 'quartout');
		doTweenY('eduardoFocusY', 'camFollowPos', getProperty('camFollow.y'), 0.64, 'quartout');
	end
	if n == 'switchHBColors' then
		if v1:lower() == 'eduardo' then	
			runHaxeCode([[
			game.setOnLuas('bfR', game.boyfriend.healthColorArray[0]);
			game.setOnLuas('bfG', game.boyfriend.healthColorArray[1]);
			game.setOnLuas('bfB', game.boyfriend.healthColorArray[2]);
			]]);
			setHealthBarColors(RGBToHex(eduardoR, eduardoG, eduardoB), RGBToHex(bfR, bfG, bfB));
		end
	end
	if n == 'tweenMark' then
		doTweenX('markTween', 'mark', isAlt and -627.1 or -658, 0.1, 'quintin');
	end
	if n == 'tweenJon' then
		doTweenX('jonTween', 'jon', isAlt and -777 or -795, 0.05, 'quintin');
	end
end

function RGBToHex(red, green, blue)
    return string.format('%.2x%.2x%.2x', red, green, blue);
end