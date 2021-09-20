% PROJECT NAME: Tanks
% WRITTEN BY: Isaac Giles
% DATE: 20/02/2019
% FILE NAME: Tanks_Game
% TEACHER: Mr. Bonisteel
% DESCRIPTION: description later lol.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% LINKED FILE(s)
include "BackEnd.t"

% VARIABLES
var chars : array char of boolean % array of all characters
var charMovementX : string := "NONE"
var charMovementY : string := "NONE"

% SCREEN SETUP
View.Set ("offscreenonly, nobuttonbar, graphics:max;max")



% MAIN CODE

% setup stuff
SpawnCharacter (false)

loop

    Input.KeyDown (chars)

    DrawGrid ()
    PlaceFood ()
    ResetVariables ()

    if CharSpawned then
	
	if not Character (Char).dead then
	    % Tell Character To Shoot If User is Clicking
	    Character (Char).Shoot ()
	end if
	
	% Display The Character
	SpawnCharacter (true)
	% Move The Enemies
	MoveEnemies ()
	
	% Move Character Based On Key Selection
	GlobalBulletDisplacementX := "none"
	GlobalBulletDisplacementY := "none"
	EnemyDisplacementX := 0
	EnemyDisplacementY := 0
	if not Character (Char).dead then
	    
	    % X Movement
	    if chars ('a') and not chars ('d') then
		charMovementX := "LEFT"
	    elsif chars ('d') and not chars ('a') then
		charMovementX := "RIGHT"
	    else
		charMovementX := "NONE"
	    end if
	    % Y Movement
	    if chars ('w') and not chars ('s') then
		charMovementY := "UP"
	    elsif chars ('s') and not chars ('w') then
		charMovementY := "DOWN"
	    else
		charMovementY := "NONE"
	    end if
	    % Finalize Movement
	    if not charMovementX = "NONE" or not charMovementY = "NONE" then
		Character (Char).MoveChar (charMovementX, charMovementY)
	    end if
	    % Apply Rotation To Character
	    RotateCharacter ()
	    
	elsif not Character(Char).deathEffect then % Ready To Respawn
	    
	end if
    
    else
	
	StartMenu(sMenu).ControlMenu()
	HardReset ()
	
    end if

    delay (25)
    View.Update % Update The Display
    cls % Clear The Display

end loop



