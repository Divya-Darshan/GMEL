# Game Design Document (GDD)

## Game Concept

A 2D physics-based platformer where the player acts as a mechanic, collects parts, builds a simple car, and attempts to reach a test garage to prove their build works.

---

## Core Goal

"Build a working car and reach the test garage to prove your skills and unlock the exit."

---

## Core Gameplay Loop

1. Move left to right
2. Collect car parts
3. Assemble car
4. Drive using physics
5. Fail and adjust build
6. Reach test garage

---

## Gameplay Mechanics

* 2D platformer movement
* Basic physics-based car
* Limited parts system:

  * Wheels
  * Car body
  * Engine
* Simple assembly system (attach parts)
* Terrain obstacles (ramps, gaps)

---

## AI Assistant (NPC)

Name: BoltBot

Role:

* Guides player
* Suggests improvements
* Gives hints

Features:

* "Suggest Build" button
* Context hints:

  * "Your car is unstable"
  * "Try bigger wheels"
* Optional humor/personality

---

## Win Condition

* Player reaches the Test Garage on the right
* Car must still function
* Trigger: Enter zone to complete level

---

## Fail Conditions

* Car breaks
* Player is stuck
* Car flips and cannot recover

---

## Level Design

* Left: Start (junkyard)
* Middle: Obstacles and part pickups
* Right: Test Garage (goal)

---

## Visual Style

* Simple 2D
* Slightly exaggerated physics
* Mechanical or junkyard theme

---

## Feedback and Polish

* Sound when parts attach
* Engine sound
* Success animation at garage
* AI text popups

---

## Scope Control

* Keep parts minimal (maximum 3 to 4 types)
* Single level (expand only if time permits)
* Simple UI
* Focus on gameplay first, polish later

---

## Stretch Goals (Optional)

* Multiple levels
* Fuel system
* Improved AI suggestions
* Cosmetic variations

---

## Development Plan

* Day 1 to 3: Movement and physics
* Day 4 to 6: Car building system
* Day 7 to 8: AI assistant
* Day 9 to 10: Level and goal
* Day 11 to 12: Polish and bug fixes

---

## Final Vision

A short, focused physics-based game where players experiment with building a car using limited parts, guided by an AI assistant, and attempt to successfully reach the test garage.
