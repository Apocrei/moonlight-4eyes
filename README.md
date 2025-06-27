# Moonlight FPS-Auto Wrapper

Automatically rounds your display’s refresh rate and updates your `Moonlight.conf` before
launching the Flatpak client.

**Installation Options:**

- **Option 1 – Download & run the self-extracting installer**  
  1. [Download the `.run` from Releases](https://github.com/Apocrei/moonlight-wrapper/releases/latest)  
  2. Allow “Execute as program” in your file manager  
  3. Double-click the `.run` (no terminal needed)

- **Option 2 – Clone the repo & run `install.sh`**  
  ```bash
  git clone https://github.com/Apocrei/moonlight-wrapper.git
  cd moonlight-wrapper
  ./install.sh

**Post-install config instructions**

Next steps:

1. **In Steam Desktop Mode**  
   - Go to **Games → Add a Non-Steam Game**  
   - Browse to `$HOME/deck/bin/moonlight` and click **Add**.

2. **In MoonDeck’s settings**  
   - Find the **Moonlight executable** field  
   - Enter:  
     ```
     $HOME/deck/bin/moonlight
     ```

That’s all—

Going forward, every way you launch Moonlight (terminal, desktop menu, Game Mode, panel shortcut, controller) will auto-update the `fps=` setting in your config before starting.  


