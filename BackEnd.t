% PROJECT NAME: Tanks
% WRITTEN BY: Isaac Giles
% DATE: 20/02/2019
% FILE NAME: Back_End
% TEACHER: Mr. Bonisteel
% DESCRIPTION: This holds all of the back end classes, functions and procedures
%              for the main game.


% LINKED FILE(s)
include "Tanks_Variables.t"


% Declaring Functions and Procedures in Advance
forward function CheckSquareCollision (X1, Y1, R1, X2, Y2, R2, offset : int) : boolean
forward function EnemyValues (EnemyIndex : int, EnemyValue : string) : int

forward procedure DrawGrid ()
forward procedure PlaceFood ()
forward procedure SpawnCharacter (display : boolean)
forward procedure RotateCharacter ()
forward procedure MoveEnemies ()
forward procedure EnemyCollision (BulletIndex : int)
forward procedure CharCollision (BulletIndex, EnemyIndex : int)
forward procedure DisplayHealthBar (xPos : int, yPos : int, health : int, maxHealth : int, offset : int)
forward procedure RespawnItem (itemType : string, itemIndex : int)
forward procedure AwardExp (expAmount : int)
forward procedure ResetVariables ()
forward procedure ResetEnemiesAndFood ()
forward procedure HardReset ()



%%%%%%%%%%%%%  CLASSES  %%%%%%%%%%%%%

class StartMenu % A Class For The Start Menu

    % Procedures, Functions and Variables To Import/Export
    import GameLogo, BeginButton, CreditsButton,
	Mouse, MouseX, MouseY, MouseButton,
	CharSpawned, GameScore,
	FirstPlay, ResetEnemiesAndFood
    export ControlMenu

    % Variables
    var SetUpRequired : boolean := true

    var GameLogoX : int
    var GameLogoY : int

    var BeginX : int
    var BeginY : int
    var HoverBegin : boolean := false

    var CreditsX : int
    var CreditsY : int
    var HoverCredits : boolean := false

    % Initializing Variables
    forward proc CheckBegin ()
    forward proc CheckCredits ()


    % Procedure For OverSeeing The Menu
    proc ControlMenu ()

	if SetUpRequired then
	    
	    % SetUp Variables
	    GameLogoX := (maxx div 2) - (Pic.Width (GameLogo) div 2)
	    GameLogoY := (maxy div 2 + 150) - (Pic.Height (GameLogo) div 2)

	    BeginX := (maxx div 2) - (Pic.Width (BeginButton) div 2)
	    BeginY := (maxy div 2) - (Pic.Height (BeginButton) div 2)

	    CreditsX := (maxx div 2) - (Pic.Width (CreditsButton) div 2)
	    CreditsY := (maxy div 2) - 125 - (Pic.Height (CreditsButton) div 2)
	    
	end if
	
	% Display Game Logo
	Pic.Draw (GameLogo, GameLogoX, GameLogoY, picMerge)

	% Call Button Procedures
	CheckBegin ()
	CheckCredits ()

    end ControlMenu

    % Procedure For The 'Begin' Button
    body proc CheckBegin ()

	% Get The Mouse Position
	Mouse.Where (MouseX, MouseY, MouseButton)

	if abs (MouseX - (BeginX + (Pic.Width (BeginButton) div 2))) <= 100 and abs (MouseY - (BeginY + (Pic.Height (BeginButton) div 2))) <= 40 then
	    
	    % hovering
	    HoverBegin := true
	    
	    % Check For Click
	    if MouseButton = 1 then
		if not FirstPlay then
		    ResetEnemiesAndFood ()
		end if
		FirstPlay := false
		GameScore := 0
		CharSpawned := true
	    end if
	    
	else
	    HoverBegin := false
	end if

	% Display Button
	if HoverBegin then
	    var scaledPic := Pic.Scale (BeginButton, Pic.Width (BeginButton) div 0.8, Pic.Height (BeginButton) div 0.8)
	    Pic.Draw (scaledPic, BeginX - 20, BeginY - 7, picMerge)
	    Pic.Free (scaledPic)
	else
	    Pic.Draw (BeginButton, BeginX, BeginY, picMerge)
	end if

    end CheckBegin

    % Procedure For The 'Crdits' Button
    body proc CheckCredits ()

	% Get The Mouse Position
	Mouse.Where (MouseX, MouseY, MouseButton)

	if abs (MouseX - (CreditsX + (Pic.Width (CreditsButton) div 2))) <= 100 and abs (MouseY - (CreditsY + (Pic.Height (CreditsButton) div 2))) <= 40 then
	    
	    % hovering
	    HoverCredits := true
	    
	    % Check For Click
	    if MouseButton = 1 then
		% credits lol..
	    end if
	    
	else
	    HoverCredits := false
	end if

	% Display Button
	if HoverCredits then
	    var scaledPic := Pic.Scale (CreditsButton, Pic.Width (CreditsButton) div 0.8, Pic.Height (CreditsButton) div 0.8)
	    Pic.Draw (scaledPic, CreditsX - 20, CreditsY - 7, picMerge)
	    Pic.Free (scaledPic)
	else
	    Pic.Draw (CreditsButton, CreditsX, CreditsY, picMerge)
	end if

    end CheckCredits

end StartMenu
var sMenu : pointer to StartMenu
new StartMenu, sMenu




class Bullet % A Bullet Class

    % Procedures, Functions and Variables To Import/Export
    import CharProjectileImg, EnemyProjectileImg, BulletRange, BulletSpeed, SplitBulletSpeed,
	GlobalBulletDisplacementX, GlobalBulletDisplacementY,
	CharPosX, CharPosY, SpeedValues, CharLvl, DmgAmounts,
	CheckSquareCollision, FoodPositionsX, FoodPositionsY, ProjectileRadius,
	FoodRadius, EnemyRadius, CharRadius, EnemyBaseValue,
	FoodHealth, RespawnItem, FoodLevels, FoodValues, AwardExp,
	EnemyCollision, CharCollision, EnemyValues
    export Fire, SetUpBullet, ExtraSetUp, Xpos, Ypos, finish, finished

    % Bullet Variables
    var BulletType : string
    var BulletIndex : int
    var EnemyIndex : int % only used if bullet belongs to an enemy
    var Xpos : int := CharPosX - 20
    var Ypos : int := CharPosY - 20
    var Xspeed, Yspeed : int := 0

    var Xdist, Ydist, Dist : int
    var DistTravelled : int := 0

    var BulletDisplacementX : int := 0
    var BulletDisplacementY : int := 0

    var TargetSet : boolean := false
    var TargetX, TargetY : int

    var error : boolean := false
    var finished : boolean := false


    % Procedure To Set The Start Position And Type of The Bullet
    proc SetUpBullet (StartX, StartY, bIndex : int, bulletType : string)
	Xpos := StartX
	Ypos := StartY
	BulletIndex := bIndex
	BulletType := bulletType
    end SetUpBullet

    % Procedure For Any Extra SetUp That May Be Required
    proc ExtraSetUp (eIndex : int)
	EnemyIndex := eIndex
    end ExtraSetUp

    % Shooting Procedure
    proc Fire (MouseX, MouseY : int)

	if not TargetSet then

	    TargetX := MouseX
	    TargetY := MouseY
	    TargetSet := true

	    Xdist := MouseX - Xpos
	    Ydist := MouseY - Ypos
	    Dist := abs (Xdist) + abs (Ydist)

	    if Dist ~= 0 then % Cannot Divide by Zero
		Xspeed := (Xdist * BulletSpeed div Dist)
		Yspeed := (Ydist * BulletSpeed div Dist)
	    else
		error := true
		finished := true
	    end if

	else

	    Xspeed := (Xdist * BulletSpeed div Dist)
	    Yspeed := (Ydist * BulletSpeed div Dist)

	    if DistTravelled >= BulletRange then
		finished := true
	    end if

	end if

	if not error then

	    Xpos := Xpos + Xspeed
	    Ypos := Ypos + Yspeed

	    if GlobalBulletDisplacementX ~= "none" then
		if GlobalBulletDisplacementX = "LEFT" then
		    BulletDisplacementX := (SpeedValues (CharLvl) div SplitBulletSpeed)
		    Xpos := Xpos - BulletDisplacementX
		end if
		if GlobalBulletDisplacementX = "RIGHT" then
		    BulletDisplacementX := (SpeedValues (CharLvl) div SplitBulletSpeed)
		    Xpos := Xpos + BulletDisplacementX
		end if
	    end if
	    if GlobalBulletDisplacementY ~= "none" then
		if GlobalBulletDisplacementY = "UP" then
		    BulletDisplacementY := (SpeedValues (CharLvl) div SplitBulletSpeed)
		    Ypos := Ypos + BulletDisplacementY
		end if
		if GlobalBulletDisplacementY = "DOWN" then
		    BulletDisplacementY := (SpeedValues (CharLvl) div SplitBulletSpeed)
		    Ypos := Ypos - BulletDisplacementY
		end if
	    end if

	    % Check For Collisions With Food
	    for i : lower (FoodPositionsX) .. upper (FoodPositionsX)
		var Collision := CheckSquareCollision (Xpos, Ypos, ProjectileRadius, FoodPositionsX (i), FoodPositionsY (i), FoodRadius, 0)
		if Collision then
		    if BulletType = "character" then
			FoodHealth (i) := FoodHealth (i) - DmgAmounts (CharLvl)
		    else
			FoodHealth (i) := FoodHealth (i) - DmgAmounts (EnemyValues (EnemyIndex, "level"))
		    end if
		    if FoodHealth (i) <= 0 then
			if BulletType = "character" then
			    AwardExp (FoodValues (FoodLevels (i)))
			end if
			RespawnItem ("food", i)
		    end if
		    finished := true
		    exit
		end if
	    end for

	    % Check For Collisions With Enemies (if this is a character bullet)
	    if BulletType = "character" then

		% Check For Collisions With Enemies
		EnemyCollision (BulletIndex)
		% Draw The Bullet
		Pic.Draw (CharProjectileImg, Xpos, Ypos, picMerge)

	    else % Check For Collisions With Character (if this is an enemy bullet)

		% Check For Collisions With Character
		CharCollision (BulletIndex, EnemyIndex)
		% Draw The Bullet
		Pic.Draw (EnemyProjectileImg, Xpos, Ypos, picMerge)

	    end if

	    DistTravelled := DistTravelled + abs (Xspeed + Yspeed)

	end if

    end Fire


    % Procedure For Setting Finished To True
    proc finish ()
	finished := true
    end finish

end Bullet
var CharacterProjectiles : flexible array 1 .. 100 of pointer to Bullet
for i : lower (CharacterProjectiles) .. upper (CharacterProjectiles)
    CharacterProjectiles (i) := nil
end for
var EnemyProjectiles : flexible array 1 .. 100 of pointer to Bullet
for i : lower (EnemyProjectiles) .. upper (EnemyProjectiles)
    EnemyProjectiles (i) := nil
end for




class DeathParticle % A Class For The Particles In The Death Effect

    % Procedures and Variables To Import/Export
    import TimeRunning
    export initializeParticle, updateParticle, active

    % Variables
    var xLoc, yLoc : int
    var xDir, yDir : real
    var particleSize : int
    var particleSpeed : int := 20

    var particleStart : int
    var particleLifeTime : int := 1100

    var active : boolean := false


    % Procedure To Initialize The Particle
    proc initializeParticle (x : int, y : int, xD : real, yD : real)

	xLoc := x
	yLoc := y

	var reverseX, reverseY : real
	rand (reverseX)
	rand (reverseY)
	if round (reverseX) = 0 then
	    xDir := xD * (-1)
	else
	    xDir := xD
	end if
	if round (reverseY) = 0 then
	    yDir := yD * (-1)
	else
	    yDir := yD
	end if

	randint (particleSize, 40, 50)

	particleStart := Time.Elapsed
	active := true

    end initializeParticle

    % Procedure To Change The Position And Then Display The Particle
    proc updateParticle ()

	TimeRunning := Time.Elapsed
	if (TimeRunning - particleStart) < particleLifeTime then
	    xLoc := (xLoc + round (xDir * particleSpeed))
	    yLoc := (yLoc + round (yDir * particleSpeed))
	    Draw.FillBox ((xLoc - (particleSize div 2)), (yLoc - (particleSize div 2)), (xLoc + (particleSize div 2)), (yLoc + (particleSize div 2)), darkgrey)
	else
	    active := false
	end if

    end updateParticle

end DeathParticle




class Character % A Character Class

    % Procedures and Variables To Import/Export
    import CharSpawned, CharSprites, SelectedSprite, CharLvl, GridDisplacementX, GridDisplacementY,
	FoodDisplacementX, FoodDisplacementY,
	EnemyDisplacementX, EnemyDisplacementY,
	SpeedValues, CharPosX, CharPosY, CharRotation, GameScore,
	Bullet, CharacterProjectiles, GlobalBulletDisplacementX, GlobalBulletDisplacementY,
	SplitBulletSpeed, Mouse, MouseX, MouseY, MouseButton,
	TimeRunning, ReloadTime,
	CharHealth, MaxHealths, DisplayHealthBar,
	DeathParticle
    export Spawn, MoveChar, Shoot, PlayDeathEffect, Revive, dead, deathEffect

    % Character Variables
    var LastRegen : int := TimeRunning
    var RegenTime : int := 2000
    var RegenAmount : int := 1
    var LastShot : int := TimeRunning
    var splitSpeed : int := 1

    var dead : boolean := false
    var deathEffect : boolean := false % true if death effect is playing
    var deathX, deathY : int
    var deathEffectStart : int := TimeRunning
    var deathDuration : int := 2000

    var DeathParticles : flexible array 1 .. 100 of pointer to DeathParticle
    for i : lower (DeathParticles) .. upper (DeathParticles)
	DeathParticles (i) := nil
    end for


    % Procedure For Toggling The Death Effect (MUST BE PLACED HERE, CANNOT BE A BODY PROCEDURE)
    proc PlayDeathEffect ()

	if not deathEffect then
	    deathX := CharPosX
	    deathY := CharPosY
	    deathEffectStart := Time.Elapsed
	    deathEffect := true
	    dead := true
	end if

	TimeRunning := Time.Elapsed
	if (TimeRunning - deathEffectStart) < deathDuration then

	    var slotFound : boolean := false
	    for i : lower (DeathParticles) .. upper (DeathParticles)

		if not slotFound then
		    if DeathParticles (i) = nil then

			var deathParticle : pointer to DeathParticle
			new DeathParticle, deathParticle % death particle
			DeathParticles (i) := deathParticle

			var particleDirX, particleDirY : real
			rand (particleDirX)
			particleDirY := (1 - particleDirX)

			% initialize the particle
			DeathParticle (deathParticle).initializeParticle (CharPosX, CharPosY, particleDirX, particleDirY)
			% display the particle
			DeathParticle (deathParticle).updateParticle ()

			slotFound := true
			exit

		    elsif DeathParticle (DeathParticles (i)).active = false then

			var particleDirX, particleDirY : real
			rand (particleDirX)
			particleDirY := (1 - particleDirX)

			% initialize the particle
			DeathParticle (DeathParticles (i)).initializeParticle (CharPosX, CharPosY, particleDirX, particleDirY)
			% display the particle
			DeathParticle (DeathParticles (i)).updateParticle ()

			slotFound := true

		    end if
		end if

		if DeathParticles (i) = nil then
		    exit
		elsif DeathParticle (DeathParticles (i)).active = true then
		    % display the particle
		    DeathParticle (DeathParticles (i)).updateParticle ()
		end if

	    end for

	else
	    deathEffect := false
	    CharSpawned := false
	end if

    end PlayDeathEffect

    % Procedure For Regenerating Character Health (MUST BE PLACED HERE, CANNOT BE A BODY PROCEDURE)
    proc RegenHealth ()
	TimeRunning := Time.Elapsed
	if (TimeRunning - LastRegen) >= RegenTime then
	    LastRegen := TimeRunning
	    CharHealth := CharHealth + RegenAmount
	    if CharHealth > MaxHealths (CharLvl) then
		CharHealth := MaxHealths (CharLvl)
	    end if
	end if
    end RegenHealth

    % Character Spawning Procedure
    proc Spawn ()

	if not dead then
	    CharPosX := maxx div 2
	    CharPosY := maxy div 2
	    var RotatedChar : int := Pic.Rotate (CharSprites (SelectedSprite), CharRotation, 50, 50)
	    Pic.Draw (RotatedChar, CharPosX - 50, CharPosY - 50, picMerge)
	    % drawline(maxx div 2, maxy div 2 + 5, maxx div 2, maxy div 2 - 5, black)
	    % drawline(maxx div 2 - 5, maxy div 2, maxx div 2 + 5, maxy div 2, black)
	    Pic.Free (RotatedChar)
	    % Print Score
	    var font := Font.New ("Comicsans:18:bold") 
	    Font.Draw (intstr(GameScore), 50, 30, font, black)
	end if

	% Show Death Effect if Player Just Died
	if deathEffect = true then
	    PlayDeathEffect ()
	elsif CharHealth < MaxHealths (CharLvl) and not dead then % Show Health Bar if Player is Injured
	    DisplayHealthBar (CharPosX, CharPosY, CharHealth, MaxHealths (CharLvl), 60)
	    RegenHealth ()
	end if

    end Spawn

    % Character Movement Procedure
    proc MoveChar (directionX : string, directionY : string)

	splitSpeed := 1
	if not directionX = "NONE" and not directionY = "NONE" then
	    splitSpeed := 2
	end if

	SplitBulletSpeed := splitSpeed

	if directionY = "UP" then
	    GridDisplacementY := GridDisplacementY - (SpeedValues (CharLvl) div splitSpeed)
	    FoodDisplacementY := FoodDisplacementY - (SpeedValues (CharLvl) div splitSpeed)
	    EnemyDisplacementY := EnemyDisplacementY - (SpeedValues (CharLvl) div splitSpeed)
	    GlobalBulletDisplacementY := "DOWN"
	end if
	if directionY = "DOWN" then
	    GridDisplacementY := GridDisplacementY + (SpeedValues (CharLvl) div splitSpeed)
	    FoodDisplacementY := FoodDisplacementY + (SpeedValues (CharLvl) div splitSpeed)
	    EnemyDisplacementY := EnemyDisplacementY + (SpeedValues (CharLvl) div splitSpeed)
	    GlobalBulletDisplacementY := "UP"
	end if
	if directionX = "LEFT" then
	    GridDisplacementX := GridDisplacementX + (SpeedValues (CharLvl) div splitSpeed)
	    FoodDisplacementX := FoodDisplacementX + (SpeedValues (CharLvl) div splitSpeed)
	    EnemyDisplacementX := EnemyDisplacementX + (SpeedValues (CharLvl) div splitSpeed)
	    GlobalBulletDisplacementX := "RIGHT"
	end if
	if directionX = "RIGHT" then
	    GridDisplacementX := GridDisplacementX - (SpeedValues (CharLvl) div splitSpeed)
	    FoodDisplacementX := FoodDisplacementX - (SpeedValues (CharLvl) div splitSpeed)
	    EnemyDisplacementX := EnemyDisplacementX - (SpeedValues (CharLvl) div splitSpeed)
	    GlobalBulletDisplacementX := "LEFT"
	end if

    end MoveChar

    % Shooting Procedure
    proc Shoot ()

	Mouse.Where (MouseX, MouseY, MouseButton)

	if MouseButton = 1 then     % User is Clicking The Screen

	    TimeRunning := Time.Elapsed
	    if (TimeRunning - LastShot) >= ReloadTime then

		LastShot := TimeRunning

		var projectile : pointer to Bullet
		new Bullet, projectile %projectile

		var SlotFound : boolean := false
		for i : lower (CharacterProjectiles) .. upper (CharacterProjectiles)
		    if CharacterProjectiles (i) = nil then
			CharacterProjectiles (i) := projectile
			Bullet (projectile).SetUpBullet (CharPosX - 20, CharPosY - 20, i, "character")
			exit
		    end if
		end for

	    end if

	end if

	for i : lower (CharacterProjectiles) .. upper (CharacterProjectiles)
	    if CharacterProjectiles (i) ~= nil then
		if Bullet (CharacterProjectiles (i)).finished = false then
		    Bullet (CharacterProjectiles (i)).Fire (MouseX, MouseY)
		else
		    CharacterProjectiles (i) := nil
		end if
	    end if
	end for

    end Shoot
    
    %Character Reviving Procedure (used when starting a new round)
    proc Revive ()
    
	dead := false
    
    end Revive


end Character
var Char : pointer to Character




class Enemy % An Enemy Class

    % Procedures and Variables To Import/Export
    import EnemySprites, SpriteLevels,
	EnemyDisplacementX, EnemyDisplacementY,
	Bullet, EnemyProjectiles, TimeRunning, ReloadTime,
	Character, Char, CharPosX, CharPosY,
	DeathParticle
    export SetUpEnemy, speed, health, maxHealth, damage, lvl,
	xLoc, yLoc,
	PathFind, TakeDamage, ResetValues,
	PlayDeathEffect, dead

    % Enemy Variables
    var TargetX, TargetY : int
    var selfIndex : int

    var xLoc, yLoc : int
    var rotation : int := 0
    var speed : int
    var health, maxHealth : int
    var damage : int

    var lvl : int
    var sprite : int

    var EnemyLastShot : int := Time.Elapsed
    var bulletIndexes : array 1 .. 50 of int
    for i : lower (bulletIndexes) .. upper (bulletIndexes)
	bulletIndexes (i) := 0
    end for

    % death variables
    var dead : boolean := false
    var deathEffect : boolean := false % true if death effect is playing
    var deathX, deathY : int
    var deathEffectStart : int := TimeRunning
    var deathDuration : int := 2000

    var DeathParticles : flexible array 1 .. 100 of pointer to DeathParticle
    for i : lower (DeathParticles) .. upper (DeathParticles)
	DeathParticles (i) := nil
    end for



    % Procedure For Toggling The Death Effect (CANNOT BE A BODY PROCEDURE)
    proc PlayDeathEffect ()

	if not deathEffect then
	    deathX := xLoc
	    deathY := yLoc
	    deathEffectStart := Time.Elapsed
	    deathEffect := true
	    dead := true
	end if

	TimeRunning := Time.Elapsed
	if (TimeRunning - deathEffectStart) < deathDuration then

	    var slotFound : boolean := false
	    for i : lower (DeathParticles) .. upper (DeathParticles)

		if not slotFound then
		    if DeathParticles (i) = nil then

			var deathParticle : pointer to DeathParticle
			new DeathParticle, deathParticle % death particle
			DeathParticles (i) := deathParticle

			var particleDirX, particleDirY : real
			rand (particleDirX)
			particleDirY := (1 - particleDirX)

			% Add Dispalcement
			deathX := deathX + EnemyDisplacementX
			deathY := deathY + EnemyDisplacementY

			% initialize the particle
			DeathParticle (deathParticle).initializeParticle (deathX, deathY, particleDirX, particleDirY)
			% display the particle
			DeathParticle (deathParticle).updateParticle ()

			slotFound := true
			exit

		    elsif DeathParticle (DeathParticles (i)).active = false then

			var particleDirX, particleDirY : real
			rand (particleDirX)
			particleDirY := (1 - particleDirX)

			% Add Dispalcement
			deathX := deathX + EnemyDisplacementX
			deathY := deathY + EnemyDisplacementY

			% initialize the particle
			DeathParticle (DeathParticles (i)).initializeParticle (deathX, deathY, particleDirX, particleDirY)
			% display the particle
			DeathParticle (DeathParticles (i)).updateParticle ()

			slotFound := true

		    end if
		end if

		if DeathParticles (i) = nil then
		    exit
		elsif DeathParticle (DeathParticles (i)).active = true then
		    % display the particle
		    DeathParticle (DeathParticles (i)).updateParticle ()
		end if

	    end for

	else
	    deathEffect := false
	end if

    end PlayDeathEffect

    % Procedure For Initializing Enemy Variables
    proc SetUpEnemy (x, y, s, h, mh, d, l, idx : int)

	xLoc := x
	yLoc := y
	speed := s
	health := h
	maxHealth := mh
	damage := d
	selfIndex := idx

	lvl := l
	for i : lower (SpriteLevels) .. upper (SpriteLevels)
	    if SpriteLevels (i) <= lvl then
		sprite := i
	    else
		exit
	    end if
	end for

    end SetUpEnemy

    % Procedure For Correctly Rotating The Unit
    proc RotateUnit ()

	var AngleAddition : int := 0
	var method : int
	if CharPosX < xLoc and CharPosY > yLoc then % Top Left Quadrant
	    AngleAddition := 90
	    method := 1 % use sine method 1
	elsif CharPosX < xLoc and CharPosY < yLoc then % Bottom Left Quadrant
	    AngleAddition := 180
	    method := 2 % use sine method 2
	elsif CharPosX > xLoc and CharPosY < yLoc then % Bottom Right Quadrant
	    AngleAddition := 270
	    method := 1 % use sine method 1
	else % Top Right Quadrant
	    method := 2 % use sine method 2
	end if

	var Xdist : real := abs (xLoc - CharPosX) % x distance between mouse and character
	var Ydist : real := abs (yLoc - CharPosY) % y distance between mouse and character
	var Dist : real := sqrt ((Xdist * Xdist) + (Ydist * Ydist)) % distance between mouse and character

	if Dist ~= 0 then % Cannot Divide By Zero
	    if method = 1 then % perform trig method 1
		rotation := floor (arcsind (Xdist * (sind (90) / Dist)) + AngleAddition)
	    else % perform trig method 2
		rotation := floor (arcsind (Ydist * (sind (90) / Dist)) + AngleAddition)
	    end if
	end if
    end RotateUnit

    % Procedure For Spawning The Enemy
    proc SpawnEnemy (x : int, y : int, RotaionRequired : boolean)

	if not dead then
	    if RotaionRequired then
		RotateUnit ()
	    end if
	    var RotatedEnemy : int := Pic.Rotate (EnemySprites (sprite), rotation, 50, 50)
	    Pic.Draw (RotatedEnemy, x - 50, y - 50, picMerge)
	    Pic.Free (RotatedEnemy)
	end if

	if deathEffect then
	    PlayDeathEffect ()
	elsif dead then
	    dead := false
	end if

    end SpawnEnemy

    % Procedure For Shooting
    proc Fire ()

	% set up an X and Y offset value
	var offsetX : int
	randint (offsetX, 0, 100)
	var offsetY : int
	randint (offsetY, 0, 100)

	TimeRunning := Time.Elapsed
	if (TimeRunning - EnemyLastShot) >= ReloadTime then
	    EnemyLastShot := Time.Elapsed

	    % generate positive and negative numbers
	    var offsetDirX : int
	    randint (offsetDirX, -50, 50)
	    var offsetDirY : int
	    randint (offsetDirY, -50, 50)

	    % make the offsets positive or negative based on generated values
	    if offsetDirX < 0 then
		offsetX := offsetX * (-1)
	    end if
	    if offsetDirY < 0 then
		offsetY := offsetY * (-1)
	    end if

	    % Fire Bullet With Offset
	    var projectile : pointer to Bullet
	    new Bullet, projectile     %projectile

	    var SlotFound : boolean := false
	    for i : lower (EnemyProjectiles) .. upper (EnemyProjectiles)
		if EnemyProjectiles (i) = nil then

		    EnemyProjectiles (i) := projectile
		    Bullet (projectile).SetUpBullet (xLoc - 25, yLoc - 25, i, "enemy")
		    Bullet (projectile).ExtraSetUp (selfIndex)
		    for a : lower (bulletIndexes) .. upper (bulletIndexes)
			if bulletIndexes (a) = 0 then
			    bulletIndexes (a) := i
			    exit
			end if
		    end for
		    exit

		end if
	    end for
	end if

	for i : lower (bulletIndexes) .. upper (bulletIndexes)
	    if bulletIndexes (i) ~= 0 then
		if EnemyProjectiles (bulletIndexes (i)) ~= nil then
		    if Bullet (EnemyProjectiles (bulletIndexes (i))).finished = false then
			Bullet (EnemyProjectiles (bulletIndexes (i))).Fire (CharPosX + offsetX, CharPosY + offsetY)
		    else
			EnemyProjectiles (bulletIndexes (i)) := nil
			bulletIndexes (i) := 0
		    end if
		end if
	    end if
	end for

    end Fire

    % Pathfinding Procedure
    proc PathFind ()

	var RotationRequired : boolean := false

	if not dead then
	    % Decide Where To Go
	    if not Character (Char).dead and abs (xLoc - CharPosX) <= 500 and abs (yLoc - CharPosY) <= 500 then
		% Enemy is Close Enough to Player to Attack
		RotationRequired := true

		% Calculate Movement
		var Xvec : int := xLoc - CharPosX
		var Yvec : int := yLoc - CharPosY
		%drawline(CharPosX, CharPosY, CharPosX+Xvec, CharPosY+Yvec, black)
		var BaseMagnitude : real := sqrt ((Xvec * Xvec) + (Yvec * Yvec))
		var NormVecX : real := (Xvec div BaseMagnitude)
		var NormVecY : real := (Yvec div BaseMagnitude)
		TargetX := round (CharPosX + (NormVecX * 400))
		TargetY := round (CharPosY + (NormVecY * 400))

		% Apply Movement
		if abs (xLoc - TargetX) >= 250 or abs (yLoc - TargetY) >= 250 then
		    var TargetVecX : int := (TargetX - xLoc)
		    var TargetVecY : int := (TargetY - yLoc)
		    var TargetMag : real := sqrt ((TargetVecX * TargetVecX) + (TargetVecY * TargetVecY))
		    var TempIncrX : int := round ((TargetVecX / TargetMag) * speed)
		    var TempIncrY : int := round ((TargetVecY / TargetMag) * speed)
		    xLoc := xLoc + TempIncrX
		    yLoc := yLoc + TempIncrY
		end if

		% Shoot If Close Enough
		if abs (xLoc - CharPosX) <= 400 and abs (yLoc - CharPosY) <= 400 then
		    Fire ()
		end if

	    else
		% Enemy is Too Far Away To See The Player
		% Maybe I can add code later to randomly move enemies around to
		% simulate that they are looking for you, but for now it is unnecessary.
	    end if
	    xLoc := xLoc + EnemyDisplacementX
	    yLoc := yLoc + EnemyDisplacementY
	end if

	% Now We Spawn The Enemy
	SpawnEnemy (xLoc, yLoc, RotationRequired)

    end PathFind

    % Procedure For Taking Damage
    proc TakeDamage (damageDealt : int)
	health := health - damageDealt
    end TakeDamage

    % Procedure For Reseting Values When Enemy Unit Dies
    proc ResetValues (tempX, tempY, tempHealth : int)
	xLoc := tempX
	yLoc := tempY
	health := tempHealth
    end ResetValues

end Enemy
var Enemies : flexible array 1 .. EnemyCount of pointer to Enemy
for i : lower (Enemies) .. upper (Enemies)
    Enemies (i) := nil
end for




%%%%%%%%%%%%%  FUNCTIONS  %%%%%%%%%%%%%

% Function To Check If 2 Squares Are Colliding
body function CheckSquareCollision (X1, Y1, R1, X2, Y2, R2, offset : int) : boolean

    var DistBetweenX : int := abs (X1 - X2)
    var DistBetweenY : int := abs (Y1 - Y2)
    var DistBetween : int := floor (sqrt ((DistBetweenX * DistBetweenX) + (DistBetweenY * DistBetweenY)))

    if DistBetween < (R1 + R2 - offset) then
	result true
    else
	result false
    end if

end CheckSquareCollision


% Function For Returning Enemy Values
body function EnemyValues (EnemyIndex : int, EnemyValue : string) : int

    if EnemyValue = "level" then
	result Enemy (Enemies (EnemyIndex)).lvl
    end if

end EnemyValues



%%%%%%%%%%%%%  PROCEDURES  %%%%%%%%%%%%%

% Procedure to Draw a Grid
body procedure DrawGrid ()

    % Draw a Vertical Line Every 20 pixels
    for i : 0 .. (GridX div GridGap)
	drawline ((maxx div 2) - (GridX div 2) + (GridGap * i) + GridDisplacementX, % X1
	    ((maxy div 2) - (GridY div 2) + GridDisplacementY),        % Y1
	    (maxx div 2) - (GridX div 2) + (GridGap * i) + GridDisplacementX,      % X2
	    ((maxy div 2) + (GridY div 2) + GridDisplacementY),        % Y2
	    grey)
    end for
    % Draw a Horizontal Line Every 20 pixels
    for i : 0 .. (GridY div GridGap)
	drawline (((maxx div 2) - (GridX div 2)) + GridDisplacementX,  % X1
	    (maxy div 2) - (GridY div 2) + (GridGap * i) + GridDisplacementY,      % Y1
	    ((maxx div 2) + (GridX div 2)) + GridDisplacementX,        %X2
	    (maxy div 2) - (GridY div 2) + (GridGap * i) + GridDisplacementY,      %Y2
	    grey)
    end for

end DrawGrid


% Procedure For Placing Food
body procedure PlaceFood ()

    % First We Create The Positions/Levels/Health of The Food
    if not FoodSpawned then
	FoodSpawned := true
	for i : lower (FoodPositionsX) .. upper (FoodPositionsX)
	    randint (FoodPositionsX (i), ((maxx div 2) - (GridX div 2)), ((maxx div 2) + (GridX div 2)))
	end for
	for i : lower (FoodPositionsY) .. upper (FoodPositionsY)
	    randint (FoodPositionsY (i), ((maxy div 2) - (GridY div 2)), ((maxy div 2) + (GridY div 2)))
	end for
	for i : lower (FoodLevels) .. upper (FoodLevels)
	    randint (FoodLevels (i), 1, upper (FoodSprites))
	    FoodHealth (i) := (FoodLevels (i) * BaseFoodHealth)
	end for
    end if

    % Now We Actually Spawn The Food
    for i : 1 .. FoodCount

	var FoodType : int
	randint (FoodType, lower (FoodSprites), upper (FoodSprites))

	var ChosenSprite := Pic.Scale (FoodSprites (FoodType),
	    (Pic.Height (FoodSprites (FoodType)) div 1.5),
	    (Pic.Width (FoodSprites (FoodType)) div 1.5))
	FoodPositionsX (i) := (FoodPositionsX (i) + FoodDisplacementX)
	FoodPositionsY (i) := (FoodPositionsY (i) + FoodDisplacementY)
	Pic.Draw (ChosenSprite, FoodPositionsX (i) - 17, FoodPositionsY (i) - 17, picMerge)
	Pic.Free (ChosenSprite) % free the variable to avoid errors
	% drawline(FoodPositionsX(i) - 5, FoodPositionsY(i), FoodPositionsX(i) + 5, FoodPositionsY(i), black)
	% drawline(FoodPositionsX(i), FoodPositionsY(i) - 5, FoodPositionsX(i), FoodPositionsY(i) + 5, black)

	if FoodHealth (i) < (FoodLevels (i) * BaseFoodHealth) then
	    DisplayHealthBar (FoodPositionsX (i), FoodPositionsY (i), FoodHealth (i), (FoodLevels (i) * BaseFoodHealth), 25)
	end if

    end for

end PlaceFood


% Procedure For Spawning The Character
body procedure SpawnCharacter (display : boolean)

    if not CharCreated then

	new Character, Char
	CharCreated := true

    end if
    
    if display then
	Character(Char).Spawn ()
    end if

end SpawnCharacter


var method, AngleAddition : int
var Xdist, Ydist, Dist : real
% Procedure For Rotating The Character
body procedure RotateCharacter ()

    % First We Get The Mouse Position
    Mouse.Where (MouseX, MouseY, MouseButton)

    AngleAddition := 0
    if MouseX < CharPosX and MouseY > CharPosY then % Top Left Quadrant
	AngleAddition := 90
	method := 1 % use sine method 1
    elsif MouseX < CharPosX and MouseY < CharPosY then % Bottom Left Quadrant
	AngleAddition := 180
	method := 2 % use sine method 2
    elsif MouseX > CharPosX and MouseY < CharPosY then % Bottom Right Quadrant
	AngleAddition := 270
	method := 1 % use sine method 1
    else % Top Right Quadrant
	method := 2 % use sine method 2
    end if

    Xdist := abs (CharPosX - MouseX) % x distance between mouse and character
    Ydist := abs (CharPosY - MouseY) % y distance between mouse and character
    Dist := sqrt ((Xdist * Xdist) + (Ydist * Ydist)) % distance between mouse and character

    if Dist ~= 0 then % Cannot Divide By Zero
	if method = 1 then % perform trig method 1
	    CharRotation := floor (arcsind (Xdist * (sind (90) / Dist)) + AngleAddition)
	else % perform trig method 2
	    CharRotation := floor (arcsind (Ydist * (sind (90) / Dist)) + AngleAddition)
	end if
    end if

end RotateCharacter


% Move All Of The Enemies
body procedure MoveEnemies ()
    if not EnemiesCreated then % instantiate enemies

	for i : lower (Enemies) .. upper (Enemies)

	    var enemy : pointer to Enemy
	    new Enemy, enemy % instantiating the enemy

	    % Enemy Positioning
	    var x : int
	    var y : int
	    loop
		var ValidPos : boolean := true
		randint (x, ((maxx div 2) - (GridX div 2)), ((maxx div 2) + (GridX div 2)))
		randint (y, ((maxy div 2) - (GridY div 2)), ((maxy div 2) + (GridY div 2)))
		for e : lower (Enemies) .. upper (Enemies)
		    if Enemies (e) = nil then
			exit
		    end if
		    if abs (Enemy (Enemies (e)).xLoc - CharPosX) <= 200 and abs (Enemy (Enemies (e)).yLoc - CharPosY) <= 200 then
			ValidPos := false
			exit
		    end if
		    if abs (Enemy (Enemies (e)).xLoc - x) <= 100 and abs (Enemy (Enemies (e)).yLoc - y) <= 100 then
			ValidPos := false
			exit
		    end if
		end for
		exit when (ValidPos = true)
	    end loop

	    % Enemy Level
	    var l : int
	    randint (l, 1, LvlCap)
	    % Enemy Speed
	    var s : int := SpeedValues (l)
	    % Enemy Health
	    var h : int := MaxHealths (l)
	    var mh : int := h
	    % Enemy Damage
	    var d : int := DmgAmounts (l)

	    % Send Setup Values To This Enemy Instance
	    Enemy (enemy).SetUpEnemy (x, y, s, h, mh, d, l, i)

	    % Add Enemy To Array
	    Enemies (i) := enemy

	end for

	% Set Enemies Created to True
	EnemiesCreated := true

    else

	for i : lower (Enemies) .. upper (Enemies)
	    Enemy (Enemies (i)).PathFind ()
	    if Enemy (Enemies (i)).health < Enemy (Enemies (i)).maxHealth then
		DisplayHealthBar (Enemy (Enemies (i)).xLoc, Enemy (Enemies (i)).yLoc, Enemy (Enemies (i)).health, Enemy (Enemies (i)).maxHealth, 60)
	    end if
	end for

    end if
end MoveEnemies


% Procedure For Handling Collisions Between Enemies and Bullets
body procedure EnemyCollision (BulletIndex : int)

    for i : lower (Enemies) .. upper (Enemies)
	if Enemies (i) ~= nil then
	    if not Enemy (Enemies (i)).dead then
		var Collision := CheckSquareCollision (Bullet (CharacterProjectiles (BulletIndex)).Xpos, Bullet (CharacterProjectiles (BulletIndex)).Ypos, ProjectileRadius, Enemy (Enemies (i)).xLoc,
		    Enemy (Enemies (i)).yLoc, EnemyRadius, 0)
		if Collision then
		    Enemy (Enemies (i)).TakeDamage (DmgAmounts (CharLvl))
		    if Enemy (Enemies (i)).health <= 0 then
			AwardExp (EnemyBaseValue * (Enemy (Enemies (i)).lvl))
			Enemy (Enemies (i)).PlayDeathEffect ()
			RespawnItem ("enemy", i)
		    end if
		    Bullet (CharacterProjectiles (BulletIndex)).finish
		    exit
		end if
	    end if
	else
	    exit
	end if
    end for

end EnemyCollision


% Procedure For Handling Collisions Between The Character and Bullets
body procedure CharCollision (BulletIndex, EnemyIndex : int)

    var Collision := CheckSquareCollision (Bullet (EnemyProjectiles (BulletIndex)).Xpos, Bullet (EnemyProjectiles (BulletIndex)).Ypos, ProjectileRadius, CharPosX, CharPosY, CharRadius, 0)
    if Collision then
	CharHealth := CharHealth - DmgAmounts (Enemy (Enemies (EnemyIndex)).lvl)
	if CharHealth <= 0 then
	    % CHARACTER IS DEAD !!!
	    Character (Char).PlayDeathEffect ()
	end if
	Bullet (EnemyProjectiles (BulletIndex)).finish
    end if

end CharCollision


% Procedure For Displaying The Health Of an Item
body procedure DisplayHealthBar (xPos : int, yPos : int, health : int, maxHealth : int, offset : int)

    var MaxBarSize : int := 54
    var ConvertedHealth : int := (health * MaxBarSize div maxHealth)
    Draw.FillBox (xPos - (MaxBarSize div 2 + 1), yPos - (offset + 8), xPos + (MaxBarSize div 2 + 1), yPos - (offset - 1), 16) % background box
    Draw.FillBox (xPos - (MaxBarSize div 2), yPos - (offset + 7), xPos - (MaxBarSize div 2) + ConvertedHealth, yPos - offset, 2) % health bar

end DisplayHealthBar


% Procedure For Reseting Positions of Items
body procedure RespawnItem (itemType : string, itemIndex : int)

    if itemType = "food" then
	randint (FoodPositionsX (itemIndex), ((maxx div 2) - (GridX div 2)), ((maxx div 2) + (GridX div 2)))
	randint (FoodPositionsY (itemIndex), ((maxy div 2) - (GridY div 2)), ((maxy div 2) + (GridY div 2)))
	FoodPositionsX (itemIndex) := FoodPositionsX (itemIndex) + GridDisplacementX
	FoodPositionsY (itemIndex) := FoodPositionsY (itemIndex) + GridDisplacementY
	FoodHealth (itemIndex) := (FoodLevels (itemIndex) * BaseFoodHealth)
    elsif itemType = "enemy" then
	var tempX, tempY, tempHealth : int
	randint (tempX, ((maxx div 2) - (GridX div 2)), ((maxx div 2) + (GridX div 2)))
	randint (tempY, ((maxy div 2) - (GridY div 2)), ((maxy div 2) + (GridY div 2)))
	tempX := tempX + GridDisplacementX
	tempY := tempY + GridDisplacementY
	tempHealth := MaxHealths (Enemy (Enemies (itemIndex)).lvl)
	Enemy (Enemies (itemIndex)).ResetValues (tempX, tempY, tempHealth)
    end if

end RespawnItem


% Procedure For Awarding Experience to The User
body procedure AwardExp (expAmount : int)

    CharExp := CharExp + expAmount
    GameScore := GameScore + expAmount
    if CharExp >= CharExpRequirements (CharLvl) and not CharLvl >= LvlCap then
	CharLvl := CharLvl + 1
    end if

end AwardExp


% Reset Some Variables
body procedure ResetVariables ()
    FoodDisplacementX := 0
    FoodDisplacementY := 0
end ResetVariables

% Reset Enemies Between Sessions
body procedure ResetEnemiesAndFood ()
    for i : lower (Enemies) .. upper (Enemies)
	RespawnItem ("enemy", i)
    end for
    for i : lower (FoodPositionsX) .. upper (FoodPositionsX)
	RespawnItem ("food", i)
    end for
end ResetEnemiesAndFood

% Reset Game Variables Between Sessions
body procedure HardReset ()
    CharLvl := 1
    CharHealth := MaxHealths(CharLvl)
    Character (Char).Revive()
end HardReset

