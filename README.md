<!-- badge-style for a small logo -->
<p align="left">
  <img src="images/moonlight-4eyes.png" alt="Moonlight Wrapper logo" width="120"/>
</p>


# Moonlight-4eyes 

**What it does:**
Anytime the Moonlight Flatpak client is opened in SteamOS, this wrapper will automatically change the Moonlight FPS cap to the client device's refresh rate via modification of the `Moonlight.conf' file. Combining this wrapper with a Host-side FPS limiter such as Qres.exe or [frl-toggle (for Nvidia users)](https://github.com/FrogTheFrog/frl-toggle), will help you achieve the smoothest possible streaming experience. 

**When it’s useful:**
Whenever you launch Moonlight, this wrapper kicks in—reads your current SteamOS refresh rate, patches `Moonlight.conf` to set the streaming framerate accordingly, and then starts Moonlight.

- **Host-limited case**  
  If your PC can only stream at, say, 100 FPS but your SteamOS display is set to 120 Hz, you only need to change the SteamOS refresh rate—Moonlight’s streaming framerate will automatically update to match. No manual edits or menu diving required.

- **High-performance case**  
  Conversely, if your host and display both support, say, 144 FPS/Hz but Moonlight is still capped at 60, the wrapper will bump Moonlight’s streaming framerate up to match your display rate on each launch. If you frequently switch refresh rates for different games, this makes everything seamless—you never have to reconfigure anything afterward.  


**Requirements:**
1. SteamOS
2. Standard Flatpak install of Moonlight
3. Optional - MoonDeck Plugin - see step 2 of "Post-install Setup"

**Installation:**

- **Clone the repo & run `install.sh`**  
  ```bash
  git clone https://github.com/Apocrei/moonlight-4eyes.git
  cd moonlight-4eyes
  ./install.sh

**Post-install Setup:**
</br></br>Please note, only shortcuts created after installing the wrapper will invoke the auto-fps function. If Moonlight was added to your Steam library prior installing this tool, you will need to remove it (can be done before or after installing the wrapper) and then add it again. 

1. **In SteamOS Desktop Mode**
   - Open **Steam** Go to **Games → Add a Non-Steam Game → select Moonlight → Add Selected Programs**  

3. **In MoonDeck’s settings (optional)**  
   - Find the **Moonlight executable** field  
   - Enter:  
     ```
     $HOME/bin/moonlight
     ```

That’s all—

Going forward, whenever you launch Moonlight, this program will automatically set the Moonlight framerate cap to the refresh rate of your client-side display. 


**Uninstall:**

- **Run `uninstall.sh`**  
  ```bash
  cd moonlight-4eyes
  ./uninstall.sh

Note: Any desktop or menu shortcuts created while the wrapper was installed may no longer work after the wrapper has been uninstalled. Simply delete these shortcuts and create new ones as needed.
