function onCreatePost()
	scaleObject('dad', 1.025, 1.025, false);
end

animStuns = {
	['turn'] = true,
	['lookDown'] = true,
	['lookUp'] = true,
	['lookTord'] = true,
	['lookTom'] = true
}

function onUpdatePost()
	if animStuns[tostring(getProperty('dad.animation.curAnim.name'))] then
		setProperty('dad.heyTimer', 1000);
		setProperty('dad.stunned', true);
	end
end

function goodNoteHit(id, dir, nt)
	if nt == 'eddAltBF' then
		setProperty('dad.stunned', false);
		setProperty('dad.heyTimer', 0);
	end
	if nt == 'eddSlideBF' then
		setProperty('dad.stunned', false);
		setProperty('dad.heyTimer', 0);
	end
end

function opponentNoteHit(id, dir, nt)
	if nt == '' then
		setProperty('dad.stunned', false);
		setProperty('dad.heyTimer', 0);
	end
end
