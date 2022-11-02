function onUpdatePost()
	if keyJustPressed('space') then
		tordHa()
	end
end

function onEvent(n)
	if n == 'dadHey' then
		tordHa()
	end
end

function tordHa()
	stopSound('haha');
	cancelTimer('hey1');
	setProperty('dad.heyTimer', 0.6);
	playAnim('dad', 'hey1', true);
	setProperty('dad.specialAnim', true);
	runTimer('hey1', 0.11);
	playSound('HAHAtord', 1, 'haha');
end

function onTimerCompleted(t)
	if t == 'hey1' then
		playAnim('dad', 'hey2', true);
		setProperty('dad.specialAnim', true);
	end
end
