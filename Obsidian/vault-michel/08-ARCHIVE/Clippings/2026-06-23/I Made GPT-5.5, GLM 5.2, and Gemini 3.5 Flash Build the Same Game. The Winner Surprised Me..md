---
title: "I Made GPT-5.5, GLM 5.2, and Gemini 3.5 Flash Build the Same Game. The Winner Surprised Me."
source: "https://x.com/tonysimons_/status/2068699755199205491"
author:
  - "[[@tonysimons_]]"
published: 2026-06-21
created: 2026-06-22
description: "I wanted a more useful coding model test.I wanted to see what happens when different coding agents are asked to build the same complete visu..."
tags:
  - "clippings"
---
![Image](https://pbs.twimg.com/media/HLUgBX2WsAAMycz?format=jpg&name=large)

I wanted a more useful coding model test.

I wanted to see what happens when different coding agents are asked to build the same complete visual app from scratch.

So I gave three setups the same prompt. The idea:

Build a playable browser game called **Moon Bouncer: Oxygen Panic**.

Same prompt, same task, same scoring system. No hand-editing before judging.

The results were closer than I expected.

They were also different in ways that actually matter if you build with these tools every day.

# The Setup

This wasn't just a model comparison.

It was a **model plus harness** comparison.

That matters because the tool wrapped around the model changes the experience. Speed matters. Reliability matters. File handling matters. Recovery matters. Whether the agent gets stuck matters.

Here are the three setups I tested:

- **Codex App on Windows** with **GPT-5.5**
- **OpenCode CLI on Windows** with **GLM 5.2**
- **Antigravity CLI on Windows** with **Gemini 3.5 Flash**

The job was to build a **React**, T**ypeScript**, **Vite browser game**.

The game concept was simple:

You control a low-gravity astronaut on the Moon. Oxygen is running out. Debris, satellites, meteors, lasers, mines, and other hazards are trying to end your run.

Survive 90 seconds and you win.

Run out of oxygen or lose your shield and you lose.

# What I Asked For

The prompt was intentionally detailed.

```text
You are building a visually polished browser game from scratch.

Project name: Moon Bouncer: Oxygen Panic

Goal:
Build a complete playable arcade survival game where the player controls a low-gravity astronaut on the Moon, dodges falling hazards, collects oxygen tanks, and survives for 90 seconds.

Important:
Do not ask clarifying questions. Make reasonable assumptions and build the best version you can within this session.

Tech requirements:

* Use React + TypeScript + Vite unless the current environment already has a clearly better frontend setup.
* The game should run locally in the browser.
* Use browser-native rendering, preferably HTML Canvas for the game area.
* Do not require external paid APIs.
* Do not use external image or audio assets.
* Procedurally create all visuals using CSS, Canvas, SVG, emoji-free drawing, gradients, shapes, particles, and text.
* The final result must be runnable with clear commands, preferably:

  * npm install
  * npm run dev
  * npm run build

Game concept:
The player is an astronaut trapped on the Moon during a satellite debris storm. Oxygen is running out. The player must survive for 90 seconds by dodging hazards and collecting oxygen tanks.

Core gameplay requirements:

* Player character:

  * Low-gravity movement.
  * Keyboard controls:

    * A/D or Arrow Left/Arrow Right to move.
    * W/Space/Arrow Up to jump or boost.
  * Mobile/touch controls:

    * Left/right movement.
    * Jump/boost button.
  * Player should feel floaty but responsive.
* Game loop:

  * Start screen.
  * Active gameplay.
  * Pause functionality.
  * Game over screen.
  * Victory screen if the player survives 90 seconds.
  * Restart button.
* Survival timer:

  * 90-second countdown.
  * Clear visual timer UI.
* Oxygen system:

  * Oxygen drains over time.
  * Oxygen tanks spawn periodically.
  * Collecting oxygen restores oxygen.
  * If oxygen reaches zero, the player loses.
* Health system:

  * Player has health or shield.
  * Hazards reduce health.
  * If health reaches zero, the player loses.
* Hazards:

  * At least 4 distinct hazard types.
  * Examples: falling satellites, meteor shards, laser sweeps, bouncing debris, unstable moon mines.
  * Hazards should have different movement patterns.
* Difficulty scaling:

  * Game gets harder as time passes.
  * Increase spawn rate, speed, hazard mix, or complexity over time.
* Score:

  * Score increases over time.
  * Bonus points for collecting oxygen.
  * Show final score on game over or victory.
* Collision:

  * Implement real collision detection.
  * Avoid fake or decorative gameplay.

Visual polish requirements:

* Make it look good enough to show in a comparison video.
* Include a Moon surface with depth, craters, and parallax background.
* Include stars, Earth in the distance, or orbital debris in the sky.
* Include particle effects:

  * Dust when the astronaut lands.
  * Sparks or burst when hit.
  * Glow or pulse when collecting oxygen.
* Include screen shake or impact feedback when hit.
* Include clear UI:

  * Oxygen bar.
  * Health/shield indicator.
  * Timer.
  * Score.
  * Current difficulty/wave indicator.
* Use strong visual hierarchy.
* Make the game readable at a glance.
* Make it responsive for desktop and mobile.
* Avoid looking like a plain tutorial demo.

Audio requirements:

* Include a sound toggle.
* Use Web Audio API or simple browser-native sound generation.
* Include small sound effects for:

  * Jump/boost.
  * Collecting oxygen.
  * Taking damage.
  * Game over.
  * Victory.
* Do not use external audio files.
* Handle browser autoplay restrictions correctly. Audio may activate after first user interaction.

UX requirements:

* Show controls on the start screen.
* Show a brief objective on the start screen.
* Include pause/resume.
* Include restart.
* Include a visible mute/sound toggle.
* Make the game playable without reading source code.
* Avoid overwhelming the player in the first 10 seconds.
* Use clear feedback when oxygen is low.
* Use clear feedback when health is low.

Code quality requirements:

* Organize code cleanly.
* Use meaningful component and function names.
* Keep game constants configurable.
* Avoid one giant unreadable file if possible.
* Use TypeScript types where useful.
* Avoid brittle magic numbers where constants make sense.
* Do not leave dead code or unused major features.
* Do not claim a feature is implemented unless it actually works.

Testing and verification:
Before finishing, run whatever checks are available:

* npm run build, if available.
* Basic manual verification notes.
* Confirm the game starts, can be played, can end, and can restart.
* Confirm mobile controls exist.
* Confirm sound toggle exists.
* Confirm hazards and oxygen collectibles spawn.
* Confirm win and loss states exist.

Final response format:
After building, provide:

1. Run commands.
2. A short feature checklist.
3. Any known issues.
4. Files created or modified.
5. A brief explanation of the architecture.
```

I wanted more than a pretty canvas.

The game needed:

- Start screen
- Active gameplay
- Pause and resume
- Game over screen
- Victory screen
- Restart button
- Keyboard controls
- Mobile touch controls
- Oxygen system
- Health or shield system
- Score
- 90-second timer
- Multiple hazard types
- Real collision detection
- Difficulty scaling
- Procedural visuals
- Sound effects
- No external image or audio assets

That last part matters.

No downloaded sprites, stock sound effects. or external assets doing the heavy lifting.

The models had to generate the game using code, canvas, CSS, SVG, procedural drawing, and browser-native audio.

## Why This Test Works

A browser game is a good coding-agent test because it stresses multiple skills at once.

A model has to handle:

- UI structure
- State management
- Animation loops
- Physics
- Collision detection
- Input handling
- Audio
- Responsive design
- Game rules
- Visual hierarchy
- Code organization

It also has to make something that feels decent when played.

That's where weak builds fall apart.

A generated app can look good in a screenshot and still be useless the second you press a key.

This test punishes that.

# How I Scored It

I scored each build on a 100-point scale.

The categories were:

- Runs without errors: 15 points
- Playable game loop: 15 points
- Movement and controls: 10 points
- Hazards, oxygen, collision, win/loss logic: 20 points
- Visual polish: 15 points
- Game feel: 10 points
- Code quality: 10 points
- Mobile/responsive support: 5 points

I also kept a separate video wow score.

That is not scientific, but it is useful.

If I am posting the result on X, the game has to be understandable on video. A technically decent build that looks dead on screen is still a weaker artifact for this kind of test.

# Result 1: Codex App on Windows with GPT-5.5

## Build time: 12 minutes, 47 seconds

<video preload="none" tabindex="-1" playsinline="" aria-label="Embedded video" poster="https://pbs.twimg.com/amplify_video_thumb/2068586385624182784/img/hQ1X1dtNlw8r6rOc.jpg" style="width: 100%; height: 100%; position: absolute; background-color: black; top: 0%; left: 0%; transform: rotate(0deg) scale(1.005);"><source type="video/mp4" src="blob:https://x.com/a9a399aa-3ac9-42bf-ac43-20fcb8ee8bea"></video>

![](https://pbs.twimg.com/amplify_video_thumb/2068586385624182784/img/hQ1X1dtNlw8r6rOc.jpg?name=large)

Codex with GPT-5.5 produced a very polished game.

This was the best-looking build in terms of charm and visual identity.

The Moon surface had depth. The background had stars and a distant Earth glow. The title screen looked good. The HUD was readable. The astronaut had more personality than the others.

It felt like a coherent mini-game, not a random canvas experiment.

## What GPT-5.5 Built Well

The GPT-5.5 game included:

- Clean start screen
- Playable low-gravity movement
- Oxygen pickups
- Falling hazards
- Ground hazards
- Laser sweeps
- Score
- Timer
- Victory state
- Sound effects
- Touch controls in code
- Clean TypeScript structure

The visuals were the strongest part.

A lot of generated games look like someone dumped rectangles into a div and called it done.

This did not.

The UI was clean. The game world made sense. The title screen sold the concept immediately.

## Sound

The sound effects worked, but they were basic.

There were little blips when collecting oxygen and little bloops when hitting obstacles.

Functional. Not bad. Not the strongest part of the build.

GLM and Gemini both did better on sound.

## Code Quality

The code was clean.

The structure looked like this:

```text
src/
  App.tsx
  main.tsx
  styles.css
  components/
    GameCanvas.tsx
  game/
    audio.ts
    config.ts
    input.ts
    renderer.ts
    simulation.ts
    types.ts
```

That is a good structure for a small game project.

The app shell, canvas lifecycle, simulation, rendering, input, audio, config, and types were separated properly.

TypeScript passed. Lint passed.

The only local build issue I hit came from the uploaded zip including platform-specific node\_modules. That is not something I count against the source. The game clearly ran on the original machine, and the code checked out.

## GPT-5.5 Score

**90.5 / 100**

## Best traits:

- Best visual charm
- Strongest overall presentation
- Cleanest smooth run
- Good code organization
- Fast build time
- Strong gameplay completeness

## Weak spots:

- Sound was basic
- Game-over state was not shown in the video
- Opening stretch was a little forgiving
- Final artifact was narrowly behind GLM

GPT-5.5 felt like the safest all-around builder.

It did not win every category, but it was strong almost everywhere.

# Result 2: OpenCode CLI on Windows with GLM 5.2

## Build time: 17 minutes, 51 seconds-ish

<video preload="none" tabindex="-1" playsinline="" aria-label="Embedded video" poster="https://pbs.twimg.com/amplify_video_thumb/2068587697589919744/img/TVr3IGBDFA9EelyW.jpg" style="width: 100%; height: 100%; position: absolute; background-color: black; top: 0%; left: 0%; transform: rotate(0deg) scale(1.005);"><source type="video/mp4" src="blob:https://x.com/386db2c8-af63-4242-85e9-0d023bfdfc2c"></video>

![](https://pbs.twimg.com/amplify_video_thumb/2068587697589919744/img/TVr3IGBDFA9EelyW.jpg?name=large)

GLM 5.2 produced the best final game.

It was not a blowout. GPT-5.5 was close.

But GLM had the strongest overall artifact once I looked at the video, gameplay systems, audio, and code.

There was one operational hiccup.

OpenCode seemed to hang near the end of the build. I had to stop it and tell it to resume. That makes the exact timing a little messy, but the total was around 17:51.

That matters.

The final output was excellent, but the run was slower and a little less smooth.

## What GLM 5.2 Built Well

The GLM game included:

- Strong start screen
- Clean HUD
- Oxygen and shield bars
- Score
- Timer
- Wave system
- Multiple hazards
- Pickups
- Damage feedback
- Game-over state
- Victory state in code
- Mobile controls
- Best sound effects of the three

The UI was probably the cleanest of the group.

The oxygen and shield bars were easy to read. The timer sat cleanly at the top. The wave and score indicators made sense.

The red danger feedback when shield got low was a smart touch.

It made the game state obvious without forcing me to study the HUD.

## Sound

GLM won sound.

No question.

It had separate effects for:

- Jump
- Boost
- Collect
- Damage
- Game over
- Victory
- Wave changes
- Low oxygen

It used noise bursts, oscillator ramps, filters, gain envelopes, and chord-style effects.

That showed up during play.

Jumping sounded better. Damage had more punch. Collecting oxygen felt more satisfying. The game felt more alive because of it.

Sound does not replace visuals, but it absolutely changes game feel.

GLM understood that better than the other two.

## Code Quality

The code structure was strong.

```text
src/
  App.tsx
  main.tsx
  styles.css
  components/
    GameOverScreen.tsx
    HUD.tsx
    PauseOverlay.tsx
    StartScreen.tsx
    TouchControls.tsx
    VictoryScreen.tsx
  game/
    audio.ts
    constants.ts
    engine.ts
    entities.ts
    hazards.ts
    particles.ts
    render.ts
    types.ts
  hooks/
    useGameEngine.ts
```

This looked like a real small game project.

Screens were split into components. Game logic had its own engine. Hazards, particles, rendering, audio, constants, and types were separated.

TypeScript passed.

There was no lint script, so GPT-5.5 gets a small hygiene advantage there.

But overall, this was excellent.

## GLM 5.2 Score

**92.5 / 100**

## Best traits:

- Best final artifact
- Best sound design
- Excellent architecture
- Strong hazard variety
- Strong UI and feedback
- Game-over state clearly shown

## Weak spots:

- Slowest build
- Small stop/resume hiccup
- Slightly less visual charm than GPT-5.5
- No lint script

GLM won the artifact race.

Not by a mile.

More like one bootprint in the moon dust.

# Result 3: Antigravity CLI on Windows with Gemini 3.5 Flash

## Build time: 3 minutes, 7 seconds

<video preload="none" tabindex="-1" playsinline="" aria-label="Embedded video" poster="https://pbs.twimg.com/amplify_video_thumb/2068589178229559296/img/RYMZK3ELP2sgtWq5.jpg" style="width: 100%; height: 100%; position: absolute; background-color: black; top: 0%; left: 0%; transform: rotate(0deg) scale(1.005);"><source type="video/mp4" src="blob:https://x.com/3ca575ba-b987-481d-859e-ef800847eb50"></video>

![](https://pbs.twimg.com/amplify_video_thumb/2068589178229559296/img/RYMZK3ELP2sgtWq5.jpg?name=large)

This result changed how I looked at the whole test.

Gemini 3.5 Flash did not make the best-looking game.

It did not have the cleanest architecture.

It did not beat GLM or GPT-5.5 on final artifact quality.

But it built a real playable game in **3 minutes and 7 seconds**.

That is hard to ignore.

## What Gemini 3.5 Flash Built Well

The Gemini game included:

- Start screen
- Game loop
- Pause
- Game over
- Restart
- Timer
- Oxygen
- Shield
- Pickups
- Hazards
- Collision
- Sound effects
- Mobile controls
- Victory state in code

The graphics were the weakest of the three.

The game was darker, simpler, and less visually polished. The world had less personality. The astronaut was less memorable. The screen was readable, but it did not have the same visual confidence as GPT-5.5 or GLM.

But the controls were excellent.

The astronaut felt fast, responsive, and easy to steer.

In pure control feel, Gemini may have been the best of the group.

## Sound

Gemini’s sound effects were decent.

Better than Codex. Not as good as GLM.

It had enough audio feedback to make the game feel responsive, but it did not have GLM’s richer sound design.

## Code Quality

The project structure was much simpler.

```text
src/
  App.tsx
  GameEngine.ts
  audio.ts
  types.ts
  index.css
  main.tsx
```

The main issue was GameEngine.ts.

It was huge, around 1,700 lines.

That is not ideal.

It worked, but it was more monolithic than the GPT-5.5 and GLM builds.

TypeScript passed, but lint failed with multiple issues. Mostly switch-case declaration errors, one unused variable, and a React hook warning.

So the code was not as clean.

But again:

**3 minutes and 7 seconds.**

That speed matters.

## Gemini 3.5 Flash Score

**88.5 / 100**

## Best traits:

- Fastest by a huge margin
- Best controls
- Decent sound
- Real playable game
- Strong prototype speed

## Weak spots:

- Weakest visuals
- Most monolithic code
- Lint failed
- Less polish overall

Gemini did not win the artifact race.

But it absolutely won the prototype race.

## Final Leaderboard: Artifact Quality

1. **OpenCode CLI on Windows with GLM 5.2: 92.5**
2. **Codex App on Windows with GPT-5.5: 90.5**
3. **Antigravity CLI on Windows with Gemini 3.5 Flash: 88.5**

**GLM 5.2 made the best final game.**

The sound was better. The mechanics were strong. The code architecture was excellent. The game-over state was clearly shown in the video. The whole artifact felt the most complete.

**GPT-5.5 was close.**

It had the best visual charm, the smoothest run, strong code quality, and a faster build than GLM.

**Gemini came in third on artifact quality, but that is not the full story.**

## Final Leaderboard: Operator Experience

1. **Antigravity CLI on Windows with Gemini 3.5 Flash: 3:07**
2. **Codex App on Windows with GPT-5.5: 12:47**
3. **OpenCode CLI on Windows with GLM 5.2: 17:51-ish**

This is where the story changes.

**Gemini was ridiculously fast.**

If I needed a playable prototype immediately, Antigravity CLI with Gemini 3.5 Flash would be tempting. The final game was not the prettiest, but it got to playable almost instantly.

Codex App with GPT-5.5 was the best balance of speed, quality, and smooth execution.

It finished quickly, did not need a stop/resume, and produced a polished game with clean code.

OpenCode CLI with GLM 5.2 had the best final output, but it was slower and had a small hiccup near the end.

That matters in real work.

A model can produce the best result and still be less pleasant to use all day.

# Category Winners

Here is how I would break it down.

## Best finished game:

OpenCode CLI with GLM 5.2

## Best visual presentation:

Codex App with GPT-5.5

## Best sound design:

OpenCode CLI with GLM 5.2

## Best controls:

Antigravity CLI with Gemini 3.5 Flash

## Best code structure:

OpenCode CLI with GLM 5.2, with GPT-5.5 very close

## Cleanest run:

Codex App with GPT-5.5

## Fastest prototype:

Antigravity CLI with Gemini 3.5 Flash

## Best all-day builder feel:

Codex App with GPT-5.5

# The Actual Takeaway

The cleanest answer is:

**OpenCode CLI with GLM 5.2 built the best game.**

But the more useful answer is:

**Each setup won a different part of the workflow.**

## GLM 5.2 through OpenCode CLI was the best finisher.

It produced the strongest final artifact, especially when sound, mechanics, architecture, and UI feedback were considered together.

## GPT-5.5 through the Codex App was the best balanced builder.

It was fast, smooth, visually polished, and cleanly structured. If I had to pick one setup to use all day without babysitting it, GPT-5.5 made the strongest case.

## Gemini 3.5 Flash through Antigravity CLI was the best prototype engine.

It produced a real playable game in 3:07. The visuals were weaker and the code was messier, but that speed is useful.

# The Workflow I Would Actually Use

The most interesting result is not that one model won.

The most interesting result is that the strengths are stackable.

For a real project, I would consider this workflow:

1. Use Gemini 3.5 Flash through Antigravity CLI to blast out a playable prototype.
2. Use GPT-5.5 through the Codex App to clean up the structure and improve the experience.
3. Use GLM 5.2 through OpenCode CLI to push final systems, sound, mechanics, and polish.

That may beat using any single model alone.

**Gemini** gets the idea moving fast. **GPT-5.5** makes it safer and cleaner. **GLM** adds richer finishing work.

That is a practical builder lesson.

# My Final Read

This test did not prove one model is universally better.

That is usually the wrong question.

The better question is:

**What kind of work do I need done right now?**

- If I need the strongest final result and I am willing to wait longer, GLM 5.2 earned the win here.
- If I need a clean, polished, reliable build with less friction, GPT-5.5 is the setup I would trust most.
- If I need a playable prototype immediately, Gemini 3.5 Flash is hard to ignore.

That is where coding with agents is heading.

Not one model for everything.

A bench of different builders, each with different strengths, used at the right point in the job.