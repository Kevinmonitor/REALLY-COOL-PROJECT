extends CharacterBody2D

class_name PlatformerController2D

@export var README: String = "IMPORTANT: MAKE SURE TO ASSIGN 'left' 'right' 'jump' 'dash' 'up' 'down' 'roll' 'latch' 'run' 'twirl' in the project settings input map. Usage tips. 1. Hover over each toggle and variable to read what it does and to make sure nothing bugs. 2. Animations are very primitive. To make full use of your custom art, you may want to slightly change the code for the animations"

#INFO READEME 
#IMPORTANT: MAKE SURE TO ASSIGN 'left' 'right' 'jump' 'dash' 'up' 'down' 'roll' 'latch' 'run' 'twirl' in the project settings input map. THIS IS REQUIRED
#Usage tips. 
#1. Hover over each toggle and variable to read what it does and to make sure nothing bugs. 
#2. Animations are very primitive. To make full use of your custom art, you may want to slightly change the code for the animations

@export_category("Necessary Child Nodes")
@export var PlayerSprite: AnimatedSprite2D
@export var PlayerCollider: CollisionShape2D
@export var WallRaycast: RayCast2D
@export var FloorRaycast: RayCast2D
@export var DashProgress: TextureProgressBar
@export var Text: RichTextLabel
@export var SlashAttack: Area2D

#INFO HORIZONTAL MOVEMENT 
@export_category("L/R Movement")
##The max speed your player will move
@export_range(50, 9999) var maxSpeed: float = 200.0
@export_range(50, 9999) var normalMaxSpeed: float = 200.0
@export_range(50, 9999) var dashSpeed: float = 200.0

##How fast your player will reach max speed from rest (in seconds)
@export_range(0, 4) var timeToReachMaxSpeed: float = 0.2
##How fast your player will reach zero speed from max speed (in seconds)
@export_range(0, 4) var timeToReachZeroSpeed: float = 0.2
##If true, player will instantly move and switch directions. Overrides the "timeToReach" variables, setting them to 0.
@export var directionalSnap: bool = false
##If enabled, the default movement speed will by 1/2 of the maxSpeed and the player must hold a "run" button to accelerate to max speed. Assign "run" (case sensitive) in the project input settings.
@export var runningModifier: bool = false

#INFO JUMPING 
@export_category("Jumping and Gravity")
##The peak height of your player's jump
@export_range(0, 20) var jumpHeight: float = 2.0
##How many jumps your character can do before needing to touch the ground again. Giving more than 1 jump disables jump buffering and coyote time.
@export_range(0, 4) var jumps: int = 1
##The strength at which your character will be pulled to the ground.
@export_range(0, 100) var gravityScale: float = 20.0
##The fastest your player can fall
@export_range(0, 1000) var terminalVelocity: float = 500.0
##Your player will move this amount faster when falling providing a less floaty jump curve.
@export_range(0.5, 3) var descendingGravityFactor: float = 1.3
##Enabling this toggle makes it so that when the player releases the jump key while still ascending, their vertical velocity will cut in half, providing variable jump height.
@export var shortHopAkaVariableJumpHeight: bool = true
##How much extra time (in seconds) your player will be given to jump after falling off an edge. This is set to 0.2 seconds by default.
@export_range(0, 0.5) var coyoteTime: float = 0.2
##The window of time (in seconds) that your player can press the jump button before hitting the ground and still have their input registered as a jump. This is set to 0.2 seconds by default.
@export_range(0, 0.5) var jumpBuffering: float = 0.2

#INFO EXTRAS
@export_category("Wall Jumping")
##Allows your player to jump off of walls. Without a Wall Kick Angle, the player will be able to scale the wall.
@export var wallJump: bool = false
##How long the player's movement input will be ignored after wall jumping.
@export_range(0, 0.5) var inputPauseAfterWallJump: float = 0.1
##The angle at which your player will jump away from the wall. 0 is straight away from the wall, 90 is straight up. Does not account for gravity
@export_range(0, 90) var wallKickAngle: float = 60.0
##The player's gravity will be divided by this number when touch a wall and descending. Set to 1 by default meaning no change will be made to the gravity and there is effectively no wall sliding. THIS IS OVERRIDDED BY WALL LATCH.
@export_range(1, 20) var wallSliding: float = 1.0
##If enabled, the player's gravity will be set to 0 when touching a wall and descending. THIS WILL OVERRIDE WALLSLIDING.
@export var wallLatching: bool = false
##wall latching must be enabled for this to work. #If enabled, the player must hold down the "latch" key to wall latch. Assign "latch" in the project input settings. The player's input will be ignored when latching.
@export var wallLatchingModifer: bool = false

@export_category("Slashing")
@export var slashCooldown: float = 1.0
@export var slashTime: float = 0.5
var isSlashReady: bool = true

@export_category("Dashing")
##The type of dashes the player can do.
@export_enum("None", "Horizontal", "Vertical", "Four Way", "Eight Way") var dashType: int
##How many dashes your player can do before needing to hit the ground.
@export_range(0, 10) var dashes: int = 1
##If enabled, pressing the opposite direction of a dash, during a dash, will zero the player's velocity.
@export var dashCancel: bool = true
##How far the player will dash. One of the dashing toggles must be on for this to be used.
@export_range(1.5, 4) var dashLength: float = 2.5

# charged dash

@export var dashChargeTime: float = 1.0
@export var dashChargeGracePeriod: float = 0.2 # after releasing dash button you have a small period to re-press it before dash charge resets.

# reference to dashtrail
var dashEffect = preload("res://Effects/DashTrail.tscn")

@export_category("Corner Cutting/Jump Correct")
##If the player's head is blocked by a jump but only by a little, the player will be nudged in the right direction and their jump will execute as intended. NEEDS RAYCASTS TO BE ATTACHED TO THE PLAYER NODE. AND ASSIGNED TO MOUNTING RAYCAST. DISTANCE OF MOUNTING DETERMINED BY PLACEMENT OF RAYCAST.
@export var cornerCutting: bool = false
##How many pixels the player will be pushed (per frame) if corner cutting is needed to correct a jump.
@export_range(1, 5) var correctionAmount: float = 1.5
##Raycast used for corner cutting calculations. Place above and to the left of the players head point up. ALL ARE NEEDED FOR IT TO WORK.
@export var leftRaycast: RayCast2D
##Raycast used for corner cutting calculations. Place above of the players head point up. ALL ARE NEEDED FOR IT TO WORK.
@export var middleRaycast: RayCast2D
##Raycast used for corner cutting calculations. Place above and to the right of the players head point up. ALL ARE NEEDED FOR IT TO WORK.
@export var rightRaycast: RayCast2D

@export_category("Down Input")
##Holding down will crouch the player. Crouching script may need to be changed depending on how your player's size proportions are. It is built for 32x player's sprites.
@export var crouch: bool = false
##Holding down and pressing the input for "roll" will execute a roll if the player is grounded. Assign a "roll" input in project settings input.
@export var canRoll: bool
@export_range(1.25, 2) var rollLength: float = 2
##If enabled, the player will stop all horizontal movement midair, wait (groundPoundPause) seconds, and then slam down into the ground when down is pressed. 
@export var groundPound: bool
##The amount of time the player will hover in the air before completing a ground pound (in seconds)
@export_range(0.05, 0.75) var groundPoundPause: float = 0.25
##If enabled, pressing up will end the ground pound early
@export var upToCancel: bool = false

@export_category("Animations (Check Box if has animation)")
##Animations must be named "run" all lowercase as the check box says
@export var run: bool
##Animations must be named "jump" all lowercase as the check box says
@export var jump: bool
##Animations must be named "idle" all lowercase as the check box says
@export var idle: bool
##Animations must be named "walk" all lowercase as the check box says
@export var walk: bool
##Animations must be named "slide" all lowercase as the check box says
@export var slide: bool
##Animations must be named "latch" all lowercase as the check box says
@export var latch: bool
##Animations must be named "falling" all lowercase as the check box says
@export var falling: bool
##Animations must be named "crouch_idle" all lowercase as the check box says
@export var crouch_idle: bool
##Animations must be named "crouch_walk" all lowercase as the check box says
@export var crouch_walk: bool
##Animations must be named "roll" all lowercase as the check box says
@export var roll: bool
var slash: bool

#Variables determined by the developer set ones.
var appliedGravity: float
var maxSpeedLock: float
var appliedTerminalVelocity: float

var friction: float
var acceleration: float
var deceleration: float
var instantAccel: bool = false
var instantStop: bool = false

var jumpMagnitude: float = 500.0
var jumpCount: int
var jumpWasPressed: bool = false
var coyoteActive: bool = false
var dashMagnitude: float
var gravityActive: bool = true
var dashing: bool = false
var dashCount: int
var rolling: bool = false

var decelerationDuration: float = 0.1
var isDeceleratingMaxSpeed: bool = false
var currentCharge: float = 0.0

var twoWayDashHorizontal
var twoWayDashVertical
var eightWayDash

var wasMovingR: bool
var wasPressingR: bool
var movementInputMonitoring: Vector2 = Vector2(true, true) #movementInputMonitoring.x addresses right direction while .y addresses left direction

var gdelta: float = 1

var dset = false

var colliderScaleLockY
var colliderPosLockY

var latched
var wasLatched
var crouching
var groundPounding

var anim
var col
var animScaleLock : Vector2

#Input Variables for the whole script
var upHold
var downHold
var leftHold
var leftTap
var leftRelease
var rightHold
var rightTap
var rightRelease
var jumpTap
var jumpRelease
var runHold
var latchHold
var dashTap
var rollTap
var downTap
var twirlTap

var isCharging
var isReleaseCharge

var damageBuffer: float = 0

# bonus stuff

var reset_position: Vector2
# Indicates that the player has an event happening and can't be controlled.
var event: bool

# hit by spike. player returns to start of room. subtract HP
func _owFuck():
	
	if damageBuffer > 0: pass
	else:
		MainGame.get_singleton().updateHP(-1)
		print(MainGame.get_singleton().playerCurrentHP)
		_startDamageBuffer()
		if MainGame.get_singleton().playerCurrentHP > 0:
			position = reset_position
			MainGame.get_singleton().load_room(MetSys.get_current_room_name())

func _startDamageBuffer():
	damageBuffer = 1
	await get_tree().create_timer(0.25).timeout
	damageBuffer = 0
	
func _ready():
	
	wasMovingR = true
	anim = PlayerSprite
	col = PlayerCollider
	
	_spawnDashTrail()
	_updateData()
	
func _updateData():
	
	acceleration = maxSpeed / timeToReachMaxSpeed
	deceleration = -maxSpeed / timeToReachZeroSpeed
	
	jumpMagnitude = (10.0 * jumpHeight) * gravityScale
	jumpCount = jumps
	
	dashMagnitude = 1.0
	dashCount = dashes
	
	maxSpeed = normalMaxSpeed
	maxSpeedLock = maxSpeed
	
	animScaleLock = abs(anim.scale)
	colliderScaleLockY = col.scale.y
	colliderPosLockY = col.position.y
	
	if timeToReachMaxSpeed == 0:
		instantAccel = true
		timeToReachMaxSpeed = 1
	elif timeToReachMaxSpeed < 0:
		timeToReachMaxSpeed = abs(timeToReachMaxSpeed)
		instantAccel = false
	else:
		instantAccel = false
		
	if timeToReachZeroSpeed == 0:
		instantStop = true
		timeToReachZeroSpeed = 1
	elif timeToReachMaxSpeed < 0:
		timeToReachMaxSpeed = abs(timeToReachMaxSpeed)
		instantStop = false
	else:
		instantStop = false
		
	if jumps > 1:
		jumpBuffering = 0
		coyoteTime = 0
	
	coyoteTime = abs(coyoteTime)
	jumpBuffering = abs(jumpBuffering)
	
	if directionalSnap:
		instantAccel = true
		instantStop = true
	
	twoWayDashHorizontal = false
	twoWayDashVertical = false
	eightWayDash = false
	if dashType == 0:
		pass
	if dashType == 1:
		twoWayDashHorizontal = true
	elif dashType == 2:
		twoWayDashVertical = true
	elif dashType == 3:
		twoWayDashHorizontal = true
		twoWayDashVertical = true
	elif dashType == 4:
		eightWayDash = true

func _process(_delta):
	
	Text.text = "slashready: " + str(isSlashReady) + "\ndashing: " + str(dashing)
	
	#INFO animations
	#directions
	
	if WallRaycast.is_colliding() and !is_on_floor() and latch and wallLatching and ((wallLatchingModifer and latchHold) or !wallLatchingModifer):
		latched = true
	else:
		latched = false
		wasLatched = true
		_setLatch(0.2, false)

	if rightHold and !latched:
		anim.scale.x = animScaleLock.x
	if leftHold and !latched:
		anim.scale.x = animScaleLock.x *- 1		
	if anim.scale.x == animScaleLock.x * -1:
		WallRaycast.scale.x = -1
	else:
		WallRaycast.scale.x = 1
		
	if slash and !slide and !dashing:
		anim.play("slash")
			
	else:
		#run
		if abs(velocity.x) > 0.1 and is_on_floor():
			anim.speed_scale = 1
			anim.play("run")
		elif abs(velocity.x) <= 0.1 and is_on_floor():
			anim.speed_scale = 1
			anim.play("idle")
	
		if dashing:
			anim.speed_scale = 1
			anim.play("dash")
		
		else:
	
			#jump
			if velocity.y < 0 and jump and !dashing:
				anim.speed_scale = 1
				anim.play("jump")
				
			elif velocity.y > gravityScale and !dashing and !crouching:
				anim.speed_scale = 1
				anim.play("falling")
		
	#if latch and slide:
		##wall slide and latch
		#if latched and !wasLatched:
			#anim.speed_scale = 1
			#anim.play("latch")
		#if WallRaycast.is_colliding() and velocity.y > 0 and slide and anim.animation != "slide" and wallSliding != 1:
			#anim.speed_scale = 1
			#anim.play("slide")
			#
		##crouch
		#if crouching and !rolling:
			#if abs(velocity.x) > 10:
				#anim.speed_scale = 1
				#anim.play("crouch_walk")
			#else:
				#anim.speed_scale = 1
				#anim.play("crouch_idle")
		#
		#if rollTap and canRoll and roll:
			#anim.speed_scale = 1
			#anim.play("roll")
			#
	_handleDashProgressBar()
		
func _handleDashProgressBar():
	if dashCount > 0:
		DashProgress.value = currentCharge/dashChargeTime * 100
		DashProgress.visible = true
	else:
		DashProgress.visible = false
	
func _spawnDashTrail():
	while true:
		if dashing or isDeceleratingMaxSpeed:
			_spawnDashImage()
		await get_tree().create_timer(0.001).timeout
		
func _spawnDashImage():
	var ghost: AnimatedSprite2D = dashEffect.instantiate()
	get_parent().add_child(ghost)
	
	ghost.global_position = global_position
	ghost.sprite_frames = anim.sprite_frames
	ghost.frame = anim.frame
	ghost.scale.x = anim.scale.x
	ghost.scale.y = anim.scale.y
		
func _physics_process(delta):
	if !dset:
		gdelta = delta
		dset = true
	#INFO Input Detectio. Define your inputs from the project settings here.
	leftHold = Input.is_action_pressed("left")
	rightHold = Input.is_action_pressed("right")
	upHold = Input.is_action_pressed("up")
	downHold = Input.is_action_pressed("down")
	leftTap = Input.is_action_just_pressed("left")
	rightTap = Input.is_action_just_pressed("right")
	leftRelease = Input.is_action_just_released("left")
	rightRelease = Input.is_action_just_released("right")
	jumpTap = Input.is_action_just_pressed("jump")
	jumpRelease = Input.is_action_just_released("jump")
	runHold = Input.is_action_pressed("run")
	latchHold = Input.is_action_pressed("latch")
	dashTap = Input.is_action_just_pressed("dash")
	rollTap = Input.is_action_just_pressed("roll")
	downTap = Input.is_action_just_pressed("down")
	twirlTap = Input.is_action_just_pressed("twirl")
	
	isCharging = Input.is_action_pressed("dash")
	isReleaseCharge = Input.is_action_just_released("dash")
	
	_fallOneWay()
	move_and_slide()
		
	#INFO Left and Right Movement
	
	if rightHold and leftHold and movementInputMonitoring:
		if !instantStop:
			_decelerate(delta, false)
		else:
			velocity.x = 0
			
	elif rightHold and movementInputMonitoring.x:
		if !isDeceleratingMaxSpeed and (velocity.x > maxSpeed or instantAccel):
			#decelerationDuration = 0.1
			velocity.x = maxSpeed
		else:
			velocity.x += acceleration * delta
		if velocity.x < 0:
			if !instantStop:
				_decelerate(delta, false)
			else:
				velocity.x = 0
				
	elif leftHold and movementInputMonitoring.y:
		if !isDeceleratingMaxSpeed and (velocity.x < -maxSpeed or instantAccel):
			#decelerationDuration = 0.1
			velocity.x = -maxSpeed
		else:
			velocity.x -= acceleration * delta
		if velocity.x > 0:
			if !instantStop:
				_decelerate(delta, false)
			else:
				velocity.x = 0
				
	if velocity.x > 0:
		wasMovingR = true
	elif velocity.x < 0:
		wasMovingR = false
		
	if rightTap:
		wasPressingR = true
	if leftTap:
		wasPressingR = false
	
	if runningModifier and !runHold:
		maxSpeed = maxSpeedLock / 2
	elif is_on_floor(): 
		maxSpeed = maxSpeedLock
		velocity.y = 0
	
	if !(leftHold or rightHold):
		if !instantStop:
			_decelerate(delta, false)
		else:
			velocity.x = 0
			
	#INFO Crouching
	if crouch:
		if downHold and is_on_floor():
			crouching = true
		elif !downHold and !rolling:
			crouching = false
			
	if !is_on_floor():
		crouching = false
			
	if crouching:
		maxSpeed = maxSpeedLock / 2
		col.scale.y = colliderScaleLockY / 2
		col.position.y = colliderPosLockY + (8 * colliderScaleLockY)
	elif !runningModifier or (runningModifier and runHold):
		maxSpeed = maxSpeedLock
		col.scale.y = colliderScaleLockY
		col.position.y = colliderPosLockY
		
	#INFO Rolling
	if canRoll and is_on_floor() and rollTap and crouching:
		_rollingTime(rollLength * 0.25)
		if wasPressingR and !(upHold):
			velocity.y = 0
			velocity.x = maxSpeedLock * rollLength
			dashCount += -1
			movementInputMonitoring = Vector2(false, false)
			_inputPauseReset(rollLength * 0.0625)
		elif !(upHold):
			velocity.y = 0
			velocity.x = -maxSpeedLock * rollLength
			dashCount += -1
			movementInputMonitoring = Vector2(false, false)
			_inputPauseReset(rollLength * 0.0625)
		
	if canRoll and rolling:
		#if you want your player to become immune or do something else while rolling, add that here.
		pass
			
	#INFO Jump and Gravity
	if velocity.y > 0:
		appliedGravity = gravityScale * descendingGravityFactor
	else:
		appliedGravity = gravityScale
	
	if WallRaycast.is_colliding() and !groundPounding and (rightHold or leftHold):
	
		slide = true
		appliedTerminalVelocity = terminalVelocity / wallSliding
		
		if wallLatching and ((wallLatchingModifer and latchHold) or !wallLatchingModifer):
			appliedGravity = 0
			
			if velocity.y < 0:
				velocity.y += 50
			if velocity.y > 0:
				velocity.y = 0
				
			if wallLatchingModifer and latchHold and movementInputMonitoring == Vector2(true, true):
				velocity.x = 0
			
		elif wallSliding != 1 and velocity.y > 0:
			appliedGravity = appliedGravity / wallSliding
			
	elif !WallRaycast.is_colliding() and !groundPounding:
		
		slide = false
		appliedTerminalVelocity = terminalVelocity
		
	else:
		
		slide = false
	
	if gravityActive:
		if velocity.y < appliedTerminalVelocity:
			velocity.y += appliedGravity
		elif velocity.y > appliedTerminalVelocity:
			velocity.y = appliedTerminalVelocity
		
	if shortHopAkaVariableJumpHeight and jumpRelease and velocity.y < 0 and !dashing:
		velocity.y = velocity.y / 2
	
	if jumps >= 1:
		
		if !is_on_floor() and !WallRaycast.is_colliding():
			if coyoteTime > 0:
				coyoteActive = true
				_coyoteTime()
				
		if jumpTap and !WallRaycast.is_colliding():
			if coyoteActive:
				coyoteActive = false
				_jump()
			if jumpBuffering > 0:
				jumpWasPressed = true
				_bufferJump()
			elif jumpBuffering == 0 and coyoteTime == 0 and is_on_floor():
				_jump()	
				
		elif jumpTap and WallRaycast.is_colliding and !is_on_floor():
			
			if !dashing:
				if wallJump and !latched:
					_wallJump()
				elif wallJump and latched:
					_wallJump()
			else:
				if wallJump and !latched:
					_superWallJump()
				elif wallJump and latched:
					_superWallJump()
				
		elif jumpTap and is_on_floor():
			if dashing:
				_superJump()
			else:
				_jump()
		
		if is_on_floor():
			jumpCount = jumps
			coyoteActive = true
			if jumpWasPressed:
				if dashing:
					_superJump()
				else:
					_jump()
					
	#INFO dashing
	_handleDash()
	
	#INFO Corner Cutting
	if cornerCutting:
		if velocity.y < 0 and leftRaycast.is_colliding() and !rightRaycast.is_colliding() and !middleRaycast.is_colliding():
			position.x += correctionAmount
		if velocity.y < 0 and !leftRaycast.is_colliding() and rightRaycast.is_colliding() and !middleRaycast.is_colliding():
			position.x -= correctionAmount
			
	#INFO Ground Pound
	if groundPound and downTap and !is_on_floor() and !WallRaycast.is_colliding():
		groundPounding = true
		gravityActive = false
		velocity.y = 0
		await get_tree().create_timer(groundPoundPause).timeout
		_groundPound()
		
	if is_on_floor() and groundPounding:
		_endGroundPound()
	
	if upToCancel and upHold and groundPound:
		_endGroundPound()

func _fallOneWay():
	if downTap and is_on_floor():
		position.y += 10

# if: release dash button, and gauge is not 100%, slash. 
# enable slash hitbox and play slash animation
func _slashAttack():
	if isSlashReady and dashTap and currentCharge < dashChargeTime and !slide:
		SlashAttack._activateSlash()
		await get_tree().create_timer(slashTime).timeout
		# then, cooldown slash
		_slashCooldown()
		
func _slashCooldown():
	isSlashReady = false
	await get_tree().create_timer(slashCooldown).timeout
	isSlashReady = true
	
func _chargeDash():
	if isCharging and !dashing and dashCount > 0 and currentCharge < dashChargeTime:
		currentCharge = clamp(currentCharge + 1.0/60.0, 0.0, dashChargeTime*1.01)
	else:
		_chargeGracePeriod()
	
func _chargeGracePeriod():
	await get_tree().create_timer(dashChargeGracePeriod).timeout
	if isCharging:
		pass
	elif currentCharge > dashChargeTime * 1.2:
		pass
	else:
		currentCharge = 0.0
		# reset dashChargeGracePeriod
		dashChargeGracePeriod = 0.1
	
func _handleDash():
	
	_chargeDash()
	_slashAttack()
	
	if is_on_floor():
		dashCount = dashes
		dashChargeGracePeriod = 0.1
		
	# if you release dash when at 100% OR you press dash at 100%
	if eightWayDash and dashCount > 0 and !rolling and ( (isReleaseCharge and currentCharge >= dashChargeTime) or (dashTap and currentCharge >= dashChargeTime) ):
		
		var input_direction = Input.get_vector("left", "right", "up", "down")
		var dTime = 0.0625 * dashLength
		velocity.x = 0
		velocity.y = 0
		_dashingTime(dTime)
		_pauseGravity(dTime)
		
		input_direction = Input.get_vector("left", "right", "up", "down")
		
		if input_direction.x == 0 and input_direction.y > 0:
			decelerationDuration = 0.1
		if input_direction.x == 0 and input_direction.y < 0:
			velocity = dashSpeed * input_direction.normalized() * 0.8
		else:
			velocity = dashSpeed * input_direction.normalized()
		currentCharge = 0.0
		#dashCount += -1
		
		movementInputMonitoring = Vector2(false, false)
		_inputPauseReset(dTime)
			
	if dashing and velocity.x > 0 and leftTap and dashCancel:
		velocity.x = 0
	if dashing and velocity.x < 0 and rightTap and dashCancel:
		velocity.x = 0
	
func _bufferJump():
	await get_tree().create_timer(jumpBuffering).timeout
	jumpWasPressed = false

func _coyoteTime():
	await get_tree().create_timer(coyoteTime).timeout
	coyoteActive = false
	jumpCount += -1
	
func _jump():
	print("jump")
	if jumpCount > 0:
		velocity.y = -jumpMagnitude
		jumpCount += -1
		jumpWasPressed = false

# if jumping immediately after a dash, do a super jump with very high velocity

func _superJump():
	print("superjump")
	if jumpCount > 0:
		velocity.x *= 1.85
		decelerationDuration = 0.4
		velocity.y = -jumpMagnitude
		jumpCount += -1
		jumpWasPressed = false	
		
func _wallJump():
	print("walljump")
	var horizontalWallKick = abs(jumpMagnitude * cos(wallKickAngle * (PI / 180)))
	var verticalWallKick = abs(jumpMagnitude * sin(wallKickAngle * (PI / 180)))
	velocity.y = -verticalWallKick * 1.4
	var dir = 1
	if wallLatchingModifer and latchHold:
		dir = -1
	if wasMovingR:
		velocity.x = -horizontalWallKick  * dir * 1.8
	else:
		velocity.x = horizontalWallKick * dir * 1.8
	if inputPauseAfterWallJump != 0:
		movementInputMonitoring = Vector2(false, false)
		_inputPauseReset(inputPauseAfterWallJump)
		
func _superWallJump():
	var horizontalWallKick = abs(jumpMagnitude * cos(wallKickAngle * (PI / 180)))
	var verticalWallKick = abs(jumpMagnitude * sin(wallKickAngle * (PI / 180)))
	decelerationDuration = 0.4
	
	velocity.y = -verticalWallKick * 2.0
	
	var dir = 1
	if wallLatchingModifer and latchHold:
		dir = -1
	if wasMovingR:
		velocity.x = -horizontalWallKick * dir * 1.25
	else:
		velocity.x = horizontalWallKick * dir * 1.25
	if inputPauseAfterWallJump != 0:
		movementInputMonitoring = Vector2(false, false)
		_inputPauseReset(inputPauseAfterWallJump)
			
func _setLatch(delay, setBool):
	await get_tree().create_timer(delay).timeout
	wasLatched = setBool
			
func _inputPauseReset(time):
	await get_tree().create_timer(time).timeout
	movementInputMonitoring = Vector2(true, true)
	
func _decelerate(delta, vertical):
	if !vertical:
		if velocity.x > 0:
			velocity.x += deceleration * delta
		elif velocity.x < 0:
			velocity.x -= deceleration * delta
	elif vertical and velocity.y > 0:
		velocity.y += deceleration * delta

func _pauseGravity(time):
	gravityActive = false
	await get_tree().create_timer(time).timeout
	gravityActive = true

func _dashingTime(time):
	dashing = true
	decelerationDuration = 0.1
	maxSpeed = dashSpeed
	await get_tree().create_timer(time).timeout
	_decelerateMaxSpeed(dashSpeed, normalMaxSpeed, decelerationDuration)
	dashing = false

func _setMaxSpeed(speed):
	maxSpeed = speed
	
func _decelerateMaxSpeed(startSpeed, endSpeed, duration):
	var tween = self.create_tween()
	tween.tween_method(_setMaxSpeed, startSpeed, endSpeed, duration)
	while tween.is_valid():
		if tween.is_running():
			isDeceleratingMaxSpeed = true
		else:
			isDeceleratingMaxSpeed = false
			break
		await get_tree().create_timer(0.01).timeout
	
func _rollingTime(time):
	rolling = true
	await get_tree().create_timer(time).timeout
	rolling = false	

func _groundPound():
	appliedTerminalVelocity = terminalVelocity * 10
	velocity.y = jumpMagnitude * 2
	
func _endGroundPound():
	groundPounding = false
	appliedTerminalVelocity = terminalVelocity
	gravityActive = true

func _placeHolder():
	print("")

# die! suffer! explode!

func kill():
	# Player dies, reset the position to the entrance.
	position = reset_position
	MainGame.get_singleton().load_room(MetSys.get_current_room_name())

func on_enter():
	# Position for kill system. Assigned when entering new room (see Game.gd).
	reset_position = position
