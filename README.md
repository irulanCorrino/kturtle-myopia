<img src="icons/64-apps-kturtle.png" align="left"
     title="Kturtle logo">
##### TODO: 'Syntax Highlighting' tool
### this is kturtle-myopia fork targeting near-sighted programmers
<ins>i devise another one made with GTK-4 and including kinda compiler [note: this fork differs from original app only by accessibility features, cannot promise being in sync with KDE though]<ins/>
#### a makeshift solution[^1]
<ins>i decided to hack the app because of unreadable font in `Editor` window --it was XFCE's incompatibility with QT/KDE theming engines;</ins> [i tried several workarounds but everything failed to set that font] now i have found the path [in this post](https://bbs.archlinux.org/viewtopic.php?id=214147&p=3) and the explanation in archwiki at last.  
here is the solution [the example applies only for Arch-based systems]:
- install compatibility layer package (Qt5 Configuration Utility) [exact instructions are [from AUR page](https://aur.archlinux.org/packages/qt5ct-kde)]
```
git clone https://aur.archlinux.org/qt5ct-kde.git
cd qt5ct-kde
makepkg -sic
```
- edit `etc/environment` [there should be no `QT_STYLE_OVERRIDE=gtk2` (or whatever else nonsence it may set) and you need to point to `qt5ct` utility], here is mine
```
QT_QPA_PLATFORMTHEME=qt5ct
QTWEBENGINE_CHROMIUM_FLAGS="-blink-settings=darkModeEnabled=true -enable-features=OverlayScrollbar,OverlayScrollbarFlashAfterAnyScrollUpdate,OverlayScrollbarFlashWhenMouseEnter"
GTK_MODULES=canberra-gtk-module
```
- run `qt5ct` and set any font you like at `General` row

> [by patch's author]  
> `xdg-desktop-portal` allows you to have KDE dialogs in non-KDE enviornment without installing `plasma-integration` package. To get them, all you need is:
>  - Install `xdg-desktop-portal` + `xdg-desktop-portal-kde`
>  - If you have `xdg-desktop-portal-gtk` installed, rename `usr/share/xdg-desktop-portal/portals/gtk.portal` to `zz-gtk.portal` (backend priority is in alphabetical order). You can add that file to `NoExtract` in `pacman.conf`.

##### [the explanation](https://wiki.archlinux.org/title/Qt#Configuration_of_Qt_5_applications_under_environments_other_than_KDE_Plasma)
> Unlike Qt 4, Qt 5 does not ship a `qtconfig` utility to configure fonts, icons or styles. Instead, it will try to use the settings from the running desktop environment. In KDE Plasma or GNOME this works well, but in other less popular desktop environments or window managers it can lead to missing icons in Qt 5 applications. One way to solve this is to fake the running desktop environment by setting `XDG_CURRENT_DESKTOP=KDE` or `GNOME`, and then using the corresponding configuration application to set the desired icon set.
> 
> Another solution is provided by the [`qt5ct`](https://archlinux.org/packages/?name=qt5ct) package, which provides a Qt 5 [QPA](https://wiki.qt.io/Qt_Platform_Abstraction) independent of the desktop environment and a configuration utility. <del>After installing the package, run `qt5ct` to set an icon theme</del>[^2], and set the [environment variable](https://wiki.archlinux.org/title/Environment_variable) `QT_QPA_PLATFORMTHEME=qt5ct` so that the settings are picked up by Qt applications. Alternatively, use `--platformtheme qt5ct` as argument to the Qt 5 application.
> 
> [`qt5ct-kde`](https://aur.archlinux.org/packages/qt5ct-kde) provides a patched `qt5ct` with better integration to KDE applications, including KDE QML applications.
---

KTurtle is an educational programming environment that uses TurtleSpeak, https://bbs.archlinux.org/viewtopic.php?id=214147&p=3a programming language loosely based on and inspired by [LOGO](http://en.wikipedia.org/wiki/Logo_programming_language).

The goal of KTurtle is to make programming as easy and accessible as possible. This makes KTurtle suitable for teaching young students the basics of math, geometry and... programming.

## Features

Some of the main features of KTurtle include:
* the ability to translate the programming commands into the native language of the student using the KDE translation framework.
* all you need integrated in one application.
* simplified programming terminology.
* intuitive syntax highlighting and error markers.

![Kturtle](icons/kturtle.gif)

Learn more in the [KTurtle manifesto](MANIFESTO.md).
---
<p align="center">
 <img width="68%" alt="myopia hacks 20240204_170516" title="myopia hacks" src="https://github.com/irulanCorrino/kturtle-myopia/assets/98284211/e0bfeb5f-4e33-4a62-8185-ad506a8d74b7">
</p>

[^1]: i am not going to abandon my idea of hacking the kTurtle app --i want `Fonts` in `Settings` menu's top row + custom colors and so on [BTW does anyone know CAN I THE HELL reuse the keycaps from cheap wireless `mass-office keyboard` for a high-end mechanic one? i had spent several days making my own font of photoluminescent tape, DAMN!!!]

[^2]: Archwiki is mistaken here --don't do THAT in the order they have specified --you would get only a frustration because of a `SEGFAULT` for `qt5ct`
