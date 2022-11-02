function onCreate() --originally created with Cherry's Stage Editor, converted back for convenience
	luaDebugMode = true;
	
	makeLuaSprite('sky', 'edd/sky', -946, -820);
	setScrollFactor('sky', 0.25, 0.2);
	scaleObject('sky', 1.125, 1.129, false);
	
	makeLuaSprite('clouds', 'edd/clouds', -1971, -356);
	setScrollFactor('clouds', 0.25, 0.2);
	scaleObject('clouds', 0.865, 0.89, false);
	
	makeLuaSprite('plane', 'edd/plane', -1470, -20);
	setScrollFactor('plane', 0.25, 0.2);
	scaleObject('plane', 0.9, 0.9, false);
	
	makeLuaSprite('houses', 'edd/houses', -1656, -46);
	setScrollFactor('houses', 0.725, 0.725);
	scaleObject('houses', 0.883, 0.89, false);
	
	makeLuaSprite('house', 'edd/house', -1770, -434);
	scaleObject('house', 0.915, 0.915, false);
	
	makeLuaSprite('fence', 'edd/fence', -1770, -434);
	scaleObject('fence', 0.915, 0.915, false);
	
	makeAnimatedLuaSprite('matt', 'edd/matt', 613, 145);
	addAnimationByPrefix('matt', 'walk', 'MattWalking', 24, true);
	addAnimationByPrefix('matt', 'idle', 'MattSnappingFinger', 24, false);
	addAnimationByPrefix('matt', 'tordReaction', 'MattReactionTord', 24, false);
	addAnimationByIndices('matt', 'lookTord', 'MattHarpoonBit', '0,1,2,3,4,5,6,7');
	addAnimationByIndices('matt', 'lookDown', 'MattHarpoonBit', '8,9,10,11,12,13,14,15,16,17,18');
	addOffset('matt', 'walk', -113, 0);
	addOffset('matt', 'tordReaction', -70, 2);
	addOffset('matt', 'lookTord', -72, -23);
	addOffset('matt', 'lookDown', -72, -23);
	playAnim('matt', 'walk', true);
	setProperty('matt.alpha', 0.0001);
	scaleObject('matt', 1.61, 1.61, false);
	
	makeAnimatedLuaSprite('tom', 'edd/tom', 790, 221);
	setProperty('tom.alpha', 0.0001);
	
	makeAnimatedLuaSprite('tom', 'edd/tom', 790, 221);
	setProperty('tom.alpha', 0.0001);
	scaleObject('tom', 1.65, 1.6, false);
	
	makeLuaSprite('car', 'edd/car', -1908, 554);
	setScrollFactor('car', 1.3, 1.3);
	scaleObject('car', 0.915, 0.915, false);
	
	makeLuaSprite('tordBG', 'edd/tordbg', -297, 1345);
	scaleObject('tordBG', 1.01, 1, false);
	
	makeLuaSprite('botFace', 'edd/CockPitUpClose', -60, 1600);
	scaleObject('botFace', 1.4, 1.4, false);
	
	addLuaSprite('sky', false);
	addLuaSprite('clouds', false);
	addLuaSprite('plane', false);
	addLuaSprite('houses', false);
	addLuaSprite('tordBG', false);
	addLuaSprite('botFace', true);
	addLuaSprite('house', false);
	addLuaSprite('fence', false);
	addLuaSprite('matt', false);
	addLuaSprite('tom', true);
	addLuaSprite('car', true);
end

function onCreatePost()
	addCharacterToList('tordB', 'dad');
	addCharacterToList('bf-slide', 'boyfriend');
end

function onSongStart()
	setProperty('clouds.velocity.x', 2);
	
	lerpPlane = true;
end

noIdleMatt = true;
idleMattAlt = false;

function onBeatHit()
	if curBeat % 2 == 0 then
		if not noIdleMatt and not idleMattAlt then
			playAnim('matt', 'idle', true);
		end
	end
	if ntSlide then
		if not canTweenBF and bfSlideTimer <= 0 then
			canTweenBF = true;
			doTweenX('outBX', 'boyfriend', 1440, 0.45, 'expoin');
			doTweenY('outBY', 'boyfriend', 2380, 0.45, 'expoin');
		end
		if not canTweenDad and dadSlideTimer <= 0 then
			canTweenDad = true;
			doTweenX('outDX', 'dad', -675, 0.45, 'expoin');
			doTweenY('outDY', 'dad', 2400, 0.45, 'expoin');
		end
	end
end

bfSlideTimer = 0;
dadSlideTimer = 0;

lerpPlane = false;
planeRemoved = false;
function onUpdate(el)
	if not planeRemoved and lerpPlane then
		setProperty('plane.x', math.lerp(-1470, 2199, (getSongPosition()/45000)));
	end
	if not planeRemoved and getProperty('plane.x') > (getProperty('houses.x') + getProperty('houses.width')) then
		removeLuaSprite('plane', true);
		planeRemoved = true;
		lerpPlane = false;
	end
	if bfSlideTimer > 0 then
		bfSlideTimer = bfSlideTimer - el;
	end
	if dadSlideTimer > 0 then
		dadSlideTimer = dadSlideTimer - el;
	end
end

ntSlide = false;
function onEvent(n, v1)
	if n == 'mattOut' then
		setProperty('matt.alpha', 1);
		doTweenX('mattWalk', 'matt', -85, 1.93);
		playAnim('matt', 'walk', true);
	end
	if n == 'mattTord' then
		playAnim('matt', 'tordReaction', true);
		noIdleMatt = true;
	end
	if n == 'eddBFTordbot' then
		triggerEvent('Change Character', 'boyfriend', 'bf-slide');
		
		setProperty('dad.skipDance', true);
		setProperty('boyfriend.skipDance', true);
		
		playAnim('dad', 'singDOWN-alt-alt', true);
		
		setProperty('dad.alpha', 1);
		setProperty('boyfriend.alpha', 1);
		
		setCharacterX('dad', -675);
		setCharacterY('dad', 2400);
		
		setCharacterX('boyfriend', 1440);
		setCharacterY('boyfriend', 2380);
		ntSlide = true;
	end
	if n == 'setupEnding' then
		noIdleMatt = true;
	end
end

function onTweenCompleted(t)
	if t == 'mattWalk' then
		playAnim('matt', 'idle', true);
		noIdleMatt = false;
	end
end

canTweenBF = true;
canTweenDad = true;
function goodNoteHit(id, dir, nt, sus)
	if nt == '' and ntSlide then
		if not sus then
			bfSlideTimer = 0.2;
			if canTweenBF then
				cancelTween('outBX');
				cancelTween('outBY');
				canTweenBF = false;
				doTweenX('inBX', 'boyfriend', 840, 0.3, 'expoout');
				doTweenY('inBY', 'boyfriend', 1980, 0.3, 'expoout');
			end
		end
	end
	if nt == 'eddSlideBF' then
		if not sus then
			dadSlideTimer = 0.2;
			if canTweenDad then
				cancelTween('outDX');
				cancelTween('outDY');
				canTweenDad = false;
				doTweenX('inDX', 'dad', -75, 0.3, 'expoout');
				doTweenY('inDY', 'dad', 2128, 0.3, 'expoout');
			end
		end
	end
end

function onGameOver()
	setProperty('camGame.zoom', 0.715);
	setProperty('defaultCamZoom', 0.715);
	
	if ntSlide then
		setProperty('camGame.scroll.x', 811.5);
		setProperty('camGame.scroll.y', 1403);
	end
	return function_continue;
end

function math.lerp(a, b, t)
    return (b - a) * t + a;
end
