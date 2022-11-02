function onCreate() --originally created with Cherry's Stage Editor, converted back for convenience
	luaDebugMode = true;
	
	makeLuaSprite('sky', 'edd/sky', -946, -820);
	setScrollFactor('sky', 0.25, 0.2);
	scaleObject('sky', 1.125, 1.129, false);
	
	makeLuaSprite('clouds', 'edd/clouds', -1971, -356);
	setScrollFactor('clouds', 0.25, 0.2);
	scaleObject('clouds', 0.865, 0.89, false);
	
	makeLuaSprite('plane', 'edd/plane', -1470, -10);
	setScrollFactor('plane', 0.25, 0.2);
	scaleObject('plane', 0.9, 0.9, false);
	
	makeLuaSprite('houses', 'edd/houses', -1656, -46);
	setScrollFactor('houses', 0.725, 0.725);
	scaleObject('houses', 0.883, 0.89, false);
	
	makeLuaSprite('house', 'edd/house', -1770, -434);
	scaleObject('house', 0.915, 0.915, false);
	
	makeAnimatedLuaSprite('mark', 'edd/mark', -2000, -27.5);
	addAnimationByPrefix('mark', 'idle', 'MarkIdle', 24, false);
	scaleObject('mark', 0.785, 0.785, false);
	
	makeAnimatedLuaSprite('jon', 'edd/jon', -2000, -4);
	addAnimationByPrefix('jon', 'idle', 'JohnIdle', 24, false);
	scaleObject('jon', 0.89, 0.935, false);
	
	makeLuaSprite('fence', 'edd/fence', -1770, -434);
	scaleObject('fence', 0.915, 0.915, false);
	
	makeAnimatedLuaSprite('matt', 'edd/matt', 626, 145);
	addAnimationByPrefix('matt', 'walk', 'MattWalking', 24, true);
	addAnimationByPrefix('matt', 'idle', 'MattSnappingFinger', 24, false);
	addAnimationByPrefix('matt', 'idle-alt', 'MattPISSED', 24, false);
	addAnimationByPrefix('matt', 'eduardoReaction', 'MattReaction0', 24, false);
	addOffset('matt', 'walk', -100, 0);
	addOffset('matt', 'eduardoReaction', -64, 4);
	playAnim('matt', 'walk', true);
	setProperty('matt.alpha', 0.0001);
	scaleObject('matt', 1.61, 1.61, false);
	
	makeAnimatedLuaSprite('tom', 'edd/tom', 790, 221);
	addAnimationByPrefix('tom', 'walk', 'TomWalkingBy', 24, true);
	addAnimationByPrefix('tom', 'transition', 'TomTransition', 24, false);
	addAnimationByIndices('tom', 'idle', 'TomLooking', '0,1,2,3,4,5,6,7,8,9,10,11,12,13');
	addAnimationByIndices('tom', 'firstAlt', 'TomLooking', '14,15,16,17,18,19');
	addAnimationByIndices('tom', 'idle-alt', 'TomLooking', '20,21,22,23,24,25,26,27,28,29,30');
	addAnimationByIndices('tom', 'altBack', 'TomLooking', '19,18,17,16,15,14');
	addAnimationByPrefix('tom', 'eduardoReaction', 'TomReaction', 24, false);
	addOffset('tom', 'walk', 5, 10);
	addOffset('tom', 'transition', 5, 0);
	addOffset('tom', 'eduardoReaction', 0, 5);
	playAnim('tom', 'walk', true);
	setProperty('tom.alpha', 0.0001);
	setProperty('tom.flipX', true);
	scaleObject('tom', 1.65, 1.6, false);
	
	makeLuaSprite('car', 'edd/car', -1908, 554);
	setScrollFactor('car', 1.3, 1.3);
	scaleObject('car', 0.915, 0.915, false);

	addLuaSprite('sky', false);
	addLuaSprite('clouds', false);
	addLuaSprite('plane', false);
	addLuaSprite('houses', false);
	addLuaSprite('house', false);
	addLuaSprite('mark', false);
	addLuaSprite('jon', false);
	addLuaSprite('fence', false);
	addLuaSprite('tom', false);
	addLuaSprite('matt', false);
	addLuaSprite('car', true);
end

function onCreatePost()
	addCharacterToList('eduardo', 'dad');
	
	for i = 0, getProperty('eventNotes.length') - 1 do
		if getPropertyFromGroup('eventNotes', i, 'event') == 'tomAlt' then
			setPropertyFromGroup('eventNotes', i, 'strumTime', getPropertyFromGroup('eventNotes', i, 'strumTime') - stepCrochet- ((6/24) * 100));
		end
	end
end

function onSongStart()
	setProperty('clouds.velocity.x', 2);
	
	lerpPlane = true;
end

noIdleMatt = true;
idleMattAlt = false;

noIdleTom = true;
idleTomAlt = false;
function onBeatHit()
	if curBeat % 2 == 0 then
		if not noIdleTom and not idleTomAlt then
			playAnim('tom', 'idle', true);
		end
		if not noIdleMatt and not idleMattAlt then
			playAnim('matt', 'idle', true);
		elseif not noIdleMatt and idleMattAlt then
			playAnim('matt', 'idle-alt', true);
		end
		playAnim('mark', 'idle', true);
		playAnim('jon', 'idle', true);
	end
	if not noIdleTom and idleTomAlt and bump > 0 then
		if curBeat % 2 == 0 then
			bump = bump - 1;
			playAnim('tom', 'idle-alt', true);
		end
	elseif bump <= 0 and idleTomAlt then
		altBack();
	end
end

lerpPlane = false;
planeRemoved = false;
function onUpdate()
	if not planeRemoved and lerpPlane then
		setProperty('plane.x', math.lerp(-1470, 2199, (getSongPosition()/45000)));
	end
	if not planeRemoved and getProperty('plane.x') > (getProperty('houses.x') + getProperty('houses.width')) then
		removeLuaSprite('plane', true);
		planeRemoved = true;
		lerpPlane = false;
	end
end

function camFocusChar(chara)
	camdad = getProperty('dad.cameraPosition');
	if chara:lower() == 'edd' then
		triggerEvent('Camera Follow Pos', tostring((getMidpointX('dad') + 33) + camdad[2]), tostring((getMidpointY('dad') + 5) + camdad[1]));
	end
	if chara:lower() == 'default' then
		triggerEvent('Camera Follow Pos', '', '');
	end
end
bump = 0;
function onEvent(n, v1)
	if n == 'mattOut' then
		setProperty('matt.alpha', 1);
		doTweenX('mattWalk', 'matt', -85, 1.93);
		playAnim('matt', 'walk', true);
	end
	if n == 'tomOut' then
		setProperty('tom.alpha', 1);
		doTweenX('tomWalk', 'tom', 1431, (2.58 - (5/24)));
		playAnim('tom', 'walk', true);
	end
	if n == 'tomAlt' then
		if not noIdleTom then
			if v1 == '' then
				v1 = getRandomInt(0, 5);
			end
			bump = tonumber(v1);
			noIdleTom = true;
			playAnim('tom', 'firstAlt', true);
			runTimer('firstAlt', 6/24);
		end
	end
	if n == 'eduardoReaction' then
		noIdleMatt = true;
		noIdleTom = true;
		playAnim('tom', 'eduardoReaction', true);
		playAnim('matt', 'eduardoReaction', true);
	end
	if n == 'charsReturn' then
		noIdleMatt = false;
		noIdleTom = false;
		idleMattAlt = true;
		playAnim('tom', 'idle', true);
		playAnim('matt', 'idle-alt', true);
	end
	if n == 'focusChar' then
		camFocusChar(v1);
	end
end

function onTimerCompleted(t)
	if t == 'trans' then
		playAnim('tom', 'idle', true);
		noIdleTom = false;
	end
	if t == 'firstAlt' then
		if bump > 0 then
			bump = bump - 1;
			playAnim('tom', 'idle-alt', true);
			noIdleTom = false;
			idleTomAlt = true;
		else
			altBack();
		end
	end
	if t == 'altBack' then
		noIdleTom = false;
		playAnim('tom', 'idle', false);
	end
end

function onTweenCompleted(t)
	if t == 'mattWalk' then
		playAnim('matt', 'idle', true);
		noIdleMatt = false;
	end
	if t == 'tomWalk' then
		setProperty('tom.flipX', false);
		playAnim('tom', 'transition', true);
		runTimer('trans', 5/24);
	end
end

function onGameOver()
	setProperty('camGame.zoom', 0.715);
	setProperty('defaultCamZoom', 0.715);
	return function_continue;
end

function altBack()
	noIdleTom = true;
	idleTomAlt = false;
	playAnim('tom', 'altBack', true);
	runTimer('altBack', 6/24);
end

function math.lerp(a, b, t)
    return (b - a) * t + a;
end
