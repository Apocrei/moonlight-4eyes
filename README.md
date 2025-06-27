# Moonlight FPS-Auto Wrapper

Anytime the Moonlight Flatpak client is opened in SteamOS, this wrapper will automatically change the Moonlight FPS cap to the client device's refresh rate via modification of the `Moonlight.conf'. This, among other best practices, is necessary to acheive the smoothest possible streaming experience.

**Requirements:**
1. SteamOS
2. Standard Flatpack install of Moonlight
3. Optional - MoonDeck Plugin - see step 2 of "Post-install config instructions"

**Installation Options:**

- **Option 1 – Download & run the self-extracting installer**  
  1. [Download the `.run` from Releases](https://github.com/Apocrei/moonlight-wrapper/releases/latest)  
  2. Run it

- **Option 2 – Clone the repo & run `install.sh`**  
  ```bash
  git clone https://github.com/Apocrei/moonlight-wrapper.git
  cd moonlight-wrapper
  ./install.sh

**Post-install config instructions:**

1. **In SteamOS Desktop Mode**  
   - Open **Steam** Go to **Games → Add a Non-Steam Game**  
   - Browse to `$HOME/bin/moonlight` and click **Add**.

2. **In MoonDeck’s settings (optional)**  
   - Find the **Moonlight executable** field  
   - Enter:  
     ```
     $HOME/bin/moonlight
     ```

That’s all—

Going forward, every way you launch Moonlight (terminal, desktop menu, Game Mode, panel shortcut, controller) will auto-update the `fps=` setting in your config before starting.  


