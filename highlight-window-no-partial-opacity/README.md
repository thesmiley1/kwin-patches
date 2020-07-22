# No Partial Opacity in Highlight Windows Effect <!-- omit in toc -->

* [Purpose](#purpose)
* [Comparison/Demonstration](#comparisondemonstration)
* [Demo explanation](#demo-explanation)
* [Implementation notes](#implementation-notes)

## Purpose

This patch aims to eliminate partially opaque windows being displayed on top of
the highlighted window in the 'highlight window' effect.

## Comparison/Demonstration

![Comparison/Demonstration](.media/demo.gif)

## Demo explanation

* **A)** KWin (Unpatched)
  * In unpatched state, kwin assigns some (non-zero) opacity to _all_ parts of
    _all_ windows.  This results in windows otherwise on top of the highlighted
    window obscuring it.  In extreme cases where the highlighted window is
    below many other windows, the highilghted window can even become
    practically impossible to see.
* **B)** KWin (Patched)
  * In patched state, all windows except the highlighted window are given zero
    opacity.  The highlighted window is never obscured and usability of the
    effect is restored.
* **C)** KDE (kwin?) Alt + Tab
  * The mystery really heats up with the Breeze Alt + Tab Task Switcher... it
    already does the right thing!  With no patches, Breeze Task Switcher
    highlights windows by bringing them to the foreground and never rendering
    anything on top of them.  Other windows are still rendered semi-opaquely.
    Further deepening the mystery, the semi-opaque rendering of other windows
    is broken by this patch (they are rendered fully transparently)!  **The
    implication seems to be that Breeze Task Switcher is sharing code with (or
    directly using) KWin's Highlight Window effect, but Breeze Task Switcher
    does not have the same usability issue of the highlighted window being
    obscured by other windows.**
  * _I think identifying the cause of these discrepancies might identify the
    root cause and proper course to fix this problem._  Is there a difference in
    how the highlight window effect is called from the task manager applet vs
    the alt+tab task switcher?
* **D)** Gnome (Comparison)
  * Gnome never obscures the highlighted window and other windows are rendered
    semi-opaquely behind the highlighted window.
* **E)** Windows (Comparison)
  * Windows never obscures the highlighted window and other windows are
    rendered only as outlines behind the highlighted window.

## Implementation notes

This patch is an **EXPERIMENTAL HACK**.  It's mostly a proof of concept that
kwin's Highlight Window effect _can_ work as well as similar functionality in
other software.
