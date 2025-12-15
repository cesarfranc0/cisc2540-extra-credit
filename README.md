# 2D Extra Credit (Godot 4)

## Implemented Systems

### Health System
- Player health tracking using a reusable `Health` component
- Visual health display via HUD (ProgressBar + Label)
- Hurt and death animations
- Screen flash feedback when taking damage

### Hazard System
- Static hazard (fire) that deals damage over time
- Moving hazard (patrolling enemy) that damages the player on contact
- Hazards interact with the player through the `Hurtbox` component

### Player Feedback
- Immediate visual feedback when taking damage
- Clear health state
- Distinct animations for idle, movement, hurt, and death

## Technical Highlights
- Signal-based communication between systems
- Reusable components (`Health`, `Hurtbox`, damage areas)
- Clean scene and script organization following Godot best practices

## Controls
- Arrow Keys / WASD: Move player
- Contact with hazards or enemies: Take damage
