<!-- badge-style for a small logo -->
<p align="left">
  <img src="images/moonlight-4eyes.png" alt="Moonlight Wrapper logo" width="120"/>
</p>

# Moonlight-4eyes

**What it does:**  
Anytime the Moonlight Flatpak client is opened in SteamOS, this wrapper automatically updates the `fps=` value in `Moonlight.conf` to match the client device’s refresh rate.  
This ensures smooth, tear-free streaming — no need to dig into menus or config files.

The wrapper detects your mode and adjusts accordingly:
- In **Desktop Mode**, it uses your display's current refresh rate via `xrandr`
- In **Gaming Mode**, it pulls the most recent AppID from `screenshots.vdf` and extracts the last Gamescope FPS cap from `steamui_system.txt`

Combine this with a host-side FPS limiter like **Qres.exe** or [**frl-toggle** (Nvidia)](https://github.com/FrogTheFrog/frl-toggle) for best results.

---

**When it’s useful:**

Whenever you launch Moonlight, this wrapper:
1. Detects your current SteamOS refresh rate **or** your latest Gamescope FPS cap
2. Writes it to `Moonlight.conf`
3. Launches (or relaunches) Moonlight seamlessly

**Host-limited case**  
If your PC can only stream at 60 FPS but your Steam Deck is set to 144 Hz, you just change your Deck’s refresh rate — this wrapper ensures Moonlight matches it automatically.

**High-performance case**  
If your host and Deck both support 144 FPS/Hz but Moonlight is stuck at 60, this wrapper bumps it to 144. No more toggling menus or re-editing config files after every rate switch.

---

**Requirements:**
1. SteamOS
2. Flatpak install of Moonlight
3. (Optional) MoonDeck Plugin — see step 3 of Post-install Setup

---

## 🚀 Installation

```
git clone https://github.com/Apocrei/moonlight-4eyes.git
cd moonlight-4eyes
./install.sh
```

---

## 🔧 Post-install Setup

⚠️ Only shortcuts created *after* installing the wrapper will invoke auto-FPS sync.  
If Moonlight was added to your Steam library earlier, remove and re-add it.

### 1. In SteamOS Desktop Mode
- Open **Steam**
- Go to **Games → Add a Non-Steam Game**
- Browse to:

```
$HOME/bin/moonlight
```

- Select and **Add**

### 2. In MoonDeck’s settings (optional)
- Find the **Moonlight executable** field
- Set it to:

```
$HOME/bin/moonlight
```

---

## 🛠️ How it works behind the scenes

- In Gaming Mode, the script finds your most recent Moonlight AppID from `screenshots.vdf`
- Then parses `steamui_system.txt` to extract the last Gamescope framerate cap
- That FPS is written into Moonlight’s config before the app launches

---

## ❌ Uninstall

```
cd moonlight-4eyes
./uninstall.sh
```

Note: Any shortcuts created while the wrapper was active may break after uninstalling.  
Just remove and recreate them as needed.

---

## 📝 Notes

- You can manually change FPS within the app — but it will revert next time
- Works best with a host-side FPS limiter to match the client rate

---

🎮 Enjoy seamless Moonlight streaming!
