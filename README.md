# KeepBluetoothSpeakerAlive 🔈💤

A lightweight, zero-window macOS menu bar utility designed to prevent Bluetooth speakers from aggressively entering sleep mode.

**Created by:** [Yury Alikin](https://github.com/yury8alikin)

## 🎯 Who is this for?
This tool is for macOS users who use Bluetooth speakers or soundbars that automatically disconnect or go into a deep power-saving sleep after a short period of audio silence. 

## 🛠️ The Problem it Solves
macOS and many modern Bluetooth audio devices use aggressive power-saving protocols during periods of silence. When you start playing audio again after a pause, the speaker takes a few seconds to "wake up," resulting in the first few seconds of your audio being cut off or muted. 

KeepBluetoothSpeakerAlive solves this by programmatically generating a completely inaudible audio signal at regular intervals. This silent "ping" forces the macOS CoreAudio system to keep the Bluetooth connection active, ensuring your speaker is always awake and ready to play without any delay.

## ✨ Features
* **Invisible Footprint:** Runs purely as a status bar item with zero window interface and no Dock icon (`LSUIElement`).
* **Instant Active State:** Defaults to "Active ON" upon launch, making it perfect for unattended boot-order execution.
* **Customizable Ping Intervals:** Choose between 10, 30, or 50-second intervals from a simple dropdown menu.
* **Persistent Configuration:** Your chosen interval is saved automatically and remembered across system reboots.
* **Zero Memory Leaks:** Cleanly terminates timers and audio engines upon exit.

## 🚀 Installation & Setup

1. Clone the repository.
2. Build the app:
```bash
  chmod +x build.sh 
  ./build.sh
```
3. Move the `KeepBluetoothSpeakerAlive.app` file into your macOS `Applications` folder.

### ⚙️ How to Run on macOS Startup (Login Items)
To ensure the app launches and begins keeping your speaker awake automatically every time you start your Mac:

1. Open the **Apple menu** () in the top-left corner of your screen and choose **System Settings**.
2. Click on **General** in the left sidebar, then select **Login Items & Extensions**.
3. Under the "Open at Login" section, click the **+** (plus) button located below the list of items.
4. Navigate to your `Applications` folder, select `KeepBluetoothSpeakerAlive.app`, and click **Open**.

Because the app is engineered to default to an active state upon load, it will silently start working in the background the moment you log in—no manual activation required!

## 🛑 How to Quit
Simply click the app's icon in the top right menu bar and select **Exit**. The app will safely terminate all background audio loops and close.

## 📄 License & Open Source
This project is open-source and licensed under the **GNU General Public License v3.0 (GPLv3)**.

You are completely free to use, modify, and distribute this software. However, under the GPLv3, any modified versions or derivative works created from this code must also be made open-source and released under this exact same license. Open source stays open source!
